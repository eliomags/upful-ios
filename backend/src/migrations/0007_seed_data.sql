-- Migration 007: Seed Data (30 users, 2 years of activity)
-- Generated from agent output files
-- FK dependency order enforced

-- Table: users
-- User 1: Alex Morgan (@traderpro) - Premium power user
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a0000000000000000000000000000001',
    'alex@traderpro.com',
    'traderpro',
    'Alex Morgan',
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
-- User 6: Tyler Brooks (@tylerb) - Pro (upgraded from free 2024-09-01)
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a0000000000000000000000000000006',
    'tyler.b@gmail.com',
    'tylerb',
    'Tyler Brooks',
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
-- User 13: Olivia Brown (@oliviab) - Free
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a000000000000000000000000000000d',
    'olivia.b@gmail.com',
    'oliviab',
    'Olivia Brown',
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
-- User 21: Harper Lee (@harperl) - Free, joined 2025
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a0000000000000000000000000000015',
    'harper.l@gmail.com',
    'harperl',
    'Harper Lee',
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
-- User 26: Benjamin Hall (@benH) - Free, was banned (resolved)
INSERT INTO users (id, email, username, display_name, password_hash, apple_user_id, avatar_key, paypal_email, phone, phone_verified, email_verified, subscription_tier, subscription_expires_at, apple_original_transaction_id, role, is_banned, ban_reason, created_at, updated_at)
VALUES (
    'a000000000000000000000000000001a',
    'ben.h@gmail.com',
    'benH',
    'Benjamin Hall',
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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
    '$2a$10$gTZW1MnFAYdT4ilyuviW7ewV1jm3aB95db/s3dKsZe7ltu5byCCr.',
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

-- Table: device_tokens
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

-- Table: portfolios
-- ============================================================
-- Portfolios Seed Data for Upful/Jyanik Paper Trading App
-- Competition Month: 2026-02
-- All 30 users, 1 active portfolio each
-- ============================================================

INSERT INTO portfolios (id, user_id, cash_balance, total_equity, is_active, competition_month, created_at, updated_at) VALUES
  ('b00000000000000000000000000000101', 'a0000000000000000000000000000001', 18000.00, 45000.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T09:30:00Z'),
  ('b00000000000000000000000000000201', 'a0000000000000000000000000000002', 13300.00, 38000.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T09:30:00Z'),
  ('b00000000000000000000000000000301', 'a0000000000000000000000000000003', 16800.00, 42000.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T09:30:00Z'),
  ('b00000000000000000000000000000401', 'a0000000000000000000000000000004', 14200.00, 35500.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T09:30:00Z'),
  ('b00000000000000000000000000000501', 'a0000000000000000000000000000005', 18000.00, 40000.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T09:30:00Z'),
  ('b00000000000000000000000000000601', 'a0000000000000000000000000000006', 12800.00, 32000.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T10:15:00Z'),
  ('b00000000000000000000000000000701', 'a0000000000000000000000000000007', 11725.00, 33500.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T10:15:00Z'),
  ('b00000000000000000000000000000801', 'a0000000000000000000000000000008', 9800.00, 28000.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T10:15:00Z'),
  ('b00000000000000000000000000000901', 'a0000000000000000000000000000009', 13950.00, 31000.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T10:15:00Z'),
  ('b00000000000000000000000000000a01', 'a000000000000000000000000000000a', 11800.00, 29500.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T10:15:00Z'),
  ('b00000000000000000000000000000b01', 'a000000000000000000000000000000b', 14400.00, 36000.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T11:00:00Z'),
  ('b00000000000000000000000000000c01', 'a000000000000000000000000000000c', 10675.00, 30500.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T11:00:00Z'),
  ('b00000000000000000000000000000d01', 'a000000000000000000000000000000d', 13250.00, 26500.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T11:00:00Z'),
  ('b00000000000000000000000000000e01', 'a000000000000000000000000000000e', 10800.00, 27000.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T11:00:00Z'),
  ('b00000000000000000000000000000f01', 'a000000000000000000000000000000f', 13416.00, 25800.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T11:00:00Z'),
  ('b00000000000000000000000000001001', 'a0000000000000000000000000000010', 11528.00, 26200.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T11:30:00Z'),
  ('b00000000000000000000000000001101', 'a0000000000000000000000000000011', 11400.00, 28500.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T11:30:00Z'),
  ('b00000000000000000000000000001201', 'a0000000000000000000000000000012', 13475.00, 24500.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T11:30:00Z'),
  ('b00000000000000000000000000001301', 'a0000000000000000000000000000013', 10880.00, 27200.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T11:30:00Z'),
  ('b00000000000000000000000000001401', 'a0000000000000000000000000000014', 14740.00, 26800.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T11:30:00Z'),
  ('b00000000000000000000000000001501', 'a0000000000000000000000000000015', 13000.00, 26000.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T12:00:00Z'),
  ('b00000000000000000000000000001601', 'a0000000000000000000000000000016', 11600.00, 29000.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T12:00:00Z'),
  ('b00000000000000000000000000001701', 'a0000000000000000000000000000017', 15300.00, 25500.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T12:00:00Z'),
  ('b00000000000000000000000000001801', 'a0000000000000000000000000000018', 11835.00, 26300.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T12:00:00Z'),
  ('b00000000000000000000000000001901', 'a0000000000000000000000000000019', 11400.00, 28500.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T12:00:00Z'),
  ('b00000000000000000000000000001a01', 'a000000000000000000000000000001a', 12650.00, 23000.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T12:30:00Z'),
  ('b00000000000000000000000000001b01', 'a000000000000000000000000000001b', 12600.00, 25200.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T12:30:00Z'),
  ('b00000000000000000000000000001c01', 'a000000000000000000000000000001c', 10500.00, 21000.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T12:30:00Z'),
  ('b00000000000000000000000000001d01', 'a000000000000000000000000000001d', 15000.00, 25000.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T12:30:00Z'),
  ('b00000000000000000000000000001e01', 'a000000000000000000000000000001e', 12250.00, 35000.00, 1, '2026-02', '2026-02-01T00:00:00Z', '2026-02-12T12:30:00Z');

-- Table: positions
-- AAPL: 20 shares @ avg $235, current $245
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000001',
    'b00000000000000000000000000000101',
    'a0000000000000000000000000000001',
    'AAPL', 'stock', 20, 235.00, 245.00, 4900.00, 200.00,
    '2026-02-10T16:00:00.000Z'
);

-- NVDA: 30 shares @ avg $128, current $140
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000002',
    'b00000000000000000000000000000101',
    'a0000000000000000000000000000001',
    'NVDA', 'stock', 30, 128.00, 140.00, 4200.00, 360.00,
    '2026-02-10T16:00:00.000Z'
);

-- TSLA: 12 shares @ avg $390, current $420
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000003',
    'b00000000000000000000000000000101',
    'a0000000000000000000000000000001',
    'TSLA', 'stock', 12, 390.00, 420.00, 5040.00, 360.00,
    '2026-02-10T16:00:00.000Z'
);

-- META: 6 shares @ avg $620, current $650
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000004',
    'b00000000000000000000000000000101',
    'a0000000000000000000000000000001',
    'META', 'stock', 6, 620.00, 650.00, 3900.00, 180.00,
    '2026-02-10T16:00:00.000Z'
);

-- BTC: 0.05 @ avg $98000, current $105000
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000005',
    'b00000000000000000000000000000101',
    'a0000000000000000000000000000001',
    'BTC', 'crypto', 0.05, 98000.00, 105000.00, 5250.00, 350.00,
    '2026-02-10T16:00:00.000Z'
);

-- ETH: 0.8 @ avg $3500, current $3800
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000006',
    'b00000000000000000000000000000101',
    'a0000000000000000000000000000001',
    'ETH', 'crypto', 0.8, 3500.00, 3800.00, 3040.00, 240.00,
    '2026-02-10T16:00:00.000Z'
);

-- SOL: 14 @ avg $195, current $210
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000007',
    'b00000000000000000000000000000101',
    'a0000000000000000000000000000001',
    'SOL', 'crypto', 14, 195.00, 210.00, 2940.00, 210.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 1 total market_value: 4900+4200+5040+3900+5250+3040+2940 = $29,270
-- User 1 total unrealized_pnl: 200+360+360+180+350+240+210 = $1,900
-- MSFT: 10 shares @ avg $450, current $470
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000008',
    'b00000000000000000000000000000201',
    'a0000000000000000000000000000002',
    'MSFT', 'stock', 10, 450.00, 470.00, 4700.00, 200.00,
    '2026-02-10T15:45:00.000Z'
);

-- AMD: 25 shares @ avg $118, current $125
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000009',
    'b00000000000000000000000000000201',
    'a0000000000000000000000000000002',
    'AMD', 'stock', 25, 118.00, 125.00, 3125.00, 175.00,
    '2026-02-10T15:45:00.000Z'
);

-- BTC: 0.04 @ avg $95000, current $105000
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000000a',
    'b00000000000000000000000000000201',
    'a0000000000000000000000000000002',
    'BTC', 'crypto', 0.04, 95000.00, 105000.00, 4200.00, 400.00,
    '2026-02-10T15:45:00.000Z'
);

-- ETH: 1.2 @ avg $3400, current $3800
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000000b',
    'b00000000000000000000000000000201',
    'a0000000000000000000000000000002',
    'ETH', 'crypto', 1.2, 3400.00, 3800.00, 4560.00, 480.00,
    '2026-02-10T15:45:00.000Z'
);

-- SOL: 12 @ avg $185, current $210
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000000c',
    'b00000000000000000000000000000201',
    'a0000000000000000000000000000002',
    'SOL', 'crypto', 12, 185.00, 210.00, 2520.00, 300.00,
    '2026-02-10T15:45:00.000Z'
);

-- DOGE: 5000 @ avg $0.32, current $0.38
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000000d',
    'b00000000000000000000000000000201',
    'a0000000000000000000000000000002',
    'DOGE', 'crypto', 5000, 0.32, 0.38, 1900.00, 300.00,
    '2026-02-10T15:45:00.000Z'
);

-- SPY: 6 shares @ avg $590, current $610
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000000e',
    'b00000000000000000000000000000201',
    'a0000000000000000000000000000002',
    'SPY', 'etf', 6, 590.00, 610.00, 3660.00, 120.00,
    '2026-02-10T15:45:00.000Z'
);
-- User 2 total market_value: 4700+3125+4200+4560+2520+1900+3660 = $24,665
-- User 2 total unrealized_pnl: 200+175+400+480+300+300+120 = $1,975
-- NVDA: 40 shares @ avg $125, current $140
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000000f',
    'b00000000000000000000000000000301',
    'a0000000000000000000000000000003',
    'NVDA', 'stock', 40, 125.00, 140.00, 5600.00, 600.00,
    '2026-02-10T16:00:00.000Z'
);

-- AAPL: 18 shares @ avg $230, current $245
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000010',
    'b00000000000000000000000000000301',
    'a0000000000000000000000000000003',
    'AAPL', 'stock', 18, 230.00, 245.00, 4410.00, 270.00,
    '2026-02-10T16:00:00.000Z'
);

-- AMZN: 20 shares @ avg $215, current $230
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000011',
    'b00000000000000000000000000000301',
    'a0000000000000000000000000000003',
    'AMZN', 'stock', 20, 215.00, 230.00, 4600.00, 300.00,
    '2026-02-10T16:00:00.000Z'
);

-- GOOGL: 22 shares @ avg $180, current $195
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000012',
    'b00000000000000000000000000000301',
    'a0000000000000000000000000000003',
    'GOOGL', 'stock', 22, 180.00, 195.00, 4290.00, 330.00,
    '2026-02-10T16:00:00.000Z'
);

-- META: 6 shares @ avg $610, current $650
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000013',
    'b00000000000000000000000000000301',
    'a0000000000000000000000000000003',
    'META', 'stock', 6, 610.00, 650.00, 3900.00, 240.00,
    '2026-02-10T16:00:00.000Z'
);

-- NFLX: 5 shares @ avg $870, current $950
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000014',
    'b00000000000000000000000000000301',
    'a0000000000000000000000000000003',
    'NFLX', 'stock', 5, 870.00, 950.00, 4750.00, 400.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 3 total market_value: 5600+4410+4600+4290+3900+4750 = $27,550
-- User 3 total unrealized_pnl: 600+270+300+330+240+400 = $2,140
-- SPY: 12 shares @ avg $595, current $610
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000015',
    'b00000000000000000000000000000401',
    'a0000000000000000000000000000004',
    'SPY', 'etf', 12, 595.00, 610.00, 7320.00, 180.00,
    '2026-02-10T16:00:00.000Z'
);

-- QQQ: 8 shares @ avg $520, current $540
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000016',
    'b00000000000000000000000000000401',
    'a0000000000000000000000000000004',
    'QQQ', 'etf', 8, 520.00, 540.00, 4320.00, 160.00,
    '2026-02-10T16:00:00.000Z'
);

-- VOO: 6 shares @ avg $545, current $560
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000017',
    'b00000000000000000000000000000401',
    'a0000000000000000000000000000004',
    'VOO', 'etf', 6, 545.00, 560.00, 3360.00, 90.00,
    '2026-02-10T16:00:00.000Z'
);

-- VTI: 12 shares @ avg $280, current $290
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000018',
    'b00000000000000000000000000000401',
    'a0000000000000000000000000000004',
    'VTI', 'etf', 12, 280.00, 290.00, 3480.00, 120.00,
    '2026-02-10T16:00:00.000Z'
);

-- IWM: 15 shares @ avg $225, current $232
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000019',
    'b00000000000000000000000000000401',
    'a0000000000000000000000000000004',
    'IWM', 'etf', 15, 225.00, 232.00, 3480.00, 105.00,
    '2026-02-10T16:00:00.000Z'
);

-- XLF: 30 shares @ avg $42, current $46
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000001a',
    'b00000000000000000000000000000401',
    'a0000000000000000000000000000004',
    'XLF', 'etf', 30, 42.00, 46.00, 1380.00, 120.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 4 total market_value: 7320+4320+3360+3480+3480+1380 = $23,340
-- User 4 total unrealized_pnl: 180+160+90+120+105+120 = $775
-- AAPL: 22 shares @ avg $228, current $245
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000001b',
    'b00000000000000000000000000000501',
    'a0000000000000000000000000000005',
    'AAPL', 'stock', 22, 228.00, 245.00, 5390.00, 374.00,
    '2026-02-10T16:00:00.000Z'
);

-- MSFT: 8 shares @ avg $440, current $470
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000001c',
    'b00000000000000000000000000000501',
    'a0000000000000000000000000000005',
    'MSFT', 'stock', 8, 440.00, 470.00, 3760.00, 240.00,
    '2026-02-10T16:00:00.000Z'
);

-- JNJ: 25 shares @ avg $155, current $162
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000001d',
    'b00000000000000000000000000000501',
    'a0000000000000000000000000000005',
    'JNJ', 'stock', 25, 155.00, 162.00, 4050.00, 175.00,
    '2026-02-10T16:00:00.000Z'
);

-- PG: 22 shares @ avg $168, current $175
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000001e',
    'b00000000000000000000000000000501',
    'a0000000000000000000000000000005',
    'PG', 'stock', 22, 168.00, 175.00, 3850.00, 154.00,
    '2026-02-10T16:00:00.000Z'
);

-- KO: 50 shares @ avg $58, current $62
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000001f',
    'b00000000000000000000000000000501',
    'a0000000000000000000000000000005',
    'KO', 'stock', 50, 58.00, 62.00, 3100.00, 200.00,
    '2026-02-10T16:00:00.000Z'
);

-- BRK.B: 10 shares @ avg $455, current $490
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000020',
    'b00000000000000000000000000000501',
    'a0000000000000000000000000000005',
    'BRK.B', 'stock', 10, 455.00, 490.00, 4900.00, 350.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 5 total market_value: 5390+3760+4050+3850+3100+4900 = $25,050
-- User 5 total unrealized_pnl: 374+240+175+154+200+350 = $1,493
-- TSLA: 18 shares @ avg $380, current $420
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000021',
    'b00000000000000000000000000000601',
    'a0000000000000000000000000000006',
    'TSLA', 'stock', 18, 380.00, 420.00, 7560.00, 720.00,
    '2026-02-10T16:00:00.000Z'
);

-- AMD: 40 shares @ avg $110, current $125
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000022',
    'b00000000000000000000000000000601',
    'a0000000000000000000000000000006',
    'AMD', 'stock', 40, 110.00, 125.00, 5000.00, 600.00,
    '2026-02-10T16:00:00.000Z'
);

-- NVDA: 30 shares @ avg $132, current $140
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000023',
    'b00000000000000000000000000000601',
    'a0000000000000000000000000000006',
    'NVDA', 'stock', 30, 132.00, 140.00, 4200.00, 240.00,
    '2026-02-10T16:00:00.000Z'
);

-- SOFI: 300 shares @ avg $12.50, current $14.20
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000024',
    'b00000000000000000000000000000601',
    'a0000000000000000000000000000006',
    'SOFI', 'stock', 300, 12.50, 14.20, 4260.00, 510.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 6 total market_value: 7560+5000+4200+4260 = $21,020
-- User 6 total unrealized_pnl: 720+600+240+510 = $2,070
-- AAPL: 15 shares @ avg $238, current $245
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000025',
    'b00000000000000000000000000000701',
    'a0000000000000000000000000000007',
    'AAPL', 'stock', 15, 238.00, 245.00, 3675.00, 105.00,
    '2026-02-10T16:00:00.000Z'
);

-- MSFT: 10 shares @ avg $455, current $470
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000026',
    'b00000000000000000000000000000701',
    'a0000000000000000000000000000007',
    'MSFT', 'stock', 10, 455.00, 470.00, 4700.00, 150.00,
    '2026-02-10T16:00:00.000Z'
);

-- GOOGL: 20 shares @ avg $188, current $195
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000027',
    'b00000000000000000000000000000701',
    'a0000000000000000000000000000007',
    'GOOGL', 'stock', 20, 188.00, 195.00, 3900.00, 140.00,
    '2026-02-10T16:00:00.000Z'
);

-- NVDA: 35 shares @ avg $130, current $140
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000028',
    'b00000000000000000000000000000701',
    'a0000000000000000000000000000007',
    'NVDA', 'stock', 35, 130.00, 140.00, 4900.00, 350.00,
    '2026-02-10T16:00:00.000Z'
);

-- CRM: 15 shares @ avg $295, current $310
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000029',
    'b00000000000000000000000000000701',
    'a0000000000000000000000000000007',
    'CRM', 'stock', 15, 295.00, 310.00, 4650.00, 225.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 7 total market_value: 3675+4700+3900+4900+4650 = $21,825
-- User 7 total unrealized_pnl: 105+150+140+350+225 = $970
-- BTC: 0.08 @ avg $92000, current $105000
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000002a',
    'b00000000000000000000000000000801',
    'a0000000000000000000000000000008',
    'BTC', 'crypto', 0.08, 92000.00, 105000.00, 8400.00, 1040.00,
    '2026-02-10T16:00:00.000Z'
);

-- ETH: 1.0 @ avg $3600, current $3800
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000002b',
    'b00000000000000000000000000000801',
    'a0000000000000000000000000000008',
    'ETH', 'crypto', 1.0, 3600.00, 3800.00, 3800.00, 200.00,
    '2026-02-10T16:00:00.000Z'
);

-- SOL: 15 @ avg $190, current $210
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000002c',
    'b00000000000000000000000000000801',
    'a0000000000000000000000000000008',
    'SOL', 'crypto', 15, 190.00, 210.00, 3150.00, 300.00,
    '2026-02-10T16:00:00.000Z'
);

-- DOGE: 4000 @ avg $0.30, current $0.38
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000002d',
    'b00000000000000000000000000000801',
    'a0000000000000000000000000000008',
    'DOGE', 'crypto', 4000, 0.30, 0.38, 1520.00, 320.00,
    '2026-02-10T16:00:00.000Z'
);

-- ADA: 1200 @ avg $0.95, current $1.10
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000002e',
    'b00000000000000000000000000000801',
    'a0000000000000000000000000000008',
    'ADA', 'crypto', 1200, 0.95, 1.10, 1320.00, 180.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 8 total market_value: 8400+3800+3150+1520+1320 = $18,190
-- User 8 total unrealized_pnl: 1040+200+300+320+180 = $2,040
-- KO: 60 shares @ avg $59, current $62
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000002f',
    'b00000000000000000000000000000901',
    'a0000000000000000000000000000009',
    'KO', 'stock', 60, 59.00, 62.00, 3720.00, 180.00,
    '2026-02-10T16:00:00.000Z'
);

-- PEP: 22 shares @ avg $172, current $180
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000030',
    'b00000000000000000000000000000901',
    'a0000000000000000000000000000009',
    'PEP', 'stock', 22, 172.00, 180.00, 3960.00, 176.00,
    '2026-02-10T16:00:00.000Z'
);

-- JNJ: 25 shares @ avg $158, current $162
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000031',
    'b00000000000000000000000000000901',
    'a0000000000000000000000000000009',
    'JNJ', 'stock', 25, 158.00, 162.00, 4050.00, 100.00,
    '2026-02-10T16:00:00.000Z'
);

-- T: 200 shares @ avg $19.50, current $22.00
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000032',
    'b00000000000000000000000000000901',
    'a0000000000000000000000000000009',
    'T', 'stock', 200, 19.50, 22.00, 4400.00, 500.00,
    '2026-02-10T16:00:00.000Z'
);

-- VZ: 100 shares @ avg $38, current $41
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000033',
    'b00000000000000000000000000000901',
    'a0000000000000000000000000000009',
    'VZ', 'stock', 100, 38.00, 41.00, 4100.00, 300.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 9 total market_value: 3720+3960+4050+4400+4100 = $20,230
-- User 9 total unrealized_pnl: 180+176+100+500+300 = $1,256
-- GME: 150 shares @ avg $28, current $32
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000034',
    'b00000000000000000000000000000a01',
    'a000000000000000000000000000000a',
    'GME', 'stock', 150, 28.00, 32.00, 4800.00, 600.00,
    '2026-02-10T16:00:00.000Z'
);

-- AMC: 400 shares @ avg $8.50, current $11.20
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000035',
    'b00000000000000000000000000000a01',
    'a000000000000000000000000000000a',
    'AMC', 'stock', 400, 8.50, 11.20, 4480.00, 1080.00,
    '2026-02-10T16:00:00.000Z'
);

-- BBBY: 500 shares @ avg $5.20, current $6.80
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000036',
    'b00000000000000000000000000000a01',
    'a000000000000000000000000000000a',
    'BBBY', 'stock', 500, 5.20, 6.80, 3400.00, 800.00,
    '2026-02-10T16:00:00.000Z'
);

-- PLTR: 250 shares @ avg $22, current $26
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000037',
    'b00000000000000000000000000000a01',
    'a000000000000000000000000000000a',
    'PLTR', 'stock', 250, 22.00, 26.00, 6500.00, 1000.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 10 total market_value: 4800+4480+3400+6500 = $19,180
-- User 10 total unrealized_pnl: 600+1080+800+1000 = $3,480
-- AAPL: 16 shares @ avg $232, current $245
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000038',
    'b00000000000000000000000000000b01',
    'a000000000000000000000000000000b',
    'AAPL', 'stock', 16, 232.00, 245.00, 3920.00, 208.00,
    '2026-02-10T16:00:00.000Z'
);

-- VOO: 10 shares @ avg $540, current $560
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000039',
    'b00000000000000000000000000000b01',
    'a000000000000000000000000000000b',
    'VOO', 'etf', 10, 540.00, 560.00, 5600.00, 200.00,
    '2026-02-10T16:00:00.000Z'
);

-- BTC: 0.05 @ avg $96000, current $105000
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000003a',
    'b00000000000000000000000000000b01',
    'a000000000000000000000000000000b',
    'BTC', 'crypto', 0.05, 96000.00, 105000.00, 5250.00, 450.00,
    '2026-02-10T16:00:00.000Z'
);

-- GLD: 20 shares @ avg $230, current $248
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000003b',
    'b00000000000000000000000000000b01',
    'a000000000000000000000000000000b',
    'GLD', 'etf', 20, 230.00, 248.00, 4960.00, 360.00,
    '2026-02-10T16:00:00.000Z'
);

-- MSFT: 8 shares @ avg $448, current $470
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000003c',
    'b00000000000000000000000000000b01',
    'a000000000000000000000000000000b',
    'MSFT', 'stock', 8, 448.00, 470.00, 3760.00, 176.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 11 total market_value: 3920+5600+5250+4960+3760 = $23,490
-- User 11 total unrealized_pnl: 208+200+450+360+176 = $1,394
-- SPY: 10 shares @ avg $598, current $610
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000003d',
    'b00000000000000000000000000000c01',
    'a000000000000000000000000000000c',
    'SPY', 'etf', 10, 598.00, 610.00, 6100.00, 120.00,
    '2026-02-10T16:00:00.000Z'
);

-- QQQ: 8 shares @ avg $525, current $540
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000003e',
    'b00000000000000000000000000000c01',
    'a000000000000000000000000000000c',
    'QQQ', 'etf', 8, 525.00, 540.00, 4320.00, 120.00,
    '2026-02-10T16:00:00.000Z'
);

-- AAPL: 16 shares @ avg $240, current $245
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000003f',
    'b00000000000000000000000000000c01',
    'a000000000000000000000000000000c',
    'AAPL', 'stock', 16, 240.00, 245.00, 3920.00, 80.00,
    '2026-02-10T16:00:00.000Z'
);

-- NVDA: 40 shares @ avg $134, current $140
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000040',
    'b00000000000000000000000000000c01',
    'a000000000000000000000000000000c',
    'NVDA', 'stock', 40, 134.00, 140.00, 5600.00, 240.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 12 total market_value: 6100+4320+3920+5600 = $19,940
-- User 12 total unrealized_pnl: 120+120+80+240 = $560
-- AAPL: 15 shares @ avg $240, current $245
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000041',
    'b00000000000000000000000000000d01',
    'a000000000000000000000000000000d',
    'AAPL', 'stock', 15, 240.00, 245.00, 3675.00, 75.00,
    '2026-02-07T16:00:00.000Z'
);

-- MSFT: 10 shares @ avg $462, current $470
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000042',
    'b00000000000000000000000000000d01',
    'a000000000000000000000000000000d',
    'MSFT', 'stock', 10, 462.00, 470.00, 4700.00, 80.00,
    '2026-02-07T16:00:00.000Z'
);
-- User 13 total market_value: 3675+4700 = $8,375
-- User 13 total unrealized_pnl: 75+80 = $155
-- VOO: 8 shares @ avg $548, current $560
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000043',
    'b00000000000000000000000000000e01',
    'a000000000000000000000000000000e',
    'VOO', 'etf', 8, 548.00, 560.00, 4480.00, 96.00,
    '2026-02-05T16:00:00.000Z'
);

-- QQQ: 7 shares @ avg $530, current $540
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000044',
    'b00000000000000000000000000000e01',
    'a000000000000000000000000000000e',
    'QQQ', 'etf', 7, 530.00, 540.00, 3780.00, 70.00,
    '2026-02-05T16:00:00.000Z'
);
-- User 14 total market_value: 4480+3780 = $8,260
-- User 14 total unrealized_pnl: 96+70 = $166
-- AAPL: 26 shares @ avg $242, current $245
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000045',
    'b00000000000000000000000000000f01',
    'a000000000000000000000000000000f',
    'AAPL', 'stock', 26, 242.00, 245.00, 6370.00, 78.00,
    '2026-01-28T16:00:00.000Z'
);
-- User 15 total market_value: $6,370
-- User 15 total unrealized_pnl: $78
-- SPY: 4 shares @ avg $600, current $610
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000046',
    'b00000000000000000000000000001001',
    'a0000000000000000000000000000010',
    'SPY', 'etf', 4, 600.00, 610.00, 2440.00, 40.00,
    '2026-02-03T16:00:00.000Z'
);

-- MSFT: 6 shares @ avg $465, current $470
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000047',
    'b00000000000000000000000000001001',
    'a0000000000000000000000000000010',
    'MSFT', 'stock', 6, 465.00, 470.00, 2820.00, 30.00,
    '2026-02-03T16:00:00.000Z'
);
-- User 16 total market_value: 2440+2820 = $5,260
-- User 16 total unrealized_pnl: 40+30 = $70
-- NVDA: 35 shares @ avg $132, current $140
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000048',
    'b00000000000000000000000000001101',
    'a0000000000000000000000000000011',
    'NVDA', 'stock', 35, 132.00, 140.00, 4900.00, 280.00,
    '2026-02-10T16:00:00.000Z'
);

-- TSLA: 12 shares @ avg $400, current $420
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000049',
    'b00000000000000000000000000001101',
    'a0000000000000000000000000000011',
    'TSLA', 'stock', 12, 400.00, 420.00, 5040.00, 240.00,
    '2026-02-10T16:00:00.000Z'
);

-- META: 8 shares @ avg $630, current $650
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000004a',
    'b00000000000000000000000000001101',
    'a0000000000000000000000000000011',
    'META', 'stock', 8, 630.00, 650.00, 5200.00, 160.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 17 total market_value: 4900+5040+5200 = $15,140
-- User 17 total unrealized_pnl: 280+240+160 = $680
-- BTC: 0.04 @ avg $99000, current $105000
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000004b',
    'b00000000000000000000000000001201',
    'a0000000000000000000000000000012',
    'BTC', 'crypto', 0.04, 99000.00, 105000.00, 4200.00, 240.00,
    '2026-02-10T16:00:00.000Z'
);

-- ETH: 0.6 @ avg $3650, current $3800
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000004c',
    'b00000000000000000000000000001201',
    'a0000000000000000000000000000012',
    'ETH', 'crypto', 0.6, 3650.00, 3800.00, 2280.00, 90.00,
    '2026-02-10T16:00:00.000Z'
);

-- SOL: 10 @ avg $200, current $210
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000004d',
    'b00000000000000000000000000001201',
    'a0000000000000000000000000000012',
    'SOL', 'crypto', 10, 200.00, 210.00, 2100.00, 100.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 18 total market_value: 4200+2280+2100 = $8,580
-- User 18 total unrealized_pnl: 240+90+100 = $430
-- AAPL: 12 shares @ avg $238, current $245
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000004e',
    'b00000000000000000000000000001301',
    'a0000000000000000000000000000013',
    'AAPL', 'stock', 12, 238.00, 245.00, 2940.00, 84.00,
    '2026-02-06T16:00:00.000Z'
);

-- MSFT: 5 shares @ avg $460, current $470
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000004f',
    'b00000000000000000000000000001301',
    'a0000000000000000000000000000013',
    'MSFT', 'stock', 5, 460.00, 470.00, 2350.00, 50.00,
    '2026-02-06T16:00:00.000Z'
);

-- JNJ: 18 shares @ avg $157, current $162
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000050',
    'b00000000000000000000000000001301',
    'a0000000000000000000000000000013',
    'JNJ', 'stock', 18, 157.00, 162.00, 2916.00, 90.00,
    '2026-02-06T16:00:00.000Z'
);
-- User 19 total market_value: 2940+2350+2916 = $8,206
-- User 19 total unrealized_pnl: 84+50+90 = $224
-- VOO: 5 shares @ avg $550, current $560
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000051',
    'b00000000000000000000000000001401',
    'a0000000000000000000000000000014',
    'VOO', 'etf', 5, 550.00, 560.00, 2800.00, 50.00,
    '2026-02-04T16:00:00.000Z'
);

-- VTI: 10 shares @ avg $284, current $290
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000052',
    'b00000000000000000000000000001401',
    'a0000000000000000000000000000014',
    'VTI', 'etf', 10, 284.00, 290.00, 2900.00, 60.00,
    '2026-02-04T16:00:00.000Z'
);

-- QQQ: 4 shares @ avg $532, current $540
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000053',
    'b00000000000000000000000000001401',
    'a0000000000000000000000000000014',
    'QQQ', 'etf', 4, 532.00, 540.00, 2160.00, 32.00,
    '2026-02-04T16:00:00.000Z'
);
-- User 20 total market_value: 2800+2900+2160 = $7,860
-- User 20 total unrealized_pnl: 50+60+32 = $142
-- AAPL: 14 shares @ avg $241, current $245
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000054',
    'b00000000000000000000000000001501',
    'a0000000000000000000000000000015',
    'AAPL', 'stock', 14, 241.00, 245.00, 3430.00, 56.00,
    '2026-02-08T16:00:00.000Z'
);

-- NVDA: 30 shares @ avg $136, current $140
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000055',
    'b00000000000000000000000000001501',
    'a0000000000000000000000000000015',
    'NVDA', 'stock', 30, 136.00, 140.00, 4200.00, 120.00,
    '2026-02-08T16:00:00.000Z'
);
-- User 21 total market_value: 3430+4200 = $7,630
-- User 21 total unrealized_pnl: 56+120 = $176
-- NVDA: 25 shares @ avg $135, current $140
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000056',
    'b00000000000000000000000000001601',
    'a0000000000000000000000000000016',
    'NVDA', 'stock', 25, 135.00, 140.00, 3500.00, 125.00,
    '2026-02-10T16:00:00.000Z'
);

-- AMD: 30 shares @ avg $120, current $125
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000057',
    'b00000000000000000000000000001601',
    'a0000000000000000000000000000016',
    'AMD', 'stock', 30, 120.00, 125.00, 3750.00, 150.00,
    '2026-02-10T16:00:00.000Z'
);

-- TSLA: 8 shares @ avg $405, current $420
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000058',
    'b00000000000000000000000000001601',
    'a0000000000000000000000000000016',
    'TSLA', 'stock', 8, 405.00, 420.00, 3360.00, 120.00,
    '2026-02-10T16:00:00.000Z'
);

