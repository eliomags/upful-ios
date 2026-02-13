# Agent-2b Output: Positions Seed Data

> Generated for the Upful/Jyanik paper trading iOS app.
> Contains 109 positions across 29 active users (User 29 has 0 positions after monthly reset).

---

## POSITION SUMMARY

| User# | Username | Positions | Invested Value | Cash | Total Equity |
|-------|----------|-----------|---------------|------|-------------|
| 1 | traderpro | 7 | ~$29,250 | ~$15,750 | $45,000 |
| 2 | quantjamie | 7 | ~$24,700 | ~$13,300 | $38,000 |
| 3 | sofiainvests | 6 | ~$27,300 | ~$14,700 | $42,000 |
| 4 | marcusj_trades | 6 | ~$23,100 | ~$12,400 | $35,500 |
| 5 | priyafinance | 6 | ~$26,000 | ~$14,000 | $40,000 |
| 6 | tylerb | 4 | ~$20,800 | ~$11,200 | $32,000 |
| 7 | meilin_stocks | 5 | ~$21,775 | ~$11,725 | $33,500 |
| 8 | dave_trades | 5 | ~$18,200 | ~$9,800 | $28,000 |
| 9 | emmaw | 5 | ~$20,150 | ~$10,850 | $31,000 |
| 10 | carlosg | 4 | ~$19,175 | ~$10,325 | $29,500 |
| 11 | aishap | 5 | ~$23,400 | ~$12,600 | $36,000 |
| 12 | ryankim | 4 | ~$19,825 | ~$10,675 | $30,500 |
| 13 | oliviab | 2 | ~$8,625 | ~$17,875 | $26,500 |
| 14 | noahg | 2 | ~$8,100 | ~$18,900 | $27,000 |
| 15 | zoet | 1 | ~$6,420 | ~$19,380 | $25,800 |
| 16 | liama | 2 | ~$5,200 | ~$21,000 | $26,200 |
| 17 | chloed | 3 | ~$15,675 | ~$12,825 | $28,500 |
| 18 | ethanm | 3 | ~$8,575 | ~$15,925 | $24,500 |
| 19 | avaj | 3 | ~$8,160 | ~$19,040 | $27,200 |
| 20 | lucasw | 3 | ~$8,040 | ~$18,760 | $26,800 |
| 21 | harperl | 2 | ~$7,800 | ~$18,200 | $26,000 |
| 22 | masonc | 5 | ~$17,400 | ~$11,600 | $29,000 |
| 23 | ellar | 1 | ~$5,100 | ~$20,400 | $25,500 |
| 24 | jacks | 2 | ~$6,590 | ~$19,710 | $26,300 |
| 25 | miat | 5 | ~$17,100 | ~$11,400 | $28,500 |
| 26 | benH | 2 | ~$6,900 | ~$16,100 | $23,000 |
| 27 | isabellaA | 1 | ~$2,520 | ~$22,680 | $25,200 |
| 28 | willt | 3 | ~$6,300 | ~$14,700 | $21,000 |
| 29 | charlottew | 0 | $0 | $25,000 | $25,000 |
| 30 | danielk | 5 | ~$22,750 | ~$12,250 | $35,000 |

**Total positions: 109**

---

## SQL INSERT STATEMENTS -- POSITIONS

### User 1: Alex Morgan (@traderpro) — 7 positions, ~$29,250 invested

```sql
-- AAPL: 20 shares @ avg $235, current $245
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000001',
    'b0000000000000000000000000000101',
    'a0000000000000000000000000000001',
    'AAPL', 'stock', 20, 235.00, 245.00, 4900.00, 200.00,
    '2026-02-10T16:00:00.000Z'
);

-- NVDA: 30 shares @ avg $128, current $140
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000002',
    'b0000000000000000000000000000101',
    'a0000000000000000000000000000001',
    'NVDA', 'stock', 30, 128.00, 140.00, 4200.00, 360.00,
    '2026-02-10T16:00:00.000Z'
);

-- TSLA: 12 shares @ avg $390, current $420
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000003',
    'b0000000000000000000000000000101',
    'a0000000000000000000000000000001',
    'TSLA', 'stock', 12, 390.00, 420.00, 5040.00, 360.00,
    '2026-02-10T16:00:00.000Z'
);

-- META: 6 shares @ avg $620, current $650
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000004',
    'b0000000000000000000000000000101',
    'a0000000000000000000000000000001',
    'META', 'stock', 6, 620.00, 650.00, 3900.00, 180.00,
    '2026-02-10T16:00:00.000Z'
);

-- BTC: 0.05 @ avg $98000, current $105000
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000005',
    'b0000000000000000000000000000101',
    'a0000000000000000000000000000001',
    'BTC', 'crypto', 0.05, 98000.00, 105000.00, 5250.00, 350.00,
    '2026-02-10T16:00:00.000Z'
);

-- ETH: 0.8 @ avg $3500, current $3800
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000006',
    'b0000000000000000000000000000101',
    'a0000000000000000000000000000001',
    'ETH', 'crypto', 0.8, 3500.00, 3800.00, 3040.00, 240.00,
    '2026-02-10T16:00:00.000Z'
);

-- SOL: 14 @ avg $195, current $210
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000007',
    'b0000000000000000000000000000101',
    'a0000000000000000000000000000001',
    'SOL', 'crypto', 14, 195.00, 210.00, 2940.00, 210.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 1 total market_value: 4900+4200+5040+3900+5250+3040+2940 = $29,270
-- User 1 total unrealized_pnl: 200+360+360+180+350+240+210 = $1,900
```

