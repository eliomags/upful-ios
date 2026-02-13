# Agent-1 Output: Users & Device Tokens Seed Data

> Generated for the Upful/Jyanik paper trading iOS app.
> Contains 30 users across 5 persona categories and 30 device tokens (1 per user).

---

## USER IDS TABLE

| User# | ID (hex) | Username | Display Name | Tier |
|-------|----------|----------|--------------|------|
| 1 | `a0000000000000000000000000000001` | traderpro | Alex Morgan | premium |
| 2 | `a0000000000000000000000000000002` | quantjamie | Jamie Chen | pro |
| 3 | `a0000000000000000000000000000003` | sofiainvests | Sofia Rodriguez | premium |
| 4 | `a0000000000000000000000000000004` | marcusj_trades | Marcus Johnson | pro |
| 5 | `a0000000000000000000000000000005` | priyafinance | Priya Sharma | premium |
| 6 | `a0000000000000000000000000000006` | tylerb | Tyler Brooks | pro |
| 7 | `a0000000000000000000000000000007` | meilin_stocks | Mei Lin | pro |
| 8 | `a0000000000000000000000000000008` | dave_trades | David Okafor | free |
| 9 | `a0000000000000000000000000000009` | emmaw | Emma Wilson | pro |
| 10 | `a000000000000000000000000000000a` | carlosg | Carlos Gutierrez | free |
| 11 | `a000000000000000000000000000000b` | aishap | Aisha Patel | premium |
| 12 | `a000000000000000000000000000000c` | ryankim | Ryan Kim | pro |
| 13 | `a000000000000000000000000000000d` | oliviab | Olivia Brown | free |
| 14 | `a000000000000000000000000000000e` | noahg | Noah Garcia | free |
| 15 | `a000000000000000000000000000000f` | zoet | Zoe Thompson | free |
| 16 | `a0000000000000000000000000000010` | liama | Liam Anderson | free |
| 17 | `a0000000000000000000000000000011` | chloed | Chloe Davis | pro |
| 18 | `a0000000000000000000000000000012` | ethanm | Ethan Martinez | free |
| 19 | `a0000000000000000000000000000013` | avaj | Ava Jackson | free |
| 20 | `a0000000000000000000000000000014` | lucasw | Lucas White | free |
| 21 | `a0000000000000000000000000000015` | harperl | Harper Lee | free |
| 22 | `a0000000000000000000000000000016` | masonc | Mason Clark | pro |
| 23 | `a0000000000000000000000000000017` | ellar | Ella Robinson | free |
| 24 | `a0000000000000000000000000000018` | jacks | Jack Scott | free |
| 25 | `a0000000000000000000000000000019` | miat | Mia Torres | premium |
| 26 | `a000000000000000000000000000001a` | benH | Benjamin Hall | free |
| 27 | `a000000000000000000000000000001b` | isabellaA | Isabella Adams | free |
| 28 | `a000000000000000000000000000001c` | willt | William Turner | free |
| 29 | `a000000000000000000000000000001d` | charlottew | Charlotte Wright | free |
| 30 | `a000000000000000000000000000001e` | danielk | Daniel King | premium |

---

## SQL INSERT STATEMENTS -- USERS

### Power Users (1-5)