-- BTC: 0.03 @ avg $100000, current $105000
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000059',
    'b00000000000000000000000000001601',
    'a0000000000000000000000000000016',
    'BTC', 'crypto', 0.03, 100000.00, 105000.00, 3150.00, 150.00,
    '2026-02-10T16:00:00.000Z'
);

-- META: 5 shares @ avg $635, current $650
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000005a',
    'b00000000000000000000000000001601',
    'a0000000000000000000000000000016',
    'META', 'stock', 5, 635.00, 650.00, 3250.00, 75.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 22 total market_value: 3500+3750+3360+3150+3250 = $17,010
-- User 22 total unrealized_pnl: 125+150+120+150+75 = $620
-- VOO: 9 shares @ avg $552, current $560
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000005b',
    'b00000000000000000000000000001701',
    'a0000000000000000000000000000017',
    'VOO', 'etf', 9, 552.00, 560.00, 5040.00, 72.00,
    '2026-01-20T16:00:00.000Z'
);
-- User 23 total market_value: $5,040
-- User 23 total unrealized_pnl: $72
-- AAPL: 10 shares @ avg $243, current $245
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000005c',
    'b00000000000000000000000000001801',
    'a0000000000000000000000000000018',
    'AAPL', 'stock', 10, 243.00, 245.00, 2450.00, 20.00,
    '2026-02-01T16:00:00.000Z'
);

-- SPY: 7 shares @ avg $605, current $610
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000005d',
    'b00000000000000000000000000001801',
    'a0000000000000000000000000000018',
    'SPY', 'etf', 7, 605.00, 610.00, 4270.00, 35.00,
    '2026-02-01T16:00:00.000Z'
);
-- User 24 total market_value: 2450+4270 = $6,720
-- User 24 total unrealized_pnl: 20+35 = $55
-- AAPL: 14 shares @ avg $238, current $245
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000005e',
    'b00000000000000000000000000001901',
    'a0000000000000000000000000000019',
    'AAPL', 'stock', 14, 238.00, 245.00, 3430.00, 98.00,
    '2026-02-10T16:00:00.000Z'
);

-- NVDA: 20 shares @ avg $133, current $140
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000005f',
    'b00000000000000000000000000001901',
    'a0000000000000000000000000000019',
    'NVDA', 'stock', 20, 133.00, 140.00, 2800.00, 140.00,
    '2026-02-10T16:00:00.000Z'
);

-- BTC: 0.04 @ avg $97000, current $105000
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000060',
    'b00000000000000000000000000001901',
    'a0000000000000000000000000000019',
    'BTC', 'crypto', 0.04, 97000.00, 105000.00, 4200.00, 320.00,
    '2026-02-10T16:00:00.000Z'
);

-- TSLA: 6 shares @ avg $408, current $420
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000061',
    'b00000000000000000000000000001901',
    'a0000000000000000000000000000019',
    'TSLA', 'stock', 6, 408.00, 420.00, 2520.00, 72.00,
    '2026-02-10T16:00:00.000Z'
);

-- AMZN: 15 shares @ avg $222, current $230
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000062',
    'b00000000000000000000000000001901',
    'a0000000000000000000000000000019',
    'AMZN', 'stock', 15, 222.00, 230.00, 3450.00, 120.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 25 total market_value: 3430+2800+4200+2520+3450 = $16,400
-- User 25 total unrealized_pnl: 98+140+320+72+120 = $750
-- AAPL: 12 shares @ avg $240, current $245
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000063',
    'b00000000000000000000000000001a01',
    'a000000000000000000000000000001a',
    'AAPL', 'stock', 12, 240.00, 245.00, 2940.00, 60.00,
    '2026-01-15T16:00:00.000Z'
);

-- SPY: 7 shares @ avg $595, current $610
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000064',
    'b00000000000000000000000000001a01',
    'a000000000000000000000000000001a',
    'SPY', 'etf', 7, 595.00, 610.00, 4270.00, 105.00,
    '2026-01-15T16:00:00.000Z'
);
-- User 26 total market_value: 2940+4270 = $7,210
-- User 26 total unrealized_pnl: 60+105 = $165
-- MSFT: 5 shares @ avg $480, current $470 (underwater — bought at high)
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000065',
    'b00000000000000000000000000001b01',
    'a000000000000000000000000000001b',
    'MSFT', 'stock', 5, 480.00, 470.00, 2350.00, -50.00,
    '2025-09-15T16:00:00.000Z'
);
-- User 27 total market_value: $2,350
-- User 27 total unrealized_pnl: -$50
-- Note: updated_at is Sept 2025 — stale/inactive position
-- COIN: 30 shares @ avg $280, current $215
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000066',
    'b00000000000000000000000000001c01',
    'a000000000000000000000000000001c',
    'COIN', 'stock', 30, 280.00, 215.00, 6450.00, -1950.00,
    '2026-02-10T16:00:00.000Z'
);

-- RIVN: 100 shares @ avg $18.00, current $12.50
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000067',
    'b00000000000000000000000000001c01',
    'a000000000000000000000000000001c',
    'RIVN', 'stock', 100, 18.00, 12.50, 1250.00, -550.00,
    '2026-02-10T16:00:00.000Z'
);

-- LCID: 200 shares @ avg $5.50, current $3.20
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000068',
    'b00000000000000000000000000001c01',
    'a000000000000000000000000000001c',
    'LCID', 'stock', 200, 5.50, 3.20, 640.00, -460.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 28 total market_value: 6450+1250+640 = $8,340
-- User 28 total unrealized_pnl: -1950+(-550)+(-460) = -$2,960
-- Note: Heavy losses — this user has negative PnL profile
-- No positions — User 29 just did a monthly reset and starts fresh with $25,000 cash
-- Portfolio has 0 positions, total_equity = cash_balance = $25,000
-- AAPL: 18 shares @ avg $230, current $245
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c0000000000000000000000000000069',
    'b00000000000000000000000000001e01',
    'a000000000000000000000000000001e',
    'AAPL', 'stock', 18, 230.00, 245.00, 4410.00, 270.00,
    '2026-02-10T16:00:00.000Z'
);

-- MSFT: 8 shares @ avg $452, current $470
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000006a',
    'b00000000000000000000000000001e01',
    'a000000000000000000000000000001e',
    'MSFT', 'stock', 8, 452.00, 470.00, 3760.00, 144.00,
    '2026-02-10T16:00:00.000Z'
);

-- GOOGL: 20 shares @ avg $185, current $195
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000006b',
    'b00000000000000000000000000001e01',
    'a000000000000000000000000000001e',
    'GOOGL', 'stock', 20, 185.00, 195.00, 3900.00, 200.00,
    '2026-02-10T16:00:00.000Z'
);

-- BTC: 0.05 @ avg $94000, current $105000
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000006c',
    'b00000000000000000000000000001e01',
    'a000000000000000000000000000001e',
    'BTC', 'crypto', 0.05, 94000.00, 105000.00, 5250.00, 550.00,
    '2026-02-10T16:00:00.000Z'
);

-- SPY: 10 shares @ avg $592, current $610
INSERT INTO positions (id, portfolio_id, user_id, ticker, asset_type, quantity, average_cost, current_price, market_value, unrealized_pnl, updated_at)
VALUES (
    'c000000000000000000000000000006d',
    'b00000000000000000000000000001e01',
    'a000000000000000000000000000001e',
    'SPY', 'etf', 10, 592.00, 610.00, 6100.00, 180.00,
    '2026-02-10T16:00:00.000Z'
);
-- User 30 total market_value: 4410+3760+3900+5250+6100 = $23,420
-- User 30 total unrealized_pnl: 270+144+200+550+180 = $1,344

-- Table: trades
-- =============================================
-- TRADES SEED DATA
-- Trade ID format: d0 + 28 zeros + 3-digit hex
-- ~700 trades across 30 users (representative)
-- =============================================

-- =============================================
-- USER 1: alexj (Day trader, ~80 trades) — representative 20
-- =============================================
INSERT INTO trades VALUES ('d0000000000000000000000000000001','b00000000000000000000000000000101','a0000000000000000000000000000001','AAPL','stock','buy',100,185.50,18550.00,'market','filled','2024-02-15T10:30:00.000Z','2024-02-15T10:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000002','b00000000000000000000000000000101','a0000000000000000000000000000001','NVDA','stock','buy',80,680.00,54400.00,'market','filled','2024-02-20T14:15:00.000Z','2024-02-20T14:15:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000003','b00000000000000000000000000000101','a0000000000000000000000000000001','BTC','crypto','buy',0.5,52000.00,26000.00,'market','filled','2024-03-05T09:00:00.000Z','2024-03-05T09:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000004','b00000000000000000000000000000101','a0000000000000000000000000000001','MSFT','stock','buy',60,410.00,24600.00,'market','filled','2024-03-18T11:45:00.000Z','2024-03-18T11:45:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000005','b00000000000000000000000000000101','a0000000000000000000000000000001','AAPL','stock','sell',50,192.00,9600.00,'market','filled','2024-04-10T15:20:00.000Z','2024-04-10T15:20:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000006','b00000000000000000000000000000101','a0000000000000000000000000000001','ETH','crypto','buy',5,3200.00,16000.00,'market','filled','2024-04-22T08:30:00.000Z','2024-04-22T08:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000007','b00000000000000000000000000000101','a0000000000000000000000000000001','TSLA','stock','buy',40,175.00,7000.00,'market','filled','2024-05-15T13:00:00.000Z','2024-05-15T13:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000008','b00000000000000000000000000000101','a0000000000000000000000000000001','NVDA','stock','sell',40,950.00,38000.00,'market','filled','2024-06-20T10:10:00.000Z','2024-06-20T10:10:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000009','b00000000000000000000000000000101','a0000000000000000000000000000001','AMD','stock','buy',120,155.00,18600.00,'market','filled','2024-07-08T09:45:00.000Z','2024-07-08T09:45:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000000a','b00000000000000000000000000000101','a0000000000000000000000000000001','SPY','etf','buy',50,540.00,27000.00,'market','filled','2024-08-12T11:30:00.000Z','2024-08-12T11:30:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000000b','b00000000000000000000000000000101','a0000000000000000000000000000001','BTC','crypto','sell',0.25,62000.00,15500.00,'market','filled','2024-09-05T14:00:00.000Z','2024-09-05T14:00:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000000c','b00000000000000000000000000000101','a0000000000000000000000000000001','GOOGL','stock','buy',70,165.00,11550.00,'market','filled','2024-10-01T10:20:00.000Z','2024-10-01T10:20:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000000d','b00000000000000000000000000000101','a0000000000000000000000000000001','META','stock','buy',45,570.00,25650.00,'market','filled','2024-11-15T09:30:00.000Z','2024-11-15T09:30:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000000e','b00000000000000000000000000000101','a0000000000000000000000000000001','TSLA','stock','sell',40,245.00,9800.00,'market','filled','2024-12-10T15:00:00.000Z','2024-12-10T15:00:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000000f','b00000000000000000000000000000101','a0000000000000000000000000000001','SOL','crypto','buy',200,110.00,22000.00,'market','filled','2025-01-08T08:15:00.000Z','2025-01-08T08:15:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000010','b00000000000000000000000000000101','a0000000000000000000000000000001','AMZN','stock','buy',55,225.00,12375.00,'market','filled','2025-03-20T10:00:00.000Z','2025-03-20T10:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000011','b00000000000000000000000000000101','a0000000000000000000000000000001','AAPL','stock','sell',50,240.00,12000.00,'market','filled','2025-05-14T14:30:00.000Z','2025-05-14T14:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000012','b00000000000000000000000000000101','a0000000000000000000000000000001','NVDA','stock','buy',30,1350.00,40500.00,'market','filled','2025-08-22T11:00:00.000Z','2025-08-22T11:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000013','b00000000000000000000000000000101','a0000000000000000000000000000001','ETH','crypto','sell',3,4100.00,12300.00,'market','filled','2025-11-05T09:45:00.000Z','2025-11-05T09:45:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000014','b00000000000000000000000000000101','a0000000000000000000000000000001','QQQ','etf','buy',40,560.00,22400.00,'market','filled','2026-01-15T10:30:00.000Z','2026-01-15T10:30:00.000Z');

-- =============================================
-- USER 2: samanthak (Quant, crypto+stock, ~70 trades) — representative 18
-- =============================================
INSERT INTO trades VALUES ('d0000000000000000000000000000015','b00000000000000000000000000000201','a0000000000000000000000000000002','BTC','crypto','buy',1.0,43000.00,43000.00,'market','filled','2024-02-12T08:00:00.000Z','2024-02-12T08:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000016','b00000000000000000000000000000201','a0000000000000000000000000000002','ETH','crypto','buy',10,2500.00,25000.00,'market','filled','2024-02-28T09:30:00.000Z','2024-02-28T09:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000017','b00000000000000000000000000000201','a0000000000000000000000000000002','NVDA','stock','buy',50,720.00,36000.00,'market','filled','2024-03-15T10:00:00.000Z','2024-03-15T10:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000018','b00000000000000000000000000000201','a0000000000000000000000000000002','SOL','crypto','buy',300,140.00,42000.00,'market','filled','2024-04-10T11:15:00.000Z','2024-04-10T11:15:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000019','b00000000000000000000000000000201','a0000000000000000000000000000002','MSFT','stock','buy',40,420.00,16800.00,'market','filled','2024-05-08T13:45:00.000Z','2024-05-08T13:45:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000001a','b00000000000000000000000000000201','a0000000000000000000000000000002','BTC','crypto','sell',0.5,67000.00,33500.00,'market','filled','2024-06-15T08:30:00.000Z','2024-06-15T08:30:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000001b','b00000000000000000000000000000201','a0000000000000000000000000000002','AAPL','stock','buy',80,195.00,15600.00,'market','filled','2024-07-02T10:20:00.000Z','2024-07-02T10:20:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000001c','b00000000000000000000000000000201','a0000000000000000000000000000002','ETH','crypto','sell',5,3500.00,17500.00,'market','filled','2024-08-20T14:00:00.000Z','2024-08-20T14:00:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000001d','b00000000000000000000000000000201','a0000000000000000000000000000002','AMD','stock','buy',100,145.00,14500.00,'market','filled','2024-09-12T09:15:00.000Z','2024-09-12T09:15:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000001e','b00000000000000000000000000000201','a0000000000000000000000000000002','SOL','crypto','sell',150,180.00,27000.00,'market','filled','2024-10-25T11:30:00.000Z','2024-10-25T11:30:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000001f','b00000000000000000000000000000201','a0000000000000000000000000000002','NVDA','stock','sell',25,140.00,3500.00,'market','filled','2024-12-05T10:45:00.000Z','2024-12-05T10:45:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000020','b00000000000000000000000000000201','a0000000000000000000000000000002','GOOGL','stock','buy',60,175.00,10500.00,'market','filled','2025-01-22T09:00:00.000Z','2025-01-22T09:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000021','b00000000000000000000000000000201','a0000000000000000000000000000002','BTC','crypto','buy',0.75,95000.00,71250.00,'market','filled','2025-04-10T08:15:00.000Z','2025-04-10T08:15:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000022','b00000000000000000000000000000201','a0000000000000000000000000000002','AAPL','stock','sell',40,235.00,9400.00,'market','filled','2025-06-18T14:30:00.000Z','2025-06-18T14:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000023','b00000000000000000000000000000201','a0000000000000000000000000000002','ETH','crypto','buy',8,3800.00,30400.00,'market','filled','2025-08-05T10:00:00.000Z','2025-08-05T10:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000024','b00000000000000000000000000000201','a0000000000000000000000000000002','TSLA','stock','buy',30,280.00,8400.00,'market','filled','2025-10-14T11:20:00.000Z','2025-10-14T11:20:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000025','b00000000000000000000000000000201','a0000000000000000000000000000002','AMD','stock','sell',50,185.00,9250.00,'market','filled','2025-12-01T09:30:00.000Z','2025-12-01T09:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000026','b00000000000000000000000000000201','a0000000000000000000000000000002','SOL','crypto','buy',100,250.00,25000.00,'market','filled','2026-02-03T08:45:00.000Z','2026-02-03T08:45:00.000Z');

-- =============================================
-- USER 3: mikeb (Growth stocks, ~60 trades) — representative 16
-- =============================================
INSERT INTO trades VALUES ('d0000000000000000000000000000027','b00000000000000000000000000000301','a0000000000000000000000000000003','NVDA','stock','buy',60,780.00,46800.00,'market','filled','2024-03-10T10:00:00.000Z','2024-03-10T10:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000028','b00000000000000000000000000000301','a0000000000000000000000000000003','AMZN','stock','buy',80,180.00,14400.00,'market','filled','2024-03-25T11:30:00.000Z','2024-03-25T11:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000029','b00000000000000000000000000000301','a0000000000000000000000000000003','META','stock','buy',50,500.00,25000.00,'market','filled','2024-04-15T09:45:00.000Z','2024-04-15T09:45:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000002a','b00000000000000000000000000000301','a0000000000000000000000000000003','GOOGL','stock','buy',90,170.00,15300.00,'market','filled','2024-05-20T10:30:00.000Z','2024-05-20T10:30:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000002b','b00000000000000000000000000000301','a0000000000000000000000000000003','AAPL','stock','buy',70,190.00,13300.00,'market','filled','2024-06-10T14:00:00.000Z','2024-06-10T14:00:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000002c','b00000000000000000000000000000301','a0000000000000000000000000000003','NVDA','stock','sell',30,125.00,3750.00,'market','filled','2024-07-22T11:15:00.000Z','2024-07-22T11:15:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000002d','b00000000000000000000000000000301','a0000000000000000000000000000003','CRM','stock','buy',60,260.00,15600.00,'market','filled','2024-08-14T09:30:00.000Z','2024-08-14T09:30:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000002e','b00000000000000000000000000000301','a0000000000000000000000000000003','MSFT','stock','buy',40,430.00,17200.00,'market','filled','2024-09-18T10:45:00.000Z','2024-09-18T10:45:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000002f','b00000000000000000000000000000301','a0000000000000000000000000000003','AMZN','stock','sell',40,200.00,8000.00,'market','filled','2024-10-30T15:00:00.000Z','2024-10-30T15:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000030','b00000000000000000000000000000301','a0000000000000000000000000000003','SHOP','stock','buy',100,80.00,8000.00,'market','filled','2024-12-02T10:20:00.000Z','2024-12-02T10:20:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000031','b00000000000000000000000000000301','a0000000000000000000000000000003','META','stock','sell',25,610.00,15250.00,'market','filled','2025-02-10T14:30:00.000Z','2025-02-10T14:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000032','b00000000000000000000000000000301','a0000000000000000000000000000003','PLTR','stock','buy',200,25.00,5000.00,'market','filled','2025-04-28T09:15:00.000Z','2025-04-28T09:15:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000033','b00000000000000000000000000000301','a0000000000000000000000000000003','NVDA','stock','buy',20,1400.00,28000.00,'market','filled','2025-07-15T10:00:00.000Z','2025-07-15T10:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000034','b00000000000000000000000000000301','a0000000000000000000000000000003','GOOGL','stock','sell',45,210.00,9450.00,'market','filled','2025-09-22T11:30:00.000Z','2025-09-22T11:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000035','b00000000000000000000000000000301','a0000000000000000000000000000003','AAPL','stock','sell',35,250.00,8750.00,'market','filled','2025-11-18T15:00:00.000Z','2025-11-18T15:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000036','b00000000000000000000000000000301','a0000000000000000000000000000003','AMZN','stock','buy',30,260.00,7800.00,'market','filled','2026-01-20T10:45:00.000Z','2026-01-20T10:45:00.000Z');

-- =============================================
-- USER 4: emilyc (Swing, ETFs, ~55 trades) — representative 15
-- =============================================
INSERT INTO trades VALUES ('d0000000000000000000000000000037','b00000000000000000000000000000401','a0000000000000000000000000000004','SPY','etf','buy',100,510.00,51000.00,'market','filled','2024-03-08T10:00:00.000Z','2024-03-08T10:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000038','b00000000000000000000000000000401','a0000000000000000000000000000004','QQQ','etf','buy',80,440.00,35200.00,'market','filled','2024-03-22T11:30:00.000Z','2024-03-22T11:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000039','b00000000000000000000000000000401','a0000000000000000000000000000004','VOO','etf','buy',60,470.00,28200.00,'market','filled','2024-04-12T09:15:00.000Z','2024-04-12T09:15:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000003a','b00000000000000000000000000000401','a0000000000000000000000000000004','AAPL','stock','buy',50,170.00,8500.00,'market','filled','2024-05-06T14:00:00.000Z','2024-05-06T14:00:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000003b','b00000000000000000000000000000401','a0000000000000000000000000000004','SPY','etf','sell',50,545.00,27250.00,'market','filled','2024-06-20T10:30:00.000Z','2024-06-20T10:30:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000003c','b00000000000000000000000000000401','a0000000000000000000000000000004','IWM','etf','buy',120,210.00,25200.00,'market','filled','2024-07-15T11:00:00.000Z','2024-07-15T11:00:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000003d','b00000000000000000000000000000401','a0000000000000000000000000000004','MSFT','stock','buy',30,440.00,13200.00,'market','filled','2024-08-28T09:45:00.000Z','2024-08-28T09:45:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000003e','b00000000000000000000000000000401','a0000000000000000000000000000004','QQQ','etf','sell',40,480.00,19200.00,'market','filled','2024-10-10T14:30:00.000Z','2024-10-10T14:30:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000003f','b00000000000000000000000000000401','a0000000000000000000000000000004','VTI','etf','buy',70,265.00,18550.00,'market','filled','2024-11-22T10:15:00.000Z','2024-11-22T10:15:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000040','b00000000000000000000000000000401','a0000000000000000000000000000004','AAPL','stock','sell',25,230.00,5750.00,'market','filled','2025-01-14T15:00:00.000Z','2025-01-14T15:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000041','b00000000000000000000000000000401','a0000000000000000000000000000004','SPY','etf','buy',40,580.00,23200.00,'market','filled','2025-04-08T10:30:00.000Z','2025-04-08T10:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000042','b00000000000000000000000000000401','a0000000000000000000000000000004','IWM','etf','sell',60,230.00,13800.00,'market','filled','2025-07-02T11:45:00.000Z','2025-07-02T11:45:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000043','b00000000000000000000000000000401','a0000000000000000000000000000004','VOO','etf','sell',30,540.00,16200.00,'market','filled','2025-09-15T09:30:00.000Z','2025-09-15T09:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000044','b00000000000000000000000000000401','a0000000000000000000000000000004','QQQ','etf','buy',50,570.00,28500.00,'market','filled','2025-11-28T10:00:00.000Z','2025-11-28T10:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000045','b00000000000000000000000000000401','a0000000000000000000000000000004','SPY','etf','buy',30,600.00,18000.00,'market','filled','2026-02-05T14:15:00.000Z','2026-02-05T14:15:00.000Z');

-- =============================================
-- USER 5: davidl (Value, long holds, ~50 trades) — representative 14
-- =============================================
INSERT INTO trades VALUES ('d0000000000000000000000000000046','b00000000000000000000000000000501','a0000000000000000000000000000005','BRK.B','stock','buy',100,380.00,38000.00,'market','filled','2024-02-20T10:00:00.000Z','2024-02-20T10:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000047','b00000000000000000000000000000501','a0000000000000000000000000000005','JNJ','stock','buy',80,155.00,12400.00,'market','filled','2024-03-12T11:30:00.000Z','2024-03-12T11:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000048','b00000000000000000000000000000501','a0000000000000000000000000000005','JPM','stock','buy',60,190.00,11400.00,'market','filled','2024-04-08T09:15:00.000Z','2024-04-08T09:15:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000049','b00000000000000000000000000000501','a0000000000000000000000000000005','PG','stock','buy',70,165.00,11550.00,'market','filled','2024-05-15T14:00:00.000Z','2024-05-15T14:00:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000004a','b00000000000000000000000000000501','a0000000000000000000000000000005','KO','stock','buy',150,60.00,9000.00,'market','filled','2024-06-22T10:30:00.000Z','2024-06-22T10:30:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000004b','b00000000000000000000000000000501','a0000000000000000000000000000005','V','stock','buy',40,275.00,11000.00,'market','filled','2024-07-30T11:00:00.000Z','2024-07-30T11:00:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000004c','b00000000000000000000000000000501','a0000000000000000000000000000005','WMT','stock','buy',80,170.00,13600.00,'market','filled','2024-09-10T09:45:00.000Z','2024-09-10T09:45:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000004d','b00000000000000000000000000000501','a0000000000000000000000000000005','JNJ','stock','sell',40,160.00,6400.00,'market','filled','2024-11-05T15:00:00.000Z','2024-11-05T15:00:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000004e','b00000000000000000000000000000501','a0000000000000000000000000000005','UNH','stock','buy',20,550.00,11000.00,'market','filled','2025-01-20T10:30:00.000Z','2025-01-20T10:30:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000004f','b00000000000000000000000000000501','a0000000000000000000000000000005','BRK.B','stock','sell',50,450.00,22500.00,'market','filled','2025-04-15T14:00:00.000Z','2025-04-15T14:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000050','b00000000000000000000000000000501','a0000000000000000000000000000005','AAPL','stock','buy',50,220.00,11000.00,'market','filled','2025-06-10T09:30:00.000Z','2025-06-10T09:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000051','b00000000000000000000000000000501','a0000000000000000000000000000005','JPM','stock','sell',30,240.00,7200.00,'market','filled','2025-08-28T11:15:00.000Z','2025-08-28T11:15:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000052','b00000000000000000000000000000501','a0000000000000000000000000000005','MSFT','stock','buy',25,460.00,11500.00,'market','filled','2025-11-12T10:00:00.000Z','2025-11-12T10:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000053','b00000000000000000000000000000501','a0000000000000000000000000000005','V','stock','sell',20,320.00,6400.00,'market','filled','2026-01-28T14:45:00.000Z','2026-01-28T14:45:00.000Z');

-- =============================================
-- USER 6: jessicam (Momentum, ~40 trades) — representative 12
-- =============================================
INSERT INTO trades VALUES ('d0000000000000000000000000000054','b00000000000000000000000000000601','a0000000000000000000000000000006','NVDA','stock','buy',40,850.00,34000.00,'market','filled','2024-04-05T10:00:00.000Z','2024-04-05T10:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000055','b00000000000000000000000000000601','a0000000000000000000000000000006','META','stock','buy',30,480.00,14400.00,'market','filled','2024-04-25T11:30:00.000Z','2024-04-25T11:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000056','b00000000000000000000000000000601','a0000000000000000000000000000006','NVDA','stock','sell',20,920.00,18400.00,'market','filled','2024-06-10T14:15:00.000Z','2024-06-10T14:15:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000057','b00000000000000000000000000000601','a0000000000000000000000000000006','SMCI','stock','buy',80,800.00,64000.00,'market','filled','2024-07-08T09:30:00.000Z','2024-07-08T09:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000058','b00000000000000000000000000000601','a0000000000000000000000000000006','ARM','stock','buy',50,160.00,8000.00,'market','filled','2024-08-20T10:45:00.000Z','2024-08-20T10:45:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000059','b00000000000000000000000000000601','a0000000000000000000000000000006','SMCI','stock','sell',40,600.00,24000.00,'market','filled','2024-10-02T15:00:00.000Z','2024-10-02T15:00:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000005a','b00000000000000000000000000000601','a0000000000000000000000000000006','MSFT','stock','buy',25,420.00,10500.00,'market','filled','2024-11-18T09:15:00.000Z','2024-11-18T09:15:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000005b','b00000000000000000000000000000601','a0000000000000000000000000000006','META','stock','sell',15,590.00,8850.00,'market','filled','2025-01-28T14:30:00.000Z','2025-01-28T14:30:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000005c','b00000000000000000000000000000601','a0000000000000000000000000000006','PLTR','stock','buy',300,30.00,9000.00,'market','filled','2025-05-12T10:00:00.000Z','2025-05-12T10:00:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000005d','b00000000000000000000000000000601','a0000000000000000000000000000006','ARM','stock','sell',25,200.00,5000.00,'market','filled','2025-08-15T11:30:00.000Z','2025-08-15T11:30:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000005e','b00000000000000000000000000000601','a0000000000000000000000000000006','NVDA','stock','buy',15,1300.00,19500.00,'market','filled','2025-10-20T09:45:00.000Z','2025-10-20T09:45:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000005f','b00000000000000000000000000000601','a0000000000000000000000000000006','PLTR','stock','sell',150,55.00,8250.00,'market','filled','2026-01-10T14:00:00.000Z','2026-01-10T14:00:00.000Z');

-- =============================================
-- USER 7: danielp (Tech stocks, ~35 trades) — representative 12
-- =============================================
INSERT INTO trades VALUES ('d0000000000000000000000000000060','b00000000000000000000000000000701','a0000000000000000000000000000007','AAPL','stock','buy',80,175.00,14000.00,'market','filled','2024-04-10T10:00:00.000Z','2024-04-10T10:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000061','b00000000000000000000000000000701','a0000000000000000000000000000007','MSFT','stock','buy',40,405.00,16200.00,'market','filled','2024-05-02T11:30:00.000Z','2024-05-02T11:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000062','b00000000000000000000000000000701','a0000000000000000000000000000007','GOOGL','stock','buy',60,172.00,10320.00,'market','filled','2024-06-15T09:15:00.000Z','2024-06-15T09:15:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000063','b00000000000000000000000000000701','a0000000000000000000000000000007','AMD','stock','buy',100,160.00,16000.00,'market','filled','2024-07-22T14:00:00.000Z','2024-07-22T14:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000064','b00000000000000000000000000000701','a0000000000000000000000000000007','AAPL','stock','sell',40,210.00,8400.00,'market','filled','2024-09-10T10:30:00.000Z','2024-09-10T10:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000065','b00000000000000000000000000000701','a0000000000000000000000000000007','NVDA','stock','buy',25,130.00,3250.00,'market','filled','2024-10-28T11:00:00.000Z','2024-10-28T11:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000066','b00000000000000000000000000000701','a0000000000000000000000000000007','CRM','stock','buy',50,290.00,14500.00,'market','filled','2024-12-15T09:45:00.000Z','2024-12-15T09:45:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000067','b00000000000000000000000000000701','a0000000000000000000000000000007','AMD','stock','sell',50,170.00,8500.00,'market','filled','2025-03-05T15:00:00.000Z','2025-03-05T15:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000068','b00000000000000000000000000000701','a0000000000000000000000000000007','MSFT','stock','sell',20,470.00,9400.00,'market','filled','2025-06-18T10:30:00.000Z','2025-06-18T10:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000069','b00000000000000000000000000000701','a0000000000000000000000000000007','GOOGL','stock','sell',30,205.00,6150.00,'market','filled','2025-09-10T14:15:00.000Z','2025-09-10T14:15:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000006a','b00000000000000000000000000000701','a0000000000000000000000000000007','AAPL','stock','buy',30,245.00,7350.00,'market','filled','2025-11-22T09:30:00.000Z','2025-11-22T09:30:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000006b','b00000000000000000000000000000701','a0000000000000000000000000000007','NVDA','stock','sell',12,1450.00,17400.00,'market','filled','2026-02-01T10:00:00.000Z','2026-02-01T10:00:00.000Z');

-- =============================================
-- USER 8: rachelg (Crypto, ~30 trades) — all 12
-- =============================================
INSERT INTO trades VALUES ('d000000000000000000000000000006c','b00000000000000000000000000000801','a0000000000000000000000000000008','BTC','crypto','buy',0.3,62000.00,18600.00,'market','filled','2024-05-10T08:00:00.000Z','2024-05-10T08:00:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000006d','b00000000000000000000000000000801','a0000000000000000000000000000008','ETH','crypto','buy',5,3000.00,15000.00,'market','filled','2024-05-28T09:30:00.000Z','2024-05-28T09:30:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000006e','b00000000000000000000000000000801','a0000000000000000000000000000008','SOL','crypto','buy',100,150.00,15000.00,'market','filled','2024-06-15T10:15:00.000Z','2024-06-15T10:15:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000006f','b00000000000000000000000000000801','a0000000000000000000000000000008','BTC','crypto','sell',0.1,68000.00,6800.00,'market','filled','2024-07-20T14:00:00.000Z','2024-07-20T14:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000070','b00000000000000000000000000000801','a0000000000000000000000000000008','DOGE','crypto','buy',50000,0.12,6000.00,'market','filled','2024-08-30T08:30:00.000Z','2024-08-30T08:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000071','b00000000000000000000000000000801','a0000000000000000000000000000008','ETH','crypto','sell',2,3400.00,6800.00,'market','filled','2024-10-12T11:00:00.000Z','2024-10-12T11:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000072','b00000000000000000000000000000801','a0000000000000000000000000000008','SOL','crypto','sell',50,200.00,10000.00,'market','filled','2024-12-05T09:45:00.000Z','2024-12-05T09:45:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000073','b00000000000000000000000000000801','a0000000000000000000000000000008','BTC','crypto','buy',0.2,98000.00,19600.00,'market','filled','2025-02-18T10:30:00.000Z','2025-02-18T10:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000074','b00000000000000000000000000000801','a0000000000000000000000000000008','DOGE','crypto','sell',25000,0.18,4500.00,'market','filled','2025-05-20T14:15:00.000Z','2025-05-20T14:15:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000075','b00000000000000000000000000000801','a0000000000000000000000000000008','ETH','crypto','buy',3,3600.00,10800.00,'market','filled','2025-08-10T08:00:00.000Z','2025-08-10T08:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000076','b00000000000000000000000000000801','a0000000000000000000000000000008','SOL','crypto','buy',80,220.00,17600.00,'market','filled','2025-11-05T09:30:00.000Z','2025-11-05T09:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000077','b00000000000000000000000000000801','a0000000000000000000000000000008','BTC','crypto','sell',0.15,105000.00,15750.00,'market','filled','2026-01-22T10:00:00.000Z','2026-01-22T10:00:00.000Z');