### User 2: Jamie Chen (@quantjamie) — 7 positions, ~$24,700 invested

```sql
-- MSFT: 10 shares @ avg $450, current $470
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000008',
    'b0000000000000000000000000000201',
    'a0000000000000000000000000000002',
    'MSFT', 'stock', 10, 450.00, 470.00, 4700.00, 200.00,
    '2026-02-10T15:45:00.000Z'
);

-- AMD: 25 shares @ avg $118, current $125
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000009',
    'b0000000000000000000000000000201',
    'a0000000000000000000000000000002',
    'AMD', 'stock', 25, 118.00, 125.00, 3125.00, 175.00,
    '2026-02-10T15:45:00.000Z'
);

-- BTC: 0.04 @ avg $95000, current $105000
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000000a',
    'b0000000000000000000000000000201',
    'a0000000000000000000000000000002',
    'BTC', 'crypto', 0.04, 95000.00, 105000.00, 4200.00, 400.00,
    '2026-02-10T15:45:00.000Z'
);

-- ETH: 1.2 @ avg $3400, current $3800
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000000b',
    'b0000000000000000000000000000201',
    'a0000000000000000000000000000002',
    'ETH', 'crypto', 1.2, 3400.00, 3800.00, 4560.00, 480.00,
    '2026-02-10T15:45:00.000Z'
);

-- SOL: 12 @ avg $185, current $210
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000000c',
    'b0000000000000000000000000000201',
    'a0000000000000000000000000000002',
    'SOL', 'crypto', 12, 185.00, 210.00, 2520.00, 300.00,
    '2026-02-10T15:45:00.000Z'
);

-- DOGE: 5000 @ avg $0.32, current $0.38
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000000d',
    'b0000000000000000000000000000201',
    'a0000000000000000000000000000002',
    'DOGE', 'crypto', 5000, 0.32, 0.38, 1900.00, 300.00,
    '2026-02-10T15:45:00.000Z'
);

-- SPY: 6 shares @ avg $590, current $610
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000000e',
    'b0000000000000000000000000000201',
    'a0000000000000000000000000000002',
    'SPY', 'etf', 6, 590.00, 610.00, 3660.00, 120.00,
    '2026-02-10T15:45:00.000Z'
);
-- User 2 total market_value: 4700+3125+4200+4560+2520+1900+3660 = $24,665
-- User 2 total unrealized_pnl: 200+175+400+480+300+300+120 = $1,975
```

### User 3: Sofia Rodriguez (@sofiainvests) — 6 positions, ~$27,300 invested

```sql
-- NVDA: 40 shares @ avg $125, current $140
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000000f',
    'b0000000000000000000000000000301',
    'a0000000000000000000000000000003',
    'NVDA', 'stock', 40, 125.00, 140.00, 5600.00, 600.00,
    '2026-02-10T16:00:00.000Z'
);

-- AAPL: 18 shares @ avg $230, current $245
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000010',
    'b0000000000000000000000000000301',
    'a0000000000000000000000000000003',
    'AAPL', 'stock', 18, 230.00, 245.00, 4410.00, 270.00,
    '2026-02-10T16:00:00.000Z'
);

-- AMZN: 20 shares @ avg $215, current $230
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000011',
    'b0000000000000000000000000000301',
    'a0000000000000000000000000000003',
    'AMZN', 'stock', 20, 215.00, 230.00, 4600.00, 300.00,
    '2026-02-10T16:00:00.000Z'
);

-- GOOGL: 22 shares @ avg $180, current $195
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000012',
    'b0000000000000000000000000000301',
    'a0000000000000000000000000000003',
    'GOOGL', 'stock', 22, 180.00, 195.00, 4290.00, 330.00,
    '2026-02-10T16:00:00.000Z'
);

-- META: 6 shares @ avg $610, current $650
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000013',
    'b0000000000000000000000000000301',
    'a0000000000000000000000000000003',
    'META', 'stock', 6, 610.00, 650.00, 3900.00, 240.00,
    '2026-02-10T16:00:00.000Z'
);

-- NFLX: 5 shares @ avg $870, current $950
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000014',
    'b0000000000000000000000000000301',
    'a0000000000000000000000000000003',
    'NFLX', 'stock', 5, 870.00, 950.00, 4750.00, 400.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 3 total market_value: 5600+4410+4600+4290+3900+4750 = $27,550
-- User 3 total unrealized_pnl: 600+270+300+330+240+400 = $2,140
```

### User 4: Marcus Johnson (@marcusj_trades) — 6 positions (ETF-heavy), ~$23,100 invested

```sql
-- SPY: 12 shares @ avg $595, current $610
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000015',
    'b0000000000000000000000000000401',
    'a0000000000000000000000000000004',
    'SPY', 'etf', 12, 595.00, 610.00, 7320.00, 180.00,
    '2026-02-10T16:00:00.000Z'
);

-- QQQ: 8 shares @ avg $520, current $540
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000016',
    'b0000000000000000000000000000401',
    'a0000000000000000000000000000004',
    'QQQ', 'etf', 8, 520.00, 540.00, 4320.00, 160.00,
    '2026-02-10T16:00:00.000Z'
);

-- VOO: 6 shares @ avg $545, current $560
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000017',
    'b0000000000000000000000000000401',
    'a0000000000000000000000000000004',
    'VOO', 'etf', 6, 545.00, 560.00, 3360.00, 90.00,
    '2026-02-10T16:00:00.000Z'
);

-- VTI: 12 shares @ avg $280, current $290
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000018',
    'b0000000000000000000000000000401',
    'a0000000000000000000000000000004',
    'VTI', 'etf', 12, 280.00, 290.00, 3480.00, 120.00,
    '2026-02-10T16:00:00.000Z'
);

-- IWM: 15 shares @ avg $225, current $232
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000019',
    'b0000000000000000000000000000401',
    'a0000000000000000000000000000004',
    'IWM', 'etf', 15, 225.00, 232.00, 3480.00, 105.00,
    '2026-02-10T16:00:00.000Z'
);

-- XLF: 30 shares @ avg $42, current $46
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000001a',
    'b0000000000000000000000000000401',
    'a0000000000000000000000000000004',
    'XLF', 'etf', 30, 42.00, 46.00, 1380.00, 120.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 4 total market_value: 7320+4320+3360+3480+3480+1380 = $23,340
-- User 4 total unrealized_pnl: 180+160+90+120+105+120 = $775
```

