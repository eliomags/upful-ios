-- Migration 003: Competitions & Leaderboard
-- Creates: competitions, competition_entries, leaderboard_cache

CREATE TABLE IF NOT EXISTS competitions (
    id              TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    type            TEXT NOT NULL,
    status          TEXT DEFAULT 'active',
    start_date      TEXT NOT NULL,
    end_date        TEXT NOT NULL,
    total_prize_pool REAL DEFAULT 0,
    participant_count INTEGER DEFAULT 0,
    created_at      TEXT DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_competitions_type_status ON competitions(type, status);
CREATE INDEX IF NOT EXISTS idx_competitions_dates ON competitions(start_date, end_date);

CREATE TABLE IF NOT EXISTS competition_entries (
    id              TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    competition_id  TEXT NOT NULL REFERENCES competitions(id) ON DELETE CASCADE,
    user_id         TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    portfolio_id    TEXT NOT NULL REFERENCES portfolios(id),
    starting_equity REAL NOT NULL DEFAULT 25000.00,
    ending_equity   REAL,
    growth_pct      REAL DEFAULT 0,
    rank            INTEGER,
    prize_amount    REAL DEFAULT 0,
    prize_status    TEXT DEFAULT 'none',
    created_at      TEXT DEFAULT (datetime('now')),
    updated_at      TEXT DEFAULT (datetime('now')),
    UNIQUE(competition_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_comp_entries_competition ON competition_entries(competition_id);
CREATE INDEX IF NOT EXISTS idx_comp_entries_user ON competition_entries(user_id);
CREATE INDEX IF NOT EXISTS idx_comp_entries_rank ON competition_entries(competition_id, rank);
CREATE INDEX IF NOT EXISTS idx_comp_entries_growth ON competition_entries(competition_id, growth_pct DESC);

CREATE TABLE IF NOT EXISTS leaderboard_cache (
    id              TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    competition_id  TEXT NOT NULL REFERENCES competitions(id) ON DELETE CASCADE,
    user_id         TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    rank            INTEGER NOT NULL,
    username        TEXT NOT NULL,
    display_name    TEXT,
    avatar_key      TEXT,
    total_equity    REAL NOT NULL,
    growth_pct      REAL NOT NULL,
    subscription_tier TEXT NOT NULL,
    updated_at      TEXT DEFAULT (datetime('now')),
    UNIQUE(competition_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_leaderboard_comp_rank ON leaderboard_cache(competition_id, rank);
CREATE INDEX IF NOT EXISTS idx_leaderboard_comp_tier ON leaderboard_cache(competition_id, subscription_tier, rank);