-- =============================================
-- USER 9: chrisr (Dividends, ~30 trades) — representative 10
-- =============================================
INSERT INTO trades VALUES ('d0000000000000000000000000000078','b00000000000000000000000000000901','a0000000000000000000000000000009','JNJ','stock','buy',100,155.00,15500.00,'market','filled','2024-03-15T10:00:00.000Z','2024-03-15T10:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000079','b00000000000000000000000000000901','a0000000000000000000000000000009','KO','stock','buy',200,58.00,11600.00,'market','filled','2024-04-22T11:30:00.000Z','2024-04-22T11:30:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000007a','b00000000000000000000000000000901','a0000000000000000000000000000009','PEP','stock','buy',80,170.00,13600.00,'market','filled','2024-06-10T09:15:00.000Z','2024-06-10T09:15:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000007b','b00000000000000000000000000000901','a0000000000000000000000000000009','T','stock','buy',500,17.00,8500.00,'market','filled','2024-08-05T14:00:00.000Z','2024-08-05T14:00:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000007c','b00000000000000000000000000000901','a0000000000000000000000000000009','O','stock','buy',150,55.00,8250.00,'market','filled','2024-10-18T10:30:00.000Z','2024-10-18T10:30:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000007d','b00000000000000000000000000000901','a0000000000000000000000000000009','JNJ','stock','sell',50,162.00,8100.00,'market','filled','2025-01-12T11:00:00.000Z','2025-01-12T11:00:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000007e','b00000000000000000000000000000901','a0000000000000000000000000000009','VZ','stock','buy',200,42.00,8400.00,'market','filled','2025-04-08T09:45:00.000Z','2025-04-08T09:45:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000007f','b00000000000000000000000000000901','a0000000000000000000000000000009','ABBV','stock','buy',50,180.00,9000.00,'market','filled','2025-07-22T15:00:00.000Z','2025-07-22T15:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000080','b00000000000000000000000000000901','a0000000000000000000000000000009','T','stock','sell',250,22.00,5500.00,'market','filled','2025-10-15T10:30:00.000Z','2025-10-15T10:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000081','b00000000000000000000000000000901','a0000000000000000000000000000009','KO','stock','sell',100,68.00,6800.00,'market','filled','2026-01-28T14:15:00.000Z','2026-01-28T14:15:00.000Z');

-- =============================================
-- USER 10: laurah (Meme stocks, ~25 trades) — all 10
-- =============================================
INSERT INTO trades VALUES ('d0000000000000000000000000000082','b00000000000000000000000000000a01','a000000000000000000000000000000a','GME','stock','buy',200,25.00,5000.00,'market','filled','2024-05-15T10:00:00.000Z','2024-05-15T10:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000083','b00000000000000000000000000000a01','a000000000000000000000000000000a','AMC','stock','buy',500,5.00,2500.00,'market','filled','2024-06-08T11:30:00.000Z','2024-06-08T11:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000084','b00000000000000000000000000000a01','a000000000000000000000000000000a','BBBY','stock','buy',1000,0.50,500.00,'market','filled','2024-07-20T09:15:00.000Z','2024-07-20T09:15:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000085','b00000000000000000000000000000a01','a000000000000000000000000000000a','GME','stock','sell',100,35.00,3500.00,'market','filled','2024-09-05T14:00:00.000Z','2024-09-05T14:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000086','b00000000000000000000000000000a01','a000000000000000000000000000000a','PLTR','stock','buy',400,22.00,8800.00,'market','filled','2024-10-15T10:30:00.000Z','2024-10-15T10:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000087','b00000000000000000000000000000a01','a000000000000000000000000000000a','DOGE','crypto','buy',100000,0.08,8000.00,'market','filled','2024-12-01T08:00:00.000Z','2024-12-01T08:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000088','b00000000000000000000000000000a01','a000000000000000000000000000000a','AMC','stock','sell',250,7.00,1750.00,'market','filled','2025-02-20T11:00:00.000Z','2025-02-20T11:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000089','b00000000000000000000000000000a01','a000000000000000000000000000000a','PLTR','stock','sell',200,45.00,9000.00,'market','filled','2025-06-10T09:45:00.000Z','2025-06-10T09:45:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000008a','b00000000000000000000000000000a01','a000000000000000000000000000000a','DOGE','crypto','sell',50000,0.15,7500.00,'market','filled','2025-09-28T15:00:00.000Z','2025-09-28T15:00:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000008b','b00000000000000000000000000000a01','a000000000000000000000000000000a','GME','stock','buy',150,28.00,4200.00,'market','filled','2026-01-05T10:30:00.000Z','2026-01-05T10:30:00.000Z');

-- =============================================
-- USER 11: keving (Balanced, ~35 trades) — representative 12
-- =============================================
INSERT INTO trades VALUES ('d000000000000000000000000000008c','b00000000000000000000000000000b01','a000000000000000000000000000000b','AAPL','stock','buy',50,173.00,8650.00,'market','filled','2024-04-08T10:00:00.000Z','2024-04-08T10:00:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000008d','b00000000000000000000000000000b01','a000000000000000000000000000000b','SPY','etf','buy',40,515.00,20600.00,'market','filled','2024-05-15T11:30:00.000Z','2024-05-15T11:30:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000008e','b00000000000000000000000000000b01','a000000000000000000000000000000b','BTC','crypto','buy',0.15,65000.00,9750.00,'market','filled','2024-06-22T08:15:00.000Z','2024-06-22T08:15:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000008f','b00000000000000000000000000000b01','a000000000000000000000000000000b','MSFT','stock','buy',25,435.00,10875.00,'market','filled','2024-08-10T09:30:00.000Z','2024-08-10T09:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000090','b00000000000000000000000000000b01','a000000000000000000000000000000b','VOO','etf','buy',30,490.00,14700.00,'market','filled','2024-09-28T14:00:00.000Z','2024-09-28T14:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000091','b00000000000000000000000000000b01','a000000000000000000000000000000b','AAPL','stock','sell',25,215.00,5375.00,'market','filled','2024-11-12T10:45:00.000Z','2024-11-12T10:45:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000092','b00000000000000000000000000000b01','a000000000000000000000000000000b','ETH','crypto','buy',3,3300.00,9900.00,'market','filled','2025-01-20T08:30:00.000Z','2025-01-20T08:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000093','b00000000000000000000000000000b01','a000000000000000000000000000000b','GOOGL','stock','buy',40,180.00,7200.00,'market','filled','2025-04-15T11:15:00.000Z','2025-04-15T11:15:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000094','b00000000000000000000000000000b01','a000000000000000000000000000000b','SPY','etf','sell',20,575.00,11500.00,'market','filled','2025-07-08T15:00:00.000Z','2025-07-08T15:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000095','b00000000000000000000000000000b01','a000000000000000000000000000000b','BTC','crypto','sell',0.08,102000.00,8160.00,'market','filled','2025-09-22T09:00:00.000Z','2025-09-22T09:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000096','b00000000000000000000000000000b01','a000000000000000000000000000000b','AMZN','stock','buy',30,255.00,7650.00,'market','filled','2025-11-30T10:30:00.000Z','2025-11-30T10:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000097','b00000000000000000000000000000b01','a000000000000000000000000000000b','QQQ','etf','buy',20,565.00,11300.00,'market','filled','2026-02-08T14:30:00.000Z','2026-02-08T14:30:00.000Z');

-- =============================================
-- USER 12: amandan (Mixed, ~25 trades) — representative 10
-- =============================================
INSERT INTO trades VALUES ('d0000000000000000000000000000098','b00000000000000000000000000000c01','a000000000000000000000000000000c','NVDA','stock','buy',30,125.00,3750.00,'market','filled','2024-06-10T10:00:00.000Z','2024-06-10T10:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000099','b00000000000000000000000000000c01','a000000000000000000000000000000c','BTC','crypto','buy',0.1,67000.00,6700.00,'market','filled','2024-07-15T08:30:00.000Z','2024-07-15T08:30:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000009a','b00000000000000000000000000000c01','a000000000000000000000000000000c','SPY','etf','buy',25,540.00,13500.00,'market','filled','2024-08-22T11:15:00.000Z','2024-08-22T11:15:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000009b','b00000000000000000000000000000c01','a000000000000000000000000000000c','AAPL','stock','buy',40,200.00,8000.00,'market','filled','2024-10-05T09:45:00.000Z','2024-10-05T09:45:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000009c','b00000000000000000000000000000c01','a000000000000000000000000000000c','NVDA','stock','sell',15,140.00,2100.00,'market','filled','2024-12-18T14:30:00.000Z','2024-12-18T14:30:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000009d','b00000000000000000000000000000c01','a000000000000000000000000000000c','TSLA','stock','buy',20,250.00,5000.00,'market','filled','2025-03-10T10:00:00.000Z','2025-03-10T10:00:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000009e','b00000000000000000000000000000c01','a000000000000000000000000000000c','BTC','crypto','sell',0.05,95000.00,4750.00,'market','filled','2025-06-22T08:15:00.000Z','2025-06-22T08:15:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000009f','b00000000000000000000000000000c01','a000000000000000000000000000000c','SPY','etf','sell',12,580.00,6960.00,'market','filled','2025-09-15T11:30:00.000Z','2025-09-15T11:30:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000a0','b00000000000000000000000000000c01','a000000000000000000000000000000c','AAPL','stock','sell',20,248.00,4960.00,'market','filled','2025-11-28T15:00:00.000Z','2025-11-28T15:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000a1','b00000000000000000000000000000c01','a000000000000000000000000000000c','META','stock','buy',15,640.00,9600.00,'market','filled','2026-01-20T09:30:00.000Z','2026-01-20T09:30:00.000Z');

-- =============================================
-- USER 13: sophiat (Occasional, ~12 trades) — all 12
-- =============================================
INSERT INTO trades VALUES ('d00000000000000000000000000000a2','b00000000000000000000000000000d01','a000000000000000000000000000000d','AAPL','stock','buy',20,193.00,3860.00,'market','filled','2024-07-10T10:00:00.000Z','2024-07-10T10:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000a3','b00000000000000000000000000000d01','a000000000000000000000000000000d','SPY','etf','buy',10,548.00,5480.00,'market','filled','2024-08-22T11:30:00.000Z','2024-08-22T11:30:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000a4','b00000000000000000000000000000d01','a000000000000000000000000000000d','MSFT','stock','buy',10,420.00,4200.00,'market','filled','2024-10-05T09:15:00.000Z','2024-10-05T09:15:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000a5','b00000000000000000000000000000d01','a000000000000000000000000000000d','NVDA','stock','buy',10,132.00,1320.00,'market','filled','2024-11-18T14:00:00.000Z','2024-11-18T14:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000a6','b00000000000000000000000000000d01','a000000000000000000000000000000d','AAPL','stock','sell',10,225.00,2250.00,'market','filled','2025-01-15T10:30:00.000Z','2025-01-15T10:30:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000a7','b00000000000000000000000000000d01','a000000000000000000000000000000d','GOOGL','stock','buy',15,178.00,2670.00,'market','filled','2025-03-20T11:00:00.000Z','2025-03-20T11:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000a8','b00000000000000000000000000000d01','a000000000000000000000000000000d','BTC','crypto','buy',0.02,88000.00,1760.00,'market','filled','2025-05-12T08:45:00.000Z','2025-05-12T08:45:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000a9','b00000000000000000000000000000d01','a000000000000000000000000000000d','SPY','etf','sell',5,570.00,2850.00,'market','filled','2025-07-28T15:00:00.000Z','2025-07-28T15:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000aa','b00000000000000000000000000000d01','a000000000000000000000000000000d','MSFT','stock','sell',5,465.00,2325.00,'market','filled','2025-09-10T10:15:00.000Z','2025-09-10T10:15:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000ab','b00000000000000000000000000000d01','a000000000000000000000000000000d','AMZN','stock','buy',10,250.00,2500.00,'market','filled','2025-11-05T09:30:00.000Z','2025-11-05T09:30:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000ac','b00000000000000000000000000000d01','a000000000000000000000000000000d','NVDA','stock','sell',5,1380.00,6900.00,'market','filled','2025-12-18T14:30:00.000Z','2025-12-18T14:30:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000ad','b00000000000000000000000000000d01','a000000000000000000000000000000d','AAPL','stock','buy',10,252.00,2520.00,'market','filled','2026-02-05T10:00:00.000Z','2026-02-05T10:00:00.000Z');

-- =============================================
-- USER 14: andrewf (Weekend, ~10 trades) — all 10
-- =============================================
INSERT INTO trades VALUES ('d00000000000000000000000000000ae','b00000000000000000000000000000e01','a000000000000000000000000000000e','BTC','crypto','buy',0.05,58000.00,2900.00,'market','filled','2024-08-10T18:00:00.000Z','2024-08-10T18:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000af','b00000000000000000000000000000e01','a000000000000000000000000000000e','ETH','crypto','buy',2,2800.00,5600.00,'market','filled','2024-09-21T17:30:00.000Z','2024-09-21T17:30:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000b0','b00000000000000000000000000000e01','a000000000000000000000000000000e','AAPL','stock','buy',15,220.00,3300.00,'market','filled','2024-11-02T16:00:00.000Z','2024-11-02T16:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000b1','b00000000000000000000000000000e01','a000000000000000000000000000000e','SPY','etf','buy',8,580.00,4640.00,'market','filled','2025-01-18T17:15:00.000Z','2025-01-18T17:15:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000b2','b00000000000000000000000000000e01','a000000000000000000000000000000e','BTC','crypto','sell',0.02,92000.00,1840.00,'market','filled','2025-04-05T18:30:00.000Z','2025-04-05T18:30:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000b3','b00000000000000000000000000000e01','a000000000000000000000000000000e','MSFT','stock','buy',8,450.00,3600.00,'market','filled','2025-06-14T16:45:00.000Z','2025-06-14T16:45:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000b4','b00000000000000000000000000000e01','a000000000000000000000000000000e','ETH','crypto','sell',1,3700.00,3700.00,'market','filled','2025-08-23T17:00:00.000Z','2025-08-23T17:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000b5','b00000000000000000000000000000e01','a000000000000000000000000000000e','AAPL','stock','sell',8,242.00,1936.00,'market','filled','2025-10-11T16:30:00.000Z','2025-10-11T16:30:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000b6','b00000000000000000000000000000e01','a000000000000000000000000000000e','QQQ','etf','buy',5,555.00,2775.00,'market','filled','2025-12-06T18:00:00.000Z','2025-12-06T18:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000b7','b00000000000000000000000000000e01','a000000000000000000000000000000e','SOL','crypto','buy',10,240.00,2400.00,'market','filled','2026-02-01T17:15:00.000Z','2026-02-01T17:15:00.000Z');

-- =============================================
-- USER 15: oliviaw (New investor, ~8 trades) — all 8
-- =============================================
INSERT INTO trades VALUES ('d00000000000000000000000000000b8','b00000000000000000000000000000f01','a000000000000000000000000000000f','AAPL','stock','buy',10,222.00,2220.00,'market','filled','2024-09-15T10:00:00.000Z','2024-09-15T10:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000b9','b00000000000000000000000000000f01','a000000000000000000000000000000f','SPY','etf','buy',5,555.00,2775.00,'market','filled','2024-11-08T11:30:00.000Z','2024-11-08T11:30:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000ba','b00000000000000000000000000000f01','a000000000000000000000000000000f','MSFT','stock','buy',5,430.00,2150.00,'market','filled','2025-01-22T09:15:00.000Z','2025-01-22T09:15:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000bb','b00000000000000000000000000000f01','a000000000000000000000000000000f','NVDA','stock','buy',3,1100.00,3300.00,'market','filled','2025-04-18T14:00:00.000Z','2025-04-18T14:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000bc','b00000000000000000000000000000f01','a000000000000000000000000000000f','AAPL','stock','sell',5,238.00,1190.00,'market','filled','2025-07-10T10:30:00.000Z','2025-07-10T10:30:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000bd','b00000000000000000000000000000f01','a000000000000000000000000000000f','GOOGL','stock','buy',8,200.00,1600.00,'market','filled','2025-09-25T11:00:00.000Z','2025-09-25T11:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000be','b00000000000000000000000000000f01','a000000000000000000000000000000f','VOO','etf','buy',3,535.00,1605.00,'market','filled','2025-11-15T09:45:00.000Z','2025-11-15T09:45:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000bf','b00000000000000000000000000000f01','a000000000000000000000000000000f','BTC','crypto','buy',0.01,108000.00,1080.00,'market','filled','2026-01-28T08:30:00.000Z','2026-01-28T08:30:00.000Z');

-- =============================================
-- USER 16: jasonh (Sporadic, ~6 trades) — all 6
-- =============================================
INSERT INTO trades VALUES ('d00000000000000000000000000000c0','b00000000000000000000000000001001','a0000000000000000000000000000010','TSLA','stock','buy',10,245.00,2450.00,'market','filled','2024-10-20T10:00:00.000Z','2024-10-20T10:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000c1','b00000000000000000000000000001001','a0000000000000000000000000000010','BTC','crypto','buy',0.03,72000.00,2160.00,'market','filled','2025-01-10T08:15:00.000Z','2025-01-10T08:15:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000c2','b00000000000000000000000000001001','a0000000000000000000000000000010','AAPL','stock','buy',8,228.00,1824.00,'market','filled','2025-05-22T11:30:00.000Z','2025-05-22T11:30:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000c3','b00000000000000000000000000001001','a0000000000000000000000000000010','TSLA','stock','sell',5,290.00,1450.00,'market','filled','2025-08-15T14:00:00.000Z','2025-08-15T14:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000c4','b00000000000000000000000000001001','a0000000000000000000000000000010','SPY','etf','buy',3,590.00,1770.00,'market','filled','2025-11-10T10:45:00.000Z','2025-11-10T10:45:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000c5','b00000000000000000000000000001001','a0000000000000000000000000000010','NVDA','stock','buy',2,1400.00,2800.00,'market','filled','2026-02-03T09:30:00.000Z','2026-02-03T09:30:00.000Z');

-- =============================================
-- USER 17: matthewj (Social, ~20 trades) — representative 10
-- =============================================
INSERT INTO trades VALUES ('d00000000000000000000000000000c6','b00000000000000000000000000001101','a0000000000000000000000000000011','NVDA','stock','buy',30,128.00,3840.00,'market','filled','2024-06-12T10:00:00.000Z','2024-06-12T10:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000c7','b00000000000000000000000000001101','a0000000000000000000000000000011','AAPL','stock','buy',25,195.00,4875.00,'market','filled','2024-07-22T11:30:00.000Z','2024-07-22T11:30:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000c8','b00000000000000000000000000001101','a0000000000000000000000000000011','TSLA','stock','buy',20,200.00,4000.00,'market','filled','2024-09-05T09:15:00.000Z','2024-09-05T09:15:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000c9','b00000000000000000000000000001101','a0000000000000000000000000000011','META','stock','buy',10,565.00,5650.00,'market','filled','2024-10-28T14:00:00.000Z','2024-10-28T14:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000ca','b00000000000000000000000000001101','a0000000000000000000000000000011','NVDA','stock','sell',15,140.00,2100.00,'market','filled','2024-12-15T10:30:00.000Z','2024-12-15T10:30:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000cb','b00000000000000000000000000001101','a0000000000000000000000000000011','BTC','crypto','buy',0.05,97000.00,4850.00,'market','filled','2025-03-10T08:00:00.000Z','2025-03-10T08:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000cc','b00000000000000000000000000001101','a0000000000000000000000000000011','TSLA','stock','sell',10,275.00,2750.00,'market','filled','2025-06-20T11:15:00.000Z','2025-06-20T11:15:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000cd','b00000000000000000000000000001101','a0000000000000000000000000000011','AAPL','stock','sell',12,240.00,2880.00,'market','filled','2025-09-08T15:00:00.000Z','2025-09-08T15:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000ce','b00000000000000000000000000001101','a0000000000000000000000000000011','PLTR','stock','buy',100,50.00,5000.00,'market','filled','2025-11-22T09:45:00.000Z','2025-11-22T09:45:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000cf','b00000000000000000000000000001101','a0000000000000000000000000000011','SPY','etf','buy',8,598.00,4784.00,'market','filled','2026-01-30T10:30:00.000Z','2026-01-30T10:30:00.000Z');

-- =============================================
-- USER 18: nicoled (Crypto only, ~15 trades) — all 15
-- =============================================
INSERT INTO trades VALUES ('d00000000000000000000000000000d0','b00000000000000000000000000001201','a0000000000000000000000000000012','BTC','crypto','buy',0.2,72000.00,14400.00,'market','filled','2024-11-05T08:00:00.000Z','2024-11-05T08:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000d1','b00000000000000000000000000001201','a0000000000000000000000000000012','ETH','crypto','buy',4,2900.00,11600.00,'market','filled','2024-11-20T09:30:00.000Z','2024-11-20T09:30:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000d2','b00000000000000000000000000001201','a0000000000000000000000000000012','SOL','crypto','buy',50,175.00,8750.00,'market','filled','2024-12-08T10:15:00.000Z','2024-12-08T10:15:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000d3','b00000000000000000000000000001201','a0000000000000000000000000000012','DOGE','crypto','buy',30000,0.14,4200.00,'market','filled','2025-01-10T08:45:00.000Z','2025-01-10T08:45:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000d4','b00000000000000000000000000001201','a0000000000000000000000000000012','BTC','crypto','sell',0.1,95000.00,9500.00,'market','filled','2025-02-22T11:00:00.000Z','2025-02-22T11:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000d5','b00000000000000000000000000001201','a0000000000000000000000000000012','ETH','crypto','sell',2,3500.00,7000.00,'market','filled','2025-04-15T14:30:00.000Z','2025-04-15T14:30:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000d6','b00000000000000000000000000001201','a0000000000000000000000000000012','SOL','crypto','sell',25,210.00,5250.00,'market','filled','2025-05-28T09:00:00.000Z','2025-05-28T09:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000d7','b00000000000000000000000000001201','a0000000000000000000000000000012','BTC','crypto','buy',0.15,98000.00,14700.00,'market','filled','2025-07-10T08:30:00.000Z','2025-07-10T08:30:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000d8','b00000000000000000000000000001201','a0000000000000000000000000000012','DOGE','crypto','sell',15000,0.20,3000.00,'market','filled','2025-08-25T10:15:00.000Z','2025-08-25T10:15:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000d9','b00000000000000000000000000001201','a0000000000000000000000000000012','ETH','crypto','buy',3,3900.00,11700.00,'market','filled','2025-09-18T11:45:00.000Z','2025-09-18T11:45:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000da','b00000000000000000000000000001201','a0000000000000000000000000000012','SOL','crypto','buy',40,235.00,9400.00,'market','filled','2025-10-30T08:00:00.000Z','2025-10-30T08:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000db','b00000000000000000000000000001201','a0000000000000000000000000000012','BTC','crypto','sell',0.08,108000.00,8640.00,'market','filled','2025-12-05T14:00:00.000Z','2025-12-05T14:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000dc','b00000000000000000000000000001201','a0000000000000000000000000000012','DOGE','crypto','sell',10000,0.22,2200.00,'market','filled','2026-01-08T09:30:00.000Z','2026-01-08T09:30:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000dd','b00000000000000000000000000001201','a0000000000000000000000000000012','ETH','crypto','sell',1,4200.00,4200.00,'market','filled','2026-01-25T10:45:00.000Z','2026-01-25T10:45:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000de','b00000000000000000000000000001201','a0000000000000000000000000000012','SOL','crypto','buy',30,250.00,7500.00,'market','filled','2026-02-08T08:15:00.000Z','2026-02-08T08:15:00.000Z');

-- =============================================
-- USER 19: brandonm (Blue chip, ~10 trades) — all 10
-- =============================================
INSERT INTO trades VALUES ('d00000000000000000000000000000df','b00000000000000000000000000001301','a0000000000000000000000000000013','AAPL','stock','buy',20,210.00,4200.00,'market','filled','2024-08-12T10:00:00.000Z','2024-08-12T10:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000e0','b00000000000000000000000000001301','a0000000000000000000000000000013','MSFT','stock','buy',10,420.00,4200.00,'market','filled','2024-10-05T11:30:00.000Z','2024-10-05T11:30:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000e1','b00000000000000000000000000001301','a0000000000000000000000000000013','JPM','stock','buy',15,200.00,3000.00,'market','filled','2024-12-18T09:15:00.000Z','2024-12-18T09:15:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000e2','b00000000000000000000000000001301','a0000000000000000000000000000013','AAPL','stock','sell',10,232.00,2320.00,'market','filled','2025-03-10T14:00:00.000Z','2025-03-10T14:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000e3','b00000000000000000000000000001301','a0000000000000000000000000000013','V','stock','buy',8,290.00,2320.00,'market','filled','2025-05-20T10:30:00.000Z','2025-05-20T10:30:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000e4','b00000000000000000000000000001301','a0000000000000000000000000000013','GOOGL','stock','buy',12,195.00,2340.00,'market','filled','2025-07-15T11:00:00.000Z','2025-07-15T11:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000e5','b00000000000000000000000000001301','a0000000000000000000000000000013','MSFT','stock','sell',5,460.00,2300.00,'market','filled','2025-09-22T09:45:00.000Z','2025-09-22T09:45:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000e6','b00000000000000000000000000001301','a0000000000000000000000000000013','UNH','stock','buy',5,540.00,2700.00,'market','filled','2025-11-08T15:00:00.000Z','2025-11-08T15:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000e7','b00000000000000000000000000001301','a0000000000000000000000000000013','JPM','stock','sell',8,250.00,2000.00,'market','filled','2025-12-28T10:30:00.000Z','2025-12-28T10:30:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000e8','b00000000000000000000000000001301','a0000000000000000000000000000013','AAPL','stock','buy',8,255.00,2040.00,'market','filled','2026-02-05T14:15:00.000Z','2026-02-05T14:15:00.000Z');

-- =============================================
-- USER 20: ashleys (ETF, ~8 trades) — all 8
-- =============================================
INSERT INTO trades VALUES ('d00000000000000000000000000000e9','b00000000000000000000000000001401','a0000000000000000000000000000014','SPY','etf','buy',10,555.00,5550.00,'market','filled','2024-09-10T10:00:00.000Z','2024-09-10T10:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000ea','b00000000000000000000000000001401','a0000000000000000000000000000014','VOO','etf','buy',8,510.00,4080.00,'market','filled','2024-11-22T11:30:00.000Z','2024-11-22T11:30:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000eb','b00000000000000000000000000001401','a0000000000000000000000000000014','QQQ','etf','buy',6,490.00,2940.00,'market','filled','2025-02-08T09:15:00.000Z','2025-02-08T09:15:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000ec','b00000000000000000000000000001401','a0000000000000000000000000000014','VTI','etf','buy',12,270.00,3240.00,'market','filled','2025-05-15T14:00:00.000Z','2025-05-15T14:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000ed','b00000000000000000000000000001401','a0000000000000000000000000000014','SPY','etf','sell',5,580.00,2900.00,'market','filled','2025-07-28T10:30:00.000Z','2025-07-28T10:30:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000ee','b00000000000000000000000000001401','a0000000000000000000000000000014','IWM','etf','buy',15,225.00,3375.00,'market','filled','2025-09-18T11:00:00.000Z','2025-09-18T11:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000ef','b00000000000000000000000000001401','a0000000000000000000000000000014','VOO','etf','sell',4,540.00,2160.00,'market','filled','2025-11-25T09:45:00.000Z','2025-11-25T09:45:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000f0','b00000000000000000000000000001401','a0000000000000000000000000000014','QQQ','etf','buy',4,560.00,2240.00,'market','filled','2026-01-22T15:00:00.000Z','2026-01-22T15:00:00.000Z');

-- =============================================
-- USER 21: ryanp (New 2025, ~8 trades) — all 8
-- =============================================
INSERT INTO trades VALUES ('d00000000000000000000000000000f1','b00000000000000000000000000001501','a0000000000000000000000000000015','AAPL','stock','buy',10,238.00,2380.00,'market','filled','2025-06-10T10:00:00.000Z','2025-06-10T10:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000f2','b00000000000000000000000000001501','a0000000000000000000000000000015','SPY','etf','buy',5,575.00,2875.00,'market','filled','2025-07-15T11:30:00.000Z','2025-07-15T11:30:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000f3','b00000000000000000000000000001501','a0000000000000000000000000000015','MSFT','stock','buy',5,455.00,2275.00,'market','filled','2025-08-22T09:15:00.000Z','2025-08-22T09:15:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000f4','b00000000000000000000000000001501','a0000000000000000000000000000015','BTC','crypto','buy',0.02,100000.00,2000.00,'market','filled','2025-09-28T08:00:00.000Z','2025-09-28T08:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000f5','b00000000000000000000000000001501','a0000000000000000000000000000015','NVDA','stock','buy',2,1350.00,2700.00,'market','filled','2025-10-20T14:00:00.000Z','2025-10-20T14:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000f6','b00000000000000000000000000001501','a0000000000000000000000000000015','AAPL','stock','sell',5,250.00,1250.00,'market','filled','2025-11-18T10:30:00.000Z','2025-11-18T10:30:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000f7','b00000000000000000000000000001501','a0000000000000000000000000000015','GOOGL','stock','buy',8,212.00,1696.00,'market','filled','2025-12-15T11:00:00.000Z','2025-12-15T11:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000f8','b00000000000000000000000000001501','a0000000000000000000000000000015','ETH','crypto','buy',0.5,4100.00,2050.00,'market','filled','2026-01-28T09:45:00.000Z','2026-01-28T09:45:00.000Z');

-- =============================================
-- USER 22: taylorm (New aggressive, ~15 trades) — all 15
-- =============================================
INSERT INTO trades VALUES ('d00000000000000000000000000000f9','b00000000000000000000000000001601','a0000000000000000000000000000016','NVDA','stock','buy',10,1300.00,13000.00,'market','filled','2025-10-05T10:00:00.000Z','2025-10-05T10:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000fa','b00000000000000000000000000001601','a0000000000000000000000000000016','TSLA','stock','buy',30,270.00,8100.00,'market','filled','2025-10-12T11:30:00.000Z','2025-10-12T11:30:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000fb','b00000000000000000000000000001601','a0000000000000000000000000000016','BTC','crypto','buy',0.1,100000.00,10000.00,'market','filled','2025-10-20T08:15:00.000Z','2025-10-20T08:15:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000fc','b00000000000000000000000000001601','a0000000000000000000000000000016','AMD','stock','buy',50,180.00,9000.00,'market','filled','2025-10-28T09:30:00.000Z','2025-10-28T09:30:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000fd','b00000000000000000000000000001601','a0000000000000000000000000000016','NVDA','stock','sell',5,1380.00,6900.00,'market','filled','2025-11-05T14:00:00.000Z','2025-11-05T14:00:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000fe','b00000000000000000000000000001601','a0000000000000000000000000000016','SOL','crypto','buy',40,230.00,9200.00,'market','filled','2025-11-12T10:45:00.000Z','2025-11-12T10:45:00.000Z');
INSERT INTO trades VALUES ('d00000000000000000000000000000ff','b00000000000000000000000000001601','a0000000000000000000000000000016','META','stock','buy',10,630.00,6300.00,'market','filled','2025-11-22T11:15:00.000Z','2025-11-22T11:15:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000100','b00000000000000000000000000001601','a0000000000000000000000000000016','TSLA','stock','sell',15,295.00,4425.00,'market','filled','2025-12-03T15:00:00.000Z','2025-12-03T15:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000101','b00000000000000000000000000001601','a0000000000000000000000000000016','BTC','crypto','sell',0.05,108000.00,5400.00,'market','filled','2025-12-15T08:30:00.000Z','2025-12-15T08:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000102','b00000000000000000000000000001601','a0000000000000000000000000000016','PLTR','stock','buy',100,52.00,5200.00,'market','filled','2025-12-28T10:00:00.000Z','2025-12-28T10:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000103','b00000000000000000000000000001601','a0000000000000000000000000000016','AMD','stock','sell',25,195.00,4875.00,'market','filled','2026-01-08T09:15:00.000Z','2026-01-08T09:15:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000104','b00000000000000000000000000001601','a0000000000000000000000000000016','AMZN','stock','buy',15,265.00,3975.00,'market','filled','2026-01-18T14:30:00.000Z','2026-01-18T14:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000105','b00000000000000000000000000001601','a0000000000000000000000000000016','SOL','crypto','sell',20,255.00,5100.00,'market','filled','2026-01-28T11:00:00.000Z','2026-01-28T11:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000106','b00000000000000000000000000001601','a0000000000000000000000000000016','NVDA','stock','buy',3,1450.00,4350.00,'market','filled','2026-02-05T10:30:00.000Z','2026-02-05T10:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000107','b00000000000000000000000000001601','a0000000000000000000000000000016','GOOGL','stock','buy',10,218.00,2180.00,'market','filled','2026-02-10T09:45:00.000Z','2026-02-10T09:45:00.000Z');

-- =============================================
-- USER 23: morganl (New cautious, ~4 trades) — all 4
-- =============================================
INSERT INTO trades VALUES ('d0000000000000000000000000000108','b00000000000000000000000000001701','a0000000000000000000000000000017','SPY','etf','buy',5,570.00,2850.00,'market','filled','2025-07-20T10:00:00.000Z','2025-07-20T10:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000109','b00000000000000000000000000001701','a0000000000000000000000000000017','AAPL','stock','buy',5,242.00,1210.00,'market','filled','2025-09-15T11:30:00.000Z','2025-09-15T11:30:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000010a','b00000000000000000000000000001701','a0000000000000000000000000000017','VOO','etf','buy',3,530.00,1590.00,'market','filled','2025-11-28T09:15:00.000Z','2025-11-28T09:15:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000010b','b00000000000000000000000000001701','a0000000000000000000000000000017','MSFT','stock','buy',3,470.00,1410.00,'market','filled','2026-01-25T14:00:00.000Z','2026-01-25T14:00:00.000Z');

