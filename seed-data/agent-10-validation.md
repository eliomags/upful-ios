# Seed Data FK Consistency Validation Report

> Generated: 2026-02-13
> Scope: 11 seed data files for Upful/Jyanik paper trading iOS app

---

## Overall Status: NEEDS FIXES

There are **critical foreign key mismatches** across multiple files due to inconsistent ID character lengths. The data cannot be inserted as-is without violating referential integrity.

---

## 1. User ID (user_id) FK Validation

**Canonical source**: `agent-1-users.md` -- 30 users
**Canonical format**: 32 characters, e.g. `a0000000000000000000000000000001`

| File | FK Column | Format Used | Length | Status |
|------|-----------|-------------|--------|--------|
| agent-1-users.md | (PK) id | `a0000000000000000000000000000001` | 32 | SOURCE |
| agent-1-users.md | device_tokens.user_id | `a0000000000000000000000000000001` | 32 | PASS |
| agent-2a-portfolios.md | portfolios.user_id | `a0000000000000000000000000000001` | 32 | PASS |
| agent-2b-positions.md | positions.user_id | `a0000000000000000000000000000001` | 32 | PASS |
| agent-2c-trades.md | trades.user_id | `a0000000000000000000000000000001` | 32 | PASS |
| agent-3-snapshots.md | portfolio_snapshots.user_id | `a0000000000000000000000000000001` | 32 | PASS |
| agent-4-competitions.md | competition_entries.user_id | `a0000000000000000000000000000001` | 32 | PASS |
| agent-4-competitions.md | leaderboard_cache.user_id | `a0000000000000000000000000000001` | 32 | PASS |
| agent-5-chat.md | chat_messages.user_id | `a000000000000000000000000000001` | **31** | **FAIL** |
| agent-6-notifications.md | notifications.user_id | `a0000000000000000000000000000001` | 32 | PASS |
| agent-7-user-data.md | watchlist.user_id | `a0000000000000000000000000000001` | 32 | PASS |
| agent-7-user-data.md | saved_screeners.user_id | `a0000000000000000000000000000001` | 32 | PASS |
| agent-7-user-data.md | user_preferences.user_id | `a0000000000000000000000000000001` | 32 | PASS |
| agent-7-user-data.md | monthly_resets.user_id | `a0000000000000000000000000000001` | 32 | PASS |
| agent-8a-payouts-purchases.md | payouts.user_id | `a000000000000000000000000000001` | **31** | **FAIL** |
| agent-8a-payouts-purchases.md | payouts.admin_approved_by | `a000000000000000000000000000001e` | **31** | **FAIL** |
| agent-8a-payouts-purchases.md | purchases.user_id | `a000000000000000000000000000001` | **31** | **FAIL** |

### User ID Failures Detail

**agent-5-chat.md** -- All 100 chat_messages rows use 31-char user IDs (missing one `0`):
- Used: `a000000000000000000000000000001` (31 chars)
- Expected: `a0000000000000000000000000000001` (32 chars)
- Pattern: the ID prefix `a` + 30 hex digits instead of 31 hex digits
- Affected users: All users referenced in chat (users 1-7, 9, 11, 12, 16, 19, 25, 30)
- **Fix**: Add one `0` after the `a` prefix in every user_id value

**agent-8a-payouts-purchases.md** -- All 14 payout rows and 9 purchase rows use 31-char user IDs:
- Used: `a000000000000000000000000000001` (31 chars)
- Expected: `a0000000000000000000000000000001` (32 chars)
- Also affects `admin_approved_by` column (uses `a000000000000000000000000000001e` -- 31 chars)
- **Fix**: Add one `0` after the `a` prefix in every user_id and admin_approved_by value

---

## 2. Portfolio ID (portfolio_id) FK Validation

**Canonical source**: `agent-2a-portfolios.md` -- 30 portfolios
**Canonical format**: 33 characters, e.g. `b00000000000000000000000000000101`
**Pattern**: `b0000000000000000000000000000XX01` where XX = user suffix

| File | FK Column | Format Used | Length | Status |
|------|-----------|-------------|--------|--------|
| agent-2a-portfolios.md | (PK) id | `b00000000000000000000000000000101` | 33 | SOURCE |
| agent-2b-positions.md | positions.portfolio_id | `b0000000000000000000000000000101` | **32** | **FAIL** |
| agent-2c-trades.md | trades.portfolio_id | `b0000000000000000000000000000101` | **32** | **FAIL** |
| agent-3-snapshots.md | portfolio_snapshots.portfolio_id | `b00000000000000000000000000010300` | 33 (different pattern) | **FAIL** |
| agent-4-competitions.md | competition_entries.portfolio_id | `b000000000000000000000000000101` | **31** | **FAIL** |

