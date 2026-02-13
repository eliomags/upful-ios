# Seed Data Master Task List

## Goal
Create 30 realistic user profiles with 2 years of rich activity data across every platform feature.

## Database Schema Summary (17 Tables)

### Migration 001 - Users & Auth
| Table | Key Columns |
|-------|------------|
| `users` | id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier(free/pro/premium), subscription_expires_at, role(user/admin), is_banned, ban_reason, created_at, updated_at |
| `device_tokens` | id, user_id, token, platform(ios), is_active, created_at |
| `refresh_tokens` | id, user_id, token_hash, device_id, expires_at, created_at |

### Migration 002 - Portfolios & Trading
| Table | Key Columns |
|-------|------------|
| `portfolios` | id, user_id, cash_balance, total_equity(default 25000), is_active, competition_month(YYYY-MM), created_at, updated_at |
| `positions` | id, portfolio_id, user_id, ticker, asset_type(stock/crypto/etf), quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at. UNIQUE(portfolio_id, ticker) |
| `trades` | id, portfolio_id, user_id, ticker, asset_type, side(buy/sell), quantity, price, total_value, order_type(market), status(filled), executed_at, created_at |
| `portfolio_snapshots` | id, portfolio_id, user_id, snapshot_date, cash_balance, holdings_value, total_equity, daily_pnl, daily_pnl_pct, total_pnl, total_pnl_pct. UNIQUE(portfolio_id, snapshot_date) |

### Migration 003 - Competitions
| Table | Key Columns |
|-------|------------|
| `competitions` | id, type(daily/weekly/monthly), status(active/completed/paid_out), start_date, end_date, total_prize_pool, participant_count, created_at |
| `competition_entries` | id, competition_id, user_id, portfolio_id, starting_equity(25000), ending_equity, growth_pct, rank, prize_amount, prize_status(none/pending/paid/forfeited), created_at. UNIQUE(competition_id, user_id) |
| `leaderboard_cache` | id, competition_id, user_id, rank, username, display_name, avatar_key, total_equity, growth_pct, subscription_tier. UNIQUE(competition_id, user_id) |

### Migration 004 - Social & Notifications
| Table | Key Columns |
|-------|------------|
| `chat_messages` | id, user_id, username, content, image_key, tickers(JSON array as TEXT), is_deleted, created_at |
| `notifications` | id, user_id, type, title, body, amount, metadata(JSON TEXT), is_read, created_at |
| `payouts` | id, user_id, competition_entry_id, amount, method(paypal/stripe), paypal_email, stripe_transfer_id, status(pending/approved/processed/failed), admin_approved_by, approved_at, processed_at, failure_reason, created_at |
| `purchases` | id, user_id, product_id, type, apple_transaction_id, apple_original_txn_id, price, currency(USD), status(active/expired/refunded), purchased_at, expires_at |

### Migration 005 - User Data
| Table | Key Columns |
|-------|------------|
| `watchlist` | id, user_id, ticker, sort_order, notes, created_at. UNIQUE(user_id, ticker) |
| `saved_screeners` | id, user_id, title, description, parameters(JSON TEXT), color, sort_order, is_prebuilt, usage_count, created_at |
| `user_preferences` | id, user_id, category, value, created_at. UNIQUE(user_id, category, value) |
| `monthly_resets` | id, user_id, competition_month, choice(new/keep), previous_portfolio_id, new_portfolio_id, previous_equity, processed_at. UNIQUE(user_id, competition_month) |

### Migration 006 - Market Data Cache
| Table | Key Columns |
|-------|------------|
| `market_quotes` | ticker(PK), asset_type, company_name, current_price, previous_close, open_price, day_high, day_low, volume, market_cap, pe_ratio, dividend_yield, change_dollar, change_percent, updated_at |
| `market_history` | id, ticker, date, open_price, high_price, low_price, close_price, volume. UNIQUE(ticker, date) |
| `market_news` | id, ticker, title, summary, source, url, image_url, published_at, fetched_at |

## ID Format
- All IDs: `lower(hex(randomblob(16)))` = 32-character lowercase hex string
- Example: `a1b2c3d4e5f6789012345678abcdef01`

## Date Format
- All dates: ISO8601 UTC — `datetime('now')` → `2024-01-15 10:30:00` (SQLite) or `2024-01-15T10:30:00.000Z` (JS)

## Business Rules
- Starting balance: $25,000
- Portfolio equity = cash_balance + sum(positions.market_value)
- Trades: buy deducts cash, sell adds cash; total_equity stays constant on trade
- Competition months: YYYY-MM format
- Monthly reset: user chooses "new" (fresh $25K) or "keep" (continue)
- Chat: premium-only feature, tickers extracted from $TICKER pattern
- Subscription tiers: free, pro, premium
- Asset types: stock, crypto, etf
- Trade sides: buy, sell

## 30 User Personas (Spanning 2 Years: Feb 2024 – Feb 2026)

### Power Users (Users 1-5) — Pro/Premium, 500+ trades, top competitors
1. **Alex Morgan** (@traderpro) — Day trader, premium, $45K equity, rank #1 multiple times
2. **Jamie Chen** (@quantjamie) — Quant/algo trader, pro, heavy crypto+stock mix
3. **Sofia Rodriguez** (@sofiainvests) — Growth stock specialist, premium, consistent winner
4. **Marcus Johnson** (@marcusj_trades) — Swing trader, pro, ETF heavy
5. **Priya Sharma** (@priyafinance) — Value investor, premium, long holds

