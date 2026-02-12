-- Migration 005: User Data
-- Creates: watchlist, saved_screeners, user_preferences, monthly_resets

CREATE TABLE IF NOT EXISTS watchlist (
    id          TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    user_id     TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    ticker      TEXT NOT NULL,
    sort_order  INTEGER DEFAULT 0,
    notes       TEXT,
    created_at  TEXT DEFAULT (datetime('now')),
    UNIQUE(user_id, ticker)
);

CREATE INDEX IF NOT EXISTS idx_watchlist_user ON watchlist(user_id, sort_order);

CREATE TABLE IF NOT EXISTS saved_screeners (
    id              TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    user_id         TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title           TEXT NOT NULL,
    description     TEXT,
    parameters      TEXT NOT NULL,
    color           TEXT DEFAULT '#008080',
    sort_order      INTEGER DEFAULT 0,
    is_prebuilt     INTEGER DEFAULT 0,
    usage_count     INTEGER DEFAULT 0,
    created_at      TEXT DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_screeners_user ON saved_screeners(user_id, sort_order);

CREATE TABLE IF NOT EXISTS user_preferences (
    id          TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    user_id     TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    category    TEXT NOT NULL,
    value       TEXT NOT NULL,
    created_at  TEXT DEFAULT (datetime('now')),
    UNIQUE(user_id, category, value)
);

CREATE INDEX IF NOT EXISTS idx_prefs_user ON user_preferences(user_id);

CREATE TABLE IF NOT EXISTS monthly_resets (
    id              TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    user_id         TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    competition_month TEXT NOT NULL,
    choice          TEXT NOT NULL,
    previous_portfolio_id TEXT REFERENCES portfolios(id),
    new_portfolio_id TEXT REFERENCES portfolios(id),
    previous_equity REAL,
    processed_at    TEXT DEFAULT (datetime('now')),
    UNIQUE(user_id, competition_month)
);