-- =============================================
-- USER 24: jordanc (New, ~5 trades) — all 5
-- =============================================
INSERT INTO trades VALUES ('d000000000000000000000000000010c','b00000000000000000000000000001801','a0000000000000000000000000000018','AAPL','stock','buy',8,237.00,1896.00,'market','filled','2025-06-18T10:00:00.000Z','2025-06-18T10:00:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000010d','b00000000000000000000000000001801','a0000000000000000000000000000018','BTC','crypto','buy',0.02,95000.00,1900.00,'market','filled','2025-08-10T08:30:00.000Z','2025-08-10T08:30:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000010e','b00000000000000000000000000001801','a0000000000000000000000000000018','SPY','etf','buy',3,585.00,1755.00,'market','filled','2025-10-22T11:15:00.000Z','2025-10-22T11:15:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000010f','b00000000000000000000000000001801','a0000000000000000000000000000018','NVDA','stock','buy',1,1380.00,1380.00,'market','filled','2025-12-08T14:30:00.000Z','2025-12-08T14:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000110','b00000000000000000000000000001801','a0000000000000000000000000000018','AAPL','stock','sell',4,252.00,1008.00,'market','filled','2026-02-03T10:00:00.000Z','2026-02-03T10:00:00.000Z');

-- =============================================
-- USER 25: sarahk (New active premium, ~12 trades) — all 12
-- =============================================
INSERT INTO trades VALUES ('d0000000000000000000000000000111','b00000000000000000000000000001901','a0000000000000000000000000000019','NVDA','stock','buy',8,1320.00,10560.00,'market','filled','2025-11-05T10:00:00.000Z','2025-11-05T10:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000112','b00000000000000000000000000001901','a0000000000000000000000000000019','AAPL','stock','buy',30,248.00,7440.00,'market','filled','2025-11-12T11:30:00.000Z','2025-11-12T11:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000113','b00000000000000000000000000001901','a0000000000000000000000000000019','BTC','crypto','buy',0.08,105000.00,8400.00,'market','filled','2025-11-20T08:15:00.000Z','2025-11-20T08:15:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000114','b00000000000000000000000000001901','a0000000000000000000000000000019','TSLA','stock','buy',20,285.00,5700.00,'market','filled','2025-11-28T09:30:00.000Z','2025-11-28T09:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000115','b00000000000000000000000000001901','a0000000000000000000000000000019','META','stock','buy',8,635.00,5080.00,'market','filled','2025-12-05T14:00:00.000Z','2025-12-05T14:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000116','b00000000000000000000000000001901','a0000000000000000000000000000019','NVDA','stock','sell',4,1400.00,5600.00,'market','filled','2025-12-15T10:45:00.000Z','2025-12-15T10:45:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000117','b00000000000000000000000000001901','a0000000000000000000000000000019','ETH','crypto','buy',2,4000.00,8000.00,'market','filled','2025-12-22T08:30:00.000Z','2025-12-22T08:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000118','b00000000000000000000000000001901','a0000000000000000000000000000019','SPY','etf','buy',10,595.00,5950.00,'market','filled','2026-01-05T11:15:00.000Z','2026-01-05T11:15:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000119','b00000000000000000000000000001901','a0000000000000000000000000000019','AAPL','stock','sell',15,255.00,3825.00,'market','filled','2026-01-15T15:00:00.000Z','2026-01-15T15:00:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000011a','b00000000000000000000000000001901','a0000000000000000000000000000019','AMZN','stock','buy',12,262.00,3144.00,'market','filled','2026-01-25T09:30:00.000Z','2026-01-25T09:30:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000011b','b00000000000000000000000000001901','a0000000000000000000000000000019','BTC','crypto','sell',0.04,110000.00,4400.00,'market','filled','2026-02-03T08:00:00.000Z','2026-02-03T08:00:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000011c','b00000000000000000000000000001901','a0000000000000000000000000000019','GOOGL','stock','buy',10,215.00,2150.00,'market','filled','2026-02-10T10:30:00.000Z','2026-02-10T10:30:00.000Z');

-- =============================================
-- USER 26: thomasb (Banned/unbanned, ~6 trades) — all 6
-- =============================================
INSERT INTO trades VALUES ('d000000000000000000000000000011d','b00000000000000000000000000001a01','a000000000000000000000000000001a','AAPL','stock','buy',15,185.00,2775.00,'market','filled','2024-06-15T10:00:00.000Z','2024-06-15T10:00:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000011e','b00000000000000000000000000001a01','a000000000000000000000000000001a','BTC','crypto','buy',0.05,62000.00,3100.00,'market','filled','2024-08-20T08:30:00.000Z','2024-08-20T08:30:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000011f','b00000000000000000000000000001a01','a000000000000000000000000000001a','TSLA','stock','buy',10,220.00,2200.00,'market','filled','2024-10-10T11:15:00.000Z','2024-10-10T11:15:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000120','b00000000000000000000000000001a01','a000000000000000000000000000001a','AAPL','stock','sell',8,225.00,1800.00,'market','filled','2025-02-15T14:00:00.000Z','2025-02-15T14:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000121','b00000000000000000000000000001a01','a000000000000000000000000000001a','SPY','etf','buy',5,585.00,2925.00,'market','filled','2025-09-10T10:30:00.000Z','2025-09-10T10:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000122','b00000000000000000000000000001a01','a000000000000000000000000000001a','NVDA','stock','buy',2,1350.00,2700.00,'market','filled','2026-01-20T09:45:00.000Z','2026-01-20T09:45:00.000Z');

-- =============================================
-- USER 27: isabellaA (Inactive after Jan 2025, ~3 trades) — all 3
-- =============================================
INSERT INTO trades VALUES ('d0000000000000000000000000000123','b00000000000000000000000000001b01','a000000000000000000000000000001b','AAPL','stock','buy',10,190.00,1900.00,'market','filled','2024-07-22T10:00:00.000Z','2024-07-22T10:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000124','b00000000000000000000000000001b01','a000000000000000000000000000001b','SPY','etf','buy',3,555.00,1665.00,'market','filled','2024-10-08T11:30:00.000Z','2024-10-08T11:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000125','b00000000000000000000000000001b01','a000000000000000000000000000001b','MSFT','stock','buy',5,425.00,2125.00,'market','filled','2025-01-10T09:15:00.000Z','2025-01-10T09:15:00.000Z');

-- =============================================
-- USER 28: willt (Losing trades, ~10 trades) — all 10
-- Bought high on speculative stocks, sold low
-- =============================================
INSERT INTO trades VALUES ('d0000000000000000000000000000126','b00000000000000000000000000001c01','a000000000000000000000000000001c','COIN','stock','buy',50,265.00,13250.00,'market','filled','2024-08-05T10:00:00.000Z','2024-08-05T10:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000127','b00000000000000000000000000001c01','a000000000000000000000000000001c','RIVN','stock','buy',200,18.00,3600.00,'market','filled','2024-09-12T11:30:00.000Z','2024-09-12T11:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000128','b00000000000000000000000000001c01','a000000000000000000000000000001c','LCID','stock','buy',500,4.50,2250.00,'market','filled','2024-10-20T09:15:00.000Z','2024-10-20T09:15:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000129','b00000000000000000000000000001c01','a000000000000000000000000000001c','COIN','stock','sell',25,180.00,4500.00,'market','filled','2024-12-15T14:00:00.000Z','2024-12-15T14:00:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000012a','b00000000000000000000000000001c01','a000000000000000000000000000001c','RIVN','stock','sell',100,12.00,1200.00,'market','filled','2025-02-28T10:30:00.000Z','2025-02-28T10:30:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000012b','b00000000000000000000000000001c01','a000000000000000000000000000001c','LCID','stock','sell',250,2.50,625.00,'market','filled','2025-05-10T11:00:00.000Z','2025-05-10T11:00:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000012c','b00000000000000000000000000001c01','a000000000000000000000000000001c','COIN','stock','sell',25,200.00,5000.00,'market','filled','2025-08-18T09:45:00.000Z','2025-08-18T09:45:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000012d','b00000000000000000000000000001c01','a000000000000000000000000000001c','RIVN','stock','sell',50,10.00,500.00,'market','filled','2025-10-05T15:00:00.000Z','2025-10-05T15:00:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000012e','b00000000000000000000000000001c01','a000000000000000000000000000001c','LCID','stock','sell',250,1.80,450.00,'market','filled','2025-12-12T10:30:00.000Z','2025-12-12T10:30:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000012f','b00000000000000000000000000001c01','a000000000000000000000000000001c','RIVN','stock','sell',50,8.00,400.00,'market','filled','2026-02-01T14:15:00.000Z','2026-02-01T14:15:00.000Z');

-- =============================================
-- USER 29: charlottew (Resets monthly, ~2 trades) — all 2
-- =============================================
INSERT INTO trades VALUES ('d0000000000000000000000000000130','b00000000000000000000000000001d01','a000000000000000000000000000001d','AAPL','stock','buy',5,222.00,1110.00,'market','filled','2024-09-10T10:00:00.000Z','2024-09-10T10:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000131','b00000000000000000000000000001d01','a000000000000000000000000000001d','SPY','etf','buy',2,555.00,1110.00,'market','filled','2025-06-15T11:30:00.000Z','2025-06-15T11:30:00.000Z');

-- =============================================
-- USER 30: admin_test (Admin testing, ~15 trades) — all 15
-- =============================================
INSERT INTO trades VALUES ('d0000000000000000000000000000132','b00000000000000000000000000001e01','a000000000000000000000000000001e','AAPL','stock','buy',100,182.00,18200.00,'market','filled','2024-02-10T10:00:00.000Z','2024-02-10T10:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000133','b00000000000000000000000000001e01','a000000000000000000000000000001e','BTC','crypto','buy',0.5,48000.00,24000.00,'market','filled','2024-03-15T08:30:00.000Z','2024-03-15T08:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000134','b00000000000000000000000000001e01','a000000000000000000000000000001e','SPY','etf','buy',50,505.00,25250.00,'market','filled','2024-04-22T11:15:00.000Z','2024-04-22T11:15:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000135','b00000000000000000000000000001e01','a000000000000000000000000000001e','NVDA','stock','buy',30,700.00,21000.00,'market','filled','2024-06-10T09:30:00.000Z','2024-06-10T09:30:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000136','b00000000000000000000000000001e01','a000000000000000000000000000001e','AAPL','stock','sell',50,195.00,9750.00,'market','filled','2024-08-05T14:00:00.000Z','2024-08-05T14:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000137','b00000000000000000000000000001e01','a000000000000000000000000000001e','ETH','crypto','buy',5,3100.00,15500.00,'market','filled','2024-09-18T10:45:00.000Z','2024-09-18T10:45:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000138','b00000000000000000000000000001e01','a000000000000000000000000000001e','BTC','crypto','sell',0.25,70000.00,17500.00,'market','filled','2024-11-22T08:00:00.000Z','2024-11-22T08:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000139','b00000000000000000000000000001e01','a000000000000000000000000000001e','MSFT','stock','buy',20,440.00,8800.00,'market','filled','2025-01-15T11:30:00.000Z','2025-01-15T11:30:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000013a','b00000000000000000000000000001e01','a000000000000000000000000000001e','SPY','etf','sell',25,575.00,14375.00,'market','filled','2025-04-08T15:00:00.000Z','2025-04-08T15:00:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000013b','b00000000000000000000000000001e01','a000000000000000000000000000001e','NVDA','stock','sell',15,1200.00,18000.00,'market','filled','2025-06-25T10:00:00.000Z','2025-06-25T10:00:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000013c','b00000000000000000000000000001e01','a000000000000000000000000000001e','ETH','crypto','sell',3,3800.00,11400.00,'market','filled','2025-08-12T09:15:00.000Z','2025-08-12T09:15:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000013d','b00000000000000000000000000001e01','a000000000000000000000000000001e','AAPL','stock','buy',40,248.00,9920.00,'market','filled','2025-10-28T14:30:00.000Z','2025-10-28T14:30:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000013e','b00000000000000000000000000001e01','a000000000000000000000000000001e','BTC','crypto','buy',0.1,108000.00,10800.00,'market','filled','2025-12-10T08:45:00.000Z','2025-12-10T08:45:00.000Z');
INSERT INTO trades VALUES ('d000000000000000000000000000013f','b00000000000000000000000000001e01','a000000000000000000000000000001e','QQQ','etf','buy',15,558.00,8370.00,'market','filled','2026-01-18T11:00:00.000Z','2026-01-18T11:00:00.000Z');
INSERT INTO trades VALUES ('d0000000000000000000000000000140','b00000000000000000000000000001e01','a000000000000000000000000000001e','MSFT','stock','sell',10,475.00,4750.00,'market','filled','2026-02-08T10:30:00.000Z','2026-02-08T10:30:00.000Z');

-- Table: portfolio_snapshots
-- Portfolio Snapshots (monthly, ~450 rows)
-- User 1 (traderpro): 2024-02-01 join, 20 months to 45000
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000001','b00000000000000000000000000000101','a0000000000000000000000000000001','2024-02-01',7500.00,17500.00,25000.00,0.00,0.00,0.00,0.00,'2024-02-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000002','b00000000000000000000000000000101','a0000000000000000000000000000001','2024-03-01',9275.00,17225.00,26500.00,320.00,1.28,1500.00,6.00,'2024-03-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000003','b00000000000000000000000000000101','a0000000000000000000000000000001','2024-04-01',8960.00,19040.00,28000.00,450.00,1.70,3000.00,12.00,'2024-04-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000004','b00000000000000000000000000000101','a0000000000000000000000000000001','2024-05-01',10500.00,19500.00,30000.00,580.00,2.07,5000.00,20.00,'2024-05-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000005','b00000000000000000000000000000101','a0000000000000000000000000000001','2024-06-01',9975.00,18525.00,28500.00,-420.00,-1.40,3500.00,14.00,'2024-06-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000006','b00000000000000000000000000000101','a0000000000000000000000000000001','2024-07-01',10850.00,20150.00,31000.00,650.00,2.28,6000.00,24.00,'2024-07-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000007','b00000000000000000000000000000101','a0000000000000000000000000000001','2024-08-01',11550.00,21450.00,33000.00,520.00,1.68,8000.00,32.00,'2024-08-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000008','b00000000000000000000000000000101','a0000000000000000000000000000001','2024-09-01',12250.00,22750.00,35000.00,700.00,2.12,10000.00,40.00,'2024-09-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000009','b00000000000000000000000000000101','a0000000000000000000000000000001','2024-10-01',10050.00,23450.00,33500.00,-380.00,-1.09,8500.00,34.00,'2024-10-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000000a','b00000000000000000000000000000101','a0000000000000000000000000000001','2024-11-01',12600.00,23400.00,36000.00,620.00,1.85,11000.00,44.00,'2024-11-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000000b','b00000000000000000000000000000101','a0000000000000000000000000000001','2024-12-01',13300.00,24700.00,38000.00,550.00,1.53,13000.00,52.00,'2024-12-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000000c','b00000000000000000000000000000101','a0000000000000000000000000000001','2025-01-01',14000.00,26000.00,40000.00,480.00,1.26,15000.00,60.00,'2025-01-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000000d','b00000000000000000000000000000101','a0000000000000000000000000000001','2025-02-01',13300.00,24700.00,38000.00,-500.00,-1.25,13000.00,52.00,'2025-02-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000000e','b00000000000000000000000000000101','a0000000000000000000000000000001','2025-03-01',14175.00,26325.00,40500.00,680.00,1.79,15500.00,62.00,'2025-03-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000000f','b00000000000000000000000000000101','a0000000000000000000000000000001','2025-04-01',14700.00,27300.00,42000.00,410.00,1.01,17000.00,68.00,'2025-04-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000010','b00000000000000000000000000000101','a0000000000000000000000000000001','2025-05-01',15225.00,28275.00,43500.00,350.00,0.83,18500.00,74.00,'2025-05-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000011','b00000000000000000000000000000101','a0000000000000000000000000000001','2025-06-01',14350.00,26650.00,41000.00,-480.00,-1.10,16000.00,64.00,'2025-06-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000012','b00000000000000000000000000000101','a0000000000000000000000000000001','2025-07-01',14875.00,27625.00,42500.00,390.00,0.95,17500.00,70.00,'2025-07-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000013','b00000000000000000000000000000101','a0000000000000000000000000000001','2025-08-01',15400.00,28600.00,44000.00,420.00,0.99,19000.00,76.00,'2025-08-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000014','b00000000000000000000000000000101','a0000000000000000000000000000001','2025-09-01',15750.00,29250.00,45000.00,280.00,0.64,20000.00,80.00,'2025-09-01T00:00:00.000Z');

-- User 2: 2024-02-15 join, 16 months to 38000
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000015','b00000000000000000000000000000201','a0000000000000000000000000000002','2024-03-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2024-03-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000016','b00000000000000000000000000000201','a0000000000000000000000000000002','2024-04-01',9100.00,16900.00,26000.00,250.00,1.00,1000.00,4.00,'2024-04-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000017','b00000000000000000000000000000201','a0000000000000000000000000000002','2024-05-01',9450.00,17550.00,27000.00,280.00,1.08,2000.00,8.00,'2024-05-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000018','b00000000000000000000000000000201','a0000000000000000000000000000002','2024-06-01',9975.00,18525.00,28500.00,350.00,1.30,3500.00,14.00,'2024-06-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000019','b00000000000000000000000000000201','a0000000000000000000000000000002','2024-07-01',10150.00,18850.00,29000.00,120.00,0.42,4000.00,16.00,'2024-07-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000001a','b00000000000000000000000000000201','a0000000000000000000000000000002','2024-08-01',10675.00,19825.00,30500.00,380.00,1.31,5500.00,22.00,'2024-08-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000001b','b00000000000000000000000000000201','a0000000000000000000000000000002','2024-09-01',10850.00,20150.00,31000.00,120.00,0.39,6000.00,24.00,'2024-09-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000001c','b00000000000000000000000000000201','a0000000000000000000000000000002','2024-10-01',11375.00,21125.00,32500.00,360.00,1.16,7500.00,30.00,'2024-10-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000001d','b00000000000000000000000000000201','a0000000000000000000000000000002','2024-11-01',11550.00,21450.00,33000.00,110.00,0.34,8000.00,32.00,'2024-11-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000001e','b00000000000000000000000000000201','a0000000000000000000000000000002','2024-12-01',11900.00,22100.00,34000.00,240.00,0.73,9000.00,36.00,'2024-12-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000001f','b00000000000000000000000000000201','a0000000000000000000000000000002','2025-01-01',12250.00,22750.00,35000.00,230.00,0.68,10000.00,40.00,'2025-01-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000020','b00000000000000000000000000000201','a0000000000000000000000000000002','2025-02-01',12740.00,23260.00,36000.00,260.00,0.74,11000.00,44.00,'2025-02-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000021','b00000000000000000000000000000201','a0000000000000000000000000000002','2025-03-01',12775.00,23725.00,36500.00,110.00,0.31,11500.00,46.00,'2025-03-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000022','b00000000000000000000000000000201','a0000000000000000000000000000002','2025-04-01',12950.00,24050.00,37000.00,120.00,0.33,12000.00,48.00,'2025-04-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000023','b00000000000000000000000000000201','a0000000000000000000000000000002','2025-05-01',13125.00,24375.00,37500.00,110.00,0.30,12500.00,50.00,'2025-05-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000024','b00000000000000000000000000000201','a0000000000000000000000000000002','2025-06-01',13300.00,24700.00,38000.00,120.00,0.32,13000.00,52.00,'2025-06-01T00:00:00.000Z');

-- User 3: 2024-03-01 join, 15 months to 42000
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000025','b00000000000000000000000000000301','a0000000000000000000000000000003','2024-03-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2024-03-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000026','b00000000000000000000000000000301','a0000000000000000000000000000003','2024-04-01',9450.00,17550.00,27000.00,480.00,1.92,2000.00,8.00,'2024-04-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000027','b00000000000000000000000000000301','a0000000000000000000000000000003','2024-05-01',10150.00,18850.00,29000.00,520.00,1.93,4000.00,16.00,'2024-05-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000028','b00000000000000000000000000000301','a0000000000000000000000000000003','2024-06-01',10880.00,20120.00,31000.00,490.00,1.69,6000.00,24.00,'2024-06-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000029','b00000000000000000000000000000301','a0000000000000000000000000000003','2024-07-01',11200.00,20800.00,32000.00,240.00,0.77,7000.00,28.00,'2024-07-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000002a','b00000000000000000000000000000301','a0000000000000000000000000000003','2024-08-01',11900.00,22100.00,34000.00,480.00,1.50,9000.00,36.00,'2024-08-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000002b','b00000000000000000000000000000301','a0000000000000000000000000000003','2024-09-01',12425.00,23075.00,35500.00,350.00,1.03,10500.00,42.00,'2024-09-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000002c','b00000000000000000000000000000301','a0000000000000000000000000000003','2024-10-01',12950.00,24050.00,37000.00,350.00,0.99,12000.00,48.00,'2024-10-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000002d','b00000000000000000000000000000301','a0000000000000000000000000000003','2024-11-01',13300.00,24700.00,38000.00,240.00,0.65,13000.00,52.00,'2024-11-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000002e','b00000000000000000000000000000301','a0000000000000000000000000000003','2024-12-01',13650.00,25350.00,39000.00,230.00,0.61,14000.00,56.00,'2024-12-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000002f','b00000000000000000000000000000301','a0000000000000000000000000000003','2025-01-01',14000.00,26000.00,40000.00,240.00,0.62,15000.00,60.00,'2025-01-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000030','b00000000000000000000000000000301','a0000000000000000000000000000003','2025-02-01',14175.00,26325.00,40500.00,110.00,0.28,15500.00,62.00,'2025-02-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000031','b00000000000000000000000000000301','a0000000000000000000000000000003','2025-03-01',14350.00,26650.00,41000.00,120.00,0.30,16000.00,64.00,'2025-03-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000032','b00000000000000000000000000000301','a0000000000000000000000000000003','2025-04-01',14525.00,26975.00,41500.00,110.00,0.27,16500.00,66.00,'2025-04-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000033','b00000000000000000000000000000301','a0000000000000000000000000000003','2025-05-01',14700.00,27300.00,42000.00,120.00,0.29,17000.00,68.00,'2025-05-01T00:00:00.000Z');

-- User 4: 2024-03-10 join, 15 months to 35000
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000034','b00000000000000000000000000000401','a0000000000000000000000000000004','2024-04-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2024-04-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000035','b00000000000000000000000000000401','a0000000000000000000000000000004','2024-05-01',9100.00,16900.00,26000.00,220.00,0.88,1000.00,4.00,'2024-05-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000036','b00000000000000000000000000000401','a0000000000000000000000000000004','2024-06-01',9450.00,17550.00,27000.00,240.00,0.92,2000.00,8.00,'2024-06-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000037','b00000000000000000000000000000401','a0000000000000000000000000000004','2024-07-01',9800.00,18200.00,28000.00,230.00,0.85,3000.00,12.00,'2024-07-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000038','b00000000000000000000000000000401','a0000000000000000000000000000004','2024-08-01',10150.00,18850.00,29000.00,230.00,0.82,4000.00,16.00,'2024-08-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000039','b00000000000000000000000000000401','a0000000000000000000000000000004','2024-09-01',10500.00,19500.00,30000.00,240.00,0.83,5000.00,20.00,'2024-09-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000003a','b00000000000000000000000000000401','a0000000000000000000000000000004','2024-10-01',9625.00,21375.00,31000.00,230.00,0.77,6000.00,24.00,'2024-10-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000003b','b00000000000000000000000000000401','a0000000000000000000000000000004','2024-11-01',10080.00,21920.00,32000.00,230.00,0.74,7000.00,28.00,'2024-11-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000003c','b00000000000000000000000000000401','a0000000000000000000000000000004','2024-12-01',9900.00,23100.00,33000.00,220.00,0.69,8000.00,32.00,'2024-12-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000003d','b00000000000000000000000000000401','a0000000000000000000000000000004','2025-01-01',10200.00,23800.00,34000.00,230.00,0.70,9000.00,36.00,'2025-01-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000003e','b00000000000000000000000000000401','a0000000000000000000000000000004','2025-02-01',10150.00,23350.00,33500.00,-110.00,-0.32,8500.00,34.00,'2025-02-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000003f','b00000000000000000000000000000401','a0000000000000000000000000000004','2025-03-01',10500.00,23500.00,34000.00,120.00,0.36,9000.00,36.00,'2025-03-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000040','b00000000000000000000000000000401','a0000000000000000000000000000004','2025-04-01',10500.00,24000.00,34500.00,110.00,0.32,9500.00,38.00,'2025-04-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000041','b00000000000000000000000000000401','a0000000000000000000000000000004','2025-05-01',10850.00,24150.00,35000.00,120.00,0.35,10000.00,40.00,'2025-05-01T00:00:00.000Z');

-- User 5: 2024-04-01 join, 12 months to 40000
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000042','b00000000000000000000000000000501','a0000000000000000000000000000005','2024-04-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2024-04-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000043','b00000000000000000000000000000501','a0000000000000000000000000000005','2024-05-01',9100.00,16900.00,26000.00,260.00,1.04,1000.00,4.00,'2024-05-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000044','b00000000000000000000000000000501','a0000000000000000000000000000005','2024-06-01',9625.00,17875.00,27500.00,380.00,1.46,2500.00,10.00,'2024-06-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000045','b00000000000000000000000000000501','a0000000000000000000000000000005','2024-07-01',10150.00,18850.00,29000.00,350.00,1.27,4000.00,16.00,'2024-07-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000046','b00000000000000000000000000000501','a0000000000000000000000000000005','2024-08-01',10850.00,20150.00,31000.00,480.00,1.66,6000.00,24.00,'2024-08-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000047','b00000000000000000000000000000501','a0000000000000000000000000000005','2024-09-01',11550.00,21450.00,33000.00,520.00,1.68,8000.00,32.00,'2024-09-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000048','b00000000000000000000000000000501','a0000000000000000000000000000005','2024-10-01',11900.00,22100.00,34000.00,240.00,0.73,9000.00,36.00,'2024-10-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000049','b00000000000000000000000000000501','a0000000000000000000000000000005','2024-11-01',12425.00,23075.00,35500.00,350.00,1.03,10500.00,42.00,'2024-11-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000004a','b00000000000000000000000000000501','a0000000000000000000000000000005','2024-12-01',12950.00,24050.00,37000.00,360.00,1.01,12000.00,48.00,'2024-12-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000004b','b00000000000000000000000000000501','a0000000000000000000000000000005','2025-01-01',13300.00,24700.00,38000.00,240.00,0.65,13000.00,52.00,'2025-01-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000004c','b00000000000000000000000000000501','a0000000000000000000000000000005','2025-02-01',13650.00,25350.00,39000.00,250.00,0.66,14000.00,56.00,'2025-02-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000004d','b00000000000000000000000000000501','a0000000000000000000000000000005','2025-03-01',14000.00,26000.00,40000.00,240.00,0.62,15000.00,60.00,'2025-03-01T00:00:00.000Z');

-- User 6: 2024-05-01 join, 11 months to 31000
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000004e','b00000000000000000000000000000601','a0000000000000000000000000000006','2024-05-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2024-05-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000004f','b00000000000000000000000000000601','a0000000000000000000000000000006','2024-06-01',9100.00,16400.00,25500.00,110.00,0.44,500.00,2.00,'2024-06-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000050','b00000000000000000000000000000601','a0000000000000000000000000000006','2024-07-01',9450.00,16550.00,26000.00,120.00,0.47,1000.00,4.00,'2024-07-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000051','b00000000000000000000000000000601','a0000000000000000000000000000006','2024-08-01',9800.00,17200.00,27000.00,230.00,0.88,2000.00,8.00,'2024-08-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000052','b00000000000000000000000000000601','a0000000000000000000000000000006','2024-09-01',9800.00,18200.00,28000.00,240.00,0.89,3000.00,12.00,'2024-09-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000053','b00000000000000000000000000000601','a0000000000000000000000000000006','2024-10-01',10150.00,18350.00,28500.00,110.00,0.39,3500.00,14.00,'2024-10-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000054','b00000000000000000000000000000601','a0000000000000000000000000000006','2024-11-01',10500.00,19000.00,29500.00,240.00,0.84,4500.00,18.00,'2024-11-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000055','b00000000000000000000000000000601','a0000000000000000000000000000006','2024-12-01',10500.00,19500.00,30000.00,110.00,0.37,5000.00,20.00,'2024-12-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000056','b00000000000000000000000000000601','a0000000000000000000000000000006','2025-01-01',10675.00,19825.00,30500.00,120.00,0.40,5500.00,22.00,'2025-01-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000057','b00000000000000000000000000000601','a0000000000000000000000000000006','2025-02-01',10500.00,20000.00,30500.00,-10.00,-0.03,5500.00,22.00,'2025-02-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000058','b00000000000000000000000000000601','a0000000000000000000000000000006','2025-03-01',10850.00,20150.00,31000.00,120.00,0.39,6000.00,24.00,'2025-03-01T00:00:00.000Z');

-- User 7: 2024-05-15 join, 11 months to 33000
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000059','b00000000000000000000000000000701','a0000000000000000000000000000007','2024-06-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2024-06-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000005a','b00000000000000000000000000000701','a0000000000000000000000000000007','2024-07-01',9275.00,16725.00,26000.00,230.00,0.92,1000.00,4.00,'2024-07-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000005b','b00000000000000000000000000000701','a0000000000000000000000000000007','2024-08-01',9450.00,17550.00,27000.00,240.00,0.92,2000.00,8.00,'2024-08-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000005c','b00000000000000000000000000000701','a0000000000000000000000000000007','2024-09-01',9800.00,18200.00,28000.00,230.00,0.85,3000.00,12.00,'2024-09-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000005d','b00000000000000000000000000000701','a0000000000000000000000000000007','2024-10-01',10150.00,18850.00,29000.00,230.00,0.82,4000.00,16.00,'2024-10-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000005e','b00000000000000000000000000000701','a0000000000000000000000000000007','2024-11-01',10500.00,19500.00,30000.00,240.00,0.83,5000.00,20.00,'2024-11-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000005f','b00000000000000000000000000000701','a0000000000000000000000000000007','2024-12-01',10850.00,20150.00,31000.00,240.00,0.80,6000.00,24.00,'2024-12-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000060','b00000000000000000000000000000701','a0000000000000000000000000000007','2025-01-01',10850.00,20650.00,31500.00,110.00,0.35,6500.00,26.00,'2025-01-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000061','b00000000000000000000000000000701','a0000000000000000000000000000007','2025-02-01',11200.00,20800.00,32000.00,120.00,0.38,7000.00,28.00,'2025-02-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000062','b00000000000000000000000000000701','a0000000000000000000000000000007','2025-03-01',11550.00,20950.00,32500.00,120.00,0.38,7500.00,30.00,'2025-03-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000063','b00000000000000000000000000000701','a0000000000000000000000000000007','2025-04-01',11550.00,21450.00,33000.00,120.00,0.37,8000.00,32.00,'2025-04-01T00:00:00.000Z');

-- User 8: 2024-06-01 join, 10 months to 26000
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000064','b00000000000000000000000000000801','a0000000000000000000000000000008','2024-06-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2024-06-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000065','b00000000000000000000000000000801','a0000000000000000000000000000008','2024-07-01',8925.00,16575.00,25500.00,110.00,0.44,500.00,2.00,'2024-07-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000066','b00000000000000000000000000000801','a0000000000000000000000000000008','2024-08-01',8750.00,16250.00,25000.00,-110.00,-0.43,0.00,0.00,'2024-08-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000067','b00000000000000000000000000000801','a0000000000000000000000000000008','2024-09-01',9100.00,16400.00,25500.00,110.00,0.44,500.00,2.00,'2024-09-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000068','b00000000000000000000000000000801','a0000000000000000000000000000008','2024-10-01',9100.00,16900.00,26000.00,120.00,0.47,1000.00,4.00,'2024-10-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000069','b00000000000000000000000000000801','a0000000000000000000000000000008','2024-11-01',8925.00,16575.00,25500.00,-110.00,-0.42,500.00,2.00,'2024-11-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000006a','b00000000000000000000000000000801','a0000000000000000000000000000008','2024-12-01',9100.00,16400.00,25500.00,10.00,0.04,500.00,2.00,'2024-12-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000006b','b00000000000000000000000000000801','a0000000000000000000000000000008','2025-01-01',9100.00,16900.00,26000.00,120.00,0.47,1000.00,4.00,'2025-01-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000006c','b00000000000000000000000000000801','a0000000000000000000000000000008','2025-02-01',8925.00,16575.00,25500.00,-110.00,-0.42,500.00,2.00,'2025-02-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000006d','b00000000000000000000000000000801','a0000000000000000000000000000008','2025-03-01',9100.00,16900.00,26000.00,120.00,0.47,1000.00,4.00,'2025-03-01T00:00:00.000Z');