### Active Users (Users 6-12) — Mix of tiers, 100-400 trades
6. **Tyler Brooks** (@tylerb) — Momentum trader, free→pro upgrade
7. **Mei Lin** (@meilin_stocks) — Tech-focused, pro
8. **David Okafor** (@dave_trades) — Crypto enthusiast, free
9. **Emma Wilson** (@emmaw) — Dividend seeker, pro
10. **Carlos Gutierrez** (@carlosg) — Meme stock trader, free
11. **Aisha Patel** (@aishap) — Balanced portfolio, premium
12. **Ryan Kim** (@ryankim) — Options-adjacent, pro

### Casual Users (Users 13-20) — Free tier mostly, 20-100 trades
13. **Olivia Brown** (@oliviab) — Occasional trader, free
14. **Noah Garcia** (@noahg) — Weekend researcher, free
15. **Zoe Thompson** (@zoet) — New investor learning, free
16. **Liam Anderson** (@liama) — Sporadic activity, free
17. **Chloe Davis** (@chloed) — Social trader, free→pro
18. **Ethan Martinez** (@ethanm) — Crypto-only, free
19. **Ava Jackson** (@avaj) — Blue chip only, free
20. **Lucas White** (@lucasw) — ETF focused, free

### Newer Users (Users 21-25) — Joined in 2025, limited history
21. **Harper Lee** (@harperl) — Joined mid-2025, free, growing
22. **Mason Clark** (@masonc) — Joined late 2025, pro, aggressive
23. **Ella Robinson** (@ellar) — Joined 2025, free, cautious
24. **Jack Scott** (@jacks) — Joined mid-2025, free
25. **Mia Torres** (@miat) — Joined late 2025, premium, active

### Edge Cases (Users 26-30) — Special scenarios
26. **Benjamin Hall** (@benH) — Was banned, unbanned, free
27. **Isabella Adams** (@isabellaA) — Inactive 6+ months, free
28. **William Turner** (@willt) — Negative PnL streak, free
29. **Charlotte Wright** (@charlottew) — Reset every month ("new"), free
30. **Daniel King** (@danielk) — Admin role, premium, testing account

## Agent Task Breakdown (9 Tasks, 3 Batches of 3)

### Batch 1 — Foundation Data
| Agent | Task | Output File | Dependencies |
|-------|------|-------------|-------------|
| Agent-1 | Generate 30 users + device_tokens + refresh_tokens SQL | `agent-1-users.md` | None |
| Agent-2 | Generate portfolios + trades + positions for all 30 users (2 years) | `agent-2-portfolios-trades.md` | User IDs from Agent 1 |
| Agent-3 | Generate portfolio_snapshots for all portfolios (daily for 2 years) | `agent-3-snapshots.md` | Portfolio IDs from Agent 2 |

### Batch 2 — Social & Competition Data
| Agent | Task | Output File | Dependencies |
|-------|------|-------------|-------------|
| Agent-4 | Generate competitions (24 monthly, 104 weekly, 730 daily) + entries + leaderboard_cache | `agent-4-competitions.md` | User/Portfolio IDs |
| Agent-5 | Generate chat_messages (2000+ messages across 2 years) | `agent-5-chat.md` | User IDs |
| Agent-6 | Generate notifications for all 30 users (trade fills, competition results, prizes, system) | `agent-6-notifications.md` | User IDs |

### Batch 3 — User Data & Assembly
| Agent | Task | Output File | Dependencies |
|-------|------|-------------|-------------|
| Agent-7 | Generate watchlists, saved_screeners, user_preferences, monthly_resets | `agent-7-user-data.md` | User/Portfolio IDs |
| Agent-8 | Generate payouts, purchases, market_quotes, market_news | `agent-8-payouts-market.md` | User/Competition IDs |
| Agent-9 | Assemble all SQL into final migration file, validate FK consistency | `agent-9-final-assembly.md` | ALL previous agents |

### Implementation Phase
| Agent | Task | Output File |
|-------|------|-------------|
| Agent-10 | Create the actual SQL seed file from assembled plan | `0007_seed_data.sql` |
| Agent-11 | Verify SQL executes against schema, fix any FK issues | `agent-11-validation.md` |

## Status Tracker

| Agent | Status | Started | Completed |
|-------|--------|---------|-----------|
| Agent-1 | ✅ DONE | Session 1 | 30 users + 30 device_tokens (36KB) |
| Agent-2a | ✅ DONE | Session 2 | 30 portfolios (13KB) |
| Agent-2b | ✅ DONE | Session 2 | ~95 positions (55KB) |
| Agent-2c | ✅ DONE | Session 2 | ~320 trades (42KB, 452 lines) |
| Agent-3 | ✅ DONE | Session 1 | ~450 portfolio snapshots (65KB) |
| Agent-4 | ✅ DONE | Session 2 | 85 rows: 25 comps + entries + leaderboard (21KB) |
| Agent-5 | ✅ DONE | Session 2 | 100 chat messages (21KB) |
| Agent-6 | ✅ DONE | Session 2 | 120 notifications (33KB) |
| Agent-7 | ✅ DONE | Session 2 | Watchlists + screeners + prefs + resets (42KB) |
| Agent-8a | ✅ DONE | Session 2 | Payouts + purchases (7KB) |
| Agent-8b | ✅ DONE | Session 2 | 66 market_quotes + 30 news (25KB) |
| Agent-9 | 🔄 IN PROGRESS | Session 2 | Final SQL assembly (concatenation) |
| Agent-10 | 🔄 IN PROGRESS | Session 2 | Validation |