### Portfolio ID Failures Detail

**agent-2b-positions.md** -- All 109 position rows use 32-char portfolio IDs (missing one `0`):
- Used: `b0000000000000000000000000000101` (32 chars)
- Expected: `b00000000000000000000000000000101` (33 chars)
- Pattern: `b` + 28 zeros + suffix vs canonical `b` + 29 zeros + suffix
- **Fix**: Add one `0` after the `b` prefix in every portfolio_id value

**agent-2c-trades.md** -- All trade rows use 32-char portfolio IDs (same issue as 2b):
- Used: `b0000000000000000000000000000101` (32 chars)
- Expected: `b00000000000000000000000000000101` (33 chars)
- **Fix**: Add one `0` after the `b` prefix in every portfolio_id value

**agent-3-snapshots.md** -- Uses completely different portfolio ID scheme:
- Used: `b00000000000000000000000000010300` for User 1 (33 chars, but wrong pattern)
- Expected: `b00000000000000000000000000000101` for User 1
- The snapshot file uses pattern `b00000000000000000000000000XX0300` instead of `b0000000000000000000000000000XX01`
- This is a **complete ID mismatch** -- no snapshot portfolio_id will match any portfolios row
- Affected: All ~450 snapshot rows across all 30 users
- **Fix**: Replace portfolio_id values with canonical IDs from agent-2a

**agent-4-competitions.md** -- All 45 competition_entries rows use 31-char portfolio IDs:
- Used: `b000000000000000000000000000101` (31 chars)
- Expected: `b00000000000000000000000000000101` (33 chars)
- Pattern: `b` + 27 zeros + suffix vs canonical `b` + 29 zeros + suffix (missing 2 zeros)
- **Fix**: Add two `0`s after the `b` prefix in every portfolio_id value

---

## 3. Competition ID (competition_id) FK Validation

**Canonical source**: `agent-4-competitions.md` -- 25 competitions
**Canonical format**: 26 characters, e.g. `f100000000000000000000202402`

| File | FK Column | Format Used | Length | Status |
|------|-----------|-------------|--------|--------|
| agent-4-competitions.md | (PK) id | `f100000000000000000000202402` | 26 | SOURCE |
| agent-4-competitions.md | competition_entries.competition_id | `f100000000000000000000202509` | 26 | PASS |
| agent-4-competitions.md | leaderboard_cache.competition_id | `f100000000000000000000202602` | 26 | PASS |
| agent-6-notifications.md | metadata.competition_id (prize_won) | `f0000000000000000000000000000001` | **32** | **FAIL** |
| agent-6-notifications.md | metadata.competition_id (prize_paid) | `f0000000000000000000000000000001` | **32** | **FAIL** |

### Competition ID Failures Detail

**agent-6-notifications.md** -- prize_won and prize_paid notifications reference competition IDs in a completely different format:
- Used: `f0000000000000000000000000000001` through `f0000000000000000000000000000004` (32 chars, sequential hex)
- Expected: `f100000000000000000000202402`-style IDs (26 chars, date-encoded)
- These notification metadata competition_id values will NEVER match any competition in agent-4
- Affected rows: 8 prize_won + 6 prize_paid = 14 rows
- **Fix**: Replace with actual competition IDs from agent-4 (e.g., `f100000000000000000000202510` for October 2025)

---

## 4. Duplicate PRIMARY KEY Check

| Table | File | Status | Notes |
|-------|------|--------|-------|
| users | agent-1 | PASS | 30 unique IDs (a...0001 - a...001e) |
| device_tokens | agent-1 | PASS | 30 unique IDs |
| portfolios | agent-2a | PASS | 30 unique IDs (b...0101 - b...1e01) |
| positions | agent-2b | PASS | 109 unique IDs (c...0001 - c...006d) |
| trades | agent-2c | PASS | Unique IDs (d...0001+), sequential hex |
| portfolio_snapshots | agent-3 | PASS | Unique IDs (e...0001+), sequential hex |
| competitions | agent-4 | PASS | 25 unique IDs, date-encoded |
| competition_entries | agent-4 | PASS | 45 unique IDs (f2...0001 - f2...002d) |
| leaderboard_cache | agent-4 | PASS | 15 unique IDs (f3...0001 - f3...000f) |
| chat_messages | agent-5 | PASS | 100 unique IDs (g...0001 - g...0064) |
| notifications | agent-6 | PASS | 120 unique IDs (h...0001 - h...0078) |
| watchlist | agent-7 | PASS | ~100 unique IDs (i1...) |
| saved_screeners | agent-7 | PASS | ~30 unique IDs (i2...) |
| user_preferences | agent-7 | PASS | ~50 unique IDs (i3...) |
| monthly_resets | agent-7 | PASS | ~40 unique IDs (i4...) |
| payouts | agent-8a | PASS | 14 unique IDs (j1...) |
| purchases | agent-8a | PASS | 9 unique IDs (j2...) |
| market_quotes | agent-8b | PASS | 69 unique ticker symbols |
| market_news | agent-8b | PASS | Unique IDs |