```sql
-- User 1: Alex Morgan (@traderpro) - Premium power user
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a0000000000000000000000000000001',
    'alex@traderpro.com',
    'traderpro',
    'Alex Morgan',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    'avatars/traderpro.png',
    'alex@traderpro.com',
    '+14155550101',
    1,
    1,
    'premium',
    '2026-12-31T23:59:59.000Z',
    NULL,
    'user',
    0,
    NULL,
    '2024-02-01T08:00:00.000Z',
    '2025-02-01T10:30:00.000Z'
);

-- User 2: Jamie Chen (@quantjamie) - Pro power user
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a0000000000000000000000000000002',
    'jamie.chen@gmail.com',
    'quantjamie',
    'Jamie Chen',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    'avatars/quantjamie.png',
    'jamie.chen@paypal.com',
    NULL,
    0,
    1,
    'pro',
    '2026-12-31T23:59:59.000Z',
    NULL,
    'user',
    0,
    NULL,
    '2024-02-15T12:00:00.000Z',
    '2025-01-20T14:15:00.000Z'
);

-- User 3: Sofia Rodriguez (@sofiainvests) - Premium power user
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a0000000000000000000000000000003',
    'sofia.r@outlook.com',
    'sofiainvests',
    'Sofia Rodriguez',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    'avatars/sofiainvests.png',
    'sofia.r@paypal.com',
    '+14155550103',
    1,
    1,
    'premium',
    '2026-12-31T23:59:59.000Z',
    NULL,
    'user',
    0,
    NULL,
    '2024-03-01T09:30:00.000Z',
    '2025-02-05T16:45:00.000Z'
);

-- User 4: Marcus Johnson (@marcusj_trades) - Pro power user
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a0000000000000000000000000000004',
    'marcus.j@yahoo.com',
    'marcusj_trades',
    'Marcus Johnson',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    'avatars/marcusj_trades.png',
    NULL,
    NULL,
    0,
    1,
    'pro',
    '2026-12-31T23:59:59.000Z',
    NULL,
    'user',
    0,
    NULL,
    '2024-03-10T11:00:00.000Z',
    '2025-01-15T09:20:00.000Z'
);

-- User 5: Priya Sharma (@priyafinance) - Premium power user
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a0000000000000000000000000000005',
    'priya.sharma@gmail.com',
    'priyafinance',
    'Priya Sharma',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    'avatars/priyafinance.png',
    'priya@paypal.com',
    '+14155550105',
    1,
    1,
    'premium',
    '2026-12-31T23:59:59.000Z',
    NULL,
    'user',
    0,
    NULL,
    '2024-04-01T07:45:00.000Z',
    '2025-02-10T11:00:00.000Z'
);
```

### Active Users (6-12)

```sql
-- User 6: Tyler Brooks (@tylerb) - Pro (upgraded from free 2024-09-01)
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a0000000000000000000000000000006',
    'tyler.b@gmail.com',
    'tylerb',
    'Tyler Brooks',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    'avatars/tylerb.png',
    NULL,
    NULL,
    0,
    1,
    'pro',
    '2026-12-31T23:59:59.000Z',
    NULL,
    'user',
    0,
    NULL,
    '2024-05-01T10:00:00.000Z',
    '2024-09-01T08:00:00.000Z'
);

-- User 7: Mei Lin (@meilin_stocks) - Pro
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a0000000000000000000000000000007',
    'mei.lin@hotmail.com',
    'meilin_stocks',
    'Mei Lin',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    'avatars/meilin_stocks.png',
    NULL,
    NULL,
    0,
    1,
    'pro',
    '2026-12-31T23:59:59.000Z',
    NULL,
    'user',
    0,
    NULL,
    '2024-05-15T14:30:00.000Z',
    '2025-01-10T17:00:00.000Z'
);

-- User 8: David Okafor (@dave_trades) - Free
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a0000000000000000000000000000008',
    'david.o@gmail.com',
    'dave_trades',
    'David Okafor',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    NULL,
    NULL,
    NULL,
    0,
    0,
    'free',
    NULL,
    NULL,
    'user',
    0,
    NULL,
    '2024-06-01T09:00:00.000Z',
    '2024-12-15T13:30:00.000Z'
);

-- User 9: Emma Wilson (@emmaw) - Pro
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a0000000000000000000000000000009',
    'emma.w@outlook.com',
    'emmaw',
    'Emma Wilson',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    'avatars/emmaw.png',
    NULL,
    NULL,
    0,
    1,
    'pro',
    '2026-12-31T23:59:59.000Z',
    NULL,
    'user',
    0,
    NULL,
    '2024-06-15T16:00:00.000Z',
    '2025-01-25T10:45:00.000Z'
);

-- User 10: Carlos Gutierrez (@carlosg) - Free
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a000000000000000000000000000000a',
    'carlos.g@gmail.com',
    'carlosg',
    'Carlos Gutierrez',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    NULL,
    NULL,
    NULL,
    0,
    0,
    'free',
    NULL,
    NULL,
    'user',
    0,
    NULL,
    '2024-07-01T08:30:00.000Z',
    '2024-11-20T15:00:00.000Z'
);

-- User 11: Aisha Patel (@aishap) - Premium
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a000000000000000000000000000000b',
    'aisha.p@gmail.com',
    'aishap',
    'Aisha Patel',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    'avatars/aishap.png',
    'aisha@paypal.com',
    '+14155550111',
    1,
    1,
    'premium',
    '2026-12-31T23:59:59.000Z',
    NULL,
    'user',
    0,
    NULL,
    '2024-07-15T13:00:00.000Z',
    '2025-02-08T09:30:00.000Z'
);

-- User 12: Ryan Kim (@ryankim) - Pro
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a000000000000000000000000000000c',
    'ryan.kim@yahoo.com',
    'ryankim',
    'Ryan Kim',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    'avatars/ryankim.png',
    NULL,
    NULL,
    0,
    1,
    'pro',
    '2026-12-31T23:59:59.000Z',
    NULL,
    'user',
    0,
    NULL,
    '2024-08-01T11:30:00.000Z',
    '2025-01-30T14:00:00.000Z'
);
```

