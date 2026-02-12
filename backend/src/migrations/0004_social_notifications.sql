-- Migration 004: Chat, Notifications, Payouts, Purchases
-- Creates: chat_messages, notifications, payouts, purchases

CREATE TABLE IF NOT EXISTS chat_messages (
    id              TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    user_id         TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    username        TEXT NOT NULL,
    content         TEXT,
    image_key       TEXT,
    tickers         TEXT,
    is_deleted      INTEGER DEFAULT 0,
    created_at      TEXT DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_chat_created ON chat_messages(created_at);
CREATE INDEX IF NOT EXISTS idx_chat_user ON chat_messages(user_id);

CREATE TABLE IF NOT EXISTS notifications (
    id              TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    user_id         TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type            TEXT NOT NULL,
    title           TEXT NOT NULL,
    body            TEXT NOT NULL,
    amount          REAL,
    metadata        TEXT,
    is_read         INTEGER DEFAULT 0,
    created_at      TEXT DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications(user_id, is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_created ON notifications(user_id, created_at);

CREATE TABLE IF NOT EXISTS payouts (
    id                  TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    user_id             TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    competition_entry_id TEXT REFERENCES competition_entries(id),
    amount              REAL NOT NULL,
    method              TEXT NOT NULL,
    paypal_email        TEXT,
    stripe_transfer_id  TEXT,
    status              TEXT DEFAULT 'pending',
    admin_approved_by   TEXT,
    approved_at         TEXT,
    processed_at        TEXT,
    failure_reason      TEXT,
    created_at          TEXT DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_payouts_user ON payouts(user_id);
CREATE INDEX IF NOT EXISTS idx_payouts_status ON payouts(status);

CREATE TABLE IF NOT EXISTS purchases (
    id                      TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    user_id                 TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    product_id              TEXT NOT NULL,
    type                    TEXT NOT NULL,
    apple_transaction_id    TEXT UNIQUE,
    apple_original_txn_id   TEXT,
    price                   REAL NOT NULL,
    currency                TEXT DEFAULT 'USD',
    status                  TEXT DEFAULT 'active',
    purchased_at            TEXT DEFAULT (datetime('now')),
    expires_at              TEXT
);

CREATE INDEX IF NOT EXISTS idx_purchases_user ON purchases(user_id);
CREATE INDEX IF NOT EXISTS idx_purchases_apple_txn ON purchases(apple_transaction_id);