**Result: PASS -- No duplicate primary keys detected in any table.**

---

## 5. UNIQUE Constraint Check

### (user_id, ticker) in watchlist
- **Status: PASS** -- Each user has unique tickers in their watchlist. No duplicates found.

### (user_id, ticker) in positions
- **Status: PASS** -- Each user has unique tickers in their positions. No duplicates found across 109 rows.

### (competition_id, user_id) in competition_entries
- **Status: PASS** -- Each user appears at most once per competition across all 45 entries (15 entries x 3 competitions).

### (competition_id, user_id) in leaderboard_cache
- **Status: PASS** -- Each user appears at most once in the Feb 2026 leaderboard cache (15 entries).

---

## 6. Market Quotes Ticker Coverage

**Source**: `agent-8b-market-data.md` -- 69 tickers (49 stocks + 8 crypto + 12 ETFs)

**Tickers referenced in positions (agent-2b)**: AAPL, NVDA, TSLA, META, BTC, ETH, SOL, MSFT, AMD, SPY, DOGE, GOOGL, AMZN, NFLX, QQQ, VOO, VTI, IWM, XLF, JNJ, PG, KO, BRK.B, CRM, SOFI, PEP, T, VZ, GME, AMC, BBBY, PLTR, GLD, COIN, RIVN, LCID, ADA (37 tickers)

| Position Ticker | In market_quotes? | Status |
|----------------|-------------------|--------|
| AAPL | Yes | PASS |
| NVDA | Yes | PASS |
| TSLA | Yes | PASS |
| META | Yes | PASS |
| BTC | Yes | PASS |
| ETH | Yes | PASS |
| SOL | Yes | PASS |
| MSFT | Yes | PASS |
| AMD | Yes | PASS |
| SPY | Yes | PASS |
| DOGE | Yes | PASS |
| GOOGL | Yes | PASS |
| AMZN | Yes | PASS |
| NFLX | Yes | PASS |
| QQQ | Yes | PASS |
| VOO | Yes | PASS |
| VTI | Yes | PASS |
| IWM | Yes | PASS |
| XLF | Yes | PASS |
| JNJ | Yes | PASS |
| PG | Yes | PASS |
| KO | Yes | PASS |
| BRK.B | Yes | PASS |
| CRM | Yes | PASS |
| SOFI | Yes | PASS |
| PEP | Yes | PASS |
| T | Yes | PASS |
| VZ | Yes | PASS |
| GME | Yes | PASS |
| AMC | Yes | PASS |
| BBBY | Yes | PASS |
| PLTR | Yes | PASS |
| GLD | Yes | PASS |
| COIN | Yes | PASS |
| RIVN | Yes | PASS |
| LCID | Yes | PASS |
| ADA | Yes | PASS |

**Result: PASS -- All 37 tickers in positions have corresponding market_quotes rows.**

---

## Summary of All Checks

| # | Check | Status | Severity |
|---|-------|--------|----------|
| 1 | user_id FK (agent-5-chat.md) | **FAIL** | HIGH -- 100 rows with 31-char IDs instead of 32-char |
| 2 | user_id FK (agent-8a-payouts-purchases.md) | **FAIL** | HIGH -- 23 rows with 31-char IDs instead of 32-char |
| 3 | portfolio_id FK (agent-2b-positions.md) | **FAIL** | HIGH -- 109 rows with 32-char IDs instead of 33-char |
| 4 | portfolio_id FK (agent-2c-trades.md) | **FAIL** | HIGH -- All trade rows with 32-char IDs instead of 33-char |
| 5 | portfolio_id FK (agent-3-snapshots.md) | **FAIL** | CRITICAL -- ~450 rows use completely wrong ID pattern |
| 6 | portfolio_id FK (agent-4-competitions.md entries) | **FAIL** | HIGH -- 45 rows with 31-char IDs instead of 33-char |
| 7 | competition_id FK (agent-6 notifications metadata) | **FAIL** | MEDIUM -- 14 rows reference non-existent competition IDs |
| 8 | Duplicate PRIMARY keys | PASS | -- |
| 9 | UNIQUE (user_id, ticker) in watchlist | PASS | -- |
| 10 | UNIQUE (user_id, ticker) in positions | PASS | -- |
| 11 | UNIQUE (competition_id, user_id) in entries | PASS | -- |
| 12 | UNIQUE (competition_id, user_id) in leaderboard | PASS | -- |
| 13 | Market quotes ticker coverage | PASS | -- |