### Casual Users (13-20)

```sql
-- User 13: Olivia Brown (@oliviab) - Free
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a000000000000000000000000000000d',
    'olivia.b@gmail.com',
    'oliviab',
    'Olivia Brown',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    NULL,
    NULL,
    NULL,
    0,
    0,
    'free',
    NULL,
    NULL,
    'user',
    0,
    NULL,
    '2024-08-15T10:00:00.000Z',
    '2024-12-01T08:00:00.000Z'
);

-- User 14: Noah Garcia (@noahg) - Free
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a000000000000000000000000000000e',
    'noah.g@outlook.com',
    'noahg',
    'Noah Garcia',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    NULL,
    NULL,
    NULL,
    0,
    0,
    'free',
    NULL,
    NULL,
    'user',
    0,
    NULL,
    '2024-09-01T15:00:00.000Z',
    '2024-12-10T12:00:00.000Z'
);

-- User 15: Zoe Thompson (@zoet) - Free
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a000000000000000000000000000000f',
    'zoe.t@gmail.com',
    'zoet',
    'Zoe Thompson',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    NULL,
    NULL,
    NULL,
    0,
    0,
    'free',
    NULL,
    NULL,
    'user',
    0,
    NULL,
    '2024-09-15T09:45:00.000Z',
    '2025-01-05T11:30:00.000Z'
);

-- User 16: Liam Anderson (@liama) - Free
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a0000000000000000000000000000010',
    'liam.a@yahoo.com',
    'liama',
    'Liam Anderson',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    NULL,
    NULL,
    NULL,
    0,
    0,
    'free',
    NULL,
    NULL,
    'user',
    0,
    NULL,
    '2024-10-01T14:00:00.000Z',
    '2025-01-12T16:00:00.000Z'
);

-- User 17: Chloe Davis (@chloed) - Pro (upgraded 2025-01-01)
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a0000000000000000000000000000011',
    'chloe.d@gmail.com',
    'chloed',
    'Chloe Davis',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    'avatars/chloed.png',
    NULL,
    NULL,
    0,
    0,
    'pro',
    '2026-12-31T23:59:59.000Z',
    NULL,
    'user',
    0,
    NULL,
    '2024-10-15T08:30:00.000Z',
    '2025-01-01T00:05:00.000Z'
);

-- User 18: Ethan Martinez (@ethanm) - Free
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a0000000000000000000000000000012',
    'ethan.m@gmail.com',
    'ethanm',
    'Ethan Martinez',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    NULL,
    NULL,
    NULL,
    0,
    0,
    'free',
    NULL,
    NULL,
    'user',
    0,
    NULL,
    '2024-11-01T12:00:00.000Z',
    '2025-01-20T10:00:00.000Z'
);

-- User 19: Ava Jackson (@avaj) - Free
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a0000000000000000000000000000013',
    'ava.j@outlook.com',
    'avaj',
    'Ava Jackson',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    NULL,
    NULL,
    NULL,
    0,
    0,
    'free',
    NULL,
    NULL,
    'user',
    0,
    NULL,
    '2024-11-15T17:30:00.000Z',
    '2025-01-08T09:15:00.000Z'
);

-- User 20: Lucas White (@lucasw) - Free
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a0000000000000000000000000000014',
    'lucas.w@gmail.com',
    'lucasw',
    'Lucas White',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    NULL,
    NULL,
    NULL,
    0,
    0,
    'free',
    NULL,
    NULL,
    'user',
    0,
    NULL,
    '2024-12-01T10:15:00.000Z',
    '2025-01-28T13:45:00.000Z'
);
```