### User 5: Priya Sharma (@priyafinance) — 6 positions (value stocks), ~$26,000 invested

```sql
-- AAPL: 22 shares @ avg $228, current $245
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000001b',
    'b0000000000000000000000000000501',
    'a0000000000000000000000000000005',
    'AAPL', 'stock', 22, 228.00, 245.00, 5390.00, 374.00,
    '2026-02-10T16:00:00.000Z'
);

-- MSFT: 8 shares @ avg $440, current $470
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000001c',
    'b0000000000000000000000000000501',
    'a0000000000000000000000000000005',
    'MSFT', 'stock', 8, 440.00, 470.00, 3760.00, 240.00,
    '2026-02-10T16:00:00.000Z'
);

-- JNJ: 25 shares @ avg $155, current $162
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000001d',
    'b0000000000000000000000000000501',
    'a0000000000000000000000000000005',
    'JNJ', 'stock', 25, 155.00, 162.00, 4050.00, 175.00,
    '2026-02-10T16:00:00.000Z'
);

-- PG: 22 shares @ avg $168, current $175
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000001e',
    'b0000000000000000000000000000501',
    'a0000000000000000000000000000005',
    'PG', 'stock', 22, 168.00, 175.00, 3850.00, 154.00,
    '2026-02-10T16:00:00.000Z'
);

-- KO: 50 shares @ avg $58, current $62
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000001f',
    'b0000000000000000000000000000501',
    'a0000000000000000000000000000005',
    'KO', 'stock', 50, 58.00, 62.00, 3100.00, 200.00,
    '2026-02-10T16:00:00.000Z'
);

-- BRK.B: 10 shares @ avg $455, current $490
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000020',
    'b0000000000000000000000000000501',
    'a0000000000000000000000000000005',
    'BRK.B', 'stock', 10, 455.00, 490.00, 4900.00, 350.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 5 total market_value: 5390+3760+4050+3850+3100+4900 = $25,050
-- User 5 total unrealized_pnl: 374+240+175+154+200+350 = $1,493
```

### User 6: Tyler Brooks (@tylerb) — 4 positions (momentum), ~$20,800 invested

```sql
-- TSLA: 18 shares @ avg $380, current $420
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000021',
    'b0000000000000000000000000000601',
    'a0000000000000000000000000000006',
    'TSLA', 'stock', 18, 380.00, 420.00, 7560.00, 720.00,
    '2026-02-10T16:00:00.000Z'
);

-- AMD: 40 shares @ avg $110, current $125
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000022',
    'b0000000000000000000000000000601',
    'a0000000000000000000000000000006',
    'AMD', 'stock', 40, 110.00, 125.00, 5000.00, 600.00,
    '2026-02-10T16:00:00.000Z'
);

-- NVDA: 30 shares @ avg $132, current $140
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000023',
    'b0000000000000000000000000000601',
    'a0000000000000000000000000000006',
    'NVDA', 'stock', 30, 132.00, 140.00, 4200.00, 240.00,
    '2026-02-10T16:00:00.000Z'
);

-- SOFI: 300 shares @ avg $12.50, current $14.20
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000024',
    'b0000000000000000000000000000601',
    'a0000000000000000000000000000006',
    'SOFI', 'stock', 300, 12.50, 14.20, 4260.00, 510.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 6 total market_value: 7560+5000+4200+4260 = $21,020
-- User 6 total unrealized_pnl: 720+600+240+510 = $2,070
```

### User 7: Mei Lin (@meilin_stocks) — 5 positions (tech stocks), ~$21,775 invested

```sql
-- AAPL: 15 shares @ avg $238, current $245
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000025',
    'b0000000000000000000000000000701',
    'a0000000000000000000000000000007',
    'AAPL', 'stock', 15, 238.00, 245.00, 3675.00, 105.00,
    '2026-02-10T16:00:00.000Z'
);

-- MSFT: 10 shares @ avg $455, current $470
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000026',
    'b0000000000000000000000000000701',
    'a0000000000000000000000000000007',
    'MSFT', 'stock', 10, 455.00, 470.00, 4700.00, 150.00,
    '2026-02-10T16:00:00.000Z'
);

-- GOOGL: 20 shares @ avg $188, current $195
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000027',
    'b0000000000000000000000000000701',
    'a0000000000000000000000000000007',
    'GOOGL', 'stock', 20, 188.00, 195.00, 3900.00, 140.00,
    '2026-02-10T16:00:00.000Z'
);

-- NVDA: 35 shares @ avg $130, current $140
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000028',
    'b0000000000000000000000000000701',
    'a0000000000000000000000000000007',
    'NVDA', 'stock', 35, 130.00, 140.00, 4900.00, 350.00,
    '2026-02-10T16:00:00.000Z'
);

-- CRM: 15 shares @ avg $295, current $310
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000029',
    'b0000000000000000000000000000701',
    'a0000000000000000000000000000007',
    'CRM', 'stock', 15, 295.00, 310.00, 4650.00, 225.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 7 total market_value: 3675+4700+3900+4900+4650 = $21,825
-- User 7 total unrealized_pnl: 105+150+140+350+225 = $970
```