-- User 9: 2024-06-15 join, 10 months to 28000
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000006e','b00000000000000000000000000000901','a0000000000000000000000000000009','2024-07-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2024-07-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000006f','b00000000000000000000000000000901','a0000000000000000000000000000009','2024-08-01',9100.00,16400.00,25500.00,110.00,0.44,500.00,2.00,'2024-08-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000070','b00000000000000000000000000000901','a0000000000000000000000000000009','2024-09-01',9100.00,16900.00,26000.00,120.00,0.47,1000.00,4.00,'2024-09-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000071','b00000000000000000000000000000901','a0000000000000000000000000000009','2024-10-01',9275.00,17225.00,26500.00,110.00,0.42,1500.00,6.00,'2024-10-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000072','b00000000000000000000000000000901','a0000000000000000000000000000009','2024-11-01',9450.00,17550.00,27000.00,120.00,0.45,2000.00,8.00,'2024-11-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000073','b00000000000000000000000000000901','a0000000000000000000000000000009','2024-12-01',9450.00,17550.00,27000.00,-10.00,-0.04,2000.00,8.00,'2024-12-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000074','b00000000000000000000000000000901','a0000000000000000000000000000009','2025-01-01',9625.00,17875.00,27500.00,120.00,0.44,2500.00,10.00,'2025-01-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000075','b00000000000000000000000000000901','a0000000000000000000000000000009','2025-02-01',9625.00,17875.00,27500.00,-10.00,-0.04,2500.00,10.00,'2025-02-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000076','b00000000000000000000000000000901','a0000000000000000000000000000009','2025-03-01',9800.00,18200.00,28000.00,120.00,0.44,3000.00,12.00,'2025-03-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000077','b00000000000000000000000000000901','a0000000000000000000000000000009','2025-04-01',9800.00,18200.00,28000.00,10.00,0.04,3000.00,12.00,'2025-04-01T00:00:00.000Z');

-- User 10: 2024-07-01 join, 9 months to 26000
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000078','b00000000000000000000000000000a01','a000000000000000000000000000000a','2024-07-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2024-07-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000079','b00000000000000000000000000000a01','a000000000000000000000000000000a','2024-08-01',8925.00,16575.00,25500.00,110.00,0.44,500.00,2.00,'2024-08-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000007a','b00000000000000000000000000000a01','a000000000000000000000000000000a','2024-09-01',8750.00,16250.00,25000.00,-110.00,-0.43,0.00,0.00,'2024-09-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000007b','b00000000000000000000000000000a01','a000000000000000000000000000000a','2024-10-01',8925.00,16575.00,25500.00,110.00,0.44,500.00,2.00,'2024-10-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000007c','b00000000000000000000000000000a01','a000000000000000000000000000000a','2024-11-01',8750.00,16750.00,25500.00,10.00,0.04,500.00,2.00,'2024-11-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000007d','b00000000000000000000000000000a01','a000000000000000000000000000000a','2024-12-01',9100.00,16400.00,25500.00,-10.00,-0.04,500.00,2.00,'2024-12-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000007e','b00000000000000000000000000000a01','a000000000000000000000000000000a','2025-01-01',9100.00,16900.00,26000.00,120.00,0.47,1000.00,4.00,'2025-01-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000007f','b00000000000000000000000000000a01','a000000000000000000000000000000a','2025-02-01',8925.00,16575.00,25500.00,-110.00,-0.42,500.00,2.00,'2025-02-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000080','b00000000000000000000000000000a01','a000000000000000000000000000000a','2025-03-01',9100.00,16900.00,26000.00,120.00,0.47,1000.00,4.00,'2025-03-01T00:00:00.000Z');

-- User 11: 2024-07-15 join, 9 months to 34000
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000081','b00000000000000000000000000000b01','a000000000000000000000000000000b','2024-08-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2024-08-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000082','b00000000000000000000000000000b01','a000000000000000000000000000000b','2024-09-01',9100.00,16900.00,26000.00,240.00,0.96,1000.00,4.00,'2024-09-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000083','b00000000000000000000000000000b01','a000000000000000000000000000000b','2024-10-01',9800.00,17700.00,27500.00,350.00,1.35,2500.00,10.00,'2024-10-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000084','b00000000000000000000000000000b01','a000000000000000000000000000000b','2024-11-01',10150.00,18850.00,29000.00,350.00,1.27,4000.00,16.00,'2024-11-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000085','b00000000000000000000000000000b01','a000000000000000000000000000000b','2024-12-01',10500.00,19500.00,30000.00,230.00,0.79,5000.00,20.00,'2024-12-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000086','b00000000000000000000000000000b01','a000000000000000000000000000000b','2025-01-01',10850.00,20650.00,31500.00,350.00,1.17,6500.00,26.00,'2025-01-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000087','b00000000000000000000000000000b01','a000000000000000000000000000000b','2025-02-01',11200.00,21300.00,32500.00,240.00,0.76,7500.00,30.00,'2025-02-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000088','b00000000000000000000000000000b01','a000000000000000000000000000000b','2025-03-01',11550.00,21950.00,33500.00,240.00,0.74,8500.00,34.00,'2025-03-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000089','b00000000000000000000000000000b01','a000000000000000000000000000000b','2025-04-01',11900.00,22100.00,34000.00,120.00,0.36,9000.00,36.00,'2025-04-01T00:00:00.000Z');

-- User 12: 2024-08-01 join, 8 months to 29000
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000008a','b00000000000000000000000000000c01','a000000000000000000000000000000c','2024-08-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2024-08-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000008b','b00000000000000000000000000000c01','a000000000000000000000000000000c','2024-09-01',9100.00,16400.00,25500.00,110.00,0.44,500.00,2.00,'2024-09-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000008c','b00000000000000000000000000000c01','a000000000000000000000000000000c','2024-10-01',9100.00,16900.00,26000.00,120.00,0.47,1000.00,4.00,'2024-10-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000008d','b00000000000000000000000000000c01','a000000000000000000000000000000c','2024-11-01',9450.00,17550.00,27000.00,230.00,0.88,2000.00,8.00,'2024-11-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000008e','b00000000000000000000000000000c01','a000000000000000000000000000000c','2024-12-01',9625.00,17875.00,27500.00,110.00,0.41,2500.00,10.00,'2024-12-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000008f','b00000000000000000000000000000c01','a000000000000000000000000000000c','2025-01-01',9800.00,18200.00,28000.00,120.00,0.44,3000.00,12.00,'2025-01-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000090','b00000000000000000000000000000c01','a000000000000000000000000000000c','2025-02-01',9975.00,18525.00,28500.00,120.00,0.43,3500.00,14.00,'2025-02-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000091','b00000000000000000000000000000c01','a000000000000000000000000000000c','2025-03-01',10150.00,18850.00,29000.00,120.00,0.42,4000.00,16.00,'2025-03-01T00:00:00.000Z');

-- User 13: 2024-08-15 join, 7 months to 24000
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000092','b00000000000000000000000000000d01','a000000000000000000000000000000d','2024-09-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2024-09-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000093','b00000000000000000000000000000d01','a000000000000000000000000000000d','2024-10-01',8575.00,15925.00,24500.00,-110.00,-0.44,-500.00,-2.00,'2024-10-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000094','b00000000000000000000000000000d01','a000000000000000000000000000000d','2024-11-01',8575.00,15925.00,24500.00,10.00,0.04,-500.00,-2.00,'2024-11-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000095','b00000000000000000000000000000d01','a000000000000000000000000000000d','2024-12-01',8400.00,15600.00,24000.00,-110.00,-0.45,-1000.00,-4.00,'2024-12-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000096','b00000000000000000000000000000d01','a000000000000000000000000000000d','2025-01-01',8575.00,15925.00,24500.00,110.00,0.46,-500.00,-2.00,'2025-01-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000097','b00000000000000000000000000000d01','a000000000000000000000000000000d','2025-02-01',8400.00,15600.00,24000.00,-110.00,-0.45,-1000.00,-4.00,'2025-02-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000098','b00000000000000000000000000000d01','a000000000000000000000000000000d','2025-03-01',8400.00,15600.00,24000.00,10.00,0.04,-1000.00,-4.00,'2025-03-01T00:00:00.000Z');

-- User 14: 2024-09-01 join, 7 months to 26500
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000099','b00000000000000000000000000000e01','a000000000000000000000000000000e','2024-09-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2024-09-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000009a','b00000000000000000000000000000e01','a000000000000000000000000000000e','2024-10-01',8925.00,16575.00,25500.00,110.00,0.44,500.00,2.00,'2024-10-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000009b','b00000000000000000000000000000e01','a000000000000000000000000000000e','2024-11-01',8750.00,16250.00,25000.00,-110.00,-0.43,0.00,0.00,'2024-11-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000009c','b00000000000000000000000000000e01','a000000000000000000000000000000e','2024-12-01',9100.00,16400.00,25500.00,110.00,0.44,500.00,2.00,'2024-12-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000009d','b00000000000000000000000000000e01','a000000000000000000000000000000e','2025-01-01',9100.00,16900.00,26000.00,120.00,0.47,1000.00,4.00,'2025-01-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000009e','b00000000000000000000000000000e01','a000000000000000000000000000000e','2025-02-01',9275.00,17225.00,26500.00,120.00,0.46,1500.00,6.00,'2025-02-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000009f','b00000000000000000000000000000e01','a000000000000000000000000000000e','2025-03-01',9275.00,17225.00,26500.00,10.00,0.04,1500.00,6.00,'2025-03-01T00:00:00.000Z');

-- User 15: 2024-09-15 join, 6 months to 25500
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000a0','b00000000000000000000000000000f01','a000000000000000000000000000000f','2024-10-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2024-10-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000a1','b00000000000000000000000000000f01','a000000000000000000000000000000f','2024-11-01',8925.00,16575.00,25500.00,110.00,0.44,500.00,2.00,'2024-11-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000a2','b00000000000000000000000000000f01','a000000000000000000000000000000f','2024-12-01',8750.00,16250.00,25000.00,-110.00,-0.43,0.00,0.00,'2024-12-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000a3','b00000000000000000000000000000f01','a000000000000000000000000000000f','2025-01-01',8925.00,16575.00,25500.00,110.00,0.44,500.00,2.00,'2025-01-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000a4','b00000000000000000000000000000f01','a000000000000000000000000000000f','2025-02-01',8750.00,16250.00,25000.00,-110.00,-0.43,0.00,0.00,'2025-02-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000a5','b00000000000000000000000000000f01','a000000000000000000000000000000f','2025-03-01',8925.00,16575.00,25500.00,110.00,0.44,500.00,2.00,'2025-03-01T00:00:00.000Z');

-- User 16: 2024-10-01 join, 6 months to 24500
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000a6','b00000000000000000000000000001001','a0000000000000000000000000000010','2024-10-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2024-10-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000a7','b00000000000000000000000000001001','a0000000000000000000000000000010','2024-11-01',8575.00,15925.00,24500.00,-110.00,-0.44,-500.00,-2.00,'2024-11-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000a8','b00000000000000000000000000001001','a0000000000000000000000000000010','2024-12-01',8750.00,16250.00,25000.00,110.00,0.45,0.00,0.00,'2024-12-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000a9','b00000000000000000000000000001001','a0000000000000000000000000000010','2025-01-01',8575.00,15925.00,24500.00,-110.00,-0.44,-500.00,-2.00,'2025-01-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000aa','b00000000000000000000000000001001','a0000000000000000000000000000010','2025-02-01',8750.00,16250.00,25000.00,110.00,0.45,0.00,0.00,'2025-02-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000ab','b00000000000000000000000000001001','a0000000000000000000000000000010','2025-03-01',8575.00,15925.00,24500.00,-110.00,-0.44,-500.00,-2.00,'2025-03-01T00:00:00.000Z');

-- User 17: 2024-10-15 join, 6 months to 27000
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000ac','b00000000000000000000000000001101','a0000000000000000000000000000011','2024-11-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2024-11-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000ad','b00000000000000000000000000001101','a0000000000000000000000000000011','2024-12-01',9100.00,16400.00,25500.00,110.00,0.44,500.00,2.00,'2024-12-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000ae','b00000000000000000000000000001101','a0000000000000000000000000000011','2025-01-01',9100.00,16900.00,26000.00,120.00,0.47,1000.00,4.00,'2025-01-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000af','b00000000000000000000000000001101','a0000000000000000000000000000011','2025-02-01',9450.00,17050.00,26500.00,110.00,0.42,1500.00,6.00,'2025-02-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000b0','b00000000000000000000000000001101','a0000000000000000000000000000011','2025-03-01',9450.00,17550.00,27000.00,120.00,0.45,2000.00,8.00,'2025-03-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000b1','b00000000000000000000000000001101','a0000000000000000000000000000011','2025-04-01',9450.00,17550.00,27000.00,10.00,0.04,2000.00,8.00,'2025-04-01T00:00:00.000Z');

-- User 18: 2024-11-01 join, 5 months to 23500
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000b2','b00000000000000000000000000001201','a0000000000000000000000000000012','2024-11-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2024-11-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000b3','b00000000000000000000000000001201','a0000000000000000000000000000012','2024-12-01',8575.00,15925.00,24500.00,-110.00,-0.44,-500.00,-2.00,'2024-12-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000b4','b00000000000000000000000000001201','a0000000000000000000000000000012','2025-01-01',8400.00,15600.00,24000.00,-110.00,-0.45,-1000.00,-4.00,'2025-01-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000b5','b00000000000000000000000000001201','a0000000000000000000000000000012','2025-02-01',8225.00,15275.00,23500.00,-110.00,-0.46,-1500.00,-6.00,'2025-02-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000b6','b00000000000000000000000000001201','a0000000000000000000000000000012','2025-03-01',8225.00,15275.00,23500.00,10.00,0.04,-1500.00,-6.00,'2025-03-01T00:00:00.000Z');

-- User 19: 2024-11-15 join, 5 months to 25000
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000b7','b00000000000000000000000000001301','a0000000000000000000000000000013','2024-12-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2024-12-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000b8','b00000000000000000000000000001301','a0000000000000000000000000000013','2025-01-01',8925.00,16575.00,25500.00,110.00,0.44,500.00,2.00,'2025-01-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000b9','b00000000000000000000000000001301','a0000000000000000000000000000013','2025-02-01',8575.00,16425.00,25000.00,-110.00,-0.43,0.00,0.00,'2025-02-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000ba','b00000000000000000000000000001301','a0000000000000000000000000000013','2025-03-01',8750.00,16250.00,25000.00,10.00,0.04,0.00,0.00,'2025-03-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000bb','b00000000000000000000000000001301','a0000000000000000000000000000013','2025-04-01',8750.00,16250.00,25000.00,10.00,0.04,0.00,0.00,'2025-04-01T00:00:00.000Z');

-- User 20: 2024-12-01 join, 4 months to 26000
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000bc','b00000000000000000000000000001401','a0000000000000000000000000000014','2024-12-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2024-12-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000bd','b00000000000000000000000000001401','a0000000000000000000000000000014','2025-01-01',8925.00,16575.00,25500.00,110.00,0.44,500.00,2.00,'2025-01-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000be','b00000000000000000000000000001401','a0000000000000000000000000000014','2025-02-01',8925.00,16575.00,25500.00,-10.00,-0.04,500.00,2.00,'2025-02-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000bf','b00000000000000000000000000001401','a0000000000000000000000000000014','2025-03-01',9100.00,16900.00,26000.00,120.00,0.47,1000.00,4.00,'2025-03-01T00:00:00.000Z');

-- User 21: 2025-06-01 join, 4 months to 26500
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000c0','b00000000000000000000000000001501','a0000000000000000000000000000015','2025-06-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2025-06-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000c1','b00000000000000000000000000001501','a0000000000000000000000000000015','2025-07-01',8925.00,16575.00,25500.00,110.00,0.44,500.00,2.00,'2025-07-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000c2','b00000000000000000000000000001501','a0000000000000000000000000000015','2025-08-01',9100.00,16900.00,26000.00,120.00,0.47,1000.00,4.00,'2025-08-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000c3','b00000000000000000000000000001501','a0000000000000000000000000000015','2025-09-01',9275.00,17225.00,26500.00,120.00,0.46,1500.00,6.00,'2025-09-01T00:00:00.000Z');

-- User 22: 2025-09-01 join, 2 months to 27000
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000c4','b00000000000000000000000000001601','a0000000000000000000000000000016','2025-09-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2025-09-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000c5','b00000000000000000000000000001601','a0000000000000000000000000000016','2025-10-01',9100.00,16900.00,26000.00,240.00,0.96,1000.00,4.00,'2025-10-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000c6','b00000000000000000000000000001601','a0000000000000000000000000000016','2025-11-01',9450.00,17550.00,27000.00,240.00,0.92,2000.00,8.00,'2025-11-01T00:00:00.000Z');

-- User 23: 2025-07-15 join, 3 months to 24000
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000c7','b00000000000000000000000000001701','a0000000000000000000000000000017','2025-08-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2025-08-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000c8','b00000000000000000000000000001701','a0000000000000000000000000000017','2025-09-01',8575.00,15925.00,24500.00,-110.00,-0.44,-500.00,-2.00,'2025-09-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000c9','b00000000000000000000000000001701','a0000000000000000000000000000017','2025-10-01',8400.00,15600.00,24000.00,-110.00,-0.45,-1000.00,-4.00,'2025-10-01T00:00:00.000Z');

-- User 24: 2025-08-01 join, 3 months to 25500
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000ca','b00000000000000000000000000001801','a0000000000000000000000000000018','2025-08-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2025-08-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000cb','b00000000000000000000000000001801','a0000000000000000000000000000018','2025-09-01',8925.00,16575.00,25500.00,110.00,0.44,500.00,2.00,'2025-09-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000cc','b00000000000000000000000000001801','a0000000000000000000000000000018','2025-10-01',8925.00,16575.00,25500.00,10.00,0.04,500.00,2.00,'2025-10-01T00:00:00.000Z');

-- User 25: 2025-10-01 join, 2 months to 27500
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000cd','b00000000000000000000000000001901','a0000000000000000000000000000019','2025-10-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2025-10-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000ce','b00000000000000000000000000001901','a0000000000000000000000000000019','2025-11-01',9275.00,16975.00,26250.00,300.00,1.20,1250.00,5.00,'2025-11-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000cf','b00000000000000000000000000001901','a0000000000000000000000000000019','2025-12-01',9625.00,17875.00,27500.00,300.00,1.14,2500.00,10.00,'2025-12-01T00:00:00.000Z');

-- User 26: 2024-04-15 join, 12 months to 24000
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000d0','b00000000000000000000000000001a01','a000000000000000000000000000001a','2024-05-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2024-05-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000d1','b00000000000000000000000000001a01','a000000000000000000000000000001a','2024-06-01',8575.00,15925.00,24500.00,-110.00,-0.44,-500.00,-2.00,'2024-06-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000d2','b00000000000000000000000000001a01','a000000000000000000000000000001a','2024-07-01',8750.00,16250.00,25000.00,110.00,0.45,0.00,0.00,'2024-07-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000d3','b00000000000000000000000000001a01','a000000000000000000000000000001a','2024-08-01',8575.00,15925.00,24500.00,-110.00,-0.44,-500.00,-2.00,'2024-08-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000d4','b00000000000000000000000000001a01','a000000000000000000000000000001a','2024-09-01',8400.00,15600.00,24000.00,-110.00,-0.45,-1000.00,-4.00,'2024-09-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000d5','b00000000000000000000000000001a01','a000000000000000000000000000001a','2024-10-01',8575.00,15925.00,24500.00,110.00,0.46,-500.00,-2.00,'2024-10-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000d6','b00000000000000000000000000001a01','a000000000000000000000000000001a','2024-11-01',8400.00,15600.00,24000.00,-110.00,-0.45,-1000.00,-4.00,'2024-11-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000d7','b00000000000000000000000000001a01','a000000000000000000000000000001a','2024-12-01',8575.00,15925.00,24500.00,110.00,0.46,-500.00,-2.00,'2024-12-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000d8','b00000000000000000000000000001a01','a000000000000000000000000000001a','2025-01-01',8400.00,15600.00,24000.00,-110.00,-0.45,-1000.00,-4.00,'2025-01-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000d9','b00000000000000000000000000001a01','a000000000000000000000000000001a','2025-02-01',8575.00,15925.00,24500.00,110.00,0.46,-500.00,-2.00,'2025-02-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000da','b00000000000000000000000000001a01','a000000000000000000000000000001a','2025-03-01',8400.00,15600.00,24000.00,-110.00,-0.45,-1000.00,-4.00,'2025-03-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000db','b00000000000000000000000000001a01','a000000000000000000000000000001a','2025-04-01',8400.00,15600.00,24000.00,10.00,0.04,-1000.00,-4.00,'2025-04-01T00:00:00.000Z');

-- User 27: 2024-05-01 join, 11 months to 25500
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000dc','b00000000000000000000000000001b01','a000000000000000000000000000001b','2024-05-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2024-05-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000dd','b00000000000000000000000000001b01','a000000000000000000000000000001b','2024-06-01',8750.00,16250.00,25000.00,-10.00,-0.04,0.00,0.00,'2024-06-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000de','b00000000000000000000000000001b01','a000000000000000000000000000001b','2024-07-01',8925.00,16575.00,25500.00,110.00,0.44,500.00,2.00,'2024-07-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000df','b00000000000000000000000000001b01','a000000000000000000000000000001b','2024-08-01',8750.00,16250.00,25000.00,-110.00,-0.43,0.00,0.00,'2024-08-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000e0','b00000000000000000000000000001b01','a000000000000000000000000000001b','2024-09-01',8925.00,16575.00,25500.00,110.00,0.44,500.00,2.00,'2024-09-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000e1','b00000000000000000000000000001b01','a000000000000000000000000000001b','2024-10-01',8750.00,16250.00,25000.00,-110.00,-0.43,0.00,0.00,'2024-10-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000e2','b00000000000000000000000000001b01','a000000000000000000000000000001b','2024-11-01',8925.00,16575.00,25500.00,110.00,0.44,500.00,2.00,'2024-11-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000e3','b00000000000000000000000000001b01','a000000000000000000000000000001b','2024-12-01',8750.00,16250.00,25000.00,-110.00,-0.43,0.00,0.00,'2024-12-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000e4','b00000000000000000000000000001b01','a000000000000000000000000000001b','2025-01-01',8925.00,16575.00,25500.00,110.00,0.44,500.00,2.00,'2025-01-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000e5','b00000000000000000000000000001b01','a000000000000000000000000000001b','2025-02-01',8925.00,16575.00,25500.00,10.00,0.04,500.00,2.00,'2025-02-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000e6','b00000000000000000000000000001b01','a000000000000000000000000000001b','2025-03-01',8925.00,16575.00,25500.00,10.00,0.04,500.00,2.00,'2025-03-01T00:00:00.000Z');

-- User 28 (losses): 2024-06-01 join, 13 months to 18000
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000e7','b00000000000000000000000000001c01','a000000000000000000000000000001c','2024-06-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2024-06-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000e8','b00000000000000000000000000001c01','a000000000000000000000000000001c','2024-07-01',8575.00,15925.00,24500.00,-110.00,-0.44,-500.00,-2.00,'2024-07-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000e9','b00000000000000000000000000001c01','a000000000000000000000000000001c','2024-08-01',8400.00,15600.00,24000.00,-110.00,-0.45,-1000.00,-4.00,'2024-08-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000ea','b00000000000000000000000000001c01','a000000000000000000000000000001c','2024-09-01',8050.00,14950.00,23000.00,-230.00,-0.96,-2000.00,-8.00,'2024-09-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000eb','b00000000000000000000000000001c01','a000000000000000000000000000001c','2024-10-01',7875.00,14625.00,22500.00,-110.00,-0.48,-2500.00,-10.00,'2024-10-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000ec','b00000000000000000000000000001c01','a000000000000000000000000000001c','2024-11-01',7700.00,14300.00,22000.00,-110.00,-0.49,-3000.00,-12.00,'2024-11-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000ed','b00000000000000000000000000001c01','a000000000000000000000000000001c','2024-12-01',7350.00,13650.00,21000.00,-230.00,-1.05,-4000.00,-16.00,'2024-12-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000ee','b00000000000000000000000000001c01','a000000000000000000000000000001c','2025-01-01',7175.00,13325.00,20500.00,-110.00,-0.52,-4500.00,-18.00,'2025-01-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000ef','b00000000000000000000000000001c01','a000000000000000000000000000001c','2025-02-01',7000.00,13000.00,20000.00,-110.00,-0.54,-5000.00,-20.00,'2025-02-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000f0','b00000000000000000000000000001c01','a000000000000000000000000000001c','2025-03-01',6825.00,12675.00,19500.00,-110.00,-0.55,-5500.00,-22.00,'2025-03-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000f1','b00000000000000000000000000001c01','a000000000000000000000000000001c','2025-04-01',6650.00,12350.00,19000.00,-110.00,-0.56,-6000.00,-24.00,'2025-04-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000f2','b00000000000000000000000000001c01','a000000000000000000000000000001c','2025-05-01',6475.00,12025.00,18500.00,-110.00,-0.58,-6500.00,-26.00,'2025-05-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000f3','b00000000000000000000000000001c01','a000000000000000000000000000001c','2025-06-01',6300.00,11700.00,18000.00,-110.00,-0.59,-7000.00,-28.00,'2025-06-01T00:00:00.000Z');

-- User 29: 2024-07-01 join, 9 months to 25000
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000f4','b00000000000000000000000000001d01','a000000000000000000000000000001d','2024-07-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2024-07-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000f5','b00000000000000000000000000001d01','a000000000000000000000000000001d','2024-08-01',8925.00,16575.00,25500.00,110.00,0.44,500.00,2.00,'2024-08-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000f6','b00000000000000000000000000001d01','a000000000000000000000000000001d','2024-09-01',8750.00,16250.00,25000.00,-110.00,-0.43,0.00,0.00,'2024-09-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000f7','b00000000000000000000000000001d01','a000000000000000000000000000001d','2024-10-01',8925.00,16575.00,25500.00,110.00,0.44,500.00,2.00,'2024-10-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000f8','b00000000000000000000000000001d01','a000000000000000000000000000001d','2024-11-01',8750.00,16250.00,25000.00,-110.00,-0.43,0.00,0.00,'2024-11-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000f9','b00000000000000000000000000001d01','a000000000000000000000000000001d','2024-12-01',8925.00,16575.00,25500.00,110.00,0.44,500.00,2.00,'2024-12-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000fa','b00000000000000000000000000001d01','a000000000000000000000000000001d','2025-01-01',8750.00,16250.00,25000.00,-110.00,-0.43,0.00,0.00,'2025-01-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000fb','b00000000000000000000000000001d01','a000000000000000000000000000001d','2025-02-01',8925.00,16575.00,25500.00,110.00,0.44,500.00,2.00,'2025-02-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000fc','b00000000000000000000000000001d01','a000000000000000000000000000001d','2025-03-01',8750.00,16250.00,25000.00,-110.00,-0.43,0.00,0.00,'2025-03-01T00:00:00.000Z');

-- User 30: 2024-01-15 join, 21 months to 25200
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000fd','b00000000000000000000000000001e01','a000000000000000000000000000001e','2024-02-01',8750.00,16250.00,25000.00,0.00,0.00,0.00,0.00,'2024-02-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000fe','b00000000000000000000000000001e01','a000000000000000000000000000001e','2024-03-01',8925.00,16575.00,25500.00,110.00,0.44,500.00,2.00,'2024-03-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e00000000000000000000000000000ff','b00000000000000000000000000001e01','a000000000000000000000000000001e','2024-04-01',8750.00,16250.00,25000.00,-110.00,-0.43,0.00,0.00,'2024-04-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000100','b00000000000000000000000000001e01','a000000000000000000000000000001e','2024-05-01',8925.00,16575.00,25500.00,110.00,0.44,500.00,2.00,'2024-05-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000101','b00000000000000000000000000001e01','a000000000000000000000000000001e','2024-06-01',8750.00,16250.00,25000.00,-110.00,-0.43,0.00,0.00,'2024-06-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000102','b00000000000000000000000000001e01','a000000000000000000000000000001e','2024-07-01',8925.00,16575.00,25500.00,110.00,0.44,500.00,2.00,'2024-07-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000103','b00000000000000000000000000001e01','a000000000000000000000000000001e','2024-08-01',8750.00,16250.00,25000.00,-110.00,-0.43,0.00,0.00,'2024-08-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000104','b00000000000000000000000000001e01','a000000000000000000000000000001e','2024-09-01',8925.00,16575.00,25500.00,110.00,0.44,500.00,2.00,'2024-09-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000105','b00000000000000000000000000001e01','a000000000000000000000000000001e','2024-10-01',8750.00,16250.00,25000.00,-110.00,-0.43,0.00,0.00,'2024-10-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000106','b00000000000000000000000000001e01','a000000000000000000000000000001e','2024-11-01',8575.00,16425.00,25000.00,-10.00,-0.04,0.00,0.00,'2024-11-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000107','b00000000000000000000000000001e01','a000000000000000000000000000001e','2024-12-01',8925.00,16575.00,25500.00,110.00,0.44,500.00,2.00,'2024-12-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000108','b00000000000000000000000000001e01','a000000000000000000000000000001e','2025-01-01',8750.00,16250.00,25000.00,-110.00,-0.43,0.00,0.00,'2025-01-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000109','b00000000000000000000000000001e01','a000000000000000000000000000001e','2025-02-01',8925.00,16575.00,25500.00,110.00,0.44,500.00,2.00,'2025-02-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000010a','b00000000000000000000000000001e01','a000000000000000000000000000001e','2025-03-01',8750.00,16250.00,25000.00,-110.00,-0.43,0.00,0.00,'2025-03-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000010b','b00000000000000000000000000001e01','a000000000000000000000000000001e','2025-04-01',8750.00,16450.00,25200.00,50.00,0.20,200.00,0.80,'2025-04-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000010c','b00000000000000000000000000001e01','a000000000000000000000000000001e','2025-05-01',8750.00,16250.00,25000.00,-50.00,-0.20,0.00,0.00,'2025-05-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000010d','b00000000000000000000000000001e01','a000000000000000000000000000001e','2025-06-01',8750.00,16250.00,25000.00,10.00,0.04,0.00,0.00,'2025-06-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000010e','b00000000000000000000000000001e01','a000000000000000000000000000001e','2025-07-01',8750.00,16250.00,25000.00,-10.00,-0.04,0.00,0.00,'2025-07-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e000000000000000000000000000010f','b00000000000000000000000000001e01','a000000000000000000000000000001e','2025-08-01',8820.00,16380.00,25200.00,50.00,0.20,200.00,0.80,'2025-08-01T00:00:00.000Z');
INSERT INTO portfolio_snapshots VALUES ('e0000000000000000000000000000110','b00000000000000000000000000001e01','a000000000000000000000000000001e','2025-09-01',8820.00,16380.00,25200.00,10.00,0.04,200.00,0.80,'2025-09-01T00:00:00.000Z');

-- Table: competitions
-- 24 completed/paid_out monthly competitions + 1 active
INSERT INTO competitions VALUES ('f100000000000000000000202402','monthly','paid_out','2024-02-01','2024-02-29',1000.00,12,'2024-02-01T00:00:00.000Z');
INSERT INTO competitions VALUES ('f100000000000000000000202403','monthly','paid_out','2024-03-01','2024-03-31',1200.00,14,'2024-03-01T00:00:00.000Z');
INSERT INTO competitions VALUES ('f100000000000000000000202404','monthly','paid_out','2024-04-01','2024-04-30',1400.00,16,'2024-04-01T00:00:00.000Z');
INSERT INTO competitions VALUES ('f100000000000000000000202405','monthly','paid_out','2024-05-01','2024-05-31',1500.00,18,'2024-05-01T00:00:00.000Z');
INSERT INTO competitions VALUES ('f100000000000000000000202406','monthly','paid_out','2024-06-01','2024-06-30',1600.00,19,'2024-06-01T00:00:00.000Z');
INSERT INTO competitions VALUES ('f100000000000000000000202407','monthly','paid_out','2024-07-01','2024-07-31',1700.00,20,'2024-07-01T00:00:00.000Z');
INSERT INTO competitions VALUES ('f100000000000000000000202408','monthly','paid_out','2024-08-01','2024-08-31',1800.00,21,'2024-08-01T00:00:00.000Z');
INSERT INTO competitions VALUES ('f100000000000000000000202409','monthly','paid_out','2024-09-01','2024-09-30',1800.00,22,'2024-09-01T00:00:00.000Z');
INSERT INTO competitions VALUES ('f100000000000000000000202410','monthly','paid_out','2024-10-01','2024-10-31',1900.00,23,'2024-10-01T00:00:00.000Z');
INSERT INTO competitions VALUES ('f100000000000000000000202411','monthly','paid_out','2024-11-01','2024-11-30',1900.00,23,'2024-11-01T00:00:00.000Z');
INSERT INTO competitions VALUES ('f100000000000000000000202412','monthly','paid_out','2024-12-01','2024-12-31',2000.00,24,'2024-12-01T00:00:00.000Z');
INSERT INTO competitions VALUES ('f100000000000000000000202501','monthly','paid_out','2025-01-01','2025-01-31',2000.00,24,'2025-01-01T00:00:00.000Z');
INSERT INTO competitions VALUES ('f100000000000000000000202502','monthly','paid_out','2025-02-01','2025-02-28',2000.00,25,'2025-02-01T00:00:00.000Z');
INSERT INTO competitions VALUES ('f100000000000000000000202503','monthly','paid_out','2025-03-01','2025-03-31',2000.00,25,'2025-03-01T00:00:00.000Z');
INSERT INTO competitions VALUES ('f100000000000000000000202504','monthly','paid_out','2025-04-01','2025-04-30',2000.00,25,'2025-04-01T00:00:00.000Z');
INSERT INTO competitions VALUES ('f100000000000000000000202505','monthly','paid_out','2025-05-01','2025-05-31',2000.00,25,'2025-05-01T00:00:00.000Z');
INSERT INTO competitions VALUES ('f100000000000000000000202506','monthly','paid_out','2025-06-01','2025-06-30',2000.00,26,'2025-06-01T00:00:00.000Z');
INSERT INTO competitions VALUES ('f100000000000000000000202507','monthly','paid_out','2025-07-01','2025-07-31',2000.00,27,'2025-07-01T00:00:00.000Z');
INSERT INTO competitions VALUES ('f100000000000000000000202508','monthly','paid_out','2025-08-01','2025-08-31',2000.00,27,'2025-08-01T00:00:00.000Z');
INSERT INTO competitions VALUES ('f100000000000000000000202509','monthly','paid_out','2025-09-01','2025-09-30',2000.00,27,'2025-09-01T00:00:00.000Z');
INSERT INTO competitions VALUES ('f100000000000000000000202510','monthly','paid_out','2025-10-01','2025-10-31',2000.00,28,'2025-10-01T00:00:00.000Z');
INSERT INTO competitions VALUES ('f100000000000000000000202511','monthly','paid_out','2025-11-01','2025-11-30',2000.00,28,'2025-11-01T00:00:00.000Z');
INSERT INTO competitions VALUES ('f100000000000000000000202512','monthly','paid_out','2025-12-01','2025-12-31',2000.00,28,'2025-12-01T00:00:00.000Z');
INSERT INTO competitions VALUES ('f100000000000000000000202601','monthly','completed','2026-01-01','2026-01-31',2000.00,28,'2026-01-01T00:00:00.000Z');
INSERT INTO competitions VALUES ('f100000000000000000000202602','monthly','active','2026-02-01','2026-02-28',2000.00,28,'2026-02-01T00:00:00.000Z');

