# Agent 8B: Market Data Seed SQL

## market_quotes

```sql
INSERT INTO market_quotes (ticker, asset_type, company_name, current_price, previous_close, open_price, day_high, day_low, volume, market_cap, pe_ratio, dividend_yield, change_dollar, change_percent, updated_at) VALUES
-- Stocks (50 tickers)
('AAPL','stock','Apple Inc.',248.50,245.20,246.80,250.10,244.90,52000000,3850000000000,32.5,0.52,3.30,1.35,'2026-02-13T16:00:00.000Z'),
('MSFT','stock','Microsoft Corporation',472.30,468.50,469.00,475.00,467.20,28000000,3510000000000,35.8,0.72,3.80,0.81,'2026-02-13T16:00:00.000Z'),
('NVDA','stock','NVIDIA Corporation',142.80,139.50,140.20,144.50,138.80,85000000,3490000000000,55.2,0.03,3.30,2.37,'2026-02-13T16:00:00.000Z'),
('GOOGL','stock','Alphabet Inc.',198.40,195.80,196.50,200.20,194.90,22000000,2430000000000,24.1,0.50,2.60,1.33,'2026-02-13T16:00:00.000Z'),
('AMZN','stock','Amazon.com Inc.',232.50,229.80,230.00,234.00,228.50,35000000,2420000000000,42.3,NULL,-2.70,1.17,'2026-02-13T16:00:00.000Z'),
('META','stock','Meta Platforms Inc.',652.80,645.20,648.00,658.00,642.50,18000000,1650000000000,28.4,0.35,7.60,1.18,'2026-02-13T16:00:00.000Z'),
('TSLA','stock','Tesla Inc.',425.30,418.50,420.00,430.00,415.80,42000000,1350000000000,68.5,NULL,6.80,1.62,'2026-02-13T16:00:00.000Z'),
('AMD','stock','Advanced Micro Devices Inc.',128.40,125.80,126.50,130.00,124.90,38000000,207000000000,42.8,NULL,2.60,2.07,'2026-02-13T16:00:00.000Z'),
('NFLX','stock','Netflix Inc.',925.50,918.20,920.00,930.00,915.00,8500000,398000000000,45.2,NULL,7.30,0.79,'2026-02-13T16:00:00.000Z'),
('CRM','stock','Salesforce Inc.',342.80,338.50,340.00,345.00,337.00,6200000,330000000000,52.1,0.58,4.30,1.27,'2026-02-13T16:00:00.000Z'),
('INTC','stock','Intel Corporation',24.80,24.20,24.50,25.30,23.90,45000000,106000000000,NULL,1.62,0.60,2.48,'2026-02-13T16:00:00.000Z'),
('ORCL','stock','Oracle Corporation',185.20,182.80,183.50,187.00,181.50,9800000,510000000000,38.5,1.08,2.40,1.31,'2026-02-13T16:00:00.000Z'),
('ADBE','stock','Adobe Inc.',485.30,480.50,482.00,488.00,479.00,4200000,213000000000,35.2,NULL,4.80,1.00,'2026-02-13T16:00:00.000Z'),
('JPM','stock','JPMorgan Chase & Co.',248.50,245.80,246.00,250.00,244.50,8500000,715000000000,13.2,2.15,2.70,1.10,'2026-02-13T16:00:00.000Z'),
('V','stock','Visa Inc.',312.40,309.50,310.00,314.00,308.00,5200000,615000000000,31.5,0.72,2.90,0.94,'2026-02-13T16:00:00.000Z'),
('MA','stock','Mastercard Inc.',528.30,524.50,525.00,530.00,522.00,3800000,490000000000,35.8,0.55,3.80,0.72,'2026-02-13T16:00:00.000Z'),
('GS','stock','Goldman Sachs Group Inc.',612.50,605.80,608.00,618.00,603.00,2800000,205000000000,15.8,2.18,6.70,1.11,'2026-02-13T16:00:00.000Z'),
('BAC','stock','Bank of America Corp.',45.80,45.20,45.40,46.30,44.90,32000000,360000000000,13.5,2.42,0.60,1.33,'2026-02-13T16:00:00.000Z'),
('BLK','stock','BlackRock Inc.',985.50,978.20,980.00,990.00,975.00,1200000,148000000000,22.5,2.12,7.30,0.75,'2026-02-13T16:00:00.000Z'),
('JNJ','stock','Johnson & Johnson',162.30,160.80,161.00,163.50,159.90,7500000,391000000000,18.2,2.95,1.50,0.93,'2026-02-13T16:00:00.000Z'),
('UNH','stock','UnitedHealth Group Inc.',548.20,542.50,545.00,552.00,540.00,3200000,505000000000,21.8,1.42,5.70,1.05,'2026-02-13T16:00:00.000Z'),
('PFE','stock','Pfizer Inc.',28.50,28.10,28.20,29.00,27.80,35000000,161000000000,12.5,5.82,0.40,1.42,'2026-02-13T16:00:00.000Z'),
('LLY','stock','Eli Lilly and Company',825.30,818.50,820.00,830.00,815.00,4500000,783000000000,68.2,0.72,6.80,0.83,'2026-02-13T16:00:00.000Z'),
('ABBV','stock','AbbVie Inc.',192.80,190.50,191.00,194.00,189.50,6800000,340000000000,18.5,3.52,2.30,1.21,'2026-02-13T16:00:00.000Z'),
('KO','stock','The Coca-Cola Company',62.50,61.80,62.00,63.00,61.50,15000000,270000000000,24.8,2.95,0.70,1.13,'2026-02-13T16:00:00.000Z'),
('PEP','stock','PepsiCo Inc.',172.80,171.20,171.50,174.00,170.50,5800000,237000000000,22.5,2.72,1.60,0.93,'2026-02-13T16:00:00.000Z'),
('PG','stock','Procter & Gamble Co.',168.50,166.80,167.00,169.50,165.90,6200000,398000000000,25.2,2.42,1.70,1.02,'2026-02-13T16:00:00.000Z'),
('WMT','stock','Walmart Inc.',185.30,183.50,184.00,187.00,182.80,8500000,498000000000,28.5,1.35,1.80,0.98,'2026-02-13T16:00:00.000Z'),
('COST','stock','Costco Wholesale Corp.',925.80,920.50,922.00,930.00,918.00,2200000,411000000000,52.3,0.55,5.30,0.58,'2026-02-13T16:00:00.000Z'),
('MCD','stock','McDonald''s Corporation',298.50,295.80,296.50,300.00,294.00,3500000,214000000000,24.8,2.22,2.70,0.91,'2026-02-13T16:00:00.000Z'),
('XOM','stock','Exxon Mobil Corporation',112.80,111.50,112.00,114.00,110.80,12000000,470000000000,13.5,3.32,1.30,1.17,'2026-02-13T16:00:00.000Z'),
('CVX','stock','Chevron Corporation',158.50,156.80,157.00,160.00,155.50,7500000,295000000000,14.2,4.05,1.70,1.08,'2026-02-13T16:00:00.000Z'),
('BA','stock','The Boeing Company',198.30,195.50,196.00,200.00,194.00,5200000,148000000000,NULL,NULL,2.80,1.43,'2026-02-13T16:00:00.000Z'),
('CAT','stock','Caterpillar Inc.',382.50,378.80,380.00,385.00,377.00,2800000,185000000000,18.5,1.52,3.70,0.98,'2026-02-13T16:00:00.000Z'),
('O','stock','Realty Income Corporation',58.20,57.80,58.00,58.80,57.50,8500000,52000000000,42.5,5.42,0.40,0.69,'2026-02-13T16:00:00.000Z'),
('T','stock','AT&T Inc.',22.80,22.50,22.60,23.10,22.30,28000000,163000000000,9.8,6.52,0.30,1.33,'2026-02-13T16:00:00.000Z'),
('VZ','stock','Verizon Communications Inc.',42.30,41.80,42.00,42.80,41.50,18000000,178000000000,10.2,6.35,0.50,1.20,'2026-02-13T16:00:00.000Z'),
('GME','stock','GameStop Corp.',18.50,17.80,18.00,19.20,17.50,15000000,7800000000,NULL,NULL,0.70,3.93,'2026-02-13T16:00:00.000Z'),
('AMC','stock','AMC Entertainment Holdings',5.80,5.50,5.60,6.10,5.40,22000000,2900000000,NULL,NULL,0.30,5.45,'2026-02-13T16:00:00.000Z'),
('PLTR','stock','Palantir Technologies Inc.',28.50,27.80,28.00,29.20,27.50,32000000,62000000000,85.2,NULL,0.70,2.52,'2026-02-13T16:00:00.000Z'),
('COIN','stock','Coinbase Global Inc.',265.30,258.50,260.00,270.00,255.00,8500000,65000000000,35.2,NULL,6.80,2.63,'2026-02-13T16:00:00.000Z'),
('RIVN','stock','Rivian Automotive Inc.',14.20,13.80,14.00,14.80,13.50,18000000,14800000000,NULL,NULL,0.40,2.90,'2026-02-13T16:00:00.000Z'),
('LCID','stock','Lucid Group Inc.',3.85,3.70,3.75,4.00,3.65,25000000,8500000000,NULL,NULL,0.15,4.05,'2026-02-13T16:00:00.000Z'),
('SOFI','stock','SoFi Technologies Inc.',12.80,12.40,12.50,13.20,12.20,22000000,13500000000,NULL,NULL,0.40,3.23,'2026-02-13T16:00:00.000Z'),
('ARM','stock','Arm Holdings plc',165.30,162.50,163.00,168.00,161.00,8500000,172000000000,105.2,NULL,2.80,1.72,'2026-02-13T16:00:00.000Z'),
('SHOP','stock','Shopify Inc.',108.50,106.80,107.00,110.00,105.50,12000000,138000000000,72.5,NULL,1.70,1.59,'2026-02-13T16:00:00.000Z'),
('SMCI','stock','Super Micro Computer Inc.',42.30,40.80,41.00,43.50,40.00,18000000,24500000000,15.2,NULL,1.50,3.68,'2026-02-13T16:00:00.000Z'),
('BRK.B','stock','Berkshire Hathaway Inc.',458.50,455.20,456.00,460.00,453.00,3200000,985000000000,12.5,NULL,3.30,0.72,'2026-02-13T16:00:00.000Z'),
('BBBY','stock','Bed Bath & Beyond Inc.',0.02,0.02,0.02,0.03,0.01,5000000,1500000,NULL,NULL,0.00,0.00,'2026-02-13T16:00:00.000Z'),
-- Crypto (8 tickers)
('BTC','crypto','Bitcoin',105250.00,103800.00,104000.00,106500.00,102500.00,28000000000,2080000000000,NULL,NULL,1450.00,1.40,'2026-02-13T16:00:00.000Z'),
('ETH','crypto','Ethereum',3850.00,3780.00,3800.00,3920.00,3750.00,15000000000,462000000000,NULL,NULL,70.00,1.85,'2026-02-13T16:00:00.000Z'),
('SOL','crypto','Solana',215.30,210.50,212.00,218.00,208.00,3500000000,98000000000,NULL,NULL,4.80,2.28,'2026-02-13T16:00:00.000Z'),
('DOGE','crypto','Dogecoin',0.385,0.372,0.375,0.395,0.368,2800000000,56000000000,NULL,NULL,0.013,3.49,'2026-02-13T16:00:00.000Z'),
('XRP','crypto','XRP',2.85,2.78,2.80,2.92,2.75,1800000000,162000000000,NULL,NULL,0.07,2.52,'2026-02-13T16:00:00.000Z'),
('ADA','crypto','Cardano',1.12,1.08,1.10,1.15,1.06,950000000,39500000000,NULL,NULL,0.04,3.70,'2026-02-13T16:00:00.000Z'),
('AVAX','crypto','Avalanche',42.80,41.50,42.00,43.50,40.80,620000000,17200000000,NULL,NULL,1.30,3.13,'2026-02-13T16:00:00.000Z'),
('LINK','crypto','Chainlink',22.50,21.80,22.00,23.00,21.50,480000000,14200000000,NULL,NULL,0.70,3.21,'2026-02-13T16:00:00.000Z'),
-- ETFs (12 tickers)
('SPY','etf','SPDR S&P 500 ETF Trust',612.50,608.20,609.50,615.00,607.00,65000000,580000000000,NULL,1.28,4.30,0.71,'2026-02-13T16:00:00.000Z'),
('QQQ','etf','Invesco QQQ Trust',542.30,538.50,540.00,545.00,537.00,42000000,290000000000,NULL,0.55,3.80,0.71,'2026-02-13T16:00:00.000Z'),
('VOO','etf','Vanguard S&P 500 ETF',562.80,559.20,560.00,565.00,558.00,8500000,520000000000,NULL,1.30,3.60,0.64,'2026-02-13T16:00:00.000Z'),
('VTI','etf','Vanguard Total Stock Market ETF',292.50,290.20,291.00,294.00,289.00,5200000,420000000000,NULL,1.32,2.30,0.79,'2026-02-13T16:00:00.000Z'),
('IWM','etf','iShares Russell 2000 ETF',228.50,225.80,226.50,230.00,224.50,22000000,72000000000,NULL,1.15,2.70,1.20,'2026-02-13T16:00:00.000Z'),
('XLF','etf','Financial Select Sector SPDR',45.80,45.30,45.50,46.20,45.00,18000000,42000000000,NULL,1.55,0.50,1.10,'2026-02-13T16:00:00.000Z'),
('GLD','etf','SPDR Gold Shares',248.50,246.80,247.00,250.00,245.50,8500000,72000000000,NULL,NULL,1.70,0.69,'2026-02-13T16:00:00.000Z'),
('ARKK','etf','ARK Innovation ETF',58.30,57.20,57.50,59.00,56.80,12000000,8500000000,NULL,NULL,1.10,1.92,'2026-02-13T16:00:00.000Z'),
('XLE','etf','Energy Select Sector SPDR',92.50,91.80,92.00,93.50,91.00,15000000,38000000000,NULL,3.25,0.70,0.76,'2026-02-13T16:00:00.000Z'),
('XLK','etf','Technology Select Sector SPDR',228.50,226.20,227.00,230.00,225.00,8500000,68000000000,NULL,0.62,2.30,1.02,'2026-02-13T16:00:00.000Z'),
('TLT','etf','iShares 20+ Year Treasury Bond ETF',92.80,92.20,92.50,93.50,91.80,18000000,52000000000,NULL,3.85,0.60,0.65,'2026-02-13T16:00:00.000Z'),
('SLV','etf','iShares Silver Trust',28.50,28.10,28.20,29.00,27.80,12000000,15000000000,NULL,NULL,0.40,1.42,'2026-02-13T16:00:00.000Z');
```