### Newer Users (21-25)

```sql
-- User 21: Harper Lee (@harperl) - Free, joined 2025
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a0000000000000000000000000000015',
    'harper.l@gmail.com',
    'harperl',
    'Harper Lee',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    NULL,
    NULL,
    NULL,
    0,
    0,
    'free',
    NULL,
    NULL,
    'user',
    0,
    NULL,
    '2025-06-01T09:00:00.000Z',
    '2025-06-15T14:30:00.000Z'
);

-- User 22: Mason Clark (@masonc) - Pro, joined 2025
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a0000000000000000000000000000016',
    'mason.c@outlook.com',
    'masonc',
    'Mason Clark',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    'avatars/masonc.png',
    NULL,
    NULL,
    0,
    1,
    'pro',
    '2026-12-31T23:59:59.000Z',
    NULL,
    'user',
    0,
    NULL,
    '2025-09-01T11:00:00.000Z',
    '2025-09-10T16:00:00.000Z'
);

-- User 23: Ella Robinson (@ellar) - Free, joined 2025
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a0000000000000000000000000000017',
    'ella.r@gmail.com',
    'ellar',
    'Ella Robinson',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    NULL,
    NULL,
    NULL,
    0,
    0,
    'free',
    NULL,
    NULL,
    'user',
    0,
    NULL,
    '2025-07-15T08:45:00.000Z',
    '2025-08-01T10:00:00.000Z'
);

-- User 24: Jack Scott (@jacks) - Free, joined 2025
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a0000000000000000000000000000018',
    'jack.s@yahoo.com',
    'jacks',
    'Jack Scott',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    NULL,
    NULL,
    NULL,
    0,
    0,
    'free',
    NULL,
    NULL,
    'user',
    0,
    NULL,
    '2025-08-01T13:00:00.000Z',
    '2025-08-20T15:30:00.000Z'
);

-- User 25: Mia Torres (@miat) - Premium, joined 2025
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a0000000000000000000000000000019',
    'mia.t@gmail.com',
    'miat',
    'Mia Torres',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    'avatars/miat.png',
    'mia.t@paypal.com',
    NULL,
    0,
    1,
    'premium',
    '2026-12-31T23:59:59.000Z',
    NULL,
    'user',
    0,
    NULL,
    '2025-10-01T10:30:00.000Z',
    '2025-10-15T12:00:00.000Z'
);
```

### Edge Cases (26-30)

```sql
-- User 26: Benjamin Hall (@benH) - Free, was banned (resolved)
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a000000000000000000000000000001a',
    'ben.h@gmail.com',
    'benH',
    'Benjamin Hall',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    NULL,
    NULL,
    NULL,
    0,
    0,
    'free',
    NULL,
    NULL,
    'user',
    0,
    'Temporary ban for spam - resolved',
    '2024-04-15T10:00:00.000Z',
    '2024-11-01T09:00:00.000Z'
);

-- User 27: Isabella Adams (@isabellaA) - Free, inactive since 2025-08-01
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a000000000000000000000000000001b',
    'isabella.a@outlook.com',
    'isabellaA',
    'Isabella Adams',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    NULL,
    NULL,
    NULL,
    0,
    0,
    'free',
    NULL,
    NULL,
    'user',
    0,
    NULL,
    '2024-05-01T11:30:00.000Z',
    '2025-08-01T08:00:00.000Z'
);

-- User 28: William Turner (@willt) - Free
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a000000000000000000000000000001c',
    'will.t@gmail.com',
    'willt',
    'William Turner',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    NULL,
    NULL,
    NULL,
    0,
    0,
    'free',
    NULL,
    NULL,
    'user',
    0,
    NULL,
    '2024-06-01T14:00:00.000Z',
    '2024-12-20T11:30:00.000Z'
);

-- User 29: Charlotte Wright (@charlottew) - Free
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a000000000000000000000000000001d',
    'charlotte.w@yahoo.com',
    'charlottew',
    'Charlotte Wright',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    NULL,
    NULL,
    NULL,
    0,
    0,
    'free',
    NULL,
    NULL,
    'user',
    0,
    NULL,
    '2024-07-01T09:15:00.000Z',
    '2025-01-05T16:45:00.000Z'
);

-- User 30: Daniel King (@danielk) - Premium, Admin
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a000000000000000000000000000001e',
    'daniel.k@jyanik.com',
    'danielk',
    'Daniel King',
    '$2b$10$K8ZpFYm5sUzx8p5Q5Zj4K.JhDCJGKDQwNQzJWRhYqBxGqVnHZ3Z3m',
    NULL,
    'avatars/danielk.png',
    NULL,
    '+14155550130',
    1,
    1,
    'premium',
    '2026-12-31T23:59:59.000Z',
    NULL,
    'admin',
    0,
    NULL,
    '2024-01-15T07:00:00.000Z',
    '2025-02-12T08:00:00.000Z'
);
```

