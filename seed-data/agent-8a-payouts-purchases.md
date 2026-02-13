# Seed Data: Payouts & Purchases

## Payouts

```sql
INSERT INTO payouts (id, user_id, competition_entry_id, amount, method, paypal_email, stripe_transfer_id, status, admin_approved_by, approved_at, processed_at, failure_reason, created_at) VALUES
-- traderpro: 3 wins ($500, $600, $400)
('j1000000000000000000000000000001', 'a000000000000000000000000000001', NULL, 500.00, 'paypal', 'alex.morgan@email.com', NULL, 'processed', 'a000000000000000000000000000001e', '2024-04-12 10:00:00', '2024-04-12 14:30:00', NULL, '2024-04-10 18:00:00'),
('j1000000000000000000000000000002', 'a000000000000000000000000000001', NULL, 600.00, 'paypal', 'alex.morgan@email.com', NULL, 'processed', 'a000000000000000000000000000001e', '2024-09-20 11:00:00', '2024-09-20 16:45:00', NULL, '2024-09-18 20:00:00'),
('j1000000000000000000000000000003', 'a000000000000000000000000000001', NULL, 400.00, 'paypal', 'alex.morgan@email.com', NULL, 'processed', 'a000000000000000000000000000001e', '2025-03-05 09:30:00', '2025-03-05 13:00:00', NULL, '2025-03-03 17:00:00'),

-- quantjamie: 2 wins ($300, $350)
('j1000000000000000000000000000004', 'a000000000000000000000000000002', NULL, 300.00, 'paypal', 'jamie.chen@email.com', NULL, 'processed', 'a000000000000000000000000000001e', '2024-06-15 10:00:00', '2024-06-15 15:20:00', NULL, '2024-06-13 19:00:00'),
('j1000000000000000000000000000005', 'a000000000000000000000000000002', NULL, 350.00, 'paypal', 'jamie.chen@email.com', NULL, 'processed', 'a000000000000000000000000000001e', '2025-01-10 12:00:00', '2025-01-10 17:00:00', NULL, '2025-01-08 21:00:00'),

-- sofiainvests: 2 wins ($500, $300)
('j1000000000000000000000000000006', 'a000000000000000000000000000003', NULL, 500.00, 'paypal', 'sofia.r@email.com', NULL, 'processed', 'a000000000000000000000000000001e', '2024-07-22 09:00:00', '2024-07-22 14:10:00', NULL, '2024-07-20 16:00:00'),
('j1000000000000000000000000000007', 'a000000000000000000000000000003', NULL, 300.00, 'paypal', 'sofia.r@email.com', NULL, 'processed', 'a000000000000000000000000000001e', '2025-05-01 10:30:00', '2025-05-01 15:00:00', NULL, '2025-04-29 18:00:00'),

-- marcusj_trades: 1 win ($200)
('j1000000000000000000000000000008', 'a000000000000000000000000000004', NULL, 200.00, 'paypal', 'marcus.j@email.com', NULL, 'processed', 'a000000000000000000000000000001e', '2024-11-18 11:00:00', '2024-11-18 16:30:00', NULL, '2024-11-16 20:00:00'),

-- priyafinance: 2 wins ($400, $500)
('j1000000000000000000000000000009', 'a000000000000000000000000000005', NULL, 400.00, 'paypal', 'priya.s@email.com', NULL, 'processed', 'a000000000000000000000000000001e', '2024-08-30 10:00:00', '2024-08-30 14:45:00', NULL, '2024-08-28 17:00:00'),
('j100000000000000000000000000000a', 'a000000000000000000000000000005', NULL, 500.00, 'paypal', 'priya.s@email.com', NULL, 'pending', NULL, NULL, NULL, NULL, '2026-02-05 19:00:00'),

-- tylerb: 1 win ($150)
('j100000000000000000000000000000b', 'a000000000000000000000000000006', NULL, 150.00, 'paypal', 'tyler.b@email.com', NULL, 'processed', 'a000000000000000000000000000001e', '2025-06-10 09:00:00', '2025-06-10 13:30:00', NULL, '2025-06-08 15:00:00'),

-- emmaw: 1 win ($200)
('j100000000000000000000000000000c', 'a000000000000000000000000000009', NULL, 200.00, 'paypal', 'emma.w@email.com', NULL, 'processed', 'a000000000000000000000000000001e', '2025-09-14 10:30:00', '2025-09-14 15:00:00', NULL, '2025-09-12 18:00:00'),

-- aishap: 1 win ($250)
('j100000000000000000000000000000d', 'a00000000000000000000000000000b', NULL, 250.00, 'paypal', 'aisha.p@email.com', NULL, 'pending', NULL, NULL, NULL, NULL, '2026-01-28 20:00:00');
```