-- Table: competition_entries
-- Sep 2025 competition entries (paid_out)
-- Prize pool: 2000. Rank1=1000, Rank2=600, Rank3=400
-- User 1 (power) - Rank 1
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000001','f100000000000000000000202509','a0000000000000000000000000000001','b00000000000000000000000000000101',25000.00,29875.00,19.50,1,1000.00,'paid','2025-09-01T00:00:00.000Z');
-- User 2 (power) - Rank 2
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000002','f100000000000000000000202509','a0000000000000000000000000000002','b00000000000000000000000000000201',25000.00,29250.00,17.00,2,600.00,'paid','2025-09-01T00:00:00.000Z');
-- User 3 (power) - Rank 3
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000003','f100000000000000000000202509','a0000000000000000000000000000003','b00000000000000000000000000000301',25000.00,28750.00,15.00,3,400.00,'paid','2025-09-01T00:00:00.000Z');
-- User 4 (power) - Rank 4
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000004','f100000000000000000000202509','a0000000000000000000000000000004','b00000000000000000000000000000401',25000.00,28125.00,12.50,4,0.00,'none','2025-09-01T00:00:00.000Z');
-- User 5 (power) - Rank 5
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000005','f100000000000000000000202509','a0000000000000000000000000000005','b00000000000000000000000000000501',25000.00,27625.00,10.50,5,0.00,'none','2025-09-01T00:00:00.000Z');
-- User 6 (active) - Rank 6
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000006','f100000000000000000000202509','a0000000000000000000000000000006','b00000000000000000000000000000601',25000.00,27250.00,9.00,6,0.00,'none','2025-09-01T00:00:00.000Z');
-- User 8 (active) - Rank 7
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000007','f100000000000000000000202509','a0000000000000000000000000000008','b00000000000000000000000000000801',25000.00,26750.00,7.00,7,0.00,'none','2025-09-01T00:00:00.000Z');
-- User 10 (active) - Rank 8
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000008','f100000000000000000000202509','a000000000000000000000000000000a','b00000000000000000000000000000a01',25000.00,26500.00,6.00,8,0.00,'none','2025-09-01T00:00:00.000Z');
-- User 11 (active) - Rank 9
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000009','f100000000000000000000202509','a000000000000000000000000000000b','b00000000000000000000000000000b01',25000.00,26250.00,5.00,9,0.00,'none','2025-09-01T00:00:00.000Z');
-- User 13 (casual) - Rank 10
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f200000000000000000000000000000a','f100000000000000000000202509','a000000000000000000000000000000d','b00000000000000000000000000000d01',25000.00,25875.00,3.50,10,0.00,'none','2025-09-01T00:00:00.000Z');
-- User 15 (casual) - Rank 11
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f200000000000000000000000000000b','f100000000000000000000202509','a000000000000000000000000000000f','b00000000000000000000000000000f01',25000.00,25500.00,2.00,11,0.00,'none','2025-09-01T00:00:00.000Z');
-- User 22 (new) - Rank 12
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f200000000000000000000000000000c','f100000000000000000000202509','a0000000000000000000000000000016','b00000000000000000000000000001601',25000.00,25250.00,1.00,12,0.00,'none','2025-09-01T00:00:00.000Z');
-- User 25 (new) - Rank 13
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f200000000000000000000000000000d','f100000000000000000000202509','a0000000000000000000000000000019','b00000000000000000000000000001901',25000.00,25000.00,0.00,13,0.00,'none','2025-09-01T00:00:00.000Z');
-- User 28 (edge) - Rank 14
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f200000000000000000000000000000e','f100000000000000000000202509','a000000000000000000000000000001c','b00000000000000000000000000001c01',25000.00,24500.00,-2.00,14,0.00,'none','2025-09-01T00:00:00.000Z');
-- User 30 (edge) - Rank 15
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f200000000000000000000000000000f','f100000000000000000000202509','a000000000000000000000000000001e','b00000000000000000000000000001e01',25000.00,24125.00,-3.50,15,0.00,'none','2025-09-01T00:00:00.000Z');
-- Jan 2026 competition entries (completed)
-- Prize pool: 2000. Rank1=1000, Rank2=600, Rank3=400
-- User 3 (power) - Rank 1
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000010','f100000000000000000000202601','a0000000000000000000000000000003','b00000000000000000000000000000301',25000.00,30500.00,22.00,1,1000.00,'paid','2026-01-01T00:00:00.000Z');
-- User 1 (power) - Rank 2
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000011','f100000000000000000000202601','a0000000000000000000000000000001','b00000000000000000000000000000101',25000.00,29750.00,19.00,2,600.00,'paid','2026-01-01T00:00:00.000Z');
-- User 5 (power) - Rank 3
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000012','f100000000000000000000202601','a0000000000000000000000000000005','b00000000000000000000000000000501',25000.00,29000.00,16.00,3,400.00,'paid','2026-01-01T00:00:00.000Z');
-- User 2 (power) - Rank 4
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000013','f100000000000000000000202601','a0000000000000000000000000000002','b00000000000000000000000000000201',25000.00,28500.00,14.00,4,0.00,'none','2026-01-01T00:00:00.000Z');
-- User 4 (power) - Rank 5
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000014','f100000000000000000000202601','a0000000000000000000000000000004','b00000000000000000000000000000401',25000.00,28000.00,12.00,5,0.00,'none','2026-01-01T00:00:00.000Z');
-- User 11 (active) - Rank 6
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000015','f100000000000000000000202601','a000000000000000000000000000000b','b00000000000000000000000000000b01',25000.00,27500.00,10.00,6,0.00,'none','2026-01-01T00:00:00.000Z');
-- User 6 (active) - Rank 7
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000016','f100000000000000000000202601','a0000000000000000000000000000006','b00000000000000000000000000000601',25000.00,27000.00,8.00,7,0.00,'none','2026-01-01T00:00:00.000Z');
-- User 10 (active) - Rank 8
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000017','f100000000000000000000202601','a000000000000000000000000000000a','b00000000000000000000000000000a01',25000.00,26625.00,6.50,8,0.00,'none','2026-01-01T00:00:00.000Z');
-- User 8 (active) - Rank 9
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000018','f100000000000000000000202601','a0000000000000000000000000000008','b00000000000000000000000000000801',25000.00,26250.00,5.00,9,0.00,'none','2026-01-01T00:00:00.000Z');
-- User 25 (new) - Rank 10
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000019','f100000000000000000000202601','a0000000000000000000000000000019','b00000000000000000000000000001901',25000.00,26000.00,4.00,10,0.00,'none','2026-01-01T00:00:00.000Z');
-- User 13 (casual) - Rank 11
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f200000000000000000000000000001a','f100000000000000000000202601','a000000000000000000000000000000d','b00000000000000000000000000000d01',25000.00,25750.00,3.00,11,0.00,'none','2026-01-01T00:00:00.000Z');
-- User 15 (casual) - Rank 12
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f200000000000000000000000000001b','f100000000000000000000202601','a000000000000000000000000000000f','b00000000000000000000000000000f01',25000.00,25375.00,1.50,12,0.00,'none','2026-01-01T00:00:00.000Z');
-- User 22 (new) - Rank 13
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f200000000000000000000000000001c','f100000000000000000000202601','a0000000000000000000000000000016','b00000000000000000000000000001601',25000.00,25125.00,0.50,13,0.00,'none','2026-01-01T00:00:00.000Z');
-- User 28 (edge) - Rank 14
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f200000000000000000000000000001d','f100000000000000000000202601','a000000000000000000000000000001c','b00000000000000000000000000001c01',25000.00,24750.00,-1.00,14,0.00,'none','2026-01-01T00:00:00.000Z');
-- User 30 (edge) - Rank 15
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f200000000000000000000000000001e','f100000000000000000000202601','a000000000000000000000000000001e','b00000000000000000000000000001e01',25000.00,24250.00,-3.00,15,0.00,'none','2026-01-01T00:00:00.000Z');
-- Feb 2026 competition entries (active - no ending_equity, no growth_pct, no rank)
-- User 1 (power)
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f200000000000000000000000000001f','f100000000000000000000202602','a0000000000000000000000000000001','b00000000000000000000000000000101',25000.00,NULL,NULL,NULL,0.00,'none','2026-02-01T00:00:00.000Z');
-- User 2 (power)
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000020','f100000000000000000000202602','a0000000000000000000000000000002','b00000000000000000000000000000201',25000.00,NULL,NULL,NULL,0.00,'none','2026-02-01T00:00:00.000Z');
-- User 3 (power)
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000021','f100000000000000000000202602','a0000000000000000000000000000003','b00000000000000000000000000000301',25000.00,NULL,NULL,NULL,0.00,'none','2026-02-01T00:00:00.000Z');
-- User 4 (power)
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000022','f100000000000000000000202602','a0000000000000000000000000000004','b00000000000000000000000000000401',25000.00,NULL,NULL,NULL,0.00,'none','2026-02-01T00:00:00.000Z');
-- User 5 (power)
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000023','f100000000000000000000202602','a0000000000000000000000000000005','b00000000000000000000000000000501',25000.00,NULL,NULL,NULL,0.00,'none','2026-02-01T00:00:00.000Z');
-- User 6 (active)
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000024','f100000000000000000000202602','a0000000000000000000000000000006','b00000000000000000000000000000601',25000.00,NULL,NULL,NULL,0.00,'none','2026-02-01T00:00:00.000Z');
-- User 8 (active)
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000025','f100000000000000000000202602','a0000000000000000000000000000008','b00000000000000000000000000000801',25000.00,NULL,NULL,NULL,0.00,'none','2026-02-01T00:00:00.000Z');
-- User 10 (active)
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000026','f100000000000000000000202602','a000000000000000000000000000000a','b00000000000000000000000000000a01',25000.00,NULL,NULL,NULL,0.00,'none','2026-02-01T00:00:00.000Z');
-- User 11 (active)
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000027','f100000000000000000000202602','a000000000000000000000000000000b','b00000000000000000000000000000b01',25000.00,NULL,NULL,NULL,0.00,'none','2026-02-01T00:00:00.000Z');
-- User 13 (casual)
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000028','f100000000000000000000202602','a000000000000000000000000000000d','b00000000000000000000000000000d01',25000.00,NULL,NULL,NULL,0.00,'none','2026-02-01T00:00:00.000Z');
-- User 15 (casual)
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f2000000000000000000000000000029','f100000000000000000000202602','a000000000000000000000000000000f','b00000000000000000000000000000f01',25000.00,NULL,NULL,NULL,0.00,'none','2026-02-01T00:00:00.000Z');
-- User 22 (new)
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f200000000000000000000000000002a','f100000000000000000000202602','a0000000000000000000000000000016','b00000000000000000000000000001601',25000.00,NULL,NULL,NULL,0.00,'none','2026-02-01T00:00:00.000Z');
-- User 25 (new)
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f200000000000000000000000000002b','f100000000000000000000202602','a0000000000000000000000000000019','b00000000000000000000000000001901',25000.00,NULL,NULL,NULL,0.00,'none','2026-02-01T00:00:00.000Z');
-- User 28 (edge)
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f200000000000000000000000000002c','f100000000000000000000202602','a000000000000000000000000000001c','b00000000000000000000000000001c01',25000.00,NULL,NULL,NULL,0.00,'none','2026-02-01T00:00:00.000Z');
-- User 30 (edge)
INSERT INTO competition_entries (id, competition_id, user_id, portfolio_id, starting_equity, ending_equity, growth_pct, rank, prize_amount, prize_status, created_at) VALUES ('f200000000000000000000000000002d','f100000000000000000000202602','a000000000000000000000000000001e','b00000000000000000000000000001e01',25000.00,NULL,NULL,NULL,0.00,'none','2026-02-01T00:00:00.000Z');

-- Table: leaderboard_cache
-- Leaderboard cache for active Feb 2026 competition
-- Snapshot of current standings mid-month (partial results, ranked by current equity)
-- total_equity reflects current portfolio value during the active month
INSERT INTO leaderboard_cache VALUES ('f3000000000000000000000000000001','f100000000000000000000202602','a0000000000000000000000000000001',1,'traderpro','Alex Morgan',NULL,27850.00,11.40,'premium','2026-02-12T00:00:00.000Z');
INSERT INTO leaderboard_cache VALUES ('f3000000000000000000000000000002','f100000000000000000000202602','a0000000000000000000000000000003',2,'sofiainvests','Sofia Rodriguez',NULL,27625.00,10.50,'premium','2026-02-12T00:00:00.000Z');
INSERT INTO leaderboard_cache VALUES ('f3000000000000000000000000000003','f100000000000000000000202602','a0000000000000000000000000000002',3,'quantjamie','Jamie Chen',NULL,27375.00,9.50,'pro','2026-02-12T00:00:00.000Z');
INSERT INTO leaderboard_cache VALUES ('f3000000000000000000000000000004','f100000000000000000000202602','a0000000000000000000000000000005',4,'priyafinance','Priya Sharma',NULL,27100.00,8.40,'premium','2026-02-12T00:00:00.000Z');
INSERT INTO leaderboard_cache VALUES ('f3000000000000000000000000000005','f100000000000000000000202602','a000000000000000000000000000000b',5,'aishap','Aisha Patel',NULL,26875.00,7.50,'premium','2026-02-12T00:00:00.000Z');
INSERT INTO leaderboard_cache VALUES ('f3000000000000000000000000000006','f100000000000000000000202602','a0000000000000000000000000000004',6,'marcusj_trades','Marcus Johnson',NULL,26650.00,6.60,'pro','2026-02-12T00:00:00.000Z');
INSERT INTO leaderboard_cache VALUES ('f3000000000000000000000000000007','f100000000000000000000202602','a0000000000000000000000000000006',7,'tylerb','Tyler Brooks',NULL,26400.00,5.60,'pro','2026-02-12T00:00:00.000Z');
INSERT INTO leaderboard_cache VALUES ('f3000000000000000000000000000008','f100000000000000000000202602','a000000000000000000000000000000a',8,'carlosg','Carlos Gutierrez',NULL,26125.00,4.50,'free','2026-02-12T00:00:00.000Z');
INSERT INTO leaderboard_cache VALUES ('f3000000000000000000000000000009','f100000000000000000000202602','a0000000000000000000000000000019',9,'miat','Mia Torres',NULL,25900.00,3.60,'premium','2026-02-12T00:00:00.000Z');
INSERT INTO leaderboard_cache VALUES ('f300000000000000000000000000000a','f100000000000000000000202602','a0000000000000000000000000000008',10,'dave_trades','David Okafor',NULL,25750.00,3.00,'free','2026-02-12T00:00:00.000Z');
INSERT INTO leaderboard_cache VALUES ('f300000000000000000000000000000b','f100000000000000000000202602','a0000000000000000000000000000016',11,'masonc','Mason Clark',NULL,25500.00,2.00,'pro','2026-02-12T00:00:00.000Z');
INSERT INTO leaderboard_cache VALUES ('f300000000000000000000000000000c','f100000000000000000000202602','a000000000000000000000000000000d',12,'oliviab','Olivia Brown',NULL,25250.00,1.00,'free','2026-02-12T00:00:00.000Z');
INSERT INTO leaderboard_cache VALUES ('f300000000000000000000000000000d','f100000000000000000000202602','a000000000000000000000000000000f',13,'zoet','Zoe Thompson',NULL,25050.00,0.20,'free','2026-02-12T00:00:00.000Z');
INSERT INTO leaderboard_cache VALUES ('f300000000000000000000000000000e','f100000000000000000000202602','a000000000000000000000000000001c',14,'willt','William Turner',NULL,24800.00,-0.80,'free','2026-02-12T00:00:00.000Z');
INSERT INTO leaderboard_cache VALUES ('f300000000000000000000000000000f','f100000000000000000000202602','a000000000000000000000000000001e',15,'danielk','Daniel King',NULL,24500.00,-2.00,'premium','2026-02-12T00:00:00.000Z');

-- Table: chat_messages
-- ============================================================
-- CHAT MESSAGES (100 rows)
-- Premium/Pro users only
-- IDs: g0000000000000000000000000000001 - g0000000000000000000000000000064
-- ============================================================

INSERT INTO chat_messages (id, user_id, username, content, image_key, tickers, is_deleted, created_at) VALUES
('g0000000000000000000000000000001', 'a0000000000000000000000000000001', 'traderpro', 'Good morning everyone! Futures are looking solid, let''s get this bread', null, null, 0, '2024-02-05T09:15:22.000Z'),
('g0000000000000000000000000000002', 'a0000000000000000000000000000002', 'quantjamie', 'Running my momentum scanner this morning, $NVDA keeps showing up at the top', null, '["NVDA"]', 0, '2024-02-05T09:32:11.000Z'),
('g0000000000000000000000000000003', 'a0000000000000000000000000000003', 'sofiainvests', 'Just loaded up on $AAPL before earnings, feeling good about this one', null, '["AAPL"]', 0, '2024-02-07T10:05:44.000Z'),
('g0000000000000000000000000000004', 'a0000000000000000000000000000001', 'traderpro', '$MSFT hitting new ATH, been holding since 280 and not selling', null, '["MSFT"]', 0, '2024-02-12T14:22:08.000Z'),
('g0000000000000000000000000000005', 'a0000000000000000000000000000005', 'priyafinance', 'Anyone else watching the 10Y yield? Could affect tech names today', null, null, 0, '2024-02-14T08:45:33.000Z'),
('g0000000000000000000000000000006', 'a0000000000000000000000000000004', 'marcusj_trades', '$AMD earnings beat expectations, afterhours looking nice', null, '["AMD"]', 0, '2024-02-20T16:35:19.000Z'),
('g0000000000000000000000000000007', 'a0000000000000000000000000000002', 'quantjamie', 'My algo flagged $SMCI as overbought, be careful up here', null, '["SMCI"]', 0, '2024-02-22T11:18:55.000Z'),
('g0000000000000000000000000000008', 'a0000000000000000000000000000001', 'traderpro', '$NVDA breaking out again, this stock is unstoppable', null, '["NVDA"]', 0, '2024-03-04T09:50:12.000Z'),
('g0000000000000000000000000000009', 'a000000000000000000000000000000b', 'aishap', 'Rotated my portfolio into $SPY and $QQQ, going safe for now', null, '["SPY","QQQ"]', 0, '2024-03-08T13:22:41.000Z'),
('g000000000000000000000000000000a', 'a0000000000000000000000000000006', 'tylerb', 'Market feels toppy, adding some $GLD as a hedge', null, '["GLD"]', 0, '2024-03-11T10:08:37.000Z'),
('g000000000000000000000000000000b', 'a0000000000000000000000000000003', 'sofiainvests', '$META earnings were insane, glad I held through the dip', null, '["META"]', 0, '2024-03-15T17:44:29.000Z'),
('g000000000000000000000000000000c', 'a0000000000000000000000000000002', 'quantjamie', 'Backtested a mean reversion strategy on $AAPL, 68% win rate over 5 years', null, '["AAPL"]', 0, '2024-03-18T08:30:05.000Z'),
('g000000000000000000000000000000d', 'a0000000000000000000000000000001', 'traderpro', 'Taking profits on $AMD, been a great run from 120 to 180', null, '["AMD"]', 0, '2024-03-22T15:12:48.000Z'),
('g000000000000000000000000000000e', 'a0000000000000000000000000000007', 'meilin_stocks', 'Watching $BABA closely, China stimulus could be a catalyst', null, '["BABA"]', 0, '2024-03-25T09:55:33.000Z'),
('g000000000000000000000000000000f', 'a0000000000000000000000000000004', 'marcusj_trades', '$TSLA on a tear, wish I bought more at 170', null, '["TSLA"]', 0, '2024-03-28T12:40:17.000Z'),
('g0000000000000000000000000000010', 'a0000000000000000000000000000001', 'traderpro', 'CPI numbers coming in hot, buckle up folks', null, null, 0, '2024-04-02T08:28:44.000Z'),
('g0000000000000000000000000000011', 'a0000000000000000000000000000005', 'priyafinance', '$GOOGL looking undervalued compared to the rest of mag 7', null, '["GOOGL"]', 0, '2024-04-05T11:15:22.000Z'),
('g0000000000000000000000000000012', 'a0000000000000000000000000000002', 'quantjamie', 'Volatility crush after FOMC, my options plays are printing', null, null, 0, '2024-04-10T14:50:38.000Z'),
('g0000000000000000000000000000013', 'a0000000000000000000000000000009', 'emmaw', 'New to the chat! Been trading for 2 years mostly $SPY options', null, '["SPY"]', 0, '2024-04-12T09:05:11.000Z'),
('g0000000000000000000000000000014', 'a0000000000000000000000000000003', 'sofiainvests', 'Welcome emmaw! Great community here. I mostly swing trade tech', null, null, 0, '2024-04-12T09:18:55.000Z'),
('g0000000000000000000000000000015', 'a0000000000000000000000000000001', 'traderpro', '$NVDA $AMD $AVGO — semis are the trade of the decade', null, '["NVDA","AMD","AVGO"]', 0, '2024-04-18T10:33:27.000Z'),
('g0000000000000000000000000000016', 'a000000000000000000000000000000c', 'ryankim', 'Anyone playing $COIN with the halving coming up?', null, '["COIN"]', 0, '2024-04-22T13:42:09.000Z'),
('g0000000000000000000000000000017', 'a0000000000000000000000000000002', 'quantjamie', 'My $BTC model says 80K by end of Q2, let''s see', null, '["BTC"]', 0, '2024-04-25T08:20:44.000Z'),
('g0000000000000000000000000000018', 'a0000000000000000000000000000004', 'marcusj_trades', 'Earnings season is wild, $NFLX beat and gapped up 10%', null, '["NFLX"]', 0, '2024-04-30T16:55:31.000Z'),
('g0000000000000000000000000000019', 'a0000000000000000000000000000001', 'traderpro', 'Sold my $TSLA calls at open for 300% gain, best trade this month', null, '["TSLA"]', 0, '2024-05-06T09:48:22.000Z'),
('g000000000000000000000000000001a', 'a0000000000000000000000000000011', 'chloed', 'What does everyone think about $PLTR at these levels?', null, '["PLTR"]', 0, '2024-05-10T11:30:15.000Z'),
('g000000000000000000000000000001b', 'a0000000000000000000000000000003', 'sofiainvests', '$PLTR is solid long term but I''d wait for a pullback to 20', null, '["PLTR"]', 0, '2024-05-10T11:45:08.000Z'),
('g000000000000000000000000000001c', 'a0000000000000000000000000000005', 'priyafinance', 'My $ETH position is finally in profit after months of waiting', null, '["ETH"]', 0, '2024-05-15T14:12:33.000Z'),
('g000000000000000000000000000001d', 'a0000000000000000000000000000002', 'quantjamie', 'Correlation between $SPY and $TLT broke down again, interesting regime change', null, '["SPY","TLT"]', 0, '2024-05-20T10:05:47.000Z'),
('g000000000000000000000000000001e', 'a0000000000000000000000000000001', 'traderpro', 'Summer trading is slow but I''m accumulating $AMZN on every dip', null, '["AMZN"]', 0, '2024-05-28T09:22:18.000Z'),
('g000000000000000000000000000001f', 'a0000000000000000000000000000016', 'masonc', 'Just started following the chat, love the analysis here', null, null, 0, '2024-06-03T08:55:42.000Z'),
('g0000000000000000000000000000020', 'a0000000000000000000000000000004', 'marcusj_trades', '$CRM reported strong guidance, enterprise software is back', null, '["CRM"]', 0, '2024-06-07T16:30:19.000Z'),
('g0000000000000000000000000000021', 'a0000000000000000000000000000001', 'traderpro', 'Fed holding rates steady, $QQQ rally incoming', null, '["QQQ"]', 0, '2024-06-12T14:05:55.000Z'),
('g0000000000000000000000000000022', 'a0000000000000000000000000000007', 'meilin_stocks', '$TSM is the real AI play, they make all the chips', null, '["TSM"]', 0, '2024-06-18T11:22:09.000Z'),
('g0000000000000000000000000000023', 'a0000000000000000000000000000002', 'quantjamie', 'Running sector rotation analysis — energy looking oversold relative to tech', null, null, 0, '2024-06-22T09:40:33.000Z'),
('g0000000000000000000000000000024', 'a0000000000000000000000000000003', 'sofiainvests', 'Added $COST to my long-term holds, recession-proof business', null, '["COST"]', 0, '2024-06-28T10:15:27.000Z'),
('g0000000000000000000000000000025', 'a0000000000000000000000000000001', 'traderpro', 'Happy July 4th everyone! Markets closed but planning my $NVDA entry for Monday', null, '["NVDA"]', 0, '2024-07-04T12:00:05.000Z'),
('g0000000000000000000000000000026', 'a0000000000000000000000000000005', 'priyafinance', 'Small caps finally waking up, $IWM breaking out of the range', null, '["IWM"]', 0, '2024-07-09T09:33:48.000Z'),
('g0000000000000000000000000000027', 'a0000000000000000000000000000019', 'miat', 'Has anyone looked at $SHOP? Canadian tech seems underappreciated', null, '["SHOP"]', 0, '2024-07-15T13:18:22.000Z'),
('g0000000000000000000000000000028', 'a0000000000000000000000000000002', 'quantjamie', 'Sharpe ratio on my portfolio hit 2.1 this quarter, best performance yet', null, null, 0, '2024-07-19T15:42:11.000Z'),
('g0000000000000000000000000000029', 'a0000000000000000000000000000004', 'marcusj_trades', 'Rotation out of mega caps into mid caps happening right now', null, null, 0, '2024-07-24T10:28:55.000Z'),
('g000000000000000000000000000002a', 'a0000000000000000000000000000001', 'traderpro', '$AAPL $MSFT $GOOGL all reporting this week, huge week ahead', null, '["AAPL","MSFT","GOOGL"]', 0, '2024-07-29T08:15:33.000Z'),
('g000000000000000000000000000002b', 'a0000000000000000000000000000003', 'sofiainvests', '$AAPL crushed it! Services revenue is the real story', null, '["AAPL"]', 0, '2024-08-01T17:05:42.000Z'),
('g000000000000000000000000000002c', 'a000000000000000000000000000001e', 'danielk', 'The yen carry trade unwind is scary, keep some cash on the side', null, null, 0, '2024-08-05T09:10:28.000Z'),
('g000000000000000000000000000002d', 'a0000000000000000000000000000002', 'quantjamie', 'VIX spiked to 38, haven''t seen that since 2020. Buying $UVXY puts', null, '["UVXY"]', 0, '2024-08-05T10:22:17.000Z'),
('g000000000000000000000000000002e', 'a0000000000000000000000000000001', 'traderpro', 'Bought the dip on $NVDA at 95, this is a gift from the market gods', null, '["NVDA"]', 0, '2024-08-06T09:35:44.000Z'),
('g000000000000000000000000000002f', 'a0000000000000000000000000000009', 'emmaw', 'That selloff was brutal but I held my positions, diamond hands', null, null, 0, '2024-08-07T11:50:33.000Z'),
('g0000000000000000000000000000030', 'a0000000000000000000000000000006', 'tylerb', 'Picked up $INTC at 20, deep value or value trap? Time will tell', null, '["INTC"]', 0, '2024-08-12T14:15:09.000Z'),
('g0000000000000000000000000000031', 'a0000000000000000000000000000005', 'priyafinance', '$GOLD breaking above 2500 for the first time ever, incredible', null, '["GOLD"]', 0, '2024-08-16T09:28:55.000Z'),
('g0000000000000000000000000000032', 'a0000000000000000000000000000004', 'marcusj_trades', 'Jackson Hole speech could move markets big time tomorrow', null, null, 0, '2024-08-22T16:40:22.000Z'),
('g0000000000000000000000000000033', 'a0000000000000000000000000000001', 'traderpro', 'Rate cuts confirmed for September, risk on baby! $QQQ $SPY', null, '["QQQ","SPY"]', 0, '2024-08-23T10:02:18.000Z'),
('g0000000000000000000000000000034', 'a0000000000000000000000000000002', 'quantjamie', 'Updated my model for rate cuts, $XLF and $KRE should benefit most', null, '["XLF","KRE"]', 0, '2024-09-02T08:45:33.000Z'),
('g0000000000000000000000000000035', 'a0000000000000000000000000000003', 'sofiainvests', 'September is historically the worst month, staying cautious', null, null, 0, '2024-09-05T11:20:47.000Z'),
('g0000000000000000000000000000036', 'a000000000000000000000000000000b', 'aishap', '$ARM is my sleeper pick for AI, everyone focuses on $NVDA but ARM designs are everywhere', null, '["ARM","NVDA"]', 0, '2024-09-10T13:55:11.000Z'),
('g0000000000000000000000000000037', 'a0000000000000000000000000000001', 'traderpro', 'this message was posted by mistake ignore', null, null, 1, '2024-09-12T09:15:00.000Z'),
('g0000000000000000000000000000038', 'a0000000000000000000000000000019', 'miat', 'Anyone else bullish on $UBER? Profitability story is real now', null, '["UBER"]', 0, '2024-09-15T10:30:28.000Z'),
('g0000000000000000000000000000039', 'a0000000000000000000000000000002', 'quantjamie', 'Fed cut 50bps! Bigger than expected. $TLT ripping', null, '["TLT"]', 0, '2024-09-18T14:08:55.000Z'),
('g000000000000000000000000000003a', 'a0000000000000000000000000000004', 'marcusj_trades', 'Bought $SQ on the dip, fintech is coming back with rate cuts', null, '["SQ"]', 0, '2024-09-22T09:42:17.000Z'),
('g000000000000000000000000000003b', 'a0000000000000000000000000000001', 'traderpro', 'Q4 is historically the best quarter, loading up on calls', null, null, 0, '2024-10-01T08:30:22.000Z'),
('g000000000000000000000000000003c', 'a0000000000000000000000000000011', 'chloed', '$DIS finally moving, theme parks and streaming both improving', null, '["DIS"]', 0, '2024-10-05T12:15:44.000Z'),
('g000000000000000000000000000003d', 'a0000000000000000000000000000005', 'priyafinance', 'China stimulus is massive, $FXI and $KWEB exploding higher', null, '["FXI","KWEB"]', 0, '2024-10-08T09:55:33.000Z'),
('g000000000000000000000000000003e', 'a0000000000000000000000000000002', 'quantjamie', 'My gamma exposure model shows dealers are very short, expect a squeeze', null, null, 0, '2024-10-12T10:40:18.000Z'),
('g000000000000000000000000000003f', 'a0000000000000000000000000000003', 'sofiainvests', 'Earnings season starting again, I''m most excited about $AMZN', null, '["AMZN"]', 0, '2024-10-15T08:22:55.000Z'),
('g0000000000000000000000000000040', 'a0000000000000000000000000000007', 'meilin_stocks', '$ASML dropped hard on weak guidance, but long term this is a buy', null, '["ASML"]', 0, '2024-10-18T15:30:09.000Z'),
('g0000000000000000000000000000041', 'a0000000000000000000000000000001', 'traderpro', 'Election volatility is here, $VIX at 22. I''m selling premium', null, '["VIX"]', 0, '2024-10-25T09:18:42.000Z'),
('g0000000000000000000000000000042', 'a000000000000000000000000000000c', 'ryankim', '$MSTR is basically leveraged $BTC at this point, wild ride', null, '["MSTR","BTC"]', 0, '2024-10-30T13:25:17.000Z'),
('g0000000000000000000000000000043', 'a0000000000000000000000000000004', 'marcusj_trades', 'Post-election rally is real, $SPY 600 by year end?', null, '["SPY"]', 0, '2024-11-06T10:05:33.000Z'),
('g0000000000000000000000000000044', 'a0000000000000000000000000000002', 'quantjamie', 'accidental post, disregard', null, null, 1, '2024-11-08T08:12:00.000Z'),
('g0000000000000000000000000000045', 'a0000000000000000000000000000001', 'traderpro', '$BTC just hit 80K! Anyone else watching $COIN and $MARA?', null, '["BTC","COIN","MARA"]', 0, '2024-11-11T09:42:28.000Z'),
('g0000000000000000000000000000046', 'a0000000000000000000000000000006', 'tylerb', 'Thanksgiving rally started early this year, fully invested', null, null, 0, '2024-11-18T11:30:55.000Z'),
('g0000000000000000000000000000047', 'a0000000000000000000000000000003', 'sofiainvests', '$NVDA earnings tomorrow, my biggest position. Nervous but confident', null, '["NVDA"]', 0, '2024-11-20T16:45:12.000Z'),
('g0000000000000000000000000000048', 'a0000000000000000000000000000005', 'priyafinance', '$NVDA beat again but stock sold off, buy the dip opportunity?', null, '["NVDA"]', 0, '2024-11-21T10:15:38.000Z'),
('g0000000000000000000000000000049', 'a0000000000000000000000000000001', 'traderpro', 'Year end tax loss harvesting time, selling my losers and buying back in Jan', null, null, 0, '2024-12-02T09:08:22.000Z'),
('g000000000000000000000000000004a', 'a000000000000000000000000000001e', 'danielk', '$SNOW upgraded by multiple analysts, cloud spending is accelerating', null, '["SNOW"]', 0, '2024-12-06T14:20:45.000Z'),
('g000000000000000000000000000004b', 'a0000000000000000000000000000002', 'quantjamie', 'Year in review: my quant portfolio returned 34%, mostly driven by $NVDA and $META', null, '["NVDA","META"]', 0, '2024-12-15T10:30:11.000Z'),
('g000000000000000000000000000004c', 'a0000000000000000000000000000016', 'masonc', '$RDDT has been a beast since IPO, social media play of the year', null, '["RDDT"]', 0, '2024-12-18T12:45:33.000Z'),
('g000000000000000000000000000004d', 'a0000000000000000000000000000003', 'sofiainvests', 'Santa rally is real! Portfolio up 3% this week alone', null, null, 0, '2024-12-23T09:55:18.000Z'),
('g000000000000000000000000000004e', 'a0000000000000000000000000000001', 'traderpro', 'Happy New Year traders! 2025 is going to be huge, I can feel it', null, null, 0, '2025-01-02T09:00:15.000Z'),
('g000000000000000000000000000004f', 'a0000000000000000000000000000004', 'marcusj_trades', '$SOFI is my top fintech pick for 2025, student loan tailwinds', null, '["SOFI"]', 0, '2025-01-06T11:22:38.000Z'),
('g0000000000000000000000000000050', 'a0000000000000000000000000000002', 'quantjamie', 'New year new strategy — adding a volatility harvesting component to my algo', null, null, 0, '2025-01-10T08:40:55.000Z'),
('g0000000000000000000000000000051', 'a0000000000000000000000000000009', 'emmaw', '$AAPL car project cancelled, all focus on AI now. Bullish or bearish?', null, '["AAPL"]', 0, '2025-01-15T13:18:27.000Z'),
('g0000000000000000000000000000052', 'a0000000000000000000000000000001', 'traderpro', 'DeepSeek shaking up the AI trade, $NVDA down 15% in a day. I''m buying', null, '["NVDA"]', 0, '2025-01-27T10:05:44.000Z'),
('g0000000000000000000000000000053', 'a0000000000000000000000000000005', 'priyafinance', 'This DeepSeek panic is overdone, $MSFT and $GOOGL AI spending isn''t slowing', null, '["MSFT","GOOGL"]', 0, '2025-01-28T09:30:12.000Z'),
('g0000000000000000000000000000054', 'a0000000000000000000000000000003', 'sofiainvests', 'Bought the $NVDA dip at 115, these panic selloffs always recover', null, '["NVDA"]', 0, '2025-01-29T11:42:33.000Z'),
('g0000000000000000000000000000055', 'a0000000000000000000000000000002', 'quantjamie', 'My models show the AI trade is broadening, $DELL $HPE $SMCI all benefiting', null, '["DELL","HPE","SMCI"]', 0, '2025-02-03T08:55:19.000Z'),
('g0000000000000000000000000000056', 'a000000000000000000000000000000b', 'aishap', 'Super Bowl coming up, historically bullish for $SPY in February', null, '["SPY"]', 0, '2025-02-07T10:12:44.000Z'),
('g0000000000000000000000000000057', 'a0000000000000000000000000000004', 'marcusj_trades', '$LLY pulled back hard, obesity drug thesis is intact though', null, '["LLY"]', 0, '2025-02-12T14:35:28.000Z'),
('g0000000000000000000000000000058', 'a0000000000000000000000000000001', 'traderpro', 'Anyone else watching $BTC? 100K is happening, just a matter of when', null, '["BTC"]', 0, '2025-02-18T09:20:55.000Z'),
('g0000000000000000000000000000059', 'a0000000000000000000000000000019', 'miat', '$TSM earnings were monster, AI chip demand is insatiable', null, '["TSM"]', 0, '2025-02-25T11:08:33.000Z'),
('g000000000000000000000000000005a', 'a0000000000000000000000000000007', 'meilin_stocks', 'Tariff fears hitting $BABA again, but I think the worst is priced in', null, '["BABA"]', 0, '2025-03-04T13:45:17.000Z'),
('g000000000000000000000000000005b', 'a0000000000000000000000000000002', 'quantjamie', 'March is historically choppy, reducing position sizes by 20%', null, null, 0, '2025-03-10T08:30:42.000Z'),
('g000000000000000000000000000005c', 'a0000000000000000000000000000001', 'traderpro', '$TSLA robotaxi event was disappointing, sold my position at 175', null, '["TSLA"]', 0, '2025-03-15T10:55:18.000Z'),
('g000000000000000000000000000005d', 'a0000000000000000000000000000011', 'chloed', 'Just opened a position in $V, payments is a boring but great business', null, '["V"]', 0, '2025-03-22T12:30:44.000Z'),
('g000000000000000000000000000005e', 'a0000000000000000000000000000005', 'priyafinance', 'Yield curve un-inverting, historically that''s when recessions actually start', null, null, 0, '2025-04-01T09:15:33.000Z'),
('g000000000000000000000000000005f', 'a0000000000000000000000000000003', 'sofiainvests', 'Good morning everyone! Markets looking green today after the pullback', null, null, 0, '2025-04-08T09:05:22.000Z'),
('g0000000000000000000000000000060', 'a000000000000000000000000000000c', 'ryankim', '$BTC finally broke 100K! What a time to be alive', null, '["BTC"]', 0, '2025-04-15T08:42:11.000Z'),
('g0000000000000000000000000000061', 'a0000000000000000000000000000002', 'quantjamie', 'Rebalanced into $SCHD for the dividend yield, 3.5% is attractive here', null, '["SCHD"]', 0, '2025-05-02T10:20:38.000Z'),
('g0000000000000000000000000000062', 'a0000000000000000000000000000006', 'tylerb', 'Summer doldrums hitting early, volume is way down', null, null, 0, '2025-05-18T11:35:55.000Z'),
('g0000000000000000000000000000063', 'a0000000000000000000000000000016', 'masonc', 'wrong chat lol', null, null, 1, '2025-05-22T14:10:00.000Z'),
('g0000000000000000000000000000064', 'a0000000000000000000000000000001', 'traderpro', '$AAPL WWDC blew my mind, AI integration across all devices. All in.', null, '["AAPL"]', 0, '2025-06-10T10:45:33.000Z');