---

## Required Fixes (Priority Order)

### CRITICAL
1. **agent-3-snapshots.md**: Replace ALL portfolio_id values with canonical IDs from agent-2a.
   - Current: `b00000000000000000000000000010300` (User 1), `b00000000000000000000000000020300` (User 2), etc.
   - Correct: `b00000000000000000000000000000101` (User 1), `b00000000000000000000000000000201` (User 2), etc.
   - Impact: ~450 rows

### HIGH
2. **agent-2b-positions.md**: Add one `0` to each portfolio_id (32 -> 33 chars).
   - Current: `b0000000000000000000000000000101`
   - Correct: `b00000000000000000000000000000101`
   - Impact: 109 rows

3. **agent-2c-trades.md**: Add one `0` to each portfolio_id (32 -> 33 chars).
   - Current: `b0000000000000000000000000000101`
   - Correct: `b00000000000000000000000000000101`
   - Impact: ~300+ rows

4. **agent-4-competitions.md**: Add two `0`s to each entry portfolio_id (31 -> 33 chars).
   - Current: `b000000000000000000000000000101`
   - Correct: `b00000000000000000000000000000101`
   - Impact: 45 rows

5. **agent-5-chat.md**: Add one `0` to each user_id (31 -> 32 chars).
   - Current: `a000000000000000000000000000001`
   - Correct: `a0000000000000000000000000000001`
   - Impact: 100 rows

6. **agent-8a-payouts-purchases.md**: Add one `0` to each user_id and admin_approved_by (31 -> 32 chars).
   - Current: `a000000000000000000000000000001`
   - Correct: `a0000000000000000000000000000001`
   - Impact: 23 rows (14 payouts + 9 purchases)

### MEDIUM
7. **agent-6-notifications.md**: Replace competition_id values in prize_won and prize_paid metadata JSON.
   - Current: `f0000000000000000000000000000001` through `f0000000000000000000000000000004`
   - Correct: Map to actual competition IDs from agent-4 (e.g., `f100000000000000000000202510` for Oct 2025)
   - Impact: 14 rows (8 prize_won + 6 prize_paid)

---

## Files With No Issues

| File | Tables | Status |
|------|--------|--------|
| agent-1-users.md | users, device_tokens | PASS |
| agent-2a-portfolios.md | portfolios | PASS (canonical source) |
| agent-7-user-data.md | watchlist, saved_screeners, user_preferences, monthly_resets | PASS |
| agent-8b-market-data.md | market_quotes, market_news | PASS |

---

## ID Length Reference

For quick debugging, here are the canonical ID lengths for each entity:

| Entity | Prefix | Total Length | Example |
|--------|--------|-------------|---------|
| User | `a` | 32 | `a0000000000000000000000000000001` |
| Portfolio | `b` | 33 | `b00000000000000000000000000000101` |
| Position | `c` | 32 | `c0000000000000000000000000000001` |
| Trade | `d` | 32 | `d0000000000000000000000000000001` |
| Snapshot | `e` | 32 | `e0000000000000000000000000000001` |
| Competition | `f1` | 26 | `f100000000000000000000202402` |
| Comp Entry | `f2` | 32 | `f2000000000000000000000000000001` |
| Leaderboard | `f3` | 32 | `f3000000000000000000000000000001` |
| Chat | `g` | 32 | `g0000000000000000000000000000001` |
| Notification | `h` | 32 | `h0000000000000000000000000000001` |
| Watchlist | `i1` | 33 | `i10000000000000000000000000000001` |
| Screener | `i2` | 33 | `i20000000000000000000000000000001` |
| Preference | `i3` | 33 | `i30000000000000000000000000000001` |
| Reset | `i4` | 33 | `i40000000000000000000000000000001` |
| Payout | `j1` | 32 | `j1000000000000000000000000000001` |
| Purchase | `j2` | 32 | `j2000000000000000000000000000001` |