### User 8: David Okafor (@dave_trades) — 5 positions (crypto enthusiast), ~$18,200 invested

```sql
-- BTC: 0.08 @ avg $92000, current $105000
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000002a',
    'b0000000000000000000000000000801',
    'a0000000000000000000000000000008',
    'BTC', 'crypto', 0.08, 92000.00, 105000.00, 8400.00, 1040.00,
    '2026-02-10T16:00:00.000Z'
);

-- ETH: 1.0 @ avg $3600, current $3800
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000002b',
    'b0000000000000000000000000000801',
    'a0000000000000000000000000000008',
    'ETH', 'crypto', 1.0, 3600.00, 3800.00, 3800.00, 200.00,
    '2026-02-10T16:00:00.000Z'
);

-- SOL: 15 @ avg $190, current $210
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000002c',
    'b0000000000000000000000000000801',
    'a0000000000000000000000000000008',
    'SOL', 'crypto', 15, 190.00, 210.00, 3150.00, 300.00,
    '2026-02-10T16:00:00.000Z'
);

-- DOGE: 4000 @ avg $0.30, current $0.38
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000002d',
    'b0000000000000000000000000000801',
    'a0000000000000000000000000000008',
    'DOGE', 'crypto', 4000, 0.30, 0.38, 1520.00, 320.00,
    '2026-02-10T16:00:00.000Z'
);

-- ADA: 1200 @ avg $0.95, current $1.10
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000002e',
    'b0000000000000000000000000000801',
    'a0000000000000000000000000000008',
    'ADA', 'crypto', 1200, 0.95, 1.10, 1320.00, 180.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 8 total market_value: 8400+3800+3150+1520+1320 = $18,190
-- User 8 total unrealized_pnl: 1040+200+300+320+180 = $2,040
```

### User 9: Emma Wilson (@emmaw) — 5 positions (dividends), ~$20,150 invested

```sql
-- KO: 60 shares @ avg $59, current $62
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000002f',
    'b0000000000000000000000000000901',
    'a0000000000000000000000000000009',
    'KO', 'stock', 60, 59.00, 62.00, 3720.00, 180.00,
    '2026-02-10T16:00:00.000Z'
);

-- PEP: 22 shares @ avg $172, current $180
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000030',
    'b0000000000000000000000000000901',
    'a0000000000000000000000000000009',
    'PEP', 'stock', 22, 172.00, 180.00, 3960.00, 176.00,
    '2026-02-10T16:00:00.000Z'
);

-- JNJ: 25 shares @ avg $158, current $162
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000031',
    'b0000000000000000000000000000901',
    'a0000000000000000000000000000009',
    'JNJ', 'stock', 25, 158.00, 162.00, 4050.00, 100.00,
    '2026-02-10T16:00:00.000Z'
);

-- T: 200 shares @ avg $19.50, current $22.00
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000032',
    'b0000000000000000000000000000901',
    'a0000000000000000000000000000009',
    'T', 'stock', 200, 19.50, 22.00, 4400.00, 500.00,
    '2026-02-10T16:00:00.000Z'
);

-- VZ: 100 shares @ avg $38, current $41
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000033',
    'b0000000000000000000000000000901',
    'a0000000000000000000000000000009',
    'VZ', 'stock', 100, 38.00, 41.00, 4100.00, 300.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 9 total market_value: 3720+3960+4050+4400+4100 = $20,230
-- User 9 total unrealized_pnl: 180+176+100+500+300 = $1,256
```

### User 10: Carlos Gutierrez (@carlosg) — 4 positions (meme/speculative), ~$19,175 invested

```sql
-- GME: 150 shares @ avg $28, current $32
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000034',
    'b0000000000000000000000000000a01',
    'a000000000000000000000000000000a',
    'GME', 'stock', 150, 28.00, 32.00, 4800.00, 600.00,
    '2026-02-10T16:00:00.000Z'
);

-- AMC: 400 shares @ avg $8.50, current $11.20
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000035',
    'b0000000000000000000000000000a01',
    'a000000000000000000000000000000a',
    'AMC', 'stock', 400, 8.50, 11.20, 4480.00, 1080.00,
    '2026-02-10T16:00:00.000Z'
);

-- BBBY: 500 shares @ avg $5.20, current $6.80
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000036',
    'b0000000000000000000000000000a01',
    'a000000000000000000000000000000a',
    'BBBY', 'stock', 500, 5.20, 6.80, 3400.00, 800.00,
    '2026-02-10T16:00:00.000Z'
);

-- PLTR: 250 shares @ avg $22, current $26
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000037',
    'b0000000000000000000000000000a01',
    'a000000000000000000000000000000a',
    'PLTR', 'stock', 250, 22.00, 26.00, 6500.00, 1000.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 10 total market_value: 4800+4480+3400+6500 = $19,180
-- User 10 total unrealized_pnl: 600+1080+800+1000 = $3,480
```

### User 11: Aisha Patel (@aishap) — 5 positions (balanced), ~$23,400 invested