**Total: 69 tickers** (49 stocks + 8 crypto + 12 ETFs)

---

## market_news

```sql
INSERT INTO market_news (id, ticker, title, summary, source, url, image_url, published_at, fetched_at) VALUES
-- AAPL (3 articles)
('k1000000000000000000000000000001','AAPL','Apple Reports Record Q1 2026 Revenue Driven by AI iPhone Demand','Apple posted record quarterly revenue of $134.2 billion for Q1 2026, beating analyst estimates by $3.8 billion. The company cited strong demand for the iPhone 17 Pro lineup with on-device AI features as the primary growth driver.','Reuters','https://reuters.com/technology/apple-q1-2026-earnings-record-revenue-2026-01-28',NULL,'2026-01-28T18:30:00.000Z','2026-02-13T16:00:00.000Z'),
('k1000000000000000000000000000002','AAPL','Apple Vision Pro 2 Pre-Orders Exceed 500K Units in First Weekend','Pre-orders for the second-generation Apple Vision Pro surpassed 500,000 units within 48 hours, more than tripling the original launch. The $2,499 headset features a lighter design and M4 chip.','Bloomberg','https://bloomberg.com/news/articles/2026-02-10/apple-vision-pro-2-preorders-exceed-500k',NULL,'2026-02-10T14:15:00.000Z','2026-02-13T16:00:00.000Z'),
('k1000000000000000000000000000003','AAPL','Apple Expands India Manufacturing to 25% of Global iPhone Output','Apple has accelerated its India manufacturing strategy, with Foxconn and Tata Electronics now producing 25% of all iPhones globally. The shift reduces reliance on China and provides cost advantages.','CNBC','https://cnbc.com/2026/02/05/apple-india-manufacturing-25-percent-iphone.html',NULL,'2026-02-05T11:00:00.000Z','2026-02-13T16:00:00.000Z'),

-- MSFT (2 articles)
('k1000000000000000000000000000004','MSFT','Microsoft Azure Revenue Surges 38% as Enterprise AI Adoption Accelerates','Microsoft reported Azure cloud revenue growth of 38% year-over-year, driven by enterprises migrating AI workloads. CEO Satya Nadella highlighted that AI services now represent over 12% of total Azure revenue.','Bloomberg','https://bloomberg.com/news/articles/2026-02-04/microsoft-azure-ai-revenue-growth-38-percent',NULL,'2026-02-04T20:00:00.000Z','2026-02-13T16:00:00.000Z'),
('k1000000000000000000000000000005','MSFT','Microsoft Copilot Reaches 100 Million Enterprise Users Milestone','Microsoft announced that its Copilot AI assistant has surpassed 100 million monthly active enterprise users across Office 365, GitHub, and Dynamics. The company raised Copilot subscription pricing by 15%.','MarketWatch','https://marketwatch.com/story/microsoft-copilot-100-million-enterprise-users-2026-02-11',NULL,'2026-02-11T09:30:00.000Z','2026-02-13T16:00:00.000Z'),

-- NVDA (3 articles)
('k1000000000000000000000000000006','NVDA','NVIDIA Unveils Blackwell Ultra GPU with 2x Performance Over B200','NVIDIA announced the Blackwell Ultra GPU architecture at its GTC 2026 keynote, promising double the inference performance of the B200 at the same power envelope. Mass production is expected in Q3 2026.','Reuters','https://reuters.com/technology/nvidia-blackwell-ultra-gpu-announcement-2026-02-12',NULL,'2026-02-12T17:45:00.000Z','2026-02-13T16:00:00.000Z'),
('k1000000000000000000000000000007','NVDA','NVIDIA Data Center Revenue Hits $42B in Q4, Up 65% Year-Over-Year','NVIDIA reported Q4 FY2026 data center revenue of $42 billion, continuing its dominance in AI accelerator chips. The company guided for $45 billion in Q1, slightly above consensus estimates.','CNBC','https://cnbc.com/2026/01/29/nvidia-q4-earnings-data-center-42-billion.html',NULL,'2026-01-29T22:00:00.000Z','2026-02-13T16:00:00.000Z'),
('k1000000000000000000000000000008','NVDA','Sovereign AI Push Drives NVIDIA Orders from 15 New Countries','Fifteen additional countries have placed orders for NVIDIA AI infrastructure as part of sovereign AI initiatives. The deals are valued at an estimated $18 billion and span government-backed data centers across Asia and the Middle East.','Bloomberg','https://bloomberg.com/news/articles/2026-02-07/nvidia-sovereign-ai-orders-15-countries',NULL,'2026-02-07T13:20:00.000Z','2026-02-13T16:00:00.000Z'),

-- TSLA (2 articles)
('k1000000000000000000000000000009','TSLA','Tesla Robotaxi Service Launches in Austin with 1,000 Vehicles','Tesla officially launched its autonomous robotaxi service in Austin, Texas, deploying 1,000 Model Y vehicles equipped with Hardware 5 and FSD v13. Rides are priced at $0.50 per mile, undercutting competitors.','Reuters','https://reuters.com/business/autos/tesla-robotaxi-austin-launch-1000-vehicles-2026-02-03',NULL,'2026-02-03T08:00:00.000Z','2026-02-13T16:00:00.000Z'),
('k1000000000000000000000000000010','TSLA','Tesla Energy Storage Deployments Triple to 35 GWh in 2025','Tesla reported that its energy storage deployments tripled year-over-year to 35 GWh in 2025, making it the fastest-growing segment. The Megapack factory in Shanghai is now operating at full capacity.','MarketWatch','https://marketwatch.com/story/tesla-energy-storage-35-gwh-2025-triple-2026-01-30',NULL,'2026-01-30T10:15:00.000Z','2026-02-13T16:00:00.000Z'),

-- META (2 articles)
('k1000000000000000000000000000011','META','Meta AI Assistant Surpasses 1 Billion Monthly Users Across Apps','Meta announced that its AI assistant, integrated across WhatsApp, Instagram, and Messenger, has exceeded 1 billion monthly active users. The company plans to introduce premium AI features with a subscription tier.','The Verge','https://theverge.com/2026/2/6/meta-ai-assistant-1-billion-users',NULL,'2026-02-06T15:00:00.000Z','2026-02-13T16:00:00.000Z'),
('k1000000000000000000000000000012','META','Meta Reports 22% Revenue Growth as Reels and AI Ad Targeting Boost Results','Meta Platforms posted Q4 revenue of $48.3 billion, a 22% increase year-over-year. The company attributed the growth to improved AI-powered ad targeting and strong performance from Reels monetization.','Bloomberg','https://bloomberg.com/news/articles/2026-01-31/meta-q4-revenue-22-percent-growth-reels-ai-ads',NULL,'2026-01-31T21:30:00.000Z','2026-02-13T16:00:00.000Z'),

-- BTC (3 articles)
('k1000000000000000000000000000013','BTC','Bitcoin Breaks $105,000 as Institutional Inflows Hit Record $2.8B Weekly','Bitcoin surged past $105,000 as institutional investors poured a record $2.8 billion into spot Bitcoin ETFs in a single week. BlackRock IBIT and Fidelity FBTC led the inflows.','CoinDesk','https://coindesk.com/markets/2026/02/13/bitcoin-105000-institutional-inflows-record',NULL,'2026-02-13T12:00:00.000Z','2026-02-13T16:00:00.000Z'),
('k1000000000000000000000000000014','BTC','Federal Reserve Signals Crypto-Friendly Regulatory Framework Coming in Q2','Federal Reserve Chair indicated that a comprehensive crypto regulatory framework is expected by Q2 2026, providing clarity on stablecoin issuance and digital asset custody for banks.','Reuters','https://reuters.com/markets/currencies/fed-crypto-regulation-framework-q2-2026-02-08',NULL,'2026-02-08T16:45:00.000Z','2026-02-13T16:00:00.000Z'),
('k1000000000000000000000000000015','BTC','Bitcoin Mining Difficulty Reaches All-Time High as Hashrate Tops 800 EH/s','The Bitcoin network hashrate has exceeded 800 exahashes per second for the first time, pushing mining difficulty to a new all-time high. Analysts note that miner profitability remains strong above $100K BTC.','CoinDesk','https://coindesk.com/tech/2026/02/01/bitcoin-mining-hashrate-800-ehs-record',NULL,'2026-02-01T09:00:00.000Z','2026-02-13T16:00:00.000Z'),

-- ETH (2 articles)
('k1000000000000000000000000000016','ETH','Ethereum Pectra Upgrade Goes Live, Enabling Account Abstraction for All Users','The Ethereum Pectra upgrade successfully activated on mainnet, introducing native account abstraction (EIP-7702) that allows all wallets to function as smart contract accounts without needing separate deployers.','CoinDesk','https://coindesk.com/tech/2026/02/09/ethereum-pectra-upgrade-live-account-abstraction',NULL,'2026-02-09T14:30:00.000Z','2026-02-13T16:00:00.000Z'),
('k1000000000000000000000000000017','ETH','Ethereum Layer 2 TVL Exceeds $80 Billion as Base and Arbitrum Dominate','Total value locked across Ethereum Layer 2 networks surpassed $80 billion, with Coinbase Base and Arbitrum accounting for over 60% of the total. Transaction fees on L2s have dropped below $0.01.','Bloomberg','https://bloomberg.com/news/articles/2026-02-11/ethereum-layer-2-tvl-80-billion-base-arbitrum',NULL,'2026-02-11T11:45:00.000Z','2026-02-13T16:00:00.000Z'),

-- SPY (2 articles)
('k1000000000000000000000000000018','SPY','S&P 500 Reaches New All-Time High on Strong Earnings Season','The S&P 500 closed at a fresh all-time high as 78% of reporting companies beat earnings estimates for Q4 2025. Technology and financials sectors led the advance.','MarketWatch','https://marketwatch.com/story/sp-500-all-time-high-q4-earnings-season-2026-02-12',NULL,'2026-02-12T20:00:00.000Z','2026-02-13T16:00:00.000Z'),
('k1000000000000000000000000000019','SPY','Fed Minutes Suggest Rate Cuts May Resume in Mid-2026 Amid Cooling Inflation','Minutes from the January FOMC meeting revealed that several officials are open to resuming rate cuts by mid-2026 if inflation continues to moderate toward the 2% target.','Reuters','https://reuters.com/markets/us/fed-minutes-rate-cuts-mid-2026-inflation-2026-02-07',NULL,'2026-02-07T19:00:00.000Z','2026-02-13T16:00:00.000Z'),

-- AMZN (2 articles)
('k1000000000000000000000000000020','AMZN','Amazon AWS Launches Custom AI Chips, Challenging NVIDIA Dominance','Amazon Web Services unveiled its next-generation Trainium3 AI training chips, claiming 40% better performance per dollar compared to NVIDIA alternatives. Major customers including Anthropic have committed to the platform.','CNBC','https://cnbc.com/2026/02/04/amazon-aws-trainium3-custom-ai-chips-nvidia.html',NULL,'2026-02-04T14:00:00.000Z','2026-02-13T16:00:00.000Z'),
('k1000000000000000000000000000021','AMZN','Amazon Same-Day Delivery Now Covers 90% of US Population','Amazon announced that its same-day delivery service now reaches 90% of the US population, up from 72% a year ago. The expansion was powered by a network of 250 new urban fulfillment centers.','Bloomberg','https://bloomberg.com/news/articles/2026-01-27/amazon-same-day-delivery-90-percent-us-population',NULL,'2026-01-27T12:30:00.000Z','2026-02-13T16:00:00.000Z'),

-- GOOGL (2 articles)
('k1000000000000000000000000000022','GOOGL','Google Gemini 3.0 Achieves New Benchmarks in Multimodal AI Reasoning','Google DeepMind released Gemini 3.0, which sets new state-of-the-art benchmarks in multimodal reasoning, code generation, and mathematical problem-solving. The model is available through Google Cloud and Vertex AI.','The Verge','https://theverge.com/2026/2/5/google-gemini-3-multimodal-ai-benchmarks',NULL,'2026-02-05T16:00:00.000Z','2026-02-13T16:00:00.000Z'),
('k1000000000000000000000000000023','GOOGL','Alphabet Cloud Revenue Surpasses $12B Quarterly for First Time','Google Cloud division reported $12.3 billion in quarterly revenue for the first time, representing 32% year-over-year growth. AI and data analytics services were cited as the primary growth catalysts.','Reuters','https://reuters.com/technology/alphabet-google-cloud-12-billion-quarterly-revenue-2026-02-03',NULL,'2026-02-03T21:15:00.000Z','2026-02-13T16:00:00.000Z'),

-- AMD (2 articles)
('k1000000000000000000000000000024','AMD','AMD MI400 AI Accelerator Wins Major Cloud Contracts with Azure and Oracle','AMD announced that its MI400 AI accelerator has been selected by Microsoft Azure and Oracle Cloud for large-scale AI training deployments. The chip offers competitive performance at a lower price point than NVIDIA alternatives.','MarketWatch','https://marketwatch.com/story/amd-mi400-azure-oracle-cloud-contracts-2026-02-10',NULL,'2026-02-10T10:00:00.000Z','2026-02-13T16:00:00.000Z'),
('k1000000000000000000000000000025','AMD','AMD Reports 28% Revenue Growth Led by Data Center and Embedded Segments','AMD posted Q4 2025 revenue of $7.8 billion, up 28% year-over-year. Data center revenue grew 52% driven by EPYC server processor adoption and AI accelerator demand.','CNBC','https://cnbc.com/2026/01/28/amd-q4-earnings-revenue-28-percent-growth.html',NULL,'2026-01-28T22:30:00.000Z','2026-02-13T16:00:00.000Z'),

-- JPM (2 articles)
('k1000000000000000000000000000026','JPM','JPMorgan Profit Rises 18% as Investment Banking Fees Surge','JPMorgan Chase reported an 18% increase in quarterly profit as investment banking revenue surged 42%. CEO Jamie Dimon cited strong M&A activity and a robust IPO pipeline for the outperformance.','Bloomberg','https://bloomberg.com/news/articles/2026-01-30/jpmorgan-profit-18-percent-investment-banking-surge',NULL,'2026-01-30T13:00:00.000Z','2026-02-13T16:00:00.000Z'),
('k1000000000000000000000000000027','JPM','JPMorgan Launches AI-Powered Wealth Management Platform for Mass Affluent','JPMorgan unveiled an AI-driven wealth management platform targeting clients with $100K-$1M in assets. The platform uses proprietary AI models for portfolio allocation and tax optimization.','CNBC','https://cnbc.com/2026/02/06/jpmorgan-ai-wealth-management-mass-affluent.html',NULL,'2026-02-06T08:45:00.000Z','2026-02-13T16:00:00.000Z'),

-- XOM (2 articles)
('k1000000000000000000000000000028','XOM','Exxon Mobil Increases Dividend by 7% as Oil Prices Stabilize Above $80','Exxon Mobil announced a 7% dividend increase, raising the quarterly payout to $1.04 per share. The energy giant cited stable oil prices and improved refining margins as supporting the increase.','Reuters','https://reuters.com/business/energy/exxon-mobil-dividend-increase-7-percent-2026-02-02',NULL,'2026-02-02T15:30:00.000Z','2026-02-13T16:00:00.000Z'),
('k1000000000000000000000000000029','XOM','Exxon Guyana Operations Hit 1 Million Barrels Per Day Production Milestone','Exxon Mobil achieved a production milestone of 1 million barrels per day from its Guyana operations, making it one of the most profitable deepwater developments in the world.','MarketWatch','https://marketwatch.com/story/exxon-guyana-1-million-barrels-day-milestone-2026-01-25',NULL,'2026-01-25T11:00:00.000Z','2026-02-13T16:00:00.000Z'),

-- SOL (2 articles)
('k1000000000000000000000000000030','SOL','Solana Processes Record 120,000 TPS as DeFi Activity Surges','The Solana blockchain processed a record 120,000 transactions per second during a peak DeFi trading period. Network uptime has been maintained at 99.95% over the past 6 months following infrastructure upgrades.','CoinDesk','https://coindesk.com/tech/2026/02/12/solana-120000-tps-record-defi-surge',NULL,'2026-02-12T10:30:00.000Z','2026-02-13T16:00:00.000Z');
```

**Total: 30 news articles across 14 tickers**
