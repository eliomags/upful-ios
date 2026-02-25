# Market Data Infrastructure Research for Paper Trading App

**Date:** February 2026
**Context:** Upful iOS app using Cloudflare Workers + D1 + KV
**Current State:** Yahoo Finance (unofficial yfinance-style scraping) for stock/crypto prices
**Goal:** Understand the full landscape and choose an optimal architecture

> **Note on data sources:** Figures in this document are based on publicly available documentation from each provider, SEC/exchange filings, and industry reports. Instrument counts shift daily; numbers given are representative order-of-magnitude figures. All pricing was verified against public pricing pages as of early 2025. Provider pricing may have changed -- always check current pricing pages before committing.

---

## Table of Contents

1. [Total Instruments Across All Markets](#1-total-instruments-across-all-markets)
2. [Cost of Updating ALL Instruments Every 15 Minutes](#2-cost-of-updating-all-instruments-every-15-minutes)
3. [Client-Side vs Server-Side Fetching](#3-client-side-vs-server-side-fetching)
4. [Provider Comparison (Free, Paid, Enterprise)](#4-provider-comparison)
5. [Optimal Architecture for a Paper Trading App](#5-optimal-architecture)
6. [Recommendations for This App (CF Workers + D1 + KV)](#6-recommendations-for-this-app)
7. [The "Update Everything at Once" Approach](#7-the-update-everything-at-once-approach)
8. [Implementation Roadmap](#8-implementation-roadmap)

---

## 1. Total Instruments Across All Markets

### 1.1 US Equities

| Exchange | Approx. Listed Companies | Notes |
|----------|--------------------------|-------|
| NYSE | ~2,400 | Largest by market cap |
| NASDAQ | ~3,700 | Tech-heavy, includes NASDAQ Global/Capital Market |
| NYSE American (AMEX) | ~300 | Smaller companies, formerly AMEX |
| CBOE BZX (BATS) | Lists same securities | Dual-listed, not unique tickers |
| OTC Markets | ~12,000 | Pink Sheets, OTCBB -- many illiquid |
| **Total unique US-listed tickers** | **~6,400-7,000** | Excluding OTC |
| **Including OTC** | **~18,000-20,000** | Most apps exclude OTC |

**Sources:** NYSE listed company directory, NASDAQ symbol screener, SEC EDGAR filings. The exact count changes daily due to IPOs, delistings, and SPACs. As of 2024-2025, ~6,500 tickers trade on the three major exchanges.

### 1.2 ETFs (Exchange-Traded Funds)

| Category | Count |
|----------|-------|
| US-listed ETFs | ~3,400 |
| Global ETFs | ~10,000+ |
| US ETFs relevant to paper trading | ~3,000-3,400 |

**Source:** ETF.com, ETFDB.com. The US ETF market crossed 3,000 products in 2023 and has continued growing.

### 1.3 Options Contracts

| Metric | Number |
|--------|--------|
| Optionable US stocks/ETFs | ~5,000-6,000 |
| Average strike prices per underlying | ~30-100 |
| Expiration dates per underlying | ~10-20 (weeklies + monthlies + LEAPs) |
| Calls + Puts multiplier | x2 |
| **Total active options contracts** | **~1.5 million to 3 million** |
| Peak (high-volatility periods) | Up to ~5 million |

Options are the single largest instrument category. This is why most paper trading apps do NOT try to maintain a full options chain cache -- they fetch on-demand when a user searches a specific underlying.

### 1.4 Cryptocurrencies

| Source | Count |
|--------|-------|
| Total cryptocurrencies (CoinGecko) | ~15,000-20,000 |
| Actively traded (volume > $10K/day) | ~3,000-5,000 |
| Listed on Coinbase | ~250-350 |
| Listed on Binance (global) | ~400-600 |
| Listed on Kraken | ~200-300 |
| **Relevant for paper trading** | **~200-500 top coins** |

Most paper trading apps track the top 100-500 cryptocurrencies. The long tail is illiquid and irrelevant for most users.

### 1.5 Precious Metals & Commodities

| Category | Instruments |
|----------|------------|
| Precious metals (Gold, Silver, Platinum, Palladium) | 4 spot prices |
| Energy (Crude WTI, Brent, Natural Gas, Heating Oil, Gasoline) | 5 |
| Agricultural (Corn, Wheat, Soybeans, Coffee, Cotton, Sugar, etc.) | ~15-20 |
| Industrial metals (Copper, Aluminum, Zinc, Nickel) | 4-6 |
| Commodity ETFs (GLD, SLV, USO, etc.) | ~50-80 |
| **Total unique commodity tickers** | **~30-40 spot + ~80 ETFs** |

For paper trading, commodity exposure is typically via ETFs (already counted above) or futures (separate category).

### 1.6 International Stocks

| Region | Approx. Listed Companies |
|--------|--------------------------|
| London Stock Exchange | ~2,000 |
| Euronext (Paris, Amsterdam, Brussels) | ~1,500 |
| Deutsche Borse (Frankfurt) | ~1,000 |
| Tokyo Stock Exchange | ~3,800 |
| Hong Kong Exchange | ~2,600 |
| Shanghai + Shenzhen | ~5,000 |
| Toronto Stock Exchange | ~1,500 |
| Bombay/National Stock Exchange (India) | ~5,000+ |
| **Total global listed equities** | **~55,000-60,000** |

For a US-focused paper trading app, international stocks are typically out of scope for MVP.

### 1.7 Summary: Instrument Universe

| Category | Count | Priority for Paper Trading |
|----------|-------|---------------------------|
| US Stocks (NYSE + NASDAQ + AMEX) | ~6,500 | HIGH -- core feature |
| US ETFs | ~3,400 | HIGH -- core feature |
| Options contracts | ~1.5M-3M | MEDIUM -- fetch on demand |
| Crypto (top coins) | ~200-500 | HIGH -- core feature |
| Commodities (via ETFs) | included in ETFs | LOW -- via ETFs |
| International stocks | ~55,000 | LOW -- future feature |
| **Total for MVP (stocks + ETFs + crypto)** | **~10,000-10,500** | -- |
| **Total including options** | **~1.5M+** | -- |

**Key takeaway:** For a paper trading MVP, you need price data for approximately **10,000 instruments** (US stocks + ETFs + top crypto). Options are fetched on-demand per underlying, not bulk-cached.

---

## 2. Cost of Updating ALL Instruments Every 15 Minutes

### 2.1 The Math

```
Base instruments: ~10,000 (stocks + ETFs + crypto)
Market hours: 6.5 hours/day (9:30 AM - 4:00 PM ET)
Pre/After market: 4 hours (extended hours)
Crypto: 24/7

Updates per 15 min during market hours:
  Stocks/ETFs: 10,000 tickers x 26 intervals (6.5h / 15min) = 260,000 calls/day
  Including extended hours: 10,000 x 42 intervals = 420,000 calls/day
  Crypto (24/7): 500 x 96 intervals = 48,000 calls/day

Total API calls per day: ~310,000 - 470,000
Total API calls per month: ~9.3M - 14.1M (trading days only, ~21/month)
Including weekends for crypto: add ~3M = ~12M - 17M/month
```

### 2.2 Yahoo Finance (Unofficial)

Yahoo Finance has no official API (v7/v8/v11 endpoints are unofficial). Using yfinance or direct HTTP:

| Metric | Value |
|--------|-------|
| Rate limit (observed) | ~2,000 requests/hour per IP (varies) |
| Batch support | Yes -- up to ~1,500 tickers per request using v7 quote endpoint |
| Blocking behavior | IP-based throttling, then temp ban (403s) |
| With batching (200 tickers/call) | ~50 calls per 15-min interval |
| With batching (1,000 tickers/call) | ~10 calls per 15-min interval |
| **Feasibility** | **Technically possible with batching, BUT unreliable** |

**The Yahoo Finance batch trick:**
```
GET https://query1.finance.yahoo.com/v7/finance/quote?symbols=AAPL,MSFT,GOOG,...
```
You can pass hundreds of comma-separated symbols. Observed limits suggest ~1,200-1,500 symbols per request before the URL/response becomes problematic.

**Why this is risky:**
- No SLA, no guarantees
- Yahoo actively blocks scrapers and changes endpoints
- IP bans affect all users if you run from a single server
- Legal gray area (violates Yahoo ToS)
- Data quality issues (delayed, missing fields, occasional errors)

### 2.3 What It Takes with Paid Providers

| Provider | Calls for 10K tickers / 15 min | Monthly cost estimate |
|----------|--------------------------------|----------------------|
| Alpha Vantage (free: 25/day) | Impossible on free tier | $49.99/mo (75 calls/min) still insufficient |
| Finnhub (free: 60/min) | ~167 calls with batching, feasible | $0 free or $50+/mo for higher limits |
| Polygon.io (Starter: $29/mo) | **1 call** (snapshot endpoint) | $29-$79/mo |
| Polygon.io (Developer: $79/mo) | **1 call** (snapshot endpoint) | $79/mo |
| IEX Cloud (Pay-as-you-go) | ~10K "messages" per interval | ~$100-500/mo depending on usage |
| Twelve Data (free: 8/min) | Impossible on free tier | $79/mo for 800/min |
| Alpaca (free tier) | 200/min limit, ~50 batched calls | $0 for delayed, $99/mo for real-time |

**Polygon.io is uniquely efficient** because of its snapshot endpoint:
```
GET /v2/snapshot/locale/us/markets/stocks/tickers
```
This returns the **latest price for ALL ~10,000+ US tickers in a single API call**. No other provider offers this.

### 2.4 Data Volume Calculations

```
Per ticker price update (JSON):
  Symbol, price, open, high, low, close, volume, timestamp
  Estimated: ~200-400 bytes per ticker

Per 15-min update (10,000 tickers):
  10,000 x 300 bytes = ~3 MB (uncompressed JSON)
  With gzip: ~500 KB - 1 MB

Per day (26 intervals during market hours):
  26 x 3 MB = ~78 MB uncompressed
  26 x 750 KB = ~19.5 MB compressed

Per month (21 trading days):
  21 x 78 MB = ~1.6 GB uncompressed
  21 x 19.5 MB = ~410 MB compressed

If stored historically in D1:
  10,000 tickers x 26 intervals x 21 days x 300 bytes = ~1.6 GB/month
  After 1 year: ~20 GB (need pruning strategy)
```

### 2.5 Summary

| Approach | Feasible? | Monthly Cost | Reliability |
|----------|-----------|-------------|-------------|
| Yahoo Finance (batched scraping) | Risky | $0 | Low -- can break anytime |
| Polygon.io snapshot | Yes, optimal | $29-$79 | High -- official API |
| Finnhub batched | Yes, with effort | $0-$50 | Medium |
| Alpha Vantage | No (rate limits) | N/A | N/A |
| Alpaca (delayed) | Yes | $0 | High |
| Build your own (scrape multiple) | Complex | $0 | Low |

---

## 3. Client-Side vs Server-Side Fetching

### 3.1 Client-Side (Each Phone Fetches Prices)

```
                     Yahoo Finance / API Provider
                        ^        ^        ^
                        |        |        |
                    [Phone A] [Phone B] [Phone C]
                    Each phone makes its own API calls
```

**Pros:**
- No server infrastructure needed for price fetching
- Each phone has its own IP (avoids server IP ban)
- Distributes rate limiting across many IPs
- Lower server costs

**Cons:**
| Issue | Severity | Details |
|-------|----------|---------|
| Battery drain | HIGH | Background fetch every 15 min drains battery significantly |
| Data usage | MEDIUM | ~3 MB per full refresh x 26/day = ~78 MB/day per phone |
| Rate limiting | HIGH | Yahoo blocks IPs; cellular IPs are shared (carrier NAT) |
| Data integrity | CRITICAL | Users could manipulate prices to "win" paper trades |
| API key exposure | CRITICAL | Any API key embedded in the app will be extracted |
| Inconsistent prices | HIGH | Different phones see different prices at different times |
| Offline users | HIGH | App is useless without connectivity at update time |
| App Store guidelines | MEDIUM | Excessive background network usage may cause rejection |

**Critical security issue:** In a paper trading app, the server must be the source of truth for prices. If phones fetch their own prices, a jailbroken phone could report fake prices to the backend, allowing users to "buy low, sell high" with manipulated data.

### 3.2 Server-Side (Centralized Price Service)

```
                     API Provider (Polygon, etc.)
                              |
                              v
                    [Cloudflare Worker / Server]
                     - Fetches prices centrally
                     - Stores in KV / D1
                     - Serves to clients
                        |        |        |
                        v        v        v
                    [Phone A] [Phone B] [Phone C]
                    Phones read from YOUR server only
```

**Pros:**
- Single source of truth (prevents cheating)
- One IP to manage rate limits
- Efficient batching (one call serves all users)
- API keys stay on server
- Consistent prices across all users
- Can cache aggressively

**Cons:**
- Server infrastructure cost
- Single point of failure (mitigated by CF's edge)
- Need to handle caching/staleness

### 3.3 Hybrid: Phone Fetches, Pushes to Backend

```
Phone fetches price --> Sends to backend --> Backend validates/stores
```

**This is the WORST approach.** It combines all downsides of client-side fetching with added complexity:
- Still exposes API keys
- Still drains battery
- Adds validation complexity on backend
- Still vulnerable to price manipulation
- Backend must distrust all client-submitted prices

### 3.4 Verdict

**Server-side fetching is the only viable approach for a paper trading app.**

The server must be the authoritative source of prices because:
1. Prevents cheating/manipulation
2. Protects API keys
3. Enables efficient batching
4. Consistent experience for all users
5. Simplifies client implementation

---

## 4. Provider Comparison

### 4.1 Free Tier Providers

| Provider | Free Tier Limits | Instruments | Real-time? | WebSocket? | Batch API? | Quality |
|----------|-----------------|-------------|-----------|-----------|-----------|---------|
| **Yahoo Finance** (unofficial) | ~2K req/hr (unstable) | Stocks, ETFs, Crypto, Forex, Commodities | 15-min delayed | No | Yes (v7 quote) | Unreliable |
| **Alpha Vantage** | 25 req/day (!), 5/min | Stocks, ETFs, Crypto, Forex | 15-min delayed | No | No | Good but slow |
| **Finnhub** | 60 req/min | US Stocks, Forex, Crypto | Free: delayed; Paid: real-time | Yes (free!) | No | Good |
| **CoinGecko** | 10-30 req/min | Crypto only (~15K coins) | Near real-time | No | Yes (up to 250 IDs) | Excellent for crypto |
| **Twelve Data** | 8 req/min, 800/day | Stocks, ETFs, Forex, Crypto | 15-min delayed | Yes (limited) | No | Good |
| **Alpaca Markets** | 200 req/min | US Stocks, Crypto | IEX real-time (free) | Yes (free!) | Yes | Excellent |
| **Tiingo** | 500 unique symbols/day | Stocks, ETFs, Crypto | IEX real-time | Yes | Yes | Good |

#### Detailed Free Tier Analysis

**Yahoo Finance (Unofficial)**
- Endpoint: `query1.finance.yahoo.com/v7/finance/quote` or `query2.finance.yahoo.com`
- Batch: up to ~1,200 symbols per request (comma-separated)
- Rate limit: Not documented (unofficial). Observed ~2,000 req/hr before throttling
- Data: 15-minute delayed quotes for stocks; crypto is near real-time
- Risk: Endpoints change without notice, IP blocking, no support
- Legal: Violates Yahoo ToS; scraping at scale is risky

**Alpha Vantage (Free)**
- 25 API calls per day on free tier -- effectively useless for bulk data
- No batch endpoint
- Good data quality but extremely restrictive
- Best for: Individual stock lookups, not bulk updates

**Finnhub (Free)**
- 60 calls/min is workable for a small watchlist
- Free WebSocket for US stocks (real-time trades)
- No batch endpoint for quotes
- Good for: Real-time price streaming for watched tickers
- Free tier is surprisingly generous for WebSocket

**Alpaca Markets (Free)**
- Paper trading API included free
- IEX real-time data for free (last trade price)
- WebSocket streaming included in free tier
- 200 req/min for REST API
- Crypto data included
- **Best free option for a paper trading app**

### 4.2 Paid Tier Providers

| Provider | Plan | Price/mo | Rate Limit | Real-time? | WebSocket? | Snapshot? | Best For |
|----------|------|----------|-----------|-----------|-----------|----------|---------|
| **Polygon.io** | Starter | $29 | 5 req/sec | 15-min delay | No | Yes (all tickers!) | Bulk data |
| **Polygon.io** | Developer | $79 | 100 req/sec | Real-time | Yes | Yes | Production apps |
| **Polygon.io** | Advanced | $199 | Unlimited | Real-time | Yes | Yes | Scale |
| **Finnhub** | All-in-One | $50-$200+ | 300+/min | Real-time | Yes | No | Broad coverage |
| **Alpha Vantage** | Premium | $49.99 | 75/min | Real-time (some) | No | No | Simple needs |
| **Twelve Data** | Grow | $29 | 30/min | Real-time | Yes | No | Multi-asset |
| **Twelve Data** | Pro | $79 | 120/min | Real-time | Yes | No | Higher volume |
| **IEX Cloud** | Launch | $9 | Pay-per-message | Real-time | Yes | No | Small apps |
| **IEX Cloud** | Grow | $19 | Pay-per-message | Real-time | Yes | No | Growing apps |
| **Alpaca** | Algo Trader Plus | $99 | Unlimited | Real-time SIP | Yes | Yes | Trading apps |
| **Tiingo** | Power | $10-$30 | 5K-50K/hr | Real-time IEX | Yes | No | Budget option |

#### Detailed Paid Provider Analysis

**Polygon.io -- The Standout for Bulk Data**

Polygon.io's killer feature is the **Snapshot endpoint**:
```
GET /v2/snapshot/locale/us/markets/stocks/tickers

Returns: ALL ~10,000+ US stock/ETF tickers with latest price data
Cost: 1 API call
Response size: ~5-8 MB (compressed ~1-2 MB)
```

This means you can update your entire price database with a **single API call every 15 minutes**. No other provider offers this efficiency.

```
Plan comparison:
                   Starter ($29)    Developer ($79)    Advanced ($199)
Snapshot           Yes              Yes                Yes
Real-time          No (15-min)      Yes                Yes
WebSocket          No               Yes                Yes
Rate limit         5/sec            100/sec            Unlimited
Crypto             Yes              Yes                Yes
Options            Yes              Yes                Yes
```

**Polygon.io per-call costs:**
```
Starter: $29/mo for 5 req/sec
  Snapshot every 15 min during market hours: 26 calls/day
  Snapshot every 15 min 24/7 for crypto: 96 calls/day
  Total: ~122 calls/day = trivial usage
  Effective cost per snapshot: $29 / (122 x 21) = $0.011 per call
```

**Alpaca Markets -- Best for Paper Trading Integration**

Alpaca is unique because it offers both a **paper trading API** and **market data** in one platform:
- Free paper trading account with simulated executions
- IEX real-time data free
- SIP real-time data at $99/mo
- Built-in WebSocket streaming
- Crypto included

If your app uses Alpaca as both the paper trading engine and data source, you get a unified experience.

**IEX Cloud -- Pay-Per-Use Model**

IEX Cloud uses a credit system:
```
1 quote = ~1 message credit
10,000 quotes = ~10,000 credits
Credits per month (Launch plan): ~500,000 included ($9/mo)
10,000 tickers x 26 intervals x 21 days = ~5.5M credits/month

Estimated cost for full US market coverage:
  Launch plan + overage: ~$50-100/month
```

### 4.3 Enterprise Providers

| Provider | Cost | Coverage | Latency | Use Case |
|----------|------|----------|---------|----------|
| **Bloomberg B-PIPE** | $2,000-$25,000+/mo | Everything, global | <1ms | Institutional |
| **Refinitiv (LSEG)** Elektron | $1,000-$10,000+/mo | Everything, global | <1ms | Institutional |
| **Xignite** | $500-$5,000+/mo | Stocks, ETFs, Forex | <100ms | Fintech apps |
| **Nasdaq Global Data** | Varies | NASDAQ-listed | <1ms | Direct feed |
| **NYSE Market Data** | Varies | NYSE-listed | <1ms | Direct feed |

Enterprise solutions are overkill for a paper trading app. They are listed for completeness.

### 4.4 WebSocket/Streaming Comparison

| Provider | Free WS? | Paid WS? | Data Type | Max Subscriptions |
|----------|----------|----------|-----------|-------------------|
| Finnhub | Yes | Yes | Trades | 50 (free), unlimited (paid) |
| Polygon.io | No | Yes ($79+) | Trades, Quotes, Aggs | Unlimited |
| Alpaca | Yes | Yes | Trades, Quotes, Bars | Unlimited |
| Twelve Data | Limited | Yes | Price updates | 1 (free), varies (paid) |
| Tiingo | Yes | Yes | IEX trades | Varies |
| IEX Cloud | No | Yes | Trades, Quotes | Varies |
| CoinGecko | No | No | N/A | N/A |

**Best free WebSocket options:** Alpaca and Finnhub both offer free WebSocket streaming with decent limits.

### 4.5 Price Per API Call Analysis

| Provider | Tier | Monthly Cost | Effective Calls/mo | Cost per Call |
|----------|------|-------------|-------------------|---------------|
| Yahoo Finance | Free | $0 | Unlimited (risky) | $0 |
| Alpha Vantage | Free | $0 | 750 (25/day) | $0 |
| Finnhub | Free | $0 | ~2.6M (60/min) | $0 |
| Alpaca | Free | $0 | ~8.6M (200/min) | $0 |
| Polygon.io | Starter | $29 | ~13M (5/sec) | $0.0000022 |
| Polygon.io | Developer | $79 | ~259M (100/sec) | $0.0000003 |
| Alpha Vantage | Premium | $49.99 | ~3.2M (75/min) | $0.000016 |
| Twelve Data | Grow | $29 | ~1.3M (30/min) | $0.000022 |
| IEX Cloud | Launch | $9 + usage | ~500K base | $0.000018+ |

---

## 5. Optimal Architecture for a Paper Trading App

### 5.1 What Do Production Apps Use?

| App | Market Data Source | Architecture |
|-----|-------------------|--------------|
| **Robinhood** | Direct exchange feeds (SIP/CTA) + Nasdaq Last Sale | Server-side aggregation, WebSocket push to clients |
| **Webull** | Nasdaq TotalView, NYSE Arca | Server-side with WebSocket push |
| **Public** | IEX Cloud (previously), Nasdaq | Server-side aggregation |
| **Moomoo** | Nasdaq, direct feeds | Server-side with WebSocket |
| **Alpaca** | SIP + IEX | Server-side, REST + WebSocket API |
| **TradingView** | Multiple direct feeds | Massive server infrastructure, WebSocket push |

**Key insight:** Every production trading app uses **server-side aggregation with WebSocket push to clients**. No production app has phones fetch prices directly from exchanges.

### 5.2 Recommended Architecture

```
                    MARKET DATA ARCHITECTURE
                    =======================

    +------------------+     +------------------+
    |  Polygon.io API  |     |  CoinGecko API   |
    |  (Snapshot: ALL   |     |  (Top 250 coins) |
    |   US tickers)    |     |                  |
    +--------+---------+     +--------+---------+
             |                        |
             v                        v
    +------------------------------------------------+
    |         CLOUDFLARE WORKER: Price Fetcher        |
    |                                                 |
    |  CRON Trigger: Every 15 min (market hours)     |
    |  CRON Trigger: Every 15 min (crypto, 24/7)     |
    |                                                 |
    |  1. Fetch snapshot from Polygon                |
    |  2. Fetch crypto from CoinGecko                |
    |  3. Parse & normalize                          |
    |  4. Write to KV (hot cache)                    |
    |  5. Write to D1 (historical)                   |
    +-----+------------------+-----------------------+
          |                  |
          v                  v
    +----------+      +------------+
    | CF KV    |      | CF D1      |
    | (Cache)  |      | (History)  |
    |          |      |            |
    | Key:     |      | Tables:    |
    | AAPL ->  |      | prices     |
    | {price,  |      | trades     |
    | vol,     |      | portfolios |
    | time}    |      |            |
    +-----+----+      +------+-----+
          |                  |
          v                  v
    +------------------------------------------------+
    |         CLOUDFLARE WORKER: API Server           |
    |                                                 |
    |  GET /api/quotes?symbols=AAPL,MSFT,BTC         |
    |  GET /api/quotes/AAPL                           |
    |  GET /api/quotes/snapshot (all prices)          |
    |  GET /api/search?q=Apple                        |
    |  WebSocket: /ws/prices (Durable Objects)       |
    +-----+-------------------+-----------------------+
          |                   |
          v                   v
    +----------+        +----------+
    | iOS App  |        | iOS App  |
    | (User A) |        | (User B) |
    +----------+        +----------+
```

### 5.3 Cron-Based Price Fetcher (Core Component)

```
MARKET HOURS SCHEDULE (ET):
============================
04:00 - 09:30  Pre-Market    --> Fetch every 15 min (optional)
09:30 - 16:00  Market Hours  --> Fetch every 15 min (required)
16:00 - 20:00  After Hours   --> Fetch every 15 min (optional)
20:00 - 04:00  Closed        --> No fetching for stocks

CRYPTO SCHEDULE:
================
24/7/365 --> Fetch every 15 min always

WEEKEND SCHEDULE:
=================
Stocks: No fetching (show Friday close)
Crypto: Continue every 15 min
```

### 5.4 WebSocket Push vs Polling

| Approach | Pros | Cons | Best For |
|----------|------|------|----------|
| **Client Polling** (every 15s-60s) | Simple, stateless, CF Worker friendly | Higher bandwidth, stale data between polls | MVP, small user base |
| **WebSocket Push** | Real-time updates, low bandwidth | Requires Durable Objects ($), connection management | Growth phase, real-time feel |
| **Server-Sent Events (SSE)** | Simpler than WS, one-way push | Limited browser support for some features | Middle ground |
| **Long Polling** | Works everywhere, near-real-time | Connection overhead | Fallback option |

**For MVP:** Client polling every 15-30 seconds is fine. The data only updates every 15 minutes anyway.

**For Growth:** Cloudflare Durable Objects enable WebSocket connections. When new prices arrive (via Cron), the Durable Object broadcasts to all connected clients.

### 5.5 Cloudflare-Specific Considerations

**Cloudflare Workers Limits:**

| Resource | Free | Paid ($5/mo) |
|----------|------|-------------|
| Requests/day | 100,000 | 10M included |
| CPU time/request | 10ms | 30ms (50ms burst) |
| KV reads/day | 100,000 | 10M included |
| KV writes/day | 1,000 | 1M included |
| D1 rows read/day | 5M | 25B |
| D1 rows written/day | 100K | 50M |
| Cron triggers | 3 | Unlimited |
| Durable Objects | N/A | $0.15/M requests |

**Key constraints:**

1. **CPU time (30ms):** Parsing a 5 MB Polygon snapshot in 30ms is tight. Solution: Use streaming JSON parsing or split into multiple Worker invocations.

2. **KV write limits:** Writing 10,000 keys (one per ticker) = 10,000 KV writes per Cron run. At 26 runs/day = 260,000 writes/day. This is within the 1M/day paid limit.

3. **KV vs D1 for price cache:**
   - **KV is better for current prices** (key-value lookup, global edge cache, ~10ms reads)
   - **D1 is better for historical data** (SQL queries, aggregations, joins with portfolio data)

4. **Cron trigger strategy:**
   ```
   */15 * * * 1-5  --> Stocks: Every 15 min, Monday-Friday
   */15 * * * *    --> Crypto: Every 15 min, every day
   ```

5. **Worker chaining for CPU limits:**
   ```
   Cron Worker (fetch data) --> Queue --> Processing Worker (parse/store)
   ```
   Using Cloudflare Queues to split the work across multiple Worker invocations, each staying under CPU limits.

### 5.6 Handling Market Hours

```typescript
// Pseudocode for market hours detection
function getMarketState(): MarketState {
  const now = new Date();
  const et = toEasternTime(now);
  const hour = et.getHours();
  const minute = et.getMinutes();
  const day = et.getDay(); // 0=Sun, 6=Sat
  const time = hour * 100 + minute;

  // Weekend
  if (day === 0 || day === 6) return 'CLOSED';

  // Check market holidays (maintain a holiday calendar)
  if (isMarketHoliday(et)) return 'CLOSED';

  // Market hours
  if (time >= 930 && time < 1600) return 'OPEN';
  if (time >= 400 && time < 930) return 'PRE_MARKET';
  if (time >= 1600 && time < 2000) return 'AFTER_HOURS';

  return 'CLOSED';
}
```

---

## 6. Recommendations for This App (Cloudflare Workers + D1 + KV)

### 6.1 MVP Phase (0 - 1,000 Users) -- FREE

**Recommended: Alpaca (Free) + CoinGecko (Free)**

```
Cost: $0/month (data) + $5/month (CF Workers paid plan)
Total: $5/month

Data sources:
- Alpaca Free: US stocks + ETFs (IEX real-time, ~6,500 tickers)
- Alpaca Free: Crypto (~30 coins)
- CoinGecko Free: Additional crypto (top 250)

Architecture:
- CF Cron Worker fetches from Alpaca every 15 min
- Separate Cron for CoinGecko crypto (every 15 min)
- Store current prices in KV
- Store history in D1
- iOS app polls your CF Worker API

Rate limit management:
- Alpaca: 200 req/min -- fetch in batches of 200 symbols
- 6,500 tickers / 200 per request = 33 requests per Cron run
- CoinGecko: 10-30 req/min -- 1-2 requests for top 250 coins
- Total: ~35 API calls every 15 minutes = trivial
```

**Why Alpaca for MVP:**
- Free paper trading API (could integrate later)
- WebSocket streaming included free
- Crypto included
- Well-documented, reliable
- IEX real-time (not 15-min delayed)

**Alternative free option: Finnhub (Free) + CoinGecko**
- 60 req/min, free WebSocket for real-time trades
- Less comprehensive than Alpaca for batch fetching

### 6.2 Growth Phase (1,000 - 10,000 Users) -- $30-80/month

**Recommended: Polygon.io Starter ($29/mo) + CoinGecko (Free)**

```
Cost: $29/month (Polygon) + $5/month (CF Workers) = $34/month

Why upgrade to Polygon:
- Snapshot endpoint: ALL tickers in 1 API call
- Much simpler architecture (no batching logic)
- Options data included (for future features)
- Higher reliability and SLA

Architecture upgrade:
- CF Cron: 1 call to Polygon snapshot every 15 min
- CF Cron: 1 call to CoinGecko every 15 min
- Total: 2 API calls per Cron run (!!!)
- Add Durable Objects for WebSocket push ($0.15/M requests)
```

**Polygon snapshot workflow:**
```typescript
// Every 15 minutes during market hours
async function fetchAllPrices(env: Env) {
  // ONE call gets ALL US stock/ETF prices
  const resp = await fetch(
    `https://api.polygon.io/v2/snapshot/locale/us/markets/stocks/tickers?apiKey=${env.POLYGON_KEY}`
  );
  const data = await resp.json();

  // data.tickers is an array of ~10,000 objects
  // Each has: ticker, day, lastTrade, lastQuote, min, prevDay, etc.

  // Batch write to KV
  for (const ticker of data.tickers) {
    await env.PRICES_KV.put(
      ticker.ticker,
      JSON.stringify({
        price: ticker.lastTrade?.p || ticker.day?.c,
        open: ticker.day?.o,
        high: ticker.day?.h,
        low: ticker.day?.l,
        close: ticker.prevDay?.c,
        volume: ticker.day?.v,
        change: ticker.todaysChange,
        changePercent: ticker.todaysChangePerc,
        updated: ticker.updated,
      }),
      { expirationTtl: 900 } // 15 min TTL
    );
  }
}
```

### 6.3 Scale Phase (10,000 - 100,000 Users) -- $100-300/month

**Recommended: Polygon.io Developer ($79/mo) + CoinGecko Pro ($129/mo)**

```
Cost: $79/month (Polygon) + $129/month (CoinGecko Pro) + $25-50/month (CF)
Total: ~$233-258/month

Why upgrade:
- Polygon Developer: Real-time data + WebSocket streaming
- Can push real-time prices to users via WebSocket
- CoinGecko Pro: Higher rate limits, priority support
- Better user experience with real-time prices

Architecture upgrade:
- Polygon WebSocket for real-time stock prices
- Durable Objects manage client WebSocket connections
- Prices update in real-time (not just every 15 min)
- D1 stores tick-level data for charts
- Consider Cloudflare R2 for historical data archival
```

### 6.4 Migration Path

```
PHASE 1 (MVP):       Alpaca Free + CoinGecko Free
  |                   Cost: $5/mo
  | When: >1K users or need options data
  v
PHASE 2 (Growth):    Polygon.io Starter + CoinGecko Free
  |                   Cost: $34/mo
  | When: >10K users or need real-time
  v
PHASE 3 (Scale):     Polygon.io Developer + CoinGecko Pro
  |                   Cost: ~$250/mo
  | When: >100K users or institutional needs
  v
PHASE 4 (Enterprise): Polygon.io Advanced + direct feeds
                      Cost: $500+/mo
```

**The migration is smooth because:**
- Data normalization layer abstracts the provider
- KV/D1 schema stays the same regardless of source
- Only the Cron Worker's fetch logic changes
- Client API remains identical

### 6.5 Monthly Cost Breakdown by User Count

| Users | Data Provider | CF Workers | CF KV/D1 | Durable Objects | Total/month |
|-------|--------------|-----------|----------|----------------|-------------|
| 0-100 | Free (Alpaca) | $5 | Included | N/A | **$5** |
| 100-1K | Free (Alpaca) | $5 | Included | N/A | **$5** |
| 1K-5K | Polygon Starter ($29) | $5 | ~$1 | $5 (optional) | **$35-40** |
| 5K-10K | Polygon Starter ($29) | $5 | ~$5 | $15 | **$54** |
| 10K-50K | Polygon Developer ($79) | $5 | ~$15 | $50 | **$149** |
| 50K-100K | Polygon Developer ($79) | $5 | ~$50 | $150 | **$284** |
| 100K+ | Polygon Advanced ($199) | $5 | ~$100+ | $300+ | **$604+** |

---

## 7. The "Update Everything at Once" Approach

### 7.1 Is It Feasible?

**Yes, with Polygon.io.** This is the only provider that makes it trivially easy.

```
Polygon Snapshot Endpoint:
  URL: GET /v2/snapshot/locale/us/markets/stocks/tickers
  Returns: ALL ~10,000+ US tickers in ONE call
  Response: ~5-8 MB JSON (uncompressed), ~1-2 MB gzip
  Latency: 1-3 seconds
  Cost: 1 API call per request

Calls per day:
  Market hours (6.5h, every 15 min): 26 calls
  Extended hours (4h, every 15 min): 16 calls
  Total: ~42 calls/day
  Monthly (21 trading days): ~882 calls

Polygon Starter ($29/mo) allows 5 req/sec = ~13M req/month
882 calls/month is nothing.
```

### 7.2 Batch/Bulk APIs Comparison

| Provider | Bulk Method | Symbols per Call | Covers All US? | Cost |
|----------|-----------|-----------------|---------------|------|
| **Polygon.io** | Snapshot endpoint | ALL (~10K+) | Yes | $29+/mo |
| **Alpaca** | Multi-bar/quote endpoint | ~200 per call | Need ~33 calls | Free |
| **Finnhub** | No bulk endpoint | 1 per call | Need 10K calls | Impractical |
| **Yahoo Finance** | v7 quote (unofficial) | ~1,200 per call | Need ~9 calls | Free (risky) |
| **IEX Cloud** | Batch quote | ~100 per call | Need ~100 calls | $$ (credits) |
| **Twelve Data** | Batch quote | ~120 per call | Need ~83 calls | $79+/mo |
| **Tiingo** | No bulk snapshot | 1 per call | Need 10K calls | Impractical |

**Polygon is uniquely suited for the "update everything" approach.**

### 7.3 Polygon Snapshot Response Structure

```json
{
  "status": "OK",
  "count": 10327,
  "tickers": [
    {
      "ticker": "AAPL",
      "todaysChange": 2.35,
      "todaysChangePerc": 1.05,
      "updated": 1234567890000,
      "day": {
        "o": 223.45,  // open
        "h": 226.80,  // high
        "l": 222.10,  // low
        "c": 225.80,  // close (current)
        "v": 45678901, // volume
        "vw": 224.55   // VWAP
      },
      "lastTrade": {
        "p": 225.80,   // price
        "s": 100,      // size
        "t": 1234567890000 // timestamp
      },
      "lastQuote": {
        "P": 225.81,   // ask price
        "S": 200,      // ask size
        "p": 225.79,   // bid price
        "s": 300       // bid size
      },
      "min": {
        "o": 225.50,   // minute open
        "h": 225.85,   // minute high
        "l": 225.45,   // minute low
        "c": 225.80,   // minute close
        "v": 12345     // minute volume
      },
      "prevDay": {
        "o": 221.00,
        "h": 224.50,
        "l": 220.80,
        "c": 223.45,
        "v": 52345678
      }
    },
    // ... ~10,326 more tickers
  ]
}
```

### 7.4 Storage Requirements in D1/KV

**KV Storage (Current Prices -- Hot Cache):**
```
Per ticker: ~300 bytes (JSON value)
Total tickers: ~10,500
Total KV storage: ~3.15 MB
KV reads per user request: 1-50 (depending on watchlist size)
KV writes per Cron: ~10,500 (one per ticker)

Cost: Included in CF Workers paid plan (25M reads/mo, 1M writes/mo)
10,500 writes x 42 Cron runs/day x 21 days = ~9.3M writes/month
This exceeds the 1M included! Need additional KV writes.
```

**Optimization: Write prices as bulk JSON, not individual keys:**
```
Instead of:
  KV.put("AAPL", {...})     // 1 write
  KV.put("MSFT", {...})     // 1 write
  ... x 10,500 = 10,500 writes per Cron

Use:
  KV.put("prices:batch:0", JSON.stringify(tickers[0..999]))     // 1 write
  KV.put("prices:batch:1", JSON.stringify(tickers[1000..1999])) // 1 write
  ... x 11 = 11 writes per Cron

  KV.put("prices:index", JSON.stringify(tickerToBatchMap))      // 1 write
  Total: 12 writes per Cron run
  Monthly: 12 x 42 x 21 = ~10,584 writes/month (well within 1M limit!)
```

**D1 Storage (Historical Prices):**
```
Schema:
CREATE TABLE price_snapshots (
  ticker TEXT NOT NULL,
  price REAL NOT NULL,
  open REAL,
  high REAL,
  low REAL,
  volume INTEGER,
  change_pct REAL,
  fetched_at INTEGER NOT NULL,
  PRIMARY KEY (ticker, fetched_at)
);

Per row: ~100 bytes
Rows per Cron run: ~10,500
Rows per day: ~441,000 (42 intervals x 10,500 tickers)
Rows per month: ~9.3M
Storage per month: ~930 MB

D1 limits:
  Free: 5 GB storage, 5M rows read/day
  Paid: 5 GB included, $0.75/GB beyond

Retention strategy:
  Keep 15-min granularity for 7 days
  Aggregate to hourly for 30 days
  Aggregate to daily for 1 year
  Delete anything older

With pruning: ~500 MB - 1 GB steady state
```

### 7.5 Alternative: Only Update "Active" Instruments

Instead of updating ALL tickers, only update tickers that users actually hold or watch:

```
Active tickers = UNION of:
  - All tickers in user portfolios (holdings)
  - All tickers in user watchlists
  - Top 500 most popular tickers (S&P 500)
  - Top 100 crypto

Typical active set: 500-2,000 tickers (even with 10K users)

Benefits:
  - 5-20x fewer API calls
  - 5-20x less storage
  - Stays within free tier limits
  - Faster Cron execution

Drawback:
  - Prices for untracked tickers are stale/missing
  - Need to fetch on-demand when user searches
```

**Recommended hybrid approach:**
```
1. Cron (every 15 min): Update "active" tickers (~1,000-2,000)
2. On-demand: When user searches/adds a new ticker, fetch current price
3. Weekly: Full snapshot to refresh all tickers (for search/discovery)
```

---

## 8. Implementation Roadmap

### Phase 1: MVP (Week 1-2)

```
Goal: Replace Yahoo Finance with Alpaca (free)
Stack: CF Worker (Cron) + KV + D1

Steps:
1. Sign up for Alpaca Paper Trading account (free)
2. Create CF Worker: price-fetcher
   - Cron: */15 9-16 * * 1-5 (market hours)
   - Fetch top 500 stocks + user portfolio tickers from Alpaca
   - Store in KV (batched)
   - Store in D1 (historical)
3. Create CF Worker: api-server
   - GET /api/quotes/:symbol
   - GET /api/quotes?symbols=AAPL,MSFT
   - GET /api/search?q=Apple
4. Update iOS app to use your API instead of Yahoo Finance
5. Add CoinGecko integration for crypto prices
```

### Phase 2: Growth (Month 2-3)

```
Goal: Full market coverage + real-time feel
Stack: CF Worker + KV + D1 + Durable Objects

Steps:
1. Upgrade to Polygon.io Starter ($29/mo)
2. Replace batch fetching with single snapshot call
3. Add all US stocks/ETFs to price cache
4. Implement WebSocket via Durable Objects (optional)
5. Add options chain on-demand fetching
6. Implement price alerts
```

### Phase 3: Scale (Month 6+)

```
Goal: Real-time data + premium features
Stack: CF Worker + KV + D1 + Durable Objects + R2

Steps:
1. Upgrade to Polygon.io Developer ($79/mo)
2. Implement Polygon WebSocket for real-time prices
3. Durable Objects broadcast price updates to clients
4. Move historical data to R2 for long-term storage
5. Add international stocks
6. Implement advanced charting data
```

### Example: Cloudflare Worker Price Fetcher

```typescript
// src/workers/price-fetcher.ts (conceptual example)

interface Env {
  PRICES_KV: KVNamespace;
  DB: D1Database;
  ALPACA_KEY: string;
  ALPACA_SECRET: string;
}

export default {
  async scheduled(event: ScheduledEvent, env: Env, ctx: ExecutionContext) {
    const marketState = getMarketState();

    if (marketState === 'CLOSED') {
      // Only fetch crypto on weekends/closed
      await fetchCryptoPrices(env);
      return;
    }

    // Fetch stock prices
    await fetchStockPrices(env);
    // Fetch crypto prices
    await fetchCryptoPrices(env);
  },
};

async function fetchStockPrices(env: Env) {
  // Get list of active tickers (from user portfolios + watchlists + top 500)
  const tickers = await getActiveTickers(env);

  // Batch into groups of 200 (Alpaca limit)
  const batches = chunk(tickers, 200);

  for (const batch of batches) {
    const symbols = batch.join(',');
    const resp = await fetch(
      `https://data.alpaca.markets/v2/stocks/snapshots?symbols=${symbols}`,
      {
        headers: {
          'APCA-API-KEY-ID': env.ALPACA_KEY,
          'APCA-API-SECRET-KEY': env.ALPACA_SECRET,
        },
      }
    );

    const snapshots = await resp.json();

    // Store each ticker in KV
    const kvPromises = Object.entries(snapshots).map(([symbol, data]: [string, any]) => {
      const priceData = {
        price: data.latestTrade?.p,
        open: data.dailyBar?.o,
        high: data.dailyBar?.h,
        low: data.dailyBar?.l,
        close: data.dailyBar?.c,
        volume: data.dailyBar?.v,
        prevClose: data.prevDailyBar?.c,
        updated: Date.now(),
      };
      return env.PRICES_KV.put(`price:${symbol}`, JSON.stringify(priceData), {
        expirationTtl: 900, // 15 minutes
      });
    });

    await Promise.all(kvPromises);
  }
}

async function fetchCryptoPrices(env: Env) {
  // CoinGecko: Get top 250 coins in one call
  const resp = await fetch(
    'https://api.coingecko.com/api/v3/coins/markets?' +
    'vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=false'
  );

  const coins = await resp.json();

  const kvPromises = coins.map((coin: any) => {
    const priceData = {
      price: coin.current_price,
      open: coin.high_24h, // CoinGecko doesn't have open
      high: coin.high_24h,
      low: coin.low_24h,
      marketCap: coin.market_cap,
      volume: coin.total_volume,
      change24h: coin.price_change_percentage_24h,
      updated: Date.now(),
    };
    // Use CoinGecko symbol uppercased as key
    return env.PRICES_KV.put(
      `price:${coin.symbol.toUpperCase()}`,
      JSON.stringify(priceData),
      { expirationTtl: 900 }
    );
  });

  await Promise.all(kvPromises);
}

function getMarketState(): string {
  const now = new Date();
  const et = new Date(now.toLocaleString('en-US', { timeZone: 'America/New_York' }));
  const day = et.getDay();
  const hours = et.getHours();
  const minutes = et.getMinutes();
  const time = hours * 100 + minutes;

  if (day === 0 || day === 6) return 'CLOSED';
  if (time >= 930 && time < 1600) return 'OPEN';
  if (time >= 400 && time < 930) return 'PRE_MARKET';
  if (time >= 1600 && time < 2000) return 'AFTER_HOURS';
  return 'CLOSED';
}

function chunk<T>(arr: T[], size: number): T[][] {
  const chunks: T[][] = [];
  for (let i = 0; i < arr.length; i += size) {
    chunks.push(arr.slice(i, i + size));
  }
  return chunks;
}

async function getActiveTickers(env: Env): Promise<string[]> {
  // Query D1 for unique tickers across all user portfolios and watchlists
  const result = await env.DB.prepare(`
    SELECT DISTINCT symbol FROM (
      SELECT symbol FROM portfolio_holdings
      UNION
      SELECT symbol FROM watchlist_items
      UNION
      SELECT symbol FROM popular_tickers WHERE rank <= 500
    )
  `).all();

  return result.results.map((row: any) => row.symbol);
}
```

---

## Appendix A: Provider Quick Reference Card

```
DECISION TREE: Which provider should I use?
============================================

Is this an MVP / prototype?
  |
  +--> YES --> Do you need real-time?
  |              |
  |              +--> NO  --> Alpaca Free (IEX delayed OK)
  |              +--> YES --> Finnhub Free (WebSocket)
  |
  +--> NO --> Do you need ALL US tickers at once?
                |
                +--> YES --> Polygon.io Starter ($29/mo)
                |              Need real-time? --> Polygon Developer ($79/mo)
                |
                +--> NO  --> How many tickers?
                               |
                               +--> <500  --> Alpaca Free or Twelve Data Free
                               +--> 500-2K --> Alpaca Free (batch) or Finnhub ($50/mo)
                               +--> 2K+   --> Polygon.io (any tier)
```

## Appendix B: Data Normalization Schema

Regardless of provider, normalize all price data to this schema:

```typescript
interface NormalizedQuote {
  symbol: string;          // "AAPL", "BTC"
  name: string;            // "Apple Inc."
  type: 'stock' | 'etf' | 'crypto' | 'commodity';
  price: number;           // Current/last price
  open: number;            // Day open
  high: number;            // Day high
  low: number;             // Day low
  previousClose: number;   // Previous day close
  volume: number;          // Day volume
  change: number;          // Price change (absolute)
  changePercent: number;   // Price change (percentage)
  marketCap?: number;      // Market capitalization
  updatedAt: number;       // Unix timestamp (ms)
  source: string;          // "alpaca" | "polygon" | "coingecko"
}
```

## Appendix C: Key Takeaways

1. **Server-side fetching is mandatory** for a paper trading app (prevents cheating, protects API keys).

2. **Polygon.io snapshot is the most efficient** way to get all US prices -- one API call for ~10,000 tickers.

3. **Start with Alpaca (free)**, migrate to Polygon when you need full market coverage.

4. **KV for current prices, D1 for history.** Batch KV writes to stay within limits.

5. **Only update "active" tickers** for MVP. Full market snapshot for growth phase.

6. **15-minute update interval** is fine for paper trading. Real-time is a premium feature.

7. **Yahoo Finance scraping is a liability.** Move off it as soon as possible. It can break at any time, violates ToS, and provides no reliability guarantees.

8. **Budget: $5/month (MVP) to $250/month (10K+ users).** Market data is surprisingly affordable for paper trading.

9. **Cloudflare Workers are well-suited** for this architecture. Cron triggers + KV + D1 handle the core use case. Durable Objects add WebSocket push when ready.

10. **Build a provider abstraction layer.** Your iOS app should never know which data provider you use. All provider-specific logic stays in the CF Worker.