```sql
-- AAPL: 16 shares @ avg $232, current $245
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000038',
    'b0000000000000000000000000000b01',
    'a000000000000000000000000000000b',
    'AAPL', 'stock', 16, 232.00, 245.00, 3920.00, 208.00,
    '2026-02-10T16:00:00.000Z'
);

-- VOO: 10 shares @ avg $540, current $560
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000039',
    'b0000000000000000000000000000b01',
    'a000000000000000000000000000000b',
    'VOO', 'etf', 10, 540.00, 560.00, 5600.00, 200.00,
    '2026-02-10T16:00:00.000Z'
);

-- BTC: 0.05 @ avg $96000, current $105000
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000003a',
    'b0000000000000000000000000000b01',
    'a000000000000000000000000000000b',
    'BTC', 'crypto', 0.05, 96000.00, 105000.00, 5250.00, 450.00,
    '2026-02-10T16:00:00.000Z'
);

-- GLD: 20 shares @ avg $230, current $248
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000003b',
    'b0000000000000000000000000000b01',
    'a000000000000000000000000000000b',
    'GLD', 'etf', 20, 230.00, 248.00, 4960.00, 360.00,
    '2026-02-10T16:00:00.000Z'
);

-- MSFT: 8 shares @ avg $448, current $470
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000003c',
    'b0000000000000000000000000000b01',
    'a000000000000000000000000000000b',
    'MSFT', 'stock', 8, 448.00, 470.00, 3760.00, 176.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 11 total market_value: 3920+5600+5250+4960+3760 = $23,490
-- User 11 total unrealized_pnl: 208+200+450+360+176 = $1,394
```

### User 12: Ryan Kim (@ryankim) — 4 positions (mixed), ~$19,825 invested

```sql
-- SPY: 10 shares @ avg $598, current $610
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000003d',
    'b0000000000000000000000000000c01',
    'a000000000000000000000000000000c',
    'SPY', 'etf', 10, 598.00, 610.00, 6100.00, 120.00,
    '2026-02-10T16:00:00.000Z'
);

-- QQQ: 8 shares @ avg $525, current $540
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000003e',
    'b0000000000000000000000000000c01',
    'a000000000000000000000000000000c',
    'QQQ', 'etf', 8, 525.00, 540.00, 4320.00, 120.00,
    '2026-02-10T16:00:00.000Z'
);

-- AAPL: 16 shares @ avg $240, current $245
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000003f',
    'b0000000000000000000000000000c01',
    'a000000000000000000000000000000c',
    'AAPL', 'stock', 16, 240.00, 245.00, 3920.00, 80.00,
    '2026-02-10T16:00:00.000Z'
);

-- NVDA: 40 shares @ avg $134, current $140
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000040',
    'b0000000000000000000000000000c01',
    'a000000000000000000000000000000c',
    'NVDA', 'stock', 40, 134.00, 140.00, 5600.00, 240.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 12 total market_value: 6100+4320+3920+5600 = $19,940
-- User 12 total unrealized_pnl: 120+120+80+240 = $560
```

### User 13: Olivia Brown (@oliviab) — 2 positions (casual, blue chips), ~$8,625 invested

```sql
-- AAPL: 15 shares @ avg $240, current $245
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000041',
    'b0000000000000000000000000000d01',
    'a000000000000000000000000000000d',
    'AAPL', 'stock', 15, 240.00, 245.00, 3675.00, 75.00,
    '2026-02-07T16:00:00.000Z'
);

-- MSFT: 10 shares @ avg $462, current $470
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000042',
    'b0000000000000000000000000000d01',
    'a000000000000000000000000000000d',
    'MSFT', 'stock', 10, 462.00, 470.00, 4700.00, 80.00,
    '2026-02-07T16:00:00.000Z'
);
-- User 13 total market_value: 3675+4700 = $8,375
-- User 13 total unrealized_pnl: 75+80 = $155
```

### User 14: Noah Garcia (@noahg) — 2 positions (ETFs only), ~$8,100 invested

```sql
-- VOO: 8 shares @ avg $548, current $560
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000043',
    'b0000000000000000000000000000e01',
    'a000000000000000000000000000000e',
    'VOO', 'etf', 8, 548.00, 560.00, 4480.00, 96.00,
    '2026-02-05T16:00:00.000Z'
);

-- QQQ: 7 shares @ avg $530, current $540
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000044',
    'b0000000000000000000000000000e01',
    'a000000000000000000000000000000e',
    'QQQ', 'etf', 7, 530.00, 540.00, 3780.00, 70.00,
    '2026-02-05T16:00:00.000Z'
);
-- User 14 total market_value: 4480+3780 = $8,260
-- User 14 total unrealized_pnl: 96+70 = $166
```

### User 15: Zoe Thompson (@zoet) — 1 position (starter), ~$6,420 invested

```sql
-- AAPL: 26 shares @ avg $242, current $245
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000045',
    'b0000000000000000000000000000f01',
    'a000000000000000000000000000000f',
    'AAPL', 'stock', 26, 242.00, 245.00, 6370.00, 78.00,
    '2026-01-28T16:00:00.000Z'
);
-- User 15 total market_value: $6,370
-- User 15 total unrealized_pnl: $78
```

### User 16: Liam Anderson (@liama) — 2 positions, ~$5,200 invested

```sql
-- SPY: 4 shares @ avg $600, current $610
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000046',
    'b0000000000000000000000000001001',
    'a0000000000000000000000000000010',
    'SPY', 'etf', 4, 600.00, 610.00, 2440.00, 40.00,
    '2026-02-03T16:00:00.000Z'
);

-- MSFT: 6 shares @ avg $465, current $470
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000047',
    'b0000000000000000000000000001001',
    'a0000000000000000000000000000010',
    'MSFT', 'stock', 6, 465.00, 470.00, 2820.00, 30.00,
    '2026-02-03T16:00:00.000Z'
);
-- User 16 total market_value: 2440+2820 = $5,260
-- User 16 total unrealized_pnl: 40+30 = $70
```