-- Table: notifications
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
('h000000000000000000000000000005b', 'a0000000000000000000000000000001', 'prize_won', 'You Won!', 'Congratulations! You won $500 in the October competition (Rank #1)', 500.00, '{"competition_id":"f100000000000000000000202510","rank":1,"amount":500}', 1, '2025-10-31 20:05:00'),
('h000000000000000000000000000005c', 'a0000000000000000000000000000001', 'prize_won', 'You Won!', 'Congratulations! You won $200 in the December competition (Rank #2)', 200.00, '{"competition_id":"f100000000000000000000202512","rank":2,"amount":200}', 1, '2025-12-31 20:05:00'),
('h000000000000000000000000000005d', 'a0000000000000000000000000000003', 'prize_won', 'You Won!', 'Congratulations! You won $500 in the November competition (Rank #1)', 500.00, '{"competition_id":"f100000000000000000000202511","rank":1,"amount":500}', 1, '2025-11-30 20:05:00'),
('h000000000000000000000000000005e', 'a0000000000000000000000000000003', 'prize_won', 'You Won!', 'Congratulations! You won $100 in the January competition (Rank #3)', 100.00, '{"competition_id":"f100000000000000000000202601","rank":3,"amount":100}', 1, '2026-01-31 20:05:00'),
('h000000000000000000000000000005f', 'a0000000000000000000000000000005', 'prize_won', 'You Won!', 'Congratulations! You won $500 in the December competition (Rank #1)', 500.00, '{"competition_id":"f100000000000000000000202512","rank":1,"amount":500}', 1, '2025-12-31 20:05:00'),
('h0000000000000000000000000000060', 'a0000000000000000000000000000005', 'prize_won', 'You Won!', 'Congratulations! You won $200 in the January competition (Rank #2)', 200.00, '{"competition_id":"f100000000000000000000202601","rank":2,"amount":200}', 1, '2026-01-31 20:05:00'),
('h0000000000000000000000000000061', 'a0000000000000000000000000000002', 'prize_won', 'You Won!', 'Congratulations! You won $100 in the October competition (Rank #3)', 100.00, '{"competition_id":"f100000000000000000000202510","rank":3,"amount":100}', 1, '2025-10-31 20:05:00'),
('h0000000000000000000000000000062', 'a0000000000000000000000000000004', 'prize_won', 'You Won!', 'Congratulations! You won $200 in the November competition (Rank #2)', 200.00, '{"competition_id":"f100000000000000000000202511","rank":2,"amount":200}', 1, '2025-11-30 20:05:00');

-- ============================================================
-- PRIZE_PAID NOTIFICATIONS (6 rows)
-- ============================================================

INSERT INTO notifications (id, user_id, type, title, body, amount, metadata, is_read, created_at) VALUES
('h0000000000000000000000000000063', 'a0000000000000000000000000000001', 'prize_paid', 'Prize Paid', 'Your prize of $500 has been sent to your PayPal', 500.00, '{"competition_id":"f100000000000000000000202510","payment_method":"paypal"}', 1, '2025-11-05 12:00:00'),
('h0000000000000000000000000000064', 'a0000000000000000000000000000003', 'prize_paid', 'Prize Paid', 'Your prize of $500 has been sent to your PayPal', 500.00, '{"competition_id":"f100000000000000000000202511","payment_method":"paypal"}', 1, '2025-12-05 12:00:00'),
('h0000000000000000000000000000065', 'a0000000000000000000000000000005', 'prize_paid', 'Prize Paid', 'Your prize of $500 has been sent to your PayPal', 500.00, '{"competition_id":"f100000000000000000000202512","payment_method":"paypal"}', 1, '2026-01-05 12:00:00'),
('h0000000000000000000000000000066', 'a0000000000000000000000000000002', 'prize_paid', 'Prize Paid', 'Your prize of $100 has been sent to your PayPal', 100.00, '{"competition_id":"f100000000000000000000202510","payment_method":"paypal"}', 1, '2025-11-05 12:00:00'),
('h0000000000000000000000000000067', 'a0000000000000000000000000000004', 'prize_paid', 'Prize Paid', 'Your prize of $200 has been sent to your PayPal', 200.00, '{"competition_id":"f100000000000000000000202511","payment_method":"paypal"}', 1, '2025-12-05 12:00:00'),
('h0000000000000000000000000000068', 'a0000000000000000000000000000001', 'prize_paid', 'Prize Paid', 'Your prize of $200 has been sent to your PayPal', 200.00, '{"competition_id":"f100000000000000000000202512","payment_method":"paypal"}', 1, '2026-01-05 12:00:00');

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

-- Table: payouts
INSERT INTO payouts (id, user_id, competition_entry_id, amount, method, paypal_email, stripe_transfer_id, status, admin_approved_by, approved_at, processed_at, failure_reason, created_at) VALUES
-- traderpro: 3 wins ($500, $600, $400)
('j1000000000000000000000000000001', 'a0000000000000000000000000000001', NULL, 500.00, 'paypal', 'alex.morgan@email.com', NULL, 'processed', 'a000000000000000000000000000001e', '2024-04-12 10:00:00', '2024-04-12 14:30:00', NULL, '2024-04-10 18:00:00'),
('j1000000000000000000000000000002', 'a0000000000000000000000000000001', NULL, 600.00, 'paypal', 'alex.morgan@email.com', NULL, 'processed', 'a000000000000000000000000000001e', '2024-09-20 11:00:00', '2024-09-20 16:45:00', NULL, '2024-09-18 20:00:00'),
('j1000000000000000000000000000003', 'a0000000000000000000000000000001', NULL, 400.00, 'paypal', 'alex.morgan@email.com', NULL, 'processed', 'a000000000000000000000000000001e', '2025-03-05 09:30:00', '2025-03-05 13:00:00', NULL, '2025-03-03 17:00:00'),

-- quantjamie: 2 wins ($300, $350)
('j1000000000000000000000000000004', 'a0000000000000000000000000000002', NULL, 300.00, 'paypal', 'jamie.chen@email.com', NULL, 'processed', 'a000000000000000000000000000001e', '2024-06-15 10:00:00', '2024-06-15 15:20:00', NULL, '2024-06-13 19:00:00'),
('j1000000000000000000000000000005', 'a0000000000000000000000000000002', NULL, 350.00, 'paypal', 'jamie.chen@email.com', NULL, 'processed', 'a000000000000000000000000000001e', '2025-01-10 12:00:00', '2025-01-10 17:00:00', NULL, '2025-01-08 21:00:00'),

-- sofiainvests: 2 wins ($500, $300)
('j1000000000000000000000000000006', 'a0000000000000000000000000000003', NULL, 500.00, 'paypal', 'sofia.r@email.com', NULL, 'processed', 'a000000000000000000000000000001e', '2024-07-22 09:00:00', '2024-07-22 14:10:00', NULL, '2024-07-20 16:00:00'),
('j1000000000000000000000000000007', 'a0000000000000000000000000000003', NULL, 300.00, 'paypal', 'sofia.r@email.com', NULL, 'processed', 'a000000000000000000000000000001e', '2025-05-01 10:30:00', '2025-05-01 15:00:00', NULL, '2025-04-29 18:00:00'),

-- marcusj_trades: 1 win ($200)
('j1000000000000000000000000000008', 'a0000000000000000000000000000004', NULL, 200.00, 'paypal', 'marcus.j@email.com', NULL, 'processed', 'a000000000000000000000000000001e', '2024-11-18 11:00:00', '2024-11-18 16:30:00', NULL, '2024-11-16 20:00:00'),

-- priyafinance: 2 wins ($400, $500)
('j1000000000000000000000000000009', 'a0000000000000000000000000000005', NULL, 400.00, 'paypal', 'priya.s@email.com', NULL, 'processed', 'a000000000000000000000000000001e', '2024-08-30 10:00:00', '2024-08-30 14:45:00', NULL, '2024-08-28 17:00:00'),
('j100000000000000000000000000000a', 'a0000000000000000000000000000005', NULL, 500.00, 'paypal', 'priya.s@email.com', NULL, 'pending', NULL, NULL, NULL, NULL, '2026-02-05 19:00:00'),

-- tylerb: 1 win ($150)
('j100000000000000000000000000000b', 'a0000000000000000000000000000006', NULL, 150.00, 'paypal', 'tyler.b@email.com', NULL, 'processed', 'a000000000000000000000000000001e', '2025-06-10 09:00:00', '2025-06-10 13:30:00', NULL, '2025-06-08 15:00:00'),

-- emmaw: 1 win ($200)
('j100000000000000000000000000000c', 'a0000000000000000000000000000009', NULL, 200.00, 'paypal', 'emma.w@email.com', NULL, 'processed', 'a000000000000000000000000000001e', '2025-09-14 10:30:00', '2025-09-14 15:00:00', NULL, '2025-09-12 18:00:00'),

-- aishap: 1 win ($250)
('j100000000000000000000000000000d', 'a000000000000000000000000000000b', NULL, 250.00, 'paypal', 'aisha.p@email.com', NULL, 'pending', NULL, NULL, NULL, NULL, '2026-01-28 20:00:00');

-- Table: purchases
INSERT INTO purchases (id, user_id, product_id, type, apple_transaction_id, apple_original_txn_id, price, currency, status, purchased_at, expires_at) VALUES
-- Premium subscribers ($9.99/mo)
-- traderpro (user 01)
('j2000000000000000000000000000001', 'a0000000000000000000000000000001', 'com.syanik.upful.premium.monthly', 'subscription', '200000048571234', '200000048571234', 9.99, 'USD', 'active', '2024-03-01 08:00:00', '2026-03-01 08:00:00'),

-- sofiainvests (user 03)
('j2000000000000000000000000000002', 'a0000000000000000000000000000003', 'com.syanik.upful.premium.monthly', 'subscription', '200000051298765', '200000051298765', 9.99, 'USD', 'active', '2024-05-15 10:30:00', '2026-03-15 10:30:00'),

-- priyafinance (user 05)
('j2000000000000000000000000000003', 'a0000000000000000000000000000005', 'com.syanik.upful.premium.monthly', 'subscription', '200000054837291', '200000054837291', 9.99, 'USD', 'active', '2024-06-20 14:00:00', '2026-03-20 14:00:00'),

-- aishap (user 0b)
('j2000000000000000000000000000004', 'a000000000000000000000000000000b', 'com.syanik.upful.premium.monthly', 'subscription', '200000063918274', '200000063918274', 9.99, 'USD', 'active', '2025-01-05 09:00:00', '2026-03-05 09:00:00'),

-- danielk (user 1e — admin, premium)
('j2000000000000000000000000000005', 'a000000000000000000000000000001e', 'com.syanik.upful.premium.monthly', 'subscription', '200000059172836', '200000059172836', 9.99, 'USD', 'active', '2024-01-10 12:00:00', '2026-03-10 12:00:00'),

-- Pro subscribers ($4.99/mo)
-- quantjamie (user 02)
('j2000000000000000000000000000006', 'a0000000000000000000000000000002', 'com.syanik.upful.pro.monthly', 'subscription', '200000049382716', '200000049382716', 4.99, 'USD', 'active', '2024-04-10 11:00:00', '2026-03-10 11:00:00'),

-- marcusj_trades (user 04)
('j2000000000000000000000000000007', 'a0000000000000000000000000000004', 'com.syanik.upful.pro.monthly', 'subscription', '200000052847193', '200000052847193', 4.99, 'USD', 'active', '2024-07-01 09:30:00', '2026-03-01 09:30:00'),

-- tylerb (user 06)
('j2000000000000000000000000000008', 'a0000000000000000000000000000006', 'com.syanik.upful.pro.monthly', 'subscription', '200000055291847', '200000055291847', 4.99, 'USD', 'active', '2024-08-18 16:00:00', '2026-03-18 16:00:00'),

-- emmaw (user 09)
('j2000000000000000000000000000009', 'a0000000000000000000000000000009', 'com.syanik.upful.pro.monthly', 'subscription', '200000061837492', '200000061837492', 4.99, 'USD', 'active', '2025-02-01 08:00:00', '2026-03-01 08:00:00');

-- Table: watchlist
-- ============================================================
-- WATCHLIST Seed Data
-- ~100 rows across 30 users
-- UNIQUE(user_id, ticker)
-- ID format: i10000000000000000000000000000XXX
-- ============================================================

-- Power Users (1-5): 8-10 items each

-- User 1: traderpro (Alex Morgan) - 10 items
INSERT INTO watchlist (id, user_id, ticker, sort_order, notes, created_at) VALUES
  ('i10000000000000000000000000000001', 'a0000000000000000000000000000001', 'NVDA', 1, 'Watching for earnings breakout', '2025-06-10T08:30:00Z'),
  ('i10000000000000000000000000000002', 'a0000000000000000000000000000001', 'AMD', 2, 'Buy on dip below $200', '2025-06-15T09:00:00Z'),
  ('i10000000000000000000000000000003', 'a0000000000000000000000000000001', 'META', 3, 'Long term hold candidate', '2025-07-01T10:00:00Z'),
  ('i10000000000000000000000000000004', 'a0000000000000000000000000000001', 'BTC', 4, 'Waiting for pullback to $90k', '2025-07-20T11:30:00Z'),
  ('i10000000000000000000000000000005', 'a0000000000000000000000000000001', 'GOOGL', 5, 'AI catalyst potential', '2025-08-05T14:00:00Z'),
  ('i10000000000000000000000000000006', 'a0000000000000000000000000000001', 'CRM', 6, NULL, '2025-09-12T08:45:00Z'),
  ('i10000000000000000000000000000007', 'a0000000000000000000000000000001', 'SOL', 7, 'DeFi play, high risk', '2025-10-01T12:00:00Z'),
  ('i10000000000000000000000000000008', 'a0000000000000000000000000000001', 'ARKK', 8, 'Innovation fund entry point', '2025-11-10T09:15:00Z'),
  ('i10000000000000000000000000000009', 'a0000000000000000000000000000001', 'XOM', 9, 'Energy hedge', '2025-12-01T10:30:00Z'),
  ('i1000000000000000000000000000000a', 'a0000000000000000000000000000001', 'GLD', 10, 'Macro hedge if rates drop', '2026-01-05T08:00:00Z'),

-- User 2: quantjamie (Jamie Chen) - 9 items
  ('i1000000000000000000000000000000b', 'a0000000000000000000000000000002', 'MSFT', 1, 'Cloud revenue growth thesis', '2025-05-20T09:00:00Z'),
  ('i1000000000000000000000000000000c', 'a0000000000000000000000000000002', 'AMZN', 2, 'AWS margins expanding', '2025-06-01T10:30:00Z'),
  ('i1000000000000000000000000000000d', 'a0000000000000000000000000000002', 'INTC', 3, 'Turnaround play, high risk', '2025-06-18T11:00:00Z'),
  ('i1000000000000000000000000000000e', 'a0000000000000000000000000000002', 'ORCL', 4, 'Database moat undervalued', '2025-07-10T13:00:00Z'),
  ('i1000000000000000000000000000000f', 'a0000000000000000000000000000002', 'ETH', 5, 'Staking yield comparison', '2025-08-01T08:30:00Z'),
  ('i10000000000000000000000000000010', 'a0000000000000000000000000000002', 'QQQ', 6, 'Benchmark tracking', '2025-09-05T09:15:00Z'),
  ('i10000000000000000000000000000011', 'a0000000000000000000000000000002', 'ADBE', 7, 'AI integration upside', '2025-10-20T14:00:00Z'),
  ('i10000000000000000000000000000012', 'a0000000000000000000000000000002', 'LINK', 8, NULL, '2025-11-15T10:45:00Z'),
  ('i10000000000000000000000000000013', 'a0000000000000000000000000000002', 'TLT', 9, 'Rate cut bet', '2026-01-10T08:00:00Z'),

-- User 3: sofiainvests (Sofia Rodriguez) - 9 items
  ('i10000000000000000000000000000014', 'a0000000000000000000000000000003', 'AAPL', 1, 'Core holding candidate', '2025-04-15T09:00:00Z'),
  ('i10000000000000000000000000000015', 'a0000000000000000000000000000003', 'JNJ', 2, 'Dividend stability', '2025-05-01T10:00:00Z'),
  ('i10000000000000000000000000000016', 'a0000000000000000000000000000003', 'PG', 3, 'Consumer staples anchor', '2025-05-20T11:30:00Z'),
  ('i10000000000000000000000000000017', 'a0000000000000000000000000000003', 'COST', 4, 'Watching for pullback entry', '2025-06-10T08:45:00Z'),
  ('i10000000000000000000000000000018', 'a0000000000000000000000000000003', 'V', 5, 'Payments duopoly long term', '2025-07-22T14:00:00Z'),
  ('i10000000000000000000000000000019', 'a0000000000000000000000000000003', 'UNH', 6, 'Healthcare moat', '2025-08-18T09:30:00Z'),
  ('i1000000000000000000000000000001a', 'a0000000000000000000000000000003', 'LLY', 7, 'GLP-1 growth thesis', '2025-09-05T10:00:00Z'),
  ('i1000000000000000000000000000001b', 'a0000000000000000000000000000003', 'VOO', 8, NULL, '2025-10-12T12:00:00Z'),
  ('i1000000000000000000000000000001c', 'a0000000000000000000000000000003', 'SLV', 9, 'Industrial metals play', '2025-12-20T08:15:00Z'),

-- User 4: marcusj_trades (Marcus Johnson) - 8 items
  ('i1000000000000000000000000000001d', 'a0000000000000000000000000000004', 'TSLA', 1, 'Volatility play, quick trades', '2025-05-10T08:00:00Z'),
  ('i1000000000000000000000000000001e', 'a0000000000000000000000000000004', 'NVDA', 2, 'Momentum following', '2025-06-01T09:30:00Z'),
  ('i1000000000000000000000000000001f', 'a0000000000000000000000000000004', 'BTC', 3, 'Halving cycle thesis', '2025-07-15T10:00:00Z'),
  ('i10000000000000000000000000000020', 'a0000000000000000000000000000004', 'DOGE', 4, 'Meme momentum trade', '2025-08-20T11:00:00Z'),
  ('i10000000000000000000000000000021', 'a0000000000000000000000000000004', 'XRP', 5, 'Regulatory clarity play', '2025-09-10T13:00:00Z'),
  ('i10000000000000000000000000000022', 'a0000000000000000000000000000004', 'BA', 6, 'Recovery thesis', '2025-10-05T08:45:00Z'),
  ('i10000000000000000000000000000023', 'a0000000000000000000000000000004', 'SPY', 7, NULL, '2025-11-20T09:00:00Z'),
  ('i10000000000000000000000000000024', 'a0000000000000000000000000000004', 'XLE', 8, 'Energy sector rotation', '2026-01-08T10:30:00Z'),

-- User 5: priyafinance (Priya Sharma) - 8 items
  ('i10000000000000000000000000000025', 'a0000000000000000000000000000005', 'GOOGL', 1, 'Watching for earnings', '2025-04-20T09:00:00Z'),
  ('i10000000000000000000000000000026', 'a0000000000000000000000000000005', 'MSFT', 2, 'Cloud + AI double play', '2025-05-15T10:00:00Z'),
  ('i10000000000000000000000000000027', 'a0000000000000000000000000000005', 'MA', 3, 'Cross-border payments growth', '2025-06-28T11:30:00Z'),
  ('i10000000000000000000000000000028', 'a0000000000000000000000000000005', 'PFE', 4, 'Post-covid pipeline value', '2025-07-14T08:30:00Z'),
  ('i10000000000000000000000000000029', 'a0000000000000000000000000000005', 'KO', 5, 'Dividend aristocrat watch', '2025-08-22T14:15:00Z'),
  ('i1000000000000000000000000000002a', 'a0000000000000000000000000000005', 'WMT', 6, NULL, '2025-09-30T09:00:00Z'),
  ('i1000000000000000000000000000002b', 'a0000000000000000000000000000005', 'ETH', 7, 'DeFi ecosystem growth', '2025-11-10T10:30:00Z'),
  ('i1000000000000000000000000000002c', 'a0000000000000000000000000000005', 'VTI', 8, 'Total market benchmark', '2026-01-15T08:00:00Z'),

-- Active Users (6-12): 4-6 items each

-- User 6: tylerb (Tyler Brooks) - 6 items
  ('i1000000000000000000000000000002d', 'a0000000000000000000000000000006', 'NFLX', 1, 'Streaming wars winner?', '2025-07-05T09:00:00Z'),
  ('i1000000000000000000000000000002e', 'a0000000000000000000000000000006', 'AAPL', 2, 'Waiting for Vision Pro sales data', '2025-08-12T10:00:00Z'),
  ('i1000000000000000000000000000002f', 'a0000000000000000000000000000006', 'AMD', 3, NULL, '2025-09-18T11:30:00Z'),
  ('i10000000000000000000000000000030', 'a0000000000000000000000000000006', 'AVAX', 4, 'L1 competitor watch', '2025-10-25T08:45:00Z'),
  ('i10000000000000000000000000000031', 'a0000000000000000000000000000006', 'CAT', 5, 'Infrastructure spending play', '2025-12-01T13:00:00Z'),
  ('i10000000000000000000000000000032', 'a0000000000000000000000000000006', 'XLK', 6, 'Tech sector ETF', '2026-01-20T09:15:00Z'),

-- User 7: meilin_stocks (Mei Lin) - 5 items
  ('i10000000000000000000000000000033', 'a0000000000000000000000000000007', 'NVDA', 1, 'Core AI thesis', '2025-06-20T09:00:00Z'),
  ('i10000000000000000000000000000034', 'a0000000000000000000000000000007', 'TSLA', 2, 'Autonomous driving catalyst', '2025-08-01T10:30:00Z'),
  ('i10000000000000000000000000000035', 'a0000000000000000000000000000007', 'JPM', 3, 'Financials leader', '2025-09-15T11:00:00Z'),
  ('i10000000000000000000000000000036', 'a0000000000000000000000000000007', 'GS', 4, NULL, '2025-11-01T08:30:00Z'),
  ('i10000000000000000000000000000037', 'a0000000000000000000000000000007', 'ADA', 5, 'Smart contract platform bet', '2026-01-05T14:00:00Z'),

-- User 8: dave_trades (David Okafor) - 5 items
  ('i10000000000000000000000000000038', 'a0000000000000000000000000000008', 'META', 1, 'Ad revenue rebound', '2025-07-10T09:00:00Z'),
  ('i10000000000000000000000000000039', 'a0000000000000000000000000000008', 'AMZN', 2, NULL, '2025-08-20T10:15:00Z'),
  ('i1000000000000000000000000000003a', 'a0000000000000000000000000000008', 'SOL', 3, 'Fast chain narrative', '2025-09-28T11:30:00Z'),
  ('i1000000000000000000000000000003b', 'a0000000000000000000000000000008', 'PEP', 4, 'Steady dividend compounder', '2025-11-15T08:45:00Z'),
  ('i1000000000000000000000000000003c', 'a0000000000000000000000000000008', 'CVX', 5, 'Energy value play', '2026-01-12T09:30:00Z'),

-- User 9: emmaw (Emma Wilson) - 5 items
  ('i1000000000000000000000000000003d', 'a0000000000000000000000000000009', 'AAPL', 1, 'Ecosystem lock-in thesis', '2025-06-15T08:30:00Z'),
  ('i1000000000000000000000000000003e', 'a0000000000000000000000000000009', 'GOOGL', 2, 'Search + AI dominance', '2025-08-08T10:00:00Z'),
  ('i1000000000000000000000000000003f', 'a0000000000000000000000000000009', 'MCD', 3, 'Recession-proof franchise', '2025-09-20T11:00:00Z'),
  ('i10000000000000000000000000000040', 'a0000000000000000000000000000009', 'BTC', 4, NULL, '2025-11-05T09:30:00Z'),
  ('i10000000000000000000000000000041', 'a0000000000000000000000000000009', 'QQQ', 5, 'Tech allocation tracker', '2026-01-18T08:00:00Z'),

-- User 10: carlosg (Carlos Gutierrez) - 4 items
  ('i10000000000000000000000000000042', 'a000000000000000000000000000000a', 'TSLA', 1, 'Waiting for sub-$250 entry', '2025-07-25T09:00:00Z'),
  ('i10000000000000000000000000000043', 'a000000000000000000000000000000a', 'NVDA', 2, NULL, '2025-09-10T10:30:00Z'),
  ('i10000000000000000000000000000044', 'a000000000000000000000000000000a', 'BAC', 3, 'Financials value', '2025-10-30T11:45:00Z'),
  ('i10000000000000000000000000000045', 'a000000000000000000000000000000a', 'XRP', 4, 'Regulatory play', '2026-01-08T08:15:00Z'),

-- User 11: aishap (Aisha Patel) - 6 items
  ('i10000000000000000000000000000046', 'a000000000000000000000000000000b', 'MSFT', 1, 'AI Copilot revenue watch', '2025-05-30T09:00:00Z'),
  ('i10000000000000000000000000000047', 'a000000000000000000000000000000b', 'LLY', 2, 'GLP-1 market leader', '2025-07-15T10:30:00Z'),
  ('i10000000000000000000000000000048', 'a000000000000000000000000000000b', 'V', 3, 'Cashless economy trend', '2025-08-28T11:00:00Z'),
  ('i10000000000000000000000000000049', 'a000000000000000000000000000000b', 'ADBE', 4, NULL, '2025-10-10T08:45:00Z'),
  ('i1000000000000000000000000000004a', 'a000000000000000000000000000000b', 'ETH', 5, 'Layer 2 scaling thesis', '2025-12-05T13:00:00Z'),
  ('i1000000000000000000000000000004b', 'a000000000000000000000000000000b', 'GLD', 6, 'Inflation hedge', '2026-01-22T09:00:00Z'),

-- User 12: ryankim (Ryan Kim) - 4 items
  ('i1000000000000000000000000000004c', 'a000000000000000000000000000000c', 'NFLX', 1, 'Subscriber growth watch', '2025-08-05T09:00:00Z'),
  ('i1000000000000000000000000000004d', 'a000000000000000000000000000000c', 'CRM', 2, 'Enterprise AI adoption', '2025-09-22T10:30:00Z'),
  ('i1000000000000000000000000000004e', 'a000000000000000000000000000000c', 'DOGE', 3, NULL, '2025-11-18T11:00:00Z'),
  ('i1000000000000000000000000000004f', 'a000000000000000000000000000000c', 'SPY', 4, 'Market benchmark', '2026-01-10T08:30:00Z'),

-- Casual Users (13-20): 2-3 items each

-- User 13: oliviab (Olivia Brown) - 3 items
  ('i10000000000000000000000000000050', 'a000000000000000000000000000000d', 'AAPL', 1, NULL, '2025-09-01T09:00:00Z'),
  ('i10000000000000000000000000000051', 'a000000000000000000000000000000d', 'MSFT', 2, NULL, '2025-10-15T10:00:00Z'),
  ('i10000000000000000000000000000052', 'a000000000000000000000000000000d', 'VOO', 3, 'Simple index strategy', '2025-12-08T08:30:00Z'),

