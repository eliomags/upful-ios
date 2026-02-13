# Notifications Seed Data (120 rows)

```sql
-- ============================================================
-- WELCOME NOTIFICATIONS (30 rows — one per user)
-- ============================================================

INSERT INTO notifications (id, user_id, type, title, body, amount, metadata, is_read, created_at) VALUES
('h0000000000000000000000000000001', 'a0000000000000000000000000000001', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2024-02-10 09:00:00'),
('h0000000000000000000000000000002', 'a0000000000000000000000000000002', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2024-02-14 10:30:00'),
('h0000000000000000000000000000003', 'a0000000000000000000000000000003', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2024-02-20 14:15:00'),
('h0000000000000000000000000000004', 'a0000000000000000000000000000004', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2024-03-01 08:45:00'),
('h0000000000000000000000000000005', 'a0000000000000000000000000000005', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2024-03-15 11:00:00'),
('h0000000000000000000000000000006', 'a0000000000000000000000000000006', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2024-04-02 09:30:00'),
('h0000000000000000000000000000007', 'a0000000000000000000000000000007', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2024-04-10 13:00:00'),
('h0000000000000000000000000000008', 'a0000000000000000000000000000008', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2024-04-18 16:20:00'),
('h0000000000000000000000000000009', 'a0000000000000000000000000000009', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2024-05-05 10:00:00'),
('h000000000000000000000000000000a', 'a000000000000000000000000000000a', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2024-05-12 08:15:00'),
('h000000000000000000000000000000b', 'a000000000000000000000000000000b', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2024-05-28 14:45:00'),
('h000000000000000000000000000000c', 'a000000000000000000000000000000c', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2024-06-03 09:00:00'),
('h000000000000000000000000000000d', 'a000000000000000000000000000000d', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2024-07-01 10:30:00'),
('h000000000000000000000000000000e', 'a000000000000000000000000000000e', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2024-07-15 12:00:00'),
('h000000000000000000000000000000f', 'a000000000000000000000000000000f', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2024-08-01 09:45:00'),
('h0000000000000000000000000000010', 'a0000000000000000000000000000010', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2024-08-20 11:30:00'),
('h0000000000000000000000000000011', 'a0000000000000000000000000000011', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2024-09-05 08:00:00'),
('h0000000000000000000000000000012', 'a0000000000000000000000000000012', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2024-09-18 15:00:00'),
('h0000000000000000000000000000013', 'a0000000000000000000000000000013', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2024-10-01 10:00:00'),
('h0000000000000000000000000000014', 'a0000000000000000000000000000014', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2024-11-10 09:30:00'),
('h0000000000000000000000000000015', 'a0000000000000000000000000000015', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2025-06-01 08:00:00'),
('h0000000000000000000000000000016', 'a0000000000000000000000000000016', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2025-07-15 10:00:00'),
('h0000000000000000000000000000017', 'a0000000000000000000000000000017', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2025-08-20 14:00:00'),
('h0000000000000000000000000000018', 'a0000000000000000000000000000018', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2025-09-10 09:00:00'),
('h0000000000000000000000000000019', 'a0000000000000000000000000000019', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2025-11-01 11:30:00'),
('h000000000000000000000000000001a', 'a000000000000000000000000000001a', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2024-03-25 10:00:00'),
('h000000000000000000000000000001b', 'a000000000000000000000000000001b', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2024-06-20 13:00:00'),
('h000000000000000000000000000001c', 'a000000000000000000000000000001c', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2024-08-10 09:15:00'),
('h000000000000000000000000000001d', 'a000000000000000000000000000001d', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2024-10-25 14:30:00'),
('h000000000000000000000000000001e', 'a000000000000000000000000000001e', 'welcome', 'Welcome to Upful!', 'Start trading with $25,000 in paper money. Good luck!', NULL, NULL, 1, '2024-12-01 08:45:00');

-- ============================================================
-- TRADE_FILLED NOTIFICATIONS (40 rows)
-- ============================================================

-- User 1 (power user) — 5 trades
INSERT INTO notifications (id, user_id, type, title, body, amount, metadata, is_read, created_at) VALUES
('h000000000000000000000000000001f', 'a0000000000000000000000000000001', 'trade_filled', 'Trade Filled', 'Your buy order for 10 shares of AAPL was filled at $189.50', NULL, '{"ticker":"AAPL","side":"buy","quantity":10,"price":189.50}', 1, '2024-03-15 10:32:00'),
('h0000000000000000000000000000020', 'a0000000000000000000000000000001', 'trade_filled', 'Trade Filled', 'Your buy order for 25 shares of NVDA was filled at $620.00', NULL, '{"ticker":"NVDA","side":"buy","quantity":25,"price":620.00}', 1, '2024-06-10 14:15:00'),
('h0000000000000000000000000000021', 'a0000000000000000000000000000001', 'trade_filled', 'Trade Filled', 'Your sell order for 10 shares of AAPL was filled at $227.30', NULL, '{"ticker":"AAPL","side":"sell","quantity":10,"price":227.30}', 1, '2024-09-20 11:45:00'),
('h0000000000000000000000000000022', 'a0000000000000000000000000000001', 'trade_filled', 'Trade Filled', 'Your buy order for 15 shares of TSLA was filled at $248.75', NULL, '{"ticker":"TSLA","side":"buy","quantity":15,"price":248.75}', 1, '2025-01-08 09:31:00'),
('h0000000000000000000000000000023', 'a0000000000000000000000000000001', 'trade_filled', 'Trade Filled', 'Your buy order for 50 shares of AMZN was filled at $228.10', NULL, '{"ticker":"AMZN","side":"buy","quantity":50,"price":228.10}', 0, '2026-01-22 10:05:00');

-- User 2 (power user) — 5 trades
INSERT INTO notifications (id, user_id, type, title, body, amount, metadata, is_read, created_at) VALUES
('h0000000000000000000000000000024', 'a0000000000000000000000000000002', 'trade_filled', 'Trade Filled', 'Your buy order for 30 shares of MSFT was filled at $410.25', NULL, '{"ticker":"MSFT","side":"buy","quantity":30,"price":410.25}', 1, '2024-04-05 09:35:00'),
('h0000000000000000000000000000025', 'a0000000000000000000000000000002', 'trade_filled', 'Trade Filled', 'Your buy order for 20 shares of GOOGL was filled at $155.80', NULL, '{"ticker":"GOOGL","side":"buy","quantity":20,"price":155.80}', 1, '2024-07-12 13:22:00'),
('h0000000000000000000000000000026', 'a0000000000000000000000000000002', 'trade_filled', 'Trade Filled', 'Your sell order for 30 shares of MSFT was filled at $445.60', NULL, '{"ticker":"MSFT","side":"sell","quantity":30,"price":445.60}', 1, '2024-10-18 15:01:00'),
('h0000000000000000000000000000027', 'a0000000000000000000000000000002', 'trade_filled', 'Trade Filled', 'Your buy order for 40 shares of META was filled at $585.20', NULL, '{"ticker":"META","side":"buy","quantity":40,"price":585.20}', 1, '2025-02-14 10:10:00'),
('h0000000000000000000000000000028', 'a0000000000000000000000000000002', 'trade_filled', 'Trade Filled', 'Your buy order for 100 shares of PLTR was filled at $98.50', NULL, '{"ticker":"PLTR","side":"buy","quantity":100,"price":98.50}', 0, '2026-02-03 11:30:00');

-- User 3 (power user) — 5 trades
INSERT INTO notifications (id, user_id, type, title, body, amount, metadata, is_read, created_at) VALUES
('h0000000000000000000000000000029', 'a0000000000000000000000000000003', 'trade_filled', 'Trade Filled', 'Your buy order for 50 shares of AMD was filled at $162.40', NULL, '{"ticker":"AMD","side":"buy","quantity":50,"price":162.40}', 1, '2024-04-22 09:45:00'),
('h000000000000000000000000000002a', 'a0000000000000000000000000000003', 'trade_filled', 'Trade Filled', 'Your buy order for 8 shares of AVGO was filled at $1420.00', NULL, '{"ticker":"AVGO","side":"buy","quantity":8,"price":1420.00}', 1, '2024-07-30 14:20:00'),
('h000000000000000000000000000002b', 'a0000000000000000000000000000003', 'trade_filled', 'Trade Filled', 'Your sell order for 50 shares of AMD was filled at $185.90', NULL, '{"ticker":"AMD","side":"sell","quantity":50,"price":185.90}', 1, '2024-11-05 10:55:00'),
('h000000000000000000000000000002c', 'a0000000000000000000000000000003', 'trade_filled', 'Trade Filled', 'Your buy order for 20 shares of NFLX was filled at $895.00', NULL, '{"ticker":"NFLX","side":"buy","quantity":20,"price":895.00}', 1, '2025-05-15 09:32:00'),
('h000000000000000000000000000002d', 'a0000000000000000000000000000003', 'trade_filled', 'Trade Filled', 'Your buy order for 35 shares of CRM was filled at $340.75', NULL, '{"ticker":"CRM","side":"buy","quantity":35,"price":340.75}', 0, '2026-01-28 13:18:00');

-- User 4 (power user) — 5 trades
INSERT INTO notifications (id, user_id, type, title, body, amount, metadata, is_read, created_at) VALUES
('h000000000000000000000000000002e', 'a0000000000000000000000000000004', 'trade_filled', 'Trade Filled', 'Your buy order for 15 shares of AAPL was filled at $195.20', NULL, '{"ticker":"AAPL","side":"buy","quantity":15,"price":195.20}', 1, '2024-05-10 10:12:00'),
('h000000000000000000000000000002f', 'a0000000000000000000000000000004', 'trade_filled', 'Trade Filled', 'Your buy order for 10 shares of NVDA was filled at $710.50', NULL, '{"ticker":"NVDA","side":"buy","quantity":10,"price":710.50}', 1, '2024-08-05 11:48:00'),
('h0000000000000000000000000000030', 'a0000000000000000000000000000004', 'trade_filled', 'Trade Filled', 'Your sell order for 15 shares of AAPL was filled at $235.10', NULL, '{"ticker":"AAPL","side":"sell","quantity":15,"price":235.10}', 1, '2024-12-02 14:30:00'),
('h0000000000000000000000000000031', 'a0000000000000000000000000000004', 'trade_filled', 'Trade Filled', 'Your buy order for 60 shares of SOFI was filled at $14.85', NULL, '{"ticker":"SOFI","side":"buy","quantity":60,"price":14.85}', 1, '2025-04-20 09:55:00'),
('h0000000000000000000000000000032', 'a0000000000000000000000000000004', 'trade_filled', 'Trade Filled', 'Your buy order for 25 shares of COIN was filled at $310.00', NULL, '{"ticker":"COIN","side":"buy","quantity":25,"price":310.00}', 0, '2026-02-05 10:42:00');

-- User 5 (power user) — 5 trades
INSERT INTO notifications (id, user_id, type, title, body, amount, metadata, is_read, created_at) VALUES
('h0000000000000000000000000000033', 'a0000000000000000000000000000005', 'trade_filled', 'Trade Filled', 'Your buy order for 100 shares of F was filled at $12.30', NULL, '{"ticker":"F","side":"buy","quantity":100,"price":12.30}', 1, '2024-05-18 09:31:00'),
('h0000000000000000000000000000034', 'a0000000000000000000000000000005', 'trade_filled', 'Trade Filled', 'Your buy order for 20 shares of TSLA was filled at $175.50', NULL, '{"ticker":"TSLA","side":"buy","quantity":20,"price":175.50}', 1, '2024-08-22 14:05:00'),
('h0000000000000000000000000000035', 'a0000000000000000000000000000005', 'trade_filled', 'Trade Filled', 'Your sell order for 100 shares of F was filled at $11.85', NULL, '{"ticker":"F","side":"sell","quantity":100,"price":11.85}', 1, '2024-11-15 10:22:00'),
('h0000000000000000000000000000036', 'a0000000000000000000000000000005', 'trade_filled', 'Trade Filled', 'Your buy order for 12 shares of GOOGL was filled at $192.40', NULL, '{"ticker":"GOOGL","side":"buy","quantity":12,"price":192.40}', 1, '2025-06-10 11:18:00'),
('h0000000000000000000000000000037', 'a0000000000000000000000000000005', 'trade_filled', 'Trade Filled', 'Your buy order for 30 shares of MSFT was filled at $455.90', NULL, '{"ticker":"MSFT","side":"buy","quantity":30,"price":455.90}', 0, '2026-01-15 09:50:00');

-- User 6 (active) — 2 trades
INSERT INTO notifications (id, user_id, type, title, body, amount, metadata, is_read, created_at) VALUES
('h0000000000000000000000000000038', 'a0000000000000000000000000000006', 'trade_filled', 'Trade Filled', 'Your buy order for 20 shares of DIS was filled at $115.60', NULL, '{"ticker":"DIS","side":"buy","quantity":20,"price":115.60}', 1, '2024-06-15 10:30:00'),
('h0000000000000000000000000000039', 'a0000000000000000000000000000006', 'trade_filled', 'Trade Filled', 'Your buy order for 5 shares of AMZN was filled at $198.20', NULL, '{"ticker":"AMZN","side":"buy","quantity":5,"price":198.20}', 1, '2024-11-20 13:45:00');

-- User 7 (active) — 2 trades
INSERT INTO notifications (id, user_id, type, title, body, amount, metadata, is_read, created_at) VALUES
('h000000000000000000000000000003a', 'a0000000000000000000000000000007', 'trade_filled', 'Trade Filled', 'Your buy order for 15 shares of NFLX was filled at $680.00', NULL, '{"ticker":"NFLX","side":"buy","quantity":15,"price":680.00}', 1, '2024-07-08 09:40:00'),
('h000000000000000000000000000003b', 'a0000000000000000000000000000007', 'trade_filled', 'Trade Filled', 'Your sell order for 15 shares of NFLX was filled at $725.30', NULL, '{"ticker":"NFLX","side":"sell","quantity":15,"price":725.30}', 1, '2024-12-10 14:15:00');

-- User 8 (active) — 1 trade
INSERT INTO notifications (id, user_id, type, title, body, amount, metadata, is_read, created_at) VALUES
('h000000000000000000000000000003c', 'a0000000000000000000000000000008', 'trade_filled', 'Trade Filled', 'Your buy order for 40 shares of INTC was filled at $31.20', NULL, '{"ticker":"INTC","side":"buy","quantity":40,"price":31.20}', 1, '2024-08-14 11:05:00');

-- User 9 (active) — 1 trade
INSERT INTO notifications (id, user_id, type, title, body, amount, metadata, is_read, created_at) VALUES
('h000000000000000000000000000003d', 'a0000000000000000000000000000009', 'trade_filled', 'Trade Filled', 'Your buy order for 10 shares of PYPL was filled at $68.50', NULL, '{"ticker":"PYPL","side":"buy","quantity":10,"price":68.50}', 1, '2024-09-02 10:20:00');

-- User 10 (active) — 1 trade
INSERT INTO notifications (id, user_id, type, title, body, amount, metadata, is_read, created_at) VALUES
('h000000000000000000000000000003e', 'a000000000000000000000000000000a', 'trade_filled', 'Trade Filled', 'Your buy order for 25 shares of SQ was filled at $78.90', NULL, '{"ticker":"SQ","side":"buy","quantity":25,"price":78.90}', 1, '2024-10-05 15:30:00');

-- User 11 (active) — 1 trade
INSERT INTO notifications (id, user_id, type, title, body, amount, metadata, is_read, created_at) VALUES
('h000000000000000000000000000003f', 'a000000000000000000000000000000b', 'trade_filled', 'Trade Filled', 'Your buy order for 8 shares of SHOP was filled at $92.40', NULL, '{"ticker":"SHOP","side":"buy","quantity":8,"price":92.40}', 1, '2024-10-22 09:15:00');

-- User 12 (active) — 2 trades
INSERT INTO notifications (id, user_id, type, title, body, amount, metadata, is_read, created_at) VALUES
('h0000000000000000000000000000040', 'a000000000000000000000000000000c', 'trade_filled', 'Trade Filled', 'Your buy order for 50 shares of BAC was filled at $37.80', NULL, '{"ticker":"BAC","side":"buy","quantity":50,"price":37.80}', 1, '2024-08-28 10:50:00'),
('h0000000000000000000000000000041', 'a000000000000000000000000000000c', 'trade_filled', 'Trade Filled', 'Your buy order for 10 shares of V was filled at $285.00', NULL, '{"ticker":"V","side":"buy","quantity":10,"price":285.00}', 0, '2025-12-15 11:20:00');

-- Casual/new users — 5 trades spread across
INSERT INTO notifications (id, user_id, type, title, body, amount, metadata, is_read, created_at) VALUES
('h0000000000000000000000000000042', 'a000000000000000000000000000000d', 'trade_filled', 'Trade Filled', 'Your buy order for 5 shares of AAPL was filled at $220.10', NULL, '{"ticker":"AAPL","side":"buy","quantity":5,"price":220.10}', 1, '2024-10-10 09:30:00'),
('h0000000000000000000000000000043', 'a0000000000000000000000000000010', 'trade_filled', 'Trade Filled', 'Your buy order for 3 shares of TSLA was filled at $260.00', NULL, '{"ticker":"TSLA","side":"buy","quantity":3,"price":260.00}', 1, '2024-11-05 14:00:00'),
('h0000000000000000000000000000044', 'a0000000000000000000000000000015', 'trade_filled', 'Trade Filled', 'Your buy order for 10 shares of NVDA was filled at $135.20', NULL, '{"ticker":"NVDA","side":"buy","quantity":10,"price":135.20}', 0, '2025-08-12 10:45:00'),
('h0000000000000000000000000000045', 'a0000000000000000000000000000018', 'trade_filled', 'Trade Filled', 'Your buy order for 20 shares of AMD was filled at $178.30', NULL, '{"ticker":"AMD","side":"buy","quantity":20,"price":178.30}', 0, '2025-11-20 09:55:00'),
('h0000000000000000000000000000046', 'a000000000000000000000000000001e', 'trade_filled', 'Trade Filled', 'Your buy order for 7 shares of MSFT was filled at $430.50', NULL, '{"ticker":"MSFT","side":"buy","quantity":7,"price":430.50}', 0, '2026-01-10 13:30:00');

-- ============================================================
-- COMPETITION_STARTED NOTIFICATIONS (10 rows)
-- ============================================================

INSERT INTO notifications (id, user_id, type, title, body, amount, metadata, is_read, created_at) VALUES
('h0000000000000000000000000000047', 'a0000000000000000000000000000001', 'competition_started', 'Competition Started', 'The October 2025 monthly competition has begun!', NULL, NULL, 1, '2025-10-01 08:00:00'),
('h0000000000000000000000000000048', 'a0000000000000000000000000000002', 'competition_started', 'Competition Started', 'The October 2025 monthly competition has begun!', NULL, NULL, 1, '2025-10-01 08:00:00'),
('h0000000000000000000000000000049', 'a0000000000000000000000000000003', 'competition_started', 'Competition Started', 'The November 2025 monthly competition has begun!', NULL, NULL, 1, '2025-11-01 08:00:00'),
('h000000000000000000000000000004a', 'a0000000000000000000000000000004', 'competition_started', 'Competition Started', 'The November 2025 monthly competition has begun!', NULL, NULL, 1, '2025-11-01 08:00:00'),
('h000000000000000000000000000004b', 'a0000000000000000000000000000005', 'competition_started', 'Competition Started', 'The December 2025 monthly competition has begun!', NULL, NULL, 1, '2025-12-01 08:00:00'),
('h000000000000000000000000000004c', 'a0000000000000000000000000000001', 'competition_started', 'Competition Started', 'The December 2025 monthly competition has begun!', NULL, NULL, 1, '2025-12-01 08:00:00'),
('h000000000000000000000000000004d', 'a0000000000000000000000000000003', 'competition_started', 'Competition Started', 'The January 2026 monthly competition has begun!', NULL, NULL, 1, '2026-01-01 08:00:00'),
('h000000000000000000000000000004e', 'a0000000000000000000000000000002', 'competition_started', 'Competition Started', 'The January 2026 monthly competition has begun!', NULL, NULL, 1, '2026-01-01 08:00:00'),
('h000000000000000000000000000004f', 'a0000000000000000000000000000001', 'competition_started', 'Competition Started', 'The February 2026 monthly competition has begun!', NULL, NULL, 1, '2026-02-01 08:00:00'),
('h0000000000000000000000000000050', 'a0000000000000000000000000000005', 'competition_started', 'Competition Started', 'The February 2026 monthly competition has begun!', NULL, NULL, 1, '2026-02-01 08:00:00');

-- ============================================================
-- COMPETITION_ENDED NOTIFICATIONS (10 rows)
-- ============================================================

INSERT INTO notifications (id, user_id, type, title, body, amount, metadata, is_read, created_at) VALUES
('h0000000000000000000000000000051', 'a0000000000000000000000000000001', 'competition_ended', 'Competition Ended', 'The October competition has ended. You finished #1!', NULL, NULL, 1, '2025-10-31 20:00:00'),
('h0000000000000000000000000000052', 'a0000000000000000000000000000002', 'competition_ended', 'Competition Ended', 'The October competition has ended. You finished #3!', NULL, NULL, 1, '2025-10-31 20:00:00'),
('h0000000000000000000000000000053', 'a0000000000000000000000000000003', 'competition_ended', 'Competition Ended', 'The November competition has ended. You finished #1!', NULL, NULL, 1, '2025-11-30 20:00:00'),
('h0000000000000000000000000000054', 'a0000000000000000000000000000004', 'competition_ended', 'Competition Ended', 'The November competition has ended. You finished #2!', NULL, NULL, 1, '2025-11-30 20:00:00'),
('h0000000000000000000000000000055', 'a0000000000000000000000000000005', 'competition_ended', 'Competition Ended', 'The December competition has ended. You finished #1!', NULL, NULL, 1, '2025-12-31 20:00:00'),
('h0000000000000000000000000000056', 'a0000000000000000000000000000001', 'competition_ended', 'Competition Ended', 'The December competition has ended. You finished #2!', NULL, NULL, 1, '2025-12-31 20:00:00'),
('h0000000000000000000000000000057', 'a0000000000000000000000000000003', 'competition_ended', 'Competition Ended', 'The January competition has ended. You finished #3!', NULL, NULL, 1, '2026-01-31 20:00:00'),
('h0000000000000000000000000000058', 'a0000000000000000000000000000002', 'competition_ended', 'Competition Ended', 'The January competition has ended. You finished #5!', NULL, NULL, 1, '2026-01-31 20:00:00'),
('h0000000000000000000000000000059', 'a0000000000000000000000000000005', 'competition_ended', 'Competition Ended', 'The January competition has ended. You finished #2!', NULL, NULL, 1, '2026-01-31 20:00:00'),
('h000000000000000000000000000005a', 'a0000000000000000000000000000004', 'competition_ended', 'Competition Ended', 'The January competition has ended. You finished #4!', NULL, NULL, 1, '2026-01-31 20:00:00');

-- ============================================================
-- PRIZE_WON NOTIFICATIONS (8 rows)
-- ============================================================

INSERT INTO notifications (id, user_id, type, title, body, amount, metadata, is_read, created_at) VALUES
('h000000000000000000000000000005b', 'a0000000000000000000000000000001', 'prize_won', 'You Won!', 'Congratulations! You won $500 in the October competition (Rank #1)', 500.00, '{"competition_id":"f0000000000000000000000000000001","rank":1,"amount":500}', 1, '2025-10-31 20:05:00'),
('h000000000000000000000000000005c', 'a0000000000000000000000000000001', 'prize_won', 'You Won!', 'Congratulations! You won $200 in the December competition (Rank #2)', 200.00, '{"competition_id":"f0000000000000000000000000000003","rank":2,"amount":200}', 1, '2025-12-31 20:05:00'),
('h000000000000000000000000000005d', 'a0000000000000000000000000000003', 'prize_won', 'You Won!', 'Congratulations! You won $500 in the November competition (Rank #1)', 500.00, '{"competition_id":"f0000000000000000000000000000002","rank":1,"amount":500}', 1, '2025-11-30 20:05:00'),
('h000000000000000000000000000005e', 'a0000000000000000000000000000003', 'prize_won', 'You Won!', 'Congratulations! You won $100 in the January competition (Rank #3)', 100.00, '{"competition_id":"f0000000000000000000000000000004","rank":3,"amount":100}', 1, '2026-01-31 20:05:00'),
('h000000000000000000000000000005f', 'a0000000000000000000000000000005', 'prize_won', 'You Won!', 'Congratulations! You won $500 in the December competition (Rank #1)', 500.00, '{"competition_id":"f0000000000000000000000000000003","rank":1,"amount":500}', 1, '2025-12-31 20:05:00'),
('h0000000000000000000000000000060', 'a0000000000000000000000000000005', 'prize_won', 'You Won!', 'Congratulations! You won $200 in the January competition (Rank #2)', 200.00, '{"competition_id":"f0000000000000000000000000000004","rank":2,"amount":200}', 1, '2026-01-31 20:05:00'),
('h0000000000000000000000000000061', 'a0000000000000000000000000000002', 'prize_won', 'You Won!', 'Congratulations! You won $100 in the October competition (Rank #3)', 100.00, '{"competition_id":"f0000000000000000000000000000001","rank":3,"amount":100}', 1, '2025-10-31 20:05:00'),
('h0000000000000000000000000000062', 'a0000000000000000000000000000004', 'prize_won', 'You Won!', 'Congratulations! You won $200 in the November competition (Rank #2)', 200.00, '{"competition_id":"f0000000000000000000000000000002","rank":2,"amount":200}', 1, '2025-11-30 20:05:00');

-- ============================================================
-- PRIZE_PAID NOTIFICATIONS (6 rows)
-- ============================================================

INSERT INTO notifications (id, user_id, type, title, body, amount, metadata, is_read, created_at) VALUES
('h0000000000000000000000000000063', 'a0000000000000000000000000000001', 'prize_paid', 'Prize Paid', 'Your prize of $500 has been sent to your PayPal', 500.00, '{"competition_id":"f0000000000000000000000000000001","payment_method":"paypal"}', 1, '2025-11-05 12:00:00'),
('h0000000000000000000000000000064', 'a0000000000000000000000000000003', 'prize_paid', 'Prize Paid', 'Your prize of $500 has been sent to your PayPal', 500.00, '{"competition_id":"f0000000000000000000000000000002","payment_method":"paypal"}', 1, '2025-12-05 12:00:00'),
('h0000000000000000000000000000065', 'a0000000000000000000000000000005', 'prize_paid', 'Prize Paid', 'Your prize of $500 has been sent to your PayPal', 500.00, '{"competition_id":"f0000000000000000000000000000003","payment_method":"paypal"}', 1, '2026-01-05 12:00:00'),
('h0000000000000000000000000000066', 'a0000000000000000000000000000002', 'prize_paid', 'Prize Paid', 'Your prize of $100 has been sent to your PayPal', 100.00, '{"competition_id":"f0000000000000000000000000000001","payment_method":"paypal"}', 1, '2025-11-05 12:00:00'),
('h0000000000000000000000000000067', 'a0000000000000000000000000000004', 'prize_paid', 'Prize Paid', 'Your prize of $200 has been sent to your PayPal', 200.00, '{"competition_id":"f0000000000000000000000000000002","payment_method":"paypal"}', 1, '2025-12-05 12:00:00'),
('h0000000000000000000000000000068', 'a0000000000000000000000000000001', 'prize_paid', 'Prize Paid', 'Your prize of $200 has been sent to your PayPal', 200.00, '{"competition_id":"f0000000000000000000000000000003","payment_method":"paypal"}', 1, '2026-01-05 12:00:00');

-- ============================================================
-- SUBSCRIPTION_UPGRADE NOTIFICATIONS (6 rows)
-- ============================================================

INSERT INTO notifications (id, user_id, type, title, body, amount, metadata, is_read, created_at) VALUES
('h0000000000000000000000000000069', 'a0000000000000000000000000000001', 'subscription_upgrade', 'Welcome to Premium!', 'You now have access to chat, advanced screeners, and more!', NULL, '{"plan":"premium","previous_plan":"free"}', 1, '2024-04-01 10:00:00'),
('h000000000000000000000000000006a', 'a0000000000000000000000000000003', 'subscription_upgrade', 'Welcome to Premium!', 'You now have access to chat, advanced screeners, and more!', NULL, '{"plan":"premium","previous_plan":"free"}', 1, '2024-05-15 09:30:00'),
('h000000000000000000000000000006b', 'a0000000000000000000000000000005', 'subscription_upgrade', 'Welcome to Premium!', 'You now have access to chat, advanced screeners, and more!', NULL, '{"plan":"premium","previous_plan":"free"}', 1, '2024-06-20 14:00:00'),
('h000000000000000000000000000006c', 'a000000000000000000000000000000b', 'subscription_upgrade', 'Welcome to Premium!', 'You now have access to chat, advanced screeners, and more!', NULL, '{"plan":"premium","previous_plan":"free"}', 1, '2024-11-01 10:15:00'),
('h000000000000000000000000000006d', 'a0000000000000000000000000000019', 'subscription_upgrade', 'Welcome to Premium!', 'You now have access to chat, advanced screeners, and more!', NULL, '{"plan":"premium","previous_plan":"free"}', 1, '2025-12-10 08:45:00'),
('h000000000000000000000000000006e', 'a0000000000000000000000000000006', 'subscription_upgrade', 'Welcome to Pro!', 'You now have access to extended trading hours and priority support!', NULL, '{"plan":"pro","previous_plan":"free"}', 1, '2024-09-15 11:00:00');

-- ============================================================
-- SYSTEM NOTIFICATIONS (10 rows)
-- ============================================================

INSERT INTO notifications (id, user_id, type, title, body, amount, metadata, is_read, created_at) VALUES
('h000000000000000000000000000006f', 'a0000000000000000000000000000001', 'system', 'New Feature', 'Stock screeners with custom filters are now available!', NULL, NULL, 1, '2024-06-01 09:00:00'),
('h0000000000000000000000000000070', 'a0000000000000000000000000000003', 'system', 'New Feature', 'Stock screeners with custom filters are now available!', NULL, NULL, 1, '2024-06-01 09:00:00'),
('h0000000000000000000000000000071', 'a0000000000000000000000000000005', 'system', 'Market Hours Update', 'Extended trading hours are now available for premium users.', NULL, NULL, 1, '2024-09-01 08:00:00'),
('h0000000000000000000000000000072', 'a0000000000000000000000000000007', 'system', 'Maintenance Notice', 'Scheduled maintenance on Saturday 10pm-2am EST. Trading will be paused.', NULL, NULL, 1, '2024-10-18 12:00:00'),
('h0000000000000000000000000000073', 'a000000000000000000000000000000a', 'system', 'New Feature', 'You can now compare up to 5 stocks side by side!', NULL, NULL, 1, '2025-01-15 09:00:00'),
('h0000000000000000000000000000074', 'a000000000000000000000000000000e', 'system', 'New Feature', 'Watchlist alerts are now live. Get notified on price movements!', NULL, NULL, 1, '2025-03-10 09:00:00'),
('h0000000000000000000000000000075', 'a0000000000000000000000000000012', 'system', 'App Update', 'Version 2.0 is here! Redesigned charts, faster data, and more.', NULL, NULL, 1, '2025-06-01 08:00:00'),
('h0000000000000000000000000000076', 'a0000000000000000000000000000002', 'system', 'Competition Update', 'Monthly competitions now feature bigger prize pools! Check it out.', NULL, NULL, 1, '2025-09-15 09:00:00'),
('h0000000000000000000000000000077', 'a0000000000000000000000000000016', 'system', 'New Feature', 'AI-powered trade insights are now available for premium members.', NULL, NULL, 1, '2025-11-01 09:00:00'),
('h0000000000000000000000000000078', 'a0000000000000000000000000000004', 'system', 'Leaderboard Update', 'The leaderboard now shows all-time rankings. See where you stand!', NULL, NULL, 1, '2026-01-20 09:00:00');
```

## Summary

| Type | Count |
|------|-------|
| welcome | 30 |
| trade_filled | 40 |
| competition_started | 10 |
| competition_ended | 10 |
| prize_won | 8 |
| prize_paid | 6 |
| subscription_upgrade | 6 |
| system | 10 |
| **Total** | **120** |

### ID Range
- `h0000000000000000000000000000001` through `h0000000000000000000000000000078` (hex 001 through 078 = 120 rows)

### Key Design Notes
- Welcome notifications: one per user, matched to their join date, all marked as read
- Trade fills: power users (1-5) have 5 each, active users (6-12) have 1-2 each, casual/new users have scattered fills
- Competition notifications: focused on Oct 2025 through Feb 2026 timeframe for active users
- Prize won: Users 1,3,5 get 2 wins each; Users 2,4 get 1 each (total 8)
- Prize paid: 6 payouts matching the earlier prize wins (Jan 2026 wins not yet paid)
- Subscription upgrades: Users 1,3,5,11(0b),25(19) upgraded to premium; User 6 upgraded to pro
- System notifications: spread across different users and dates, covering feature launches and maintenance
- `is_read=0` only on recent trade notifications (last ~2 months) to simulate unread state