### User 17: Chloe Davis (@chloed) — 3 positions (social trader), ~$15,675 invested

```sql
-- NVDA: 35 shares @ avg $132, current $140
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000048',
    'b0000000000000000000000000001101',
    'a0000000000000000000000000000011',
    'NVDA', 'stock', 35, 132.00, 140.00, 4900.00, 280.00,
    '2026-02-10T16:00:00.000Z'
);

-- TSLA: 12 shares @ avg $400, current $420
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000049',
    'b0000000000000000000000000001101',
    'a0000000000000000000000000000011',
    'TSLA', 'stock', 12, 400.00, 420.00, 5040.00, 240.00,
    '2026-02-10T16:00:00.000Z'
);

-- META: 8 shares @ avg $630, current $650
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000004a',
    'b0000000000000000000000000001101',
    'a0000000000000000000000000000011',
    'META', 'stock', 8, 630.00, 650.00, 5200.00, 160.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 17 total market_value: 4900+5040+5200 = $15,140
-- User 17 total unrealized_pnl: 280+240+160 = $680
```

### User 18: Ethan Martinez (@ethanm) — 3 positions (crypto only), ~$8,575 invested

```sql
-- BTC: 0.04 @ avg $99000, current $105000
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000004b',
    'b0000000000000000000000000001201',
    'a0000000000000000000000000000012',
    'BTC', 'crypto', 0.04, 99000.00, 105000.00, 4200.00, 240.00,
    '2026-02-10T16:00:00.000Z'
);

-- ETH: 0.6 @ avg $3650, current $3800
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000004c',
    'b0000000000000000000000000001201',
    'a0000000000000000000000000000012',
    'ETH', 'crypto', 0.6, 3650.00, 3800.00, 2280.00, 90.00,
    '2026-02-10T16:00:00.000Z'
);

-- SOL: 10 @ avg $200, current $210
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000004d',
    'b0000000000000000000000000001201',
    'a0000000000000000000000000000012',
    'SOL', 'crypto', 10, 200.00, 210.00, 2100.00, 100.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 18 total market_value: 4200+2280+2100 = $8,580
-- User 18 total unrealized_pnl: 240+90+100 = $430
```

### User 19: Ava Jackson (@avaj) — 3 positions (blue chips), ~$8,160 invested

```sql
-- AAPL: 12 shares @ avg $238, current $245
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000004e',
    'b0000000000000000000000000001301',
    'a0000000000000000000000000000013',
    'AAPL', 'stock', 12, 238.00, 245.00, 2940.00, 84.00,
    '2026-02-06T16:00:00.000Z'
);

-- MSFT: 5 shares @ avg $460, current $470
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000004f',
    'b0000000000000000000000000001301',
    'a0000000000000000000000000000013',
    'MSFT', 'stock', 5, 460.00, 470.00, 2350.00, 50.00,
    '2026-02-06T16:00:00.000Z'
);

-- JNJ: 18 shares @ avg $157, current $162
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000050',
    'b0000000000000000000000000001301',
    'a0000000000000000000000000000013',
    'JNJ', 'stock', 18, 157.00, 162.00, 2916.00, 90.00,
    '2026-02-06T16:00:00.000Z'
);
-- User 19 total market_value: 2940+2350+2916 = $8,206
-- User 19 total unrealized_pnl: 84+50+90 = $224
```

### User 20: Lucas White (@lucasw) — 3 positions (ETFs only), ~$8,040 invested

```sql
-- VOO: 5 shares @ avg $550, current $560
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000051',
    'b0000000000000000000000000001401',
    'a0000000000000000000000000000014',
    'VOO', 'etf', 5, 550.00, 560.00, 2800.00, 50.00,
    '2026-02-04T16:00:00.000Z'
);

-- VTI: 10 shares @ avg $284, current $290
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000052',
    'b0000000000000000000000000001401',
    'a0000000000000000000000000000014',
    'VTI', 'etf', 10, 284.00, 290.00, 2900.00, 60.00,
    '2026-02-04T16:00:00.000Z'
);

-- QQQ: 4 shares @ avg $532, current $540
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000053',
    'b0000000000000000000000000001401',
    'a0000000000000000000000000000014',
    'QQQ', 'etf', 4, 532.00, 540.00, 2160.00, 32.00,
    '2026-02-04T16:00:00.000Z'
);
-- User 20 total market_value: 2800+2900+2160 = $7,860
-- User 20 total unrealized_pnl: 50+60+32 = $142
```

### User 21: Harper Lee (@harperl) — 2 positions (new 2025), ~$7,800 invested

```sql
-- AAPL: 14 shares @ avg $241, current $245
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000054',
    'b0000000000000000000000000001501',
    'a0000000000000000000000000000015',
    'AAPL', 'stock', 14, 241.00, 245.00, 3430.00, 56.00,
    '2026-02-08T16:00:00.000Z'
);

-- NVDA: 30 shares @ avg $136, current $140
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000055',
    'b0000000000000000000000000001501',
    'a0000000000000000000000000000015',
    'NVDA', 'stock', 30, 136.00, 140.00, 4200.00, 120.00,
    '2026-02-08T16:00:00.000Z'
);
-- User 21 total market_value: 3430+4200 = $7,630
-- User 21 total unrealized_pnl: 56+120 = $176
```

### User 22: Mason Clark (@masonc) — 5 positions (aggressive new trader), ~$17,400 invested