## Purchases (Apple IAP Subscriptions)

```sql
INSERT INTO purchases (id, user_id, product_id, type, apple_transaction_id, apple_original_txn_id, price, currency, status, purchased_at, expires_at) VALUES
-- Premium subscribers ($9.99/mo)
-- traderpro (user 01)
('j2000000000000000000000000000001', 'a000000000000000000000000000001', 'com.syanik.upful.premium.monthly', 'subscription', '200000048571234', '200000048571234', 9.99, 'USD', 'active', '2024-03-01 08:00:00', '2026-03-01 08:00:00'),

-- sofiainvests (user 03)
('j2000000000000000000000000000002', 'a000000000000000000000000000003', 'com.syanik.upful.premium.monthly', 'subscription', '200000051298765', '200000051298765', 9.99, 'USD', 'active', '2024-05-15 10:30:00', '2026-03-15 10:30:00'),

-- priyafinance (user 05)
('j2000000000000000000000000000003', 'a000000000000000000000000000005', 'com.syanik.upful.premium.monthly', 'subscription', '200000054837291', '200000054837291', 9.99, 'USD', 'active', '2024-06-20 14:00:00', '2026-03-20 14:00:00'),

-- aishap (user 0b)
('j2000000000000000000000000000004', 'a00000000000000000000000000000b', 'com.syanik.upful.premium.monthly', 'subscription', '200000063918274', '200000063918274', 9.99, 'USD', 'active', '2025-01-05 09:00:00', '2026-03-05 09:00:00'),

-- danielk (user 1e — admin, premium)
('j2000000000000000000000000000005', 'a000000000000000000000000000001e', 'com.syanik.upful.premium.monthly', 'subscription', '200000059172836', '200000059172836', 9.99, 'USD', 'active', '2024-01-10 12:00:00', '2026-03-10 12:00:00'),

-- Pro subscribers ($4.99/mo)
-- quantjamie (user 02)
('j2000000000000000000000000000006', 'a000000000000000000000000000002', 'com.syanik.upful.pro.monthly', 'subscription', '200000049382716', '200000049382716', 4.99, 'USD', 'active', '2024-04-10 11:00:00', '2026-03-10 11:00:00'),

-- marcusj_trades (user 04)
('j2000000000000000000000000000007', 'a000000000000000000000000000004', 'com.syanik.upful.pro.monthly', 'subscription', '200000052847193', '200000052847193', 4.99, 'USD', 'active', '2024-07-01 09:30:00', '2026-03-01 09:30:00'),

-- tylerb (user 06)
('j2000000000000000000000000000008', 'a000000000000000000000000000006', 'com.syanik.upful.pro.monthly', 'subscription', '200000055291847', '200000055291847', 4.99, 'USD', 'active', '2024-08-18 16:00:00', '2026-03-18 16:00:00'),

-- emmaw (user 09)
('j2000000000000000000000000000009', 'a000000000000000000000000000009', 'com.syanik.upful.pro.monthly', 'subscription', '200000061837492', '200000061837492', 4.99, 'USD', 'active', '2025-02-01 08:00:00', '2026-03-01 08:00:00');
```

## Summary

| Table | Rows | Notes |
|-------|------|-------|
| payouts | 14 | 12 processed, 2 pending (priya $500, aisha $250) |
| purchases | 9 | 5 premium ($9.99), 4 pro ($4.99), all active |

### Payout Totals by User
| User | Total Paid | Status |
|------|-----------|--------|
| traderpro | $1,500 | All processed |
| quantjamie | $650 | All processed |
| sofiainvests | $800 | All processed |
| marcusj_trades | $200 | Processed |
| priyafinance | $400 processed + $500 pending | 1 pending |
| tylerb | $150 | Processed |
| emmaw | $200 | Processed |
| aishap | $0 processed + $250 pending | 1 pending |