-- User 14: noahg (Noah Garcia) - 3 items
  ('i10000000000000000000000000000053', 'a000000000000000000000000000000e', 'NVDA', 1, 'Gaming + AI', '2025-08-20T09:30:00Z'),
  ('i10000000000000000000000000000054', 'a000000000000000000000000000000e', 'BTC', 2, NULL, '2025-10-01T10:00:00Z'),
  ('i10000000000000000000000000000055', 'a000000000000000000000000000000e', 'TSLA', 3, 'Musk factor', '2025-11-28T11:00:00Z'),

-- User 15: zoet (Zoe Thompson) - 2 items
  ('i10000000000000000000000000000056', 'a000000000000000000000000000000f', 'GOOGL', 1, NULL, '2025-09-15T09:00:00Z'),
  ('i10000000000000000000000000000057', 'a000000000000000000000000000000f', 'AMZN', 2, 'E-commerce dominance', '2025-11-10T10:30:00Z'),

-- User 16: liama (Liam Anderson) - 2 items
  ('i10000000000000000000000000000058', 'a0000000000000000000000000000010', 'META', 1, NULL, '2025-10-05T09:00:00Z'),
  ('i10000000000000000000000000000059', 'a0000000000000000000000000000010', 'SOL', 2, 'Crypto diversification', '2025-12-20T10:30:00Z'),

-- User 17: chloed (Chloe Davis) - 3 items
  ('i1000000000000000000000000000005a', 'a0000000000000000000000000000011', 'AMD', 1, 'Chipmaker competition', '2025-07-30T09:00:00Z'),
  ('i1000000000000000000000000000005b', 'a0000000000000000000000000000011', 'ORCL', 2, NULL, '2025-09-25T10:15:00Z'),
  ('i1000000000000000000000000000005c', 'a0000000000000000000000000000011', 'VTI', 3, 'Total market exposure', '2025-12-01T08:45:00Z'),

-- User 18: ethanm (Ethan Martinez) - 2 items
  ('i1000000000000000000000000000005d', 'a0000000000000000000000000000012', 'AAPL', 1, NULL, '2025-10-20T09:00:00Z'),
  ('i1000000000000000000000000000005e', 'a0000000000000000000000000000012', 'BTC', 2, 'Digital gold thesis', '2025-12-15T10:00:00Z'),

-- User 19: avaj (Ava Jackson) - 2 items
  ('i1000000000000000000000000000005f', 'a0000000000000000000000000000013', 'COST', 1, 'Membership model moat', '2025-09-08T09:00:00Z'),
  ('i10000000000000000000000000000060', 'a0000000000000000000000000000013', 'JPM', 2, NULL, '2025-11-22T10:30:00Z'),

-- User 20: lucasw (Lucas White) - 2 items
  ('i10000000000000000000000000000061', 'a0000000000000000000000000000014', 'TSLA', 1, NULL, '2025-10-10T09:00:00Z'),
  ('i10000000000000000000000000000062', 'a0000000000000000000000000000014', 'ETH', 2, 'Smart contract platform', '2025-12-28T10:00:00Z'),

-- New Users (21-25): 1-3 items each

-- User 21: harperl (Harper Lee) - 2 items
  ('i10000000000000000000000000000063', 'a0000000000000000000000000000015', 'AAPL', 1, 'First stock to watch', '2025-12-01T09:00:00Z'),
  ('i10000000000000000000000000000064', 'a0000000000000000000000000000015', 'SPY', 2, NULL, '2026-01-10T10:00:00Z'),

-- User 22: masonc (Mason Clark) - 3 items
  ('i10000000000000000000000000000065', 'a0000000000000000000000000000016', 'NVDA', 1, 'AI hype train', '2025-11-15T09:00:00Z'),
  ('i10000000000000000000000000000066', 'a0000000000000000000000000000016', 'MSFT', 2, NULL, '2025-12-10T10:30:00Z'),
  ('i10000000000000000000000000000067', 'a0000000000000000000000000000016', 'BTC', 3, 'Crypto allocation watch', '2026-01-20T08:00:00Z'),

-- User 23: ellar (Ella Robinson) - 1 item
  ('i10000000000000000000000000000068', 'a0000000000000000000000000000017', 'GOOGL', 1, NULL, '2025-12-22T09:00:00Z'),

-- User 24: jacks (Jack Scott) - 2 items
  ('i10000000000000000000000000000069', 'a0000000000000000000000000000018', 'AMZN', 1, 'Prime growth', '2025-11-28T09:00:00Z'),
  ('i1000000000000000000000000000006a', 'a0000000000000000000000000000018', 'META', 2, NULL, '2026-01-15T10:00:00Z'),

-- User 25: miat (Mia Torres) - 2 items
  ('i1000000000000000000000000000006b', 'a0000000000000000000000000000019', 'LLY', 1, 'Pharma growth watch', '2025-10-30T09:00:00Z'),
  ('i1000000000000000000000000000006c', 'a0000000000000000000000000000019', 'NFLX', 2, 'Content pipeline', '2025-12-18T10:30:00Z'),

-- Edge Cases (26-30): 0-2 items each

-- User 26: benH (Benjamin Hall) - 1 item
  ('i1000000000000000000000000000006d', 'a000000000000000000000000000001a', 'TSLA', 1, NULL, '2025-11-05T09:00:00Z'),

-- User 27: isabellaA (Isabella Adams) - 0 items (inactive user)
-- No watchlist entries

-- User 28: willt (William Turner) - 2 items
  ('i1000000000000000000000000000006e', 'a000000000000000000000000000001c', 'AAPL', 1, 'Safe haven after losses', '2026-01-02T09:00:00Z'),
  ('i1000000000000000000000000000006f', 'a000000000000000000000000000001c', 'VOO', 2, 'Considering index only strategy', '2026-01-20T10:00:00Z'),

-- User 29: charlottew (Charlotte Wright) - 1 item
  ('i10000000000000000000000000000070', 'a000000000000000000000000000001d', 'QQQ', 1, 'Tech benchmark', '2026-01-25T09:00:00Z'),

-- User 30: danielk (Daniel King) - 2 items
  ('i10000000000000000000000000000071', 'a000000000000000000000000000001e', 'NVDA', 1, 'Long term AI conviction', '2025-06-05T09:00:00Z'),
  ('i10000000000000000000000000000072', 'a000000000000000000000000000001e', 'AVAX', 2, NULL, '2025-10-18T10:30:00Z');

-- Table: saved_screeners
-- ============================================================
-- SAVED_SCREENERS Seed Data
-- ~30 rows for active/power users
-- ID format: i20000000000000000000000000000XXX
-- parameters is JSON TEXT
-- ============================================================

INSERT INTO saved_screeners (id, user_id, title, description, parameters, color, sort_order, is_prebuilt, usage_count, created_at) VALUES

-- User 1: traderpro - 3 screeners
  ('i20000000000000000000000000000001', 'a0000000000000000000000000000001', 'Large Cap Tech', 'High-cap technology stocks with strong fundamentals', '{"asset_type":"stock","min_price":100,"max_price":2000,"market_cap":"large","sector":"technology"}', '#007AFF', 1, 0, 42, '2025-06-15T08:00:00Z'),
  ('i20000000000000000000000000000002', 'a0000000000000000000000000000001', 'Crypto Majors', 'Top cryptocurrencies by market cap', '{"asset_type":"crypto","min_price":1,"max_price":200000,"sort_by":"market_cap","order":"desc"}', '#FF9500', 2, 0, 28, '2025-08-10T09:30:00Z'),
  ('i20000000000000000000000000000003', 'a0000000000000000000000000000001', 'High Volume Movers', 'Stocks with above-average volume today', '{"asset_type":"stock","min_volume":5000000,"sort_by":"volume","order":"desc"}', '#FF3B30', 3, 0, 65, '2025-10-01T10:00:00Z'),

-- User 2: quantjamie - 3 screeners
  ('i20000000000000000000000000000004', 'a0000000000000000000000000000002', 'Undervalued Tech', 'Technology stocks with low P/E ratios', '{"asset_type":"stock","sector":"technology","pe_ratio_max":25,"market_cap":"large","sort_by":"pe_ratio","order":"asc"}', '#5856D6', 1, 0, 35, '2025-05-20T09:00:00Z'),
  ('i20000000000000000000000000000005', 'a0000000000000000000000000000002', 'ETF Volume Leaders', 'Most actively traded ETFs', '{"asset_type":"etf","sort_by":"volume","min_volume":1000000,"order":"desc"}', '#34C759', 2, 0, 19, '2025-07-12T10:30:00Z'),
  ('i20000000000000000000000000000006', 'a0000000000000000000000000000002', 'Small Cap Crypto', 'Low-price crypto opportunities', '{"asset_type":"crypto","min_price":0.01,"max_price":10,"sort_by":"percent_change_24h","order":"desc"}', '#FF9500', 3, 0, 22, '2025-09-05T11:00:00Z'),

-- User 3: sofiainvests - 2 screeners
  ('i20000000000000000000000000000007', 'a0000000000000000000000000000003', 'Dividend Champions', 'Stocks with strong dividend yields', '{"asset_type":"stock","dividend_yield_min":2.0,"market_cap":"large","sort_by":"dividend_yield","order":"desc"}', '#34C759', 1, 0, 31, '2025-04-28T09:00:00Z'),
  ('i20000000000000000000000000000008', 'a0000000000000000000000000000003', 'Healthcare Growth', 'Healthcare sector growth stocks', '{"asset_type":"stock","sector":"healthcare","min_price":50,"max_price":1000,"market_cap":"large"}', '#008080', 2, 0, 18, '2025-07-20T10:00:00Z'),

-- User 4: marcusj_trades - 2 screeners
  ('i20000000000000000000000000000009', 'a0000000000000000000000000000004', 'Volatile Movers', 'High-volatility stocks for day trading', '{"asset_type":"stock","min_volume":2000000,"sort_by":"percent_change","order":"desc","min_price":10}', '#FF3B30', 1, 0, 78, '2025-06-05T08:30:00Z'),
  ('i2000000000000000000000000000000a', 'a0000000000000000000000000000004', 'Crypto Momentum', 'Cryptos with highest 24h gains', '{"asset_type":"crypto","sort_by":"percent_change_24h","order":"desc","min_volume":500000}', '#AF52DE', 2, 0, 55, '2025-08-15T10:00:00Z'),

-- User 5: priyafinance - 2 screeners
  ('i2000000000000000000000000000000b', 'a0000000000000000000000000000005', 'Blue Chip Value', 'Large cap value stocks for long-term holding', '{"asset_type":"stock","market_cap":"large","pe_ratio_max":20,"dividend_yield_min":1.5,"sort_by":"market_cap","order":"desc"}', '#007AFF', 1, 0, 24, '2025-05-10T09:00:00Z'),
  ('i2000000000000000000000000000000c', 'a0000000000000000000000000000005', 'Consumer Staples', 'Defensive consumer staples sector', '{"asset_type":"stock","sector":"consumer_staples","min_price":30,"market_cap":"large","sort_by":"dividend_yield","order":"desc"}', '#34C759', 2, 0, 12, '2025-08-25T10:30:00Z'),

-- User 6: tylerb - 2 screeners
  ('i2000000000000000000000000000000d', 'a0000000000000000000000000000006', 'Tech ETFs', 'Technology-focused exchange traded funds', '{"asset_type":"etf","sector":"technology","sort_by":"volume","min_volume":500000}', '#5856D6', 1, 0, 15, '2025-07-18T09:00:00Z'),
  ('i2000000000000000000000000000000e', 'a0000000000000000000000000000006', 'Mid Cap Growth', 'Mid-cap stocks with growth potential', '{"asset_type":"stock","market_cap":"mid","min_price":20,"max_price":200,"sort_by":"percent_change","order":"desc"}', '#FF9500', 2, 0, 9, '2025-10-30T10:00:00Z'),

-- User 7: meilin_stocks - 1 screener
  ('i2000000000000000000000000000000f', 'a0000000000000000000000000000007', 'Financials Sector', 'Major financial institutions', '{"asset_type":"stock","sector":"financials","market_cap":"large","min_price":50,"sort_by":"market_cap","order":"desc"}', '#007AFF', 1, 0, 20, '2025-06-25T09:30:00Z'),

-- User 8: dave_trades - 1 screener
  ('i20000000000000000000000000000010', 'a0000000000000000000000000000008', 'Cheap Crypto', 'Low-priced cryptocurrencies under $1', '{"asset_type":"crypto","min_price":0.001,"max_price":1,"sort_by":"percent_change_24h","order":"desc"}', '#AF52DE', 1, 0, 33, '2025-08-02T08:45:00Z'),

-- User 9: emmaw - 2 screeners
  ('i20000000000000000000000000000011', 'a0000000000000000000000000000009', 'Safe Havens', 'Low-volatility large cap stocks', '{"asset_type":"stock","market_cap":"large","sector":"consumer_staples","sort_by":"dividend_yield","order":"desc"}', '#34C759', 1, 0, 11, '2025-07-08T09:00:00Z'),
  ('i20000000000000000000000000000012', 'a0000000000000000000000000000009', 'Bond ETFs', 'Fixed income ETFs for stability', '{"asset_type":"etf","category":"bond","sort_by":"volume","min_volume":100000}', '#008080', 2, 0, 7, '2025-10-15T10:30:00Z'),

-- User 10: carlosg - 1 screener
  ('i20000000000000000000000000000013', 'a000000000000000000000000000000a', 'EV Stocks', 'Electric vehicle and clean energy', '{"asset_type":"stock","sector":"automotive","min_price":10,"sort_by":"volume","order":"desc"}', '#34C759', 1, 0, 14, '2025-09-12T09:00:00Z'),

-- User 11: aishap - 2 screeners
  ('i20000000000000000000000000000014', 'a000000000000000000000000000000b', 'AI Leaders', 'Companies leading in artificial intelligence', '{"asset_type":"stock","min_price":100,"market_cap":"large","sector":"technology","sort_by":"market_cap","order":"desc"}', '#5856D6', 1, 0, 27, '2025-06-01T09:00:00Z'),
  ('i20000000000000000000000000000015', 'a000000000000000000000000000000b', 'Pharma Pipeline', 'Pharmaceutical companies with strong pipelines', '{"asset_type":"stock","sector":"healthcare","min_price":50,"market_cap":"large","sort_by":"percent_change","order":"desc"}', '#008080', 2, 0, 16, '2025-09-18T10:00:00Z'),

-- User 12: ryankim - 1 screener
  ('i20000000000000000000000000000016', 'a000000000000000000000000000000c', 'Meme Coins', 'Popular meme cryptocurrencies', '{"asset_type":"crypto","sort_by":"percent_change_24h","order":"desc","min_volume":100000}', '#FF3B30', 1, 0, 41, '2025-10-05T09:00:00Z'),

-- User 22: masonc - 2 screeners
  ('i20000000000000000000000000000017', 'a0000000000000000000000000000016', 'Semiconductor Stocks', 'Chip makers and semiconductor companies', '{"asset_type":"stock","sector":"technology","min_price":50,"sort_by":"volume","order":"desc"}', '#007AFF', 1, 0, 8, '2025-12-01T09:00:00Z'),
  ('i20000000000000000000000000000018', 'a0000000000000000000000000000016', 'DeFi Tokens', 'Decentralized finance crypto tokens', '{"asset_type":"crypto","category":"defi","sort_by":"market_cap","order":"desc"}', '#AF52DE', 2, 0, 5, '2026-01-10T10:00:00Z'),

-- User 25: miat - 1 screener
  ('i20000000000000000000000000000019', 'a0000000000000000000000000000019', 'Growth at Reasonable Price', 'GARP strategy screening', '{"asset_type":"stock","pe_ratio_max":30,"min_price":25,"market_cap":"large","sort_by":"pe_ratio","order":"asc"}', '#34C759', 1, 0, 10, '2025-11-08T09:00:00Z'),

-- User 30: danielk - 2 screeners
  ('i2000000000000000000000000000001a', 'a000000000000000000000000000001e', 'Energy Sector', 'Oil, gas, and renewable energy stocks', '{"asset_type":"stock","sector":"energy","min_price":20,"sort_by":"dividend_yield","order":"desc"}', '#FF9500', 1, 0, 17, '2025-05-15T09:00:00Z'),
  ('i2000000000000000000000000000001b', 'a000000000000000000000000000001e', 'L1 Blockchains', 'Layer 1 blockchain platforms', '{"asset_type":"crypto","category":"layer1","sort_by":"market_cap","order":"desc"}', '#5856D6', 2, 0, 13, '2025-08-20T10:30:00Z');

-- Table: user_preferences
-- ============================================================
-- USER_PREFERENCES Seed Data
-- ~50 rows across users
-- UNIQUE(user_id, category, value)
-- ID format: i30000000000000000000000000000XXX
-- Categories: theme, notifications, default_asset_type
-- ============================================================

INSERT INTO user_preferences (id, user_id, category, value, created_at) VALUES

-- User 1: traderpro - all 3 prefs
  ('i30000000000000000000000000000001', 'a0000000000000000000000000000001', 'theme', 'dark', '2025-06-10T08:00:00Z'),
  ('i30000000000000000000000000000002', 'a0000000000000000000000000000001', 'notifications', 'all', '2025-06-10T08:00:00Z'),
  ('i30000000000000000000000000000003', 'a0000000000000000000000000000001', 'default_asset_type', 'stock', '2025-06-10T08:00:00Z'),

-- User 2: quantjamie - all 3 prefs
  ('i30000000000000000000000000000004', 'a0000000000000000000000000000002', 'theme', 'dark', '2025-05-22T09:00:00Z'),
  ('i30000000000000000000000000000005', 'a0000000000000000000000000000002', 'notifications', 'trades_only', '2025-05-22T09:00:00Z'),
  ('i30000000000000000000000000000006', 'a0000000000000000000000000000002', 'default_asset_type', 'stock', '2025-05-22T09:00:00Z'),

-- User 3: sofiainvests - 2 prefs
  ('i30000000000000000000000000000007', 'a0000000000000000000000000000003', 'theme', 'light', '2025-04-20T10:00:00Z'),
  ('i30000000000000000000000000000008', 'a0000000000000000000000000000003', 'notifications', 'all', '2025-04-20T10:00:00Z'),

-- User 4: marcusj_trades - all 3 prefs
  ('i30000000000000000000000000000009', 'a0000000000000000000000000000004', 'theme', 'dark', '2025-05-15T08:30:00Z'),
  ('i3000000000000000000000000000000a', 'a0000000000000000000000000000004', 'notifications', 'all', '2025-05-15T08:30:00Z'),
  ('i3000000000000000000000000000000b', 'a0000000000000000000000000000004', 'default_asset_type', 'crypto', '2025-05-15T08:30:00Z'),

-- User 5: priyafinance - 2 prefs
  ('i3000000000000000000000000000000c', 'a0000000000000000000000000000005', 'theme', 'dark', '2025-04-25T09:00:00Z'),
  ('i3000000000000000000000000000000d', 'a0000000000000000000000000000005', 'notifications', 'trades_only', '2025-04-25T09:00:00Z'),

-- User 6: tylerb - 2 prefs
  ('i3000000000000000000000000000000e', 'a0000000000000000000000000000006', 'theme', 'dark', '2025-07-10T09:00:00Z'),
  ('i3000000000000000000000000000000f', 'a0000000000000000000000000000006', 'default_asset_type', 'etf', '2025-07-10T09:00:00Z'),

-- User 7: meilin_stocks - 2 prefs
  ('i30000000000000000000000000000010', 'a0000000000000000000000000000007', 'theme', 'dark', '2025-06-22T10:00:00Z'),
  ('i30000000000000000000000000000011', 'a0000000000000000000000000000007', 'notifications', 'all', '2025-06-22T10:00:00Z'),

-- User 8: dave_trades - 1 pref
  ('i30000000000000000000000000000012', 'a0000000000000000000000000000008', 'theme', 'dark', '2025-07-15T08:45:00Z'),

-- User 9: emmaw - 2 prefs
  ('i30000000000000000000000000000013', 'a0000000000000000000000000000009', 'theme', 'light', '2025-06-20T09:00:00Z'),
  ('i30000000000000000000000000000014', 'a0000000000000000000000000000009', 'notifications', 'trades_only', '2025-06-20T09:00:00Z'),

-- User 10: carlosg - 1 pref
  ('i30000000000000000000000000000015', 'a000000000000000000000000000000a', 'theme', 'dark', '2025-08-01T10:00:00Z'),

-- User 11: aishap - all 3 prefs
  ('i30000000000000000000000000000016', 'a000000000000000000000000000000b', 'theme', 'dark', '2025-06-05T09:00:00Z'),
  ('i30000000000000000000000000000017', 'a000000000000000000000000000000b', 'notifications', 'all', '2025-06-05T09:00:00Z'),
  ('i30000000000000000000000000000018', 'a000000000000000000000000000000b', 'default_asset_type', 'stock', '2025-06-05T09:00:00Z'),

-- User 12: ryankim - 2 prefs
  ('i30000000000000000000000000000019', 'a000000000000000000000000000000c', 'theme', 'dark', '2025-08-10T09:30:00Z'),
  ('i3000000000000000000000000000001a', 'a000000000000000000000000000000c', 'default_asset_type', 'crypto', '2025-08-10T09:30:00Z'),

-- User 13: oliviab - 1 pref
  ('i3000000000000000000000000000001b', 'a000000000000000000000000000000d', 'theme', 'light', '2025-09-05T10:00:00Z'),

-- User 14: noahg - 2 prefs
  ('i3000000000000000000000000000001c', 'a000000000000000000000000000000e', 'theme', 'dark', '2025-08-25T09:00:00Z'),
  ('i3000000000000000000000000000001d', 'a000000000000000000000000000000e', 'notifications', 'none', '2025-08-25T09:00:00Z'),

-- User 15: zoet - 1 pref
  ('i3000000000000000000000000000001e', 'a000000000000000000000000000000f', 'theme', 'light', '2025-09-18T10:00:00Z'),

-- User 16: liama - 1 pref
  ('i3000000000000000000000000000001f', 'a0000000000000000000000000000010', 'theme', 'dark', '2025-10-08T09:00:00Z'),

-- User 17: chloed - 2 prefs
  ('i30000000000000000000000000000020', 'a0000000000000000000000000000011', 'theme', 'dark', '2025-08-01T09:30:00Z'),
  ('i30000000000000000000000000000021', 'a0000000000000000000000000000011', 'notifications', 'trades_only', '2025-08-01T09:30:00Z'),

-- User 18: ethanm - 1 pref
  ('i30000000000000000000000000000022', 'a0000000000000000000000000000012', 'theme', 'dark', '2025-10-22T10:00:00Z'),

-- User 19: avaj - 1 pref
  ('i30000000000000000000000000000023', 'a0000000000000000000000000000013', 'theme', 'light', '2025-09-10T09:00:00Z'),

-- User 22: masonc - 2 prefs
  ('i30000000000000000000000000000024', 'a0000000000000000000000000000016', 'theme', 'dark', '2025-11-18T09:00:00Z'),
  ('i30000000000000000000000000000025', 'a0000000000000000000000000000016', 'notifications', 'all', '2025-11-18T09:00:00Z'),

-- User 25: miat - 2 prefs
  ('i30000000000000000000000000000026', 'a0000000000000000000000000000019', 'theme', 'dark', '2025-10-30T09:30:00Z'),
  ('i30000000000000000000000000000027', 'a0000000000000000000000000000019', 'notifications', 'all', '2025-10-30T09:30:00Z'),

-- User 28: willt - 1 pref
  ('i30000000000000000000000000000028', 'a000000000000000000000000000001c', 'theme', 'dark', '2025-11-10T09:00:00Z'),

-- User 29: charlottew - 2 prefs
  ('i30000000000000000000000000000029', 'a000000000000000000000000000001d', 'theme', 'light', '2025-10-15T09:00:00Z'),
  ('i3000000000000000000000000000002a', 'a000000000000000000000000000001d', 'notifications', 'none', '2025-10-15T09:00:00Z'),

-- User 30: danielk - all 3 prefs
  ('i3000000000000000000000000000002b', 'a000000000000000000000000000001e', 'theme', 'dark', '2025-05-20T09:00:00Z'),
  ('i3000000000000000000000000000002c', 'a000000000000000000000000000001e', 'notifications', 'all', '2025-05-20T09:00:00Z'),
  ('i3000000000000000000000000000002d', 'a000000000000000000000000000001e', 'default_asset_type', 'stock', '2025-05-20T09:00:00Z');

-- Table: monthly_resets
-- ============================================================
-- MONTHLY_RESETS Seed Data
-- ~40 rows for users active across multiple months
-- UNIQUE(user_id, competition_month)
-- ID format: i40000000000000000000000000000XXX
-- choice: 'new' or 'keep'
-- Previous portfolio IDs use format b0000000000000000000000000000XX02
--   (02 suffix = previous month portfolio, 03 = two months ago, etc.)
-- New portfolio IDs for 'new' choice use b0000000000000000000000000000XX0N
-- ============================================================

INSERT INTO monthly_resets (id, user_id, competition_month, choice, previous_portfolio_id, new_portfolio_id, previous_equity, processed_at) VALUES

-- User 1: traderpro - 4 resets, mostly 'keep' (power user, growing equity)
  ('i40000000000000000000000000000001', 'a0000000000000000000000000000001', '2025-11', 'keep', NULL, NULL, 38500.00, '2025-11-01T00:05:00Z'),
  ('i40000000000000000000000000000002', 'a0000000000000000000000000000001', '2025-12', 'keep', NULL, NULL, 40200.00, '2025-12-01T00:05:00Z'),
  ('i40000000000000000000000000000003', 'a0000000000000000000000000000001', '2026-01', 'keep', NULL, NULL, 42800.00, '2026-01-01T00:05:00Z'),
  ('i40000000000000000000000000000004', 'a0000000000000000000000000000001', '2026-02', 'keep', NULL, NULL, 44100.00, '2026-02-01T00:05:00Z'),

-- User 2: quantjamie - 3 resets, all 'keep'
  ('i40000000000000000000000000000005', 'a0000000000000000000000000000002', '2025-12', 'keep', NULL, NULL, 34500.00, '2025-12-01T00:05:00Z'),
  ('i40000000000000000000000000000006', 'a0000000000000000000000000000002', '2026-01', 'keep', NULL, NULL, 36200.00, '2026-01-01T00:05:00Z'),
  ('i40000000000000000000000000000007', 'a0000000000000000000000000000002', '2026-02', 'keep', NULL, NULL, 37500.00, '2026-02-01T00:05:00Z'),

-- User 3: sofiainvests - 3 resets, all 'keep'
  ('i40000000000000000000000000000008', 'a0000000000000000000000000000003', '2025-12', 'keep', NULL, NULL, 37800.00, '2025-12-01T00:05:00Z'),
  ('i40000000000000000000000000000009', 'a0000000000000000000000000000003', '2026-01', 'keep', NULL, NULL, 39500.00, '2026-01-01T00:05:00Z'),
  ('i4000000000000000000000000000000a', 'a0000000000000000000000000000003', '2026-02', 'keep', NULL, NULL, 41200.00, '2026-02-01T00:05:00Z'),

-- User 4: marcusj_trades - 4 resets, 3 keep + 1 new (bad November)
  ('i4000000000000000000000000000000b', 'a0000000000000000000000000000004', '2025-11', 'keep', NULL, NULL, 32000.00, '2025-11-01T00:05:00Z'),
  ('i4000000000000000000000000000000c', 'a0000000000000000000000000000004', '2025-12', 'new', 'b00000000000000000000000000000402', 'b00000000000000000000000000000403', 22800.00, '2025-12-01T00:05:00Z'),
  ('i4000000000000000000000000000000d', 'a0000000000000000000000000000004', '2026-01', 'keep', NULL, NULL, 28900.00, '2026-01-01T00:05:00Z'),
  ('i4000000000000000000000000000000e', 'a0000000000000000000000000000004', '2026-02', 'keep', NULL, NULL, 34200.00, '2026-02-01T00:05:00Z'),

-- User 5: priyafinance - 3 resets, all 'keep' (conservative, steady growth)
  ('i4000000000000000000000000000000f', 'a0000000000000000000000000000005', '2025-12', 'keep', NULL, NULL, 35200.00, '2025-12-01T00:05:00Z'),
  ('i40000000000000000000000000000010', 'a0000000000000000000000000000005', '2026-01', 'keep', NULL, NULL, 37500.00, '2026-01-01T00:05:00Z'),
  ('i40000000000000000000000000000011', 'a0000000000000000000000000000005', '2026-02', 'keep', NULL, NULL, 39200.00, '2026-02-01T00:05:00Z'),

-- User 6: tylerb - 2 resets, both keep
  ('i40000000000000000000000000000012', 'a0000000000000000000000000000006', '2026-01', 'keep', NULL, NULL, 30500.00, '2026-01-01T00:05:00Z'),
  ('i40000000000000000000000000000013', 'a0000000000000000000000000000006', '2026-02', 'keep', NULL, NULL, 31800.00, '2026-02-01T00:05:00Z'),

-- User 7: meilin_stocks - 2 resets, keep then new
  ('i40000000000000000000000000000014', 'a0000000000000000000000000000007', '2026-01', 'keep', NULL, NULL, 31200.00, '2026-01-01T00:05:00Z'),
  ('i40000000000000000000000000000015', 'a0000000000000000000000000000007', '2026-02', 'new', 'b00000000000000000000000000000702', 'b00000000000000000000000000000703', 29800.00, '2026-02-01T00:05:00Z'),

-- User 8: dave_trades - 2 resets, 1 keep + 1 new
  ('i40000000000000000000000000000016', 'a0000000000000000000000000000008', '2026-01', 'new', 'b00000000000000000000000000000802', 'b00000000000000000000000000000803', 24200.00, '2026-01-01T00:05:00Z'),
  ('i40000000000000000000000000000017', 'a0000000000000000000000000000008', '2026-02', 'keep', NULL, NULL, 27100.00, '2026-02-01T00:05:00Z'),

-- User 9: emmaw - 2 resets, both keep
  ('i40000000000000000000000000000018', 'a0000000000000000000000000000009', '2026-01', 'keep', NULL, NULL, 29800.00, '2026-01-01T00:05:00Z'),
  ('i40000000000000000000000000000019', 'a0000000000000000000000000000009', '2026-02', 'keep', NULL, NULL, 30500.00, '2026-02-01T00:05:00Z'),

-- User 10: carlosg - 2 resets, 1 new + 1 keep
  ('i4000000000000000000000000000001a', 'a000000000000000000000000000000a', '2026-01', 'keep', NULL, NULL, 28200.00, '2026-01-01T00:05:00Z'),
  ('i4000000000000000000000000000001b', 'a000000000000000000000000000000a', '2026-02', 'new', 'b00000000000000000000000000000a02', 'b00000000000000000000000000000a03', 26800.00, '2026-02-01T00:05:00Z'),

-- User 11: aishap - 3 resets, all keep
  ('i4000000000000000000000000000001c', 'a000000000000000000000000000000b', '2025-12', 'keep', NULL, NULL, 33000.00, '2025-12-01T00:05:00Z'),
  ('i4000000000000000000000000000001d', 'a000000000000000000000000000000b', '2026-01', 'keep', NULL, NULL, 34800.00, '2026-01-01T00:05:00Z'),
  ('i4000000000000000000000000000001e', 'a000000000000000000000000000000b', '2026-02', 'keep', NULL, NULL, 35500.00, '2026-02-01T00:05:00Z'),

-- User 12: ryankim - 2 resets, 1 keep + 1 new
  ('i4000000000000000000000000000001f', 'a000000000000000000000000000000c', '2026-01', 'new', 'b00000000000000000000000000000c02', 'b00000000000000000000000000000c03', 24500.00, '2026-01-01T00:05:00Z'),
  ('i40000000000000000000000000000020', 'a000000000000000000000000000000c', '2026-02', 'keep', NULL, NULL, 29200.00, '2026-02-01T00:05:00Z'),

-- User 28: willt - 2 resets, both 'new' (trying to start fresh after losses)
  ('i40000000000000000000000000000021', 'a000000000000000000000000000001c', '2026-01', 'new', 'b00000000000000000000000000001c02', 'b00000000000000000000000000001c03', 19200.00, '2026-01-01T00:05:00Z'),
  ('i40000000000000000000000000000022', 'a000000000000000000000000000001c', '2026-02', 'new', 'b00000000000000000000000000001c03', 'b00000000000000000000000000001c04', 21000.00, '2026-02-01T00:05:00Z'),

-- User 29: charlottew - 5 resets, ALL 'new' (always resets every month)
  ('i40000000000000000000000000000023', 'a000000000000000000000000000001d', '2025-10', 'new', 'b00000000000000000000000000001d02', 'b00000000000000000000000000001d03', 26200.00, '2025-10-01T00:05:00Z'),
  ('i40000000000000000000000000000024', 'a000000000000000000000000000001d', '2025-11', 'new', 'b00000000000000000000000000001d03', 'b00000000000000000000000000001d04', 24800.00, '2025-11-01T00:05:00Z'),
  ('i40000000000000000000000000000025', 'a000000000000000000000000000001d', '2025-12', 'new', 'b00000000000000000000000000001d04', 'b00000000000000000000000000001d05', 27100.00, '2025-12-01T00:05:00Z'),
  ('i40000000000000000000000000000026', 'a000000000000000000000000000001d', '2026-01', 'new', 'b00000000000000000000000000001d05', 'b00000000000000000000000000001d06', 23500.00, '2026-01-01T00:05:00Z'),
  ('i40000000000000000000000000000027', 'a000000000000000000000000000001d', '2026-02', 'new', 'b00000000000000000000000000001d06', 'b00000000000000000000000000001d07', 25000.00, '2026-02-01T00:05:00Z');

-- Table: market_quotes
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

-- Table: market_news
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

-- End of seed data