---

## SQL INSERT STATEMENTS -- DEVICE TOKENS

```sql
-- Device token for User 1: Alex Morgan
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt000000000000000000000000000001',
    'a0000000000000000000000000000001',
    'fake_apns_token_traderpro_a1b2c3d4',
    'ios',
    1,
    '2024-02-01T08:05:00.000Z',
    '2025-02-01T10:30:00.000Z'
);

-- Device token for User 2: Jamie Chen
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt000000000000000000000000000002',
    'a0000000000000000000000000000002',
    'fake_apns_token_quantjamie_e5f6a7b8',
    'ios',
    1,
    '2024-02-15T12:05:00.000Z',
    '2025-01-20T14:15:00.000Z'
);

-- Device token for User 3: Sofia Rodriguez
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt000000000000000000000000000003',
    'a0000000000000000000000000000003',
    'fake_apns_token_sofiainvests_c9d0e1f2',
    'ios',
    1,
    '2024-03-01T09:35:00.000Z',
    '2025-02-05T16:45:00.000Z'
);

-- Device token for User 4: Marcus Johnson
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt000000000000000000000000000004',
    'a0000000000000000000000000000004',
    'fake_apns_token_marcusj_trades_a3b4c5d6',
    'ios',
    1,
    '2024-03-10T11:05:00.000Z',
    '2025-01-15T09:20:00.000Z'
);

-- Device token for User 5: Priya Sharma
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt000000000000000000000000000005',
    'a0000000000000000000000000000005',
    'fake_apns_token_priyafinance_e7f8a9b0',
    'ios',
    1,
    '2024-04-01T07:50:00.000Z',
    '2025-02-10T11:00:00.000Z'
);

-- Device token for User 6: Tyler Brooks
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt000000000000000000000000000006',
    'a0000000000000000000000000000006',
    'fake_apns_token_tylerb_c1d2e3f4',
    'ios',
    1,
    '2024-05-01T10:05:00.000Z',
    '2024-09-01T08:00:00.000Z'
);

-- Device token for User 7: Mei Lin
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt000000000000000000000000000007',
    'a0000000000000000000000000000007',
    'fake_apns_token_meilin_stocks_a5b6c7d8',
    'ios',
    1,
    '2024-05-15T14:35:00.000Z',
    '2025-01-10T17:00:00.000Z'
);

-- Device token for User 8: David Okafor
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt000000000000000000000000000008',
    'a0000000000000000000000000000008',
    'fake_apns_token_dave_trades_e9f0a1b2',
    'ios',
    1,
    '2024-06-01T09:05:00.000Z',
    '2024-12-15T13:30:00.000Z'
);

-- Device token for User 9: Emma Wilson
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt000000000000000000000000000009',
    'a0000000000000000000000000000009',
    'fake_apns_token_emmaw_c3d4e5f6',
    'ios',
    1,
    '2024-06-15T16:05:00.000Z',
    '2025-01-25T10:45:00.000Z'
);

-- Device token for User 10: Carlos Gutierrez
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt00000000000000000000000000000a',
    'a000000000000000000000000000000a',
    'fake_apns_token_carlosg_a7b8c9d0',
    'ios',
    1,
    '2024-07-01T08:35:00.000Z',
    '2024-11-20T15:00:00.000Z'
);

-- Device token for User 11: Aisha Patel
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt00000000000000000000000000000b',
    'a000000000000000000000000000000b',
    'fake_apns_token_aishap_e1f2a3b4',
    'ios',
    1,
    '2024-07-15T13:05:00.000Z',
    '2025-02-08T09:30:00.000Z'
);

-- Device token for User 12: Ryan Kim
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt00000000000000000000000000000c',
    'a000000000000000000000000000000c',
    'fake_apns_token_ryankim_c5d6e7f8',
    'ios',
    1,
    '2024-08-01T11:35:00.000Z',
    '2025-01-30T14:00:00.000Z'
);

-- Device token for User 13: Olivia Brown
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt00000000000000000000000000000d',
    'a000000000000000000000000000000d',
    'fake_apns_token_oliviab_a9b0c1d2',
    'ios',
    1,
    '2024-08-15T10:05:00.000Z',
    '2024-12-01T08:00:00.000Z'
);

-- Device token for User 14: Noah Garcia
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt00000000000000000000000000000e',
    'a000000000000000000000000000000e',
    'fake_apns_token_noahg_e3f4a5b6',
    'ios',
    1,
    '2024-09-01T15:05:00.000Z',
    '2024-12-10T12:00:00.000Z'
);

-- Device token for User 15: Zoe Thompson
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt00000000000000000000000000000f',
    'a000000000000000000000000000000f',
    'fake_apns_token_zoet_c7d8e9f0',
    'ios',
    1,
    '2024-09-15T09:50:00.000Z',
    '2025-01-05T11:30:00.000Z'
);

-- Device token for User 16: Liam Anderson
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt000000000000000000000000000010',
    'a0000000000000000000000000000010',
    'fake_apns_token_liama_a1b2c3d4',
    'ios',
    1,
    '2024-10-01T14:05:00.000Z',
    '2025-01-12T16:00:00.000Z'
);

-- Device token for User 17: Chloe Davis
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt000000000000000000000000000011',
    'a0000000000000000000000000000011',
    'fake_apns_token_chloed_e5f6a7b8',
    'ios',
    1,
    '2024-10-15T08:35:00.000Z',
    '2025-01-01T00:05:00.000Z'
);

-- Device token for User 18: Ethan Martinez
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt000000000000000000000000000012',
    'a0000000000000000000000000000012',
    'fake_apns_token_ethanm_c9d0e1f2',
    'ios',
    1,
    '2024-11-01T12:05:00.000Z',
    '2025-01-20T10:00:00.000Z'
);

-- Device token for User 19: Ava Jackson
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt000000000000000000000000000013',
    'a0000000000000000000000000000013',
    'fake_apns_token_avaj_a3b4c5d6',
    'ios',
    1,
    '2024-11-15T17:35:00.000Z',
    '2025-01-08T09:15:00.000Z'
);

-- Device token for User 20: Lucas White
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt000000000000000000000000000014',
    'a0000000000000000000000000000014',
    'fake_apns_token_lucasw_e7f8a9b0',
    'ios',
    1,
    '2024-12-01T10:20:00.000Z',
    '2025-01-28T13:45:00.000Z'
);

-- Device token for User 21: Harper Lee
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt000000000000000000000000000015',
    'a0000000000000000000000000000015',
    'fake_apns_token_harperl_c1d2e3f4',
    'ios',
    1,
    '2025-06-01T09:05:00.000Z',
    '2025-06-15T14:30:00.000Z'
);

-- Device token for User 22: Mason Clark
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt000000000000000000000000000016',
    'a0000000000000000000000000000016',
    'fake_apns_token_masonc_a5b6c7d8',
    'ios',
    1,
    '2025-09-01T11:05:00.000Z',
    '2025-09-10T16:00:00.000Z'
);

-- Device token for User 23: Ella Robinson
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt000000000000000000000000000017',
    'a0000000000000000000000000000017',
    'fake_apns_token_ellar_e9f0a1b2',
    'ios',
    1,
    '2025-07-15T08:50:00.000Z',
    '2025-08-01T10:00:00.000Z'
);

-- Device token for User 24: Jack Scott
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt000000000000000000000000000018',
    'a0000000000000000000000000000018',
    'fake_apns_token_jacks_c3d4e5f6',
    'ios',
    1,
    '2025-08-01T13:05:00.000Z',
    '2025-08-20T15:30:00.000Z'
);

-- Device token for User 25: Mia Torres
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt000000000000000000000000000019',
    'a0000000000000000000000000000019',
    'fake_apns_token_miat_a7b8c9d0',
    'ios',
    1,
    '2025-10-01T10:35:00.000Z',
    '2025-10-15T12:00:00.000Z'
);

-- Device token for User 26: Benjamin Hall
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt00000000000000000000000000001a',
    'a000000000000000000000000000001a',
    'fake_apns_token_benH_e1f2a3b4',
    'ios',
    1,
    '2024-04-15T10:05:00.000Z',
    '2024-11-01T09:00:00.000Z'
);

-- Device token for User 27: Isabella Adams (inactive)
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt00000000000000000000000000001b',
    'a000000000000000000000000000001b',
    'fake_apns_token_isabellaA_c5d6e7f8',
    'ios',
    0,
    '2024-05-01T11:35:00.000Z',
    '2025-08-01T08:00:00.000Z'
);

-- Device token for User 28: William Turner
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt00000000000000000000000000001c',
    'a000000000000000000000000000001c',
    'fake_apns_token_willt_a9b0c1d2',
    'ios',
    1,
    '2024-06-01T14:05:00.000Z',
    '2024-12-20T11:30:00.000Z'
);

-- Device token for User 29: Charlotte Wright
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt00000000000000000000000000001d',
    'a000000000000000000000000000001d',
    'fake_apns_token_charlottew_e3f4a5b6',
    'ios',
    1,
    '2024-07-01T09:20:00.000Z',
    '2025-01-05T16:45:00.000Z'
);

-- Device token for User 30: Daniel King (admin)
INSERT INTO device_tokens (id, user_id, token, platform, is_active, created_at, updated_at)
VALUES (
    'dt00000000000000000000000000001e',
    'a000000000000000000000000000001e',
    'fake_apns_token_danielk_c7d8e9f0',
    'ios',
    1,
    '2024-01-15T07:05:00.000Z',
    '2025-02-12T08:00:00.000Z'
);
```