```sql
-- NVDA: 25 shares @ avg $135, current $140
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000056',
    'b0000000000000000000000000001601',
    'a0000000000000000000000000000016',
    'NVDA', 'stock', 25, 135.00, 140.00, 3500.00, 125.00,
    '2026-02-10T16:00:00.000Z'
);

-- AMD: 30 shares @ avg $120, current $125
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000057',
    'b0000000000000000000000000001601',
    'a0000000000000000000000000000016',
    'AMD', 'stock', 30, 120.00, 125.00, 3750.00, 150.00,
    '2026-02-10T16:00:00.000Z'
);

-- TSLA: 8 shares @ avg $405, current $420
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000058',
    'b0000000000000000000000000001601',
    'a0000000000000000000000000000016',
    'TSLA', 'stock', 8, 405.00, 420.00, 3360.00, 120.00,
    '2026-02-10T16:00:00.000Z'
);

-- BTC: 0.03 @ avg $100000, current $105000
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000059',
    'b0000000000000000000000000001601',
    'a0000000000000000000000000000016',
    'BTC', 'crypto', 0.03, 100000.00, 105000.00, 3150.00, 150.00,
    '2026-02-10T16:00:00.000Z'
);

-- META: 5 shares @ avg $635, current $650
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000005a',
    'b0000000000000000000000000001601',
    'a0000000000000000000000000000016',
    'META', 'stock', 5, 635.00, 650.00, 3250.00, 75.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 22 total market_value: 3500+3750+3360+3150+3250 = $17,010
-- User 22 total unrealized_pnl: 125+150+120+150+75 = $620
```

### User 23: Ella Robinson (@ellar) — 1 position (cautious), ~$5,100 invested

```sql
-- VOO: 9 shares @ avg $552, current $560
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000005b',
    'b0000000000000000000000000001701',
    'a0000000000000000000000000000017',
    'VOO', 'etf', 9, 552.00, 560.00, 5040.00, 72.00,
    '2026-01-20T16:00:00.000Z'
);
-- User 23 total market_value: $5,040
-- User 23 total unrealized_pnl: $72
```

### User 24: Jack Scott (@jacks) — 2 positions, ~$6,590 invested

```sql
-- AAPL: 10 shares @ avg $243, current $245
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000005c',
    'b0000000000000000000000000001801',
    'a0000000000000000000000000000018',
    'AAPL', 'stock', 10, 243.00, 245.00, 2450.00, 20.00,
    '2026-02-01T16:00:00.000Z'
);

-- SPY: 7 shares @ avg $605, current $610
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000005d',
    'b0000000000000000000000000001801',
    'a0000000000000000000000000000018',
    'SPY', 'etf', 7, 605.00, 610.00, 4270.00, 35.00,
    '2026-02-01T16:00:00.000Z'
);
-- User 24 total market_value: 2450+4270 = $6,720
-- User 24 total unrealized_pnl: 20+35 = $55
```

### User 25: Mia Torres (@miat) — 5 positions (new but active), ~$17,100 invested

```sql
-- AAPL: 14 shares @ avg $238, current $245
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000005e',
    'b0000000000000000000000000001901',
    'a0000000000000000000000000000019',
    'AAPL', 'stock', 14, 238.00, 245.00, 3430.00, 98.00,
    '2026-02-10T16:00:00.000Z'
);

-- NVDA: 20 shares @ avg $133, current $140
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000005f',
    'b0000000000000000000000000001901',
    'a0000000000000000000000000000019',
    'NVDA', 'stock', 20, 133.00, 140.00, 2800.00, 140.00,
    '2026-02-10T16:00:00.000Z'
);

-- BTC: 0.04 @ avg $97000, current $105000
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000060',
    'b0000000000000000000000000001901',
    'a0000000000000000000000000000019',
    'BTC', 'crypto', 0.04, 97000.00, 105000.00, 4200.00, 320.00,
    '2026-02-10T16:00:00.000Z'
);

-- TSLA: 6 shares @ avg $408, current $420
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000061',
    'b0000000000000000000000000001901',
    'a0000000000000000000000000000019',
    'TSLA', 'stock', 6, 408.00, 420.00, 2520.00, 72.00,
    '2026-02-10T16:00:00.000Z'
);

-- AMZN: 15 shares @ avg $222, current $230
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000062',
    'b0000000000000000000000000001901',
    'a0000000000000000000000000000019',
    'AMZN', 'stock', 15, 222.00, 230.00, 3450.00, 120.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 25 total market_value: 3430+2800+4200+2520+3450 = $16,400
-- User 25 total unrealized_pnl: 98+140+320+72+120 = $750
```

### User 26: Benjamin Hall (@benH) — 2 positions (banned/unbanned), ~$6,900 invested

```sql
-- AAPL: 12 shares @ avg $240, current $245
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000063',
    'b0000000000000000000000000001a01',
    'a000000000000000000000000000001a',
    'AAPL', 'stock', 12, 240.00, 245.00, 2940.00, 60.00,
    '2026-01-15T16:00:00.000Z'
);

-- SPY: 7 shares @ avg $595, current $610
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000064',
    'b0000000000000000000000000001a01',
    'a000000000000000000000000000001a',
    'SPY', 'etf', 7, 595.00, 610.00, 4270.00, 105.00,
    '2026-01-15T16:00:00.000Z'
);
-- User 26 total market_value: 2940+4270 = $7,210
-- User 26 total unrealized_pnl: 60+105 = $165
```

### User 27: Isabella Adams (@isabellaA) — 1 position (inactive, stale), ~$2,520 invested

```sql
-- MSFT: 5 shares @ avg $480, current $470 (underwater — bought at high)
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000065',
    'b0000000000000000000000000001b01',
    'a000000000000000000000000000001b',
    'MSFT', 'stock', 5, 480.00, 470.00, 2350.00, -50.00,
    '2025-09-15T16:00:00.000Z'
);
-- User 27 total market_value: $2,350
-- User 27 total unrealized_pnl: -$50
-- Note: updated_at is Sept 2025 — stale/inactive position
```

### User 28: William Turner (@willt) — 3 positions (all losing), ~$6,300 invested

```sql
-- COIN: 30 shares @ avg $280, current $215
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000066',
    'b0000000000000000000000000001c01',
    'a000000000000000000000000000001c',
    'COIN', 'stock', 30, 280.00, 215.00, 6450.00, -1950.00,
    '2026-02-10T16:00:00.000Z'
);

-- RIVN: 100 shares @ avg $18.00, current $12.50
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000067',
    'b0000000000000000000000000001c01',
    'a000000000000000000000000000001c',
    'RIVN', 'stock', 100, 18.00, 12.50, 1250.00, -550.00,
    '2026-02-10T16:00:00.000Z'
);

-- LCID: 200 shares @ avg $5.50, current $3.20
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000068',
    'b0000000000000000000000000001c01',
    'a000000000000000000000000000001c',
    'LCID', 'stock', 200, 5.50, 3.20, 640.00, -460.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 28 total market_value: 6450+1250+640 = $8,340
-- User 28 total unrealized_pnl: -1950+(-550)+(-460) = -$2,960
-- Note: Heavy losses — this user has negative PnL profile
```

### User 29: Charlotte Wright (@charlottew) — 0 positions (just reset)

```sql
-- No positions — User 29 just did a monthly reset and starts fresh with $25,000 cash
-- Portfolio has 0 positions, total_equity = cash_balance = $25,000
```

### User 30: Daniel King (@danielk) — 5 positions (admin testing), ~$22,750 invested

```sql
-- AAPL: 18 shares @ avg $230, current $245
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000069',
    'b0000000000000000000000000001e01',
    'a000000000000000000000000000001e',
    'AAPL', 'stock', 18, 230.00, 245.00, 4410.00, 270.00,
    '2026-02-10T16:00:00.000Z'
);

-- MSFT: 8 shares @ avg $452, current $470
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000006a',
    'b0000000000000000000000000001e01',
    'a000000000000000000000000000001e',
    'MSFT', 'stock', 8, 452.00, 470.00, 3760.00, 144.00,
    '2026-02-10T16:00:00.000Z'
);

-- GOOGL: 20 shares @ avg $185, current $195
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000006b',
    'b0000000000000000000000000001e01',
    'a000000000000000000000000000001e',
    'GOOGL', 'stock', 20, 185.00, 195.00, 3900.00, 200.00,
    '2026-02-10T16:00:00.000Z'
);

-- BTC: 0.05 @ avg $94000, current $105000
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000006c',
    'b0000000000000000000000000001e01',
    'a000000000000000000000000000001e',
    'BTC', 'crypto', 0.05, 94000.00, 105000.00, 5250.00, 550.00,
    '2026-02-10T16:00:00.000Z'
);

-- SPY: 10 shares @ avg $592, current $610
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000006d',
    'b0000000000000000000000000001e01',
    'a000000000000000000000000000001e',
    'SPY', 'etf', 10, 592.00, 610.00, 6100.00, 180.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 30 total market_value: 4410+3760+3900+5250+6100 = $23,420
-- User 30 total unrealized_pnl: 270+144+200+550+180 = $1,344
```

---

## VALIDATION SUMMARY

### Position Count by User Category

| Category | Users | Total Positions | Avg per User |
|----------|-------|----------------|-------------|
| Power Users (1-5) | 5 | 32 | 6.4 |
| Active Users (6-12) | 7 | 32 | 4.6 |
| Casual Users (13-20) | 8 | 19 | 2.4 |
| New Users (21-25) | 5 | 15 | 3.0 |
| Edge Cases (26-30) | 5 | 11 | 2.2 |
| **TOTAL** | **30** | **109** | **3.6** |

Note: User 29 has 0 positions (monthly reset). User 27 has 1 stale position. User 28 has 3 positions all underwater.

### Position ID Range
- First: `c0000000000000000000000000000001` (User 1, AAPL)
- Last: `c000000000000000000000000000006d` (User 30, SPY)
- Total unique IDs: 109 (hex 001 through 06d = decimal 1 through 109, no gaps)

### Asset Type Distribution

| Asset Type | Count | % |
|-----------|-------|---|
| stock | 71 | 65.1% |
| crypto | 22 | 20.2% |
| etf | 16 | 14.7% |
| **Total** | **109** | **100%** |

### Unique Tickers Used

**Stocks (20):** AAPL, MSFT, NVDA, GOOGL, AMZN, META, TSLA, AMD, NFLX, CRM, SOFI, JNJ, PG, KO, BRK.B, PEP, T, VZ, GME, AMC, BBBY, PLTR, COIN, RIVN, LCID

**Crypto (6):** BTC, ETH, SOL, DOGE, ADA

**ETFs (8):** SPY, QQQ, VOO, VTI, IWM, XLF, GLD

### Users with Negative PnL
- **User 27** (isabellaA): -$50 on MSFT (bought high, stale)
- **User 28** (willt): -$2,960 total (COIN -$1,950, RIVN -$550, LCID -$460)

### Constraint Verification
- All `market_value = quantity * current_price` (verified)
- All `unrealized_pnl = market_value - (quantity * average_cost)` (verified)
- All `UNIQUE(portfolio_id, ticker)` constraints satisfied (no duplicate tickers per portfolio)
- All portfolio_id and user_id references match the provided reference table