---

## COMPLETION STATUS

- **Total Users**: 30/30
- **Total Device Tokens**: 30/30
- **ID Range**: `a0000000000000000000000000000001` through `a000000000000000000000000000001e`
- **DT ID Range**: `dt000000000000000000000000000001` through `dt00000000000000000000000000001e`

### Tier Breakdown
| Tier | Count | Users |
|------|-------|-------|
| premium | 6 | #1, #3, #5, #11, #25, #30 |
| pro | 8 | #2, #4, #6, #7, #9, #12, #17, #22 |
| free | 16 | #8, #10, #13-16, #18-21, #23-24, #26-29 |

### Special Flags
| Flag | User(s) |
|------|---------|
| role='admin' | #30 (danielk) |
| ban_reason set (resolved) | #26 (benH) |
| inactive device_token (is_active=0) | #27 (isabellaA) |
| phone_verified=1 | #1, #3, #5, #11, #30 |
| email_verified=1 | #1-7, #9, #11-12, #22, #25, #30 |
| paypal_email set | #1, #2, #3, #5, #11, #25 |

### Cross-Reference for Other Agents
Other agents should reference users by their hex IDs from the USER IDS TABLE above. Key users for cross-referencing:
- **Admin**: `a000000000000000000000000000001e` (danielk)
- **Power traders**: `a0000000000000000000000000000001` through `a0000000000000000000000000000005`
- **Active traders**: `a0000000000000000000000000000006` through `a000000000000000000000000000000c`
- **Casual users**: `a000000000000000000000000000000d` through `a0000000000000000000000000000014`
- **New users**: `a0000000000000000000000000000015` through `a0000000000000000000000000000019`
- **Edge cases**: `a000000000000000000000000000001a` through `a000000000000000000000000000001e`
