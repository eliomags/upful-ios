-- Migration 002: Portfolios & Trading
-- Creates: portfolios, positions, trades, portfolio_snapshots

CREATE TABLE IF NOT EXISTS portfolios (
    id              TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    user_id         TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    cash_balance    REAL NOT NULL DEFAULT 25000.00,
    total_equity    REAL NOT NULL DEFAULT 25000.00,
    is_active       INTEGER DEFAULT 1,
    competition_month TEXT,
    created_at      TEXT DEFAULT (datetime('now')),
    updated_at      TEXT DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_portfolios_user ON portfolios(user_id);
CREATE INDEX IF NOT EXISTS idx_portfolios_active ON portfolios(user_id, is_active);
CREATE INDEX IF NOT EXISTS idx_portfolios_month ON portfolios(competition_month);

CREATE TABLE IF NOT EXISTS positions (
    id              TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    portfolio_id    TEXT NOT NULL REFERENCES portfolios(id) ON DELETE CASCADE,
    user_id         TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    ticker          TEXT NOT NULL,
    asset_type      TEXT NOT NULL DEFAULT 'stock',
    quantity        REAL NOT NULL DEFAULT 0,
    average_cost    REAL NOT NULL DEFAULT 0,
    current_price   REAL DEFAULT 0,
    market_value    REAL DEFAULT 0,
    unrealized_pnl  REAL DEFAULT 0,
    updated_at      TEXT DEFAULT (datetime('now')),
    UNIQUE(portfolio_id, ticker)
);

CREATE INDEX IF NOT EXISTS idx_positions_portfolio ON positions(portfolio_id);
CREATE INDEX IF NOT EXISTS idx_positions_user ON positions(user_id);
CREATE INDEX IF NOT EXISTS idx_positions_ticker ON positions(ticker);

CREATE TABLE IF NOT EXISTS trades (
    id              TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    portfolio_id    TEXT NOT NULL REFERENCES portfolios(id) ON DELETE CASCADE,
    user_id         TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    ticker          TEXT NOT NULL,
    asset_type      TEXT NOT NULL DEFAULT 'stock',
    side            TEXT NOT NULL,
    quantity        REAL NOT NULL,
    price           REAL NOT NULL,
    total_value     REAL NOT NULL,
    order_type      TEXT DEFAULT 'market',
    status          TEXT DEFAULT 'filled',
    executed_at     TEXT DEFAULT (datetime('now')),
    created_at      TEXT DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_trades_portfolio ON trades(portfolio_id);
CREATE INDEX IF NOT EXISTS idx_trades_user ON trades(user_id);
CREATE INDEX IF NOT EXISTS idx_trades_ticker ON trades(ticker);
CREATE INDEX IF NOT EXISTS idx_trades_executed ON trades(executed_at);

CREATE TABLE IF NOT EXISTS portfolio_snapshots (
    id              TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    portfolio_id    TEXT NOT NULL REFERENCES portfolios(id) ON DELETE CASCADE,
    user_id         TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    snapshot_date   TEXT NOT NULL,
    cash_balance    REAL NOT NULL,
    holdings_value  REAL NOT NULL,
    total_equity    REAL NOT NULL,
    daily_pnl       REAL DEFAULT 0,
    daily_pnl_pct   REAL DEFAULT 0,
    total_pnl       REAL DEFAULT 0,
    total_pnl_pct   REAL DEFAULT 0,
    created_at      TEXT DEFAULT (datetime('now')),
    UNIQUE(portfolio_id, snapshot_date)
);

CREATE INDEX IF NOT EXISTS idx_snapshots_user_date ON portfolio_snapshots(user_id, snapshot_date);
CREATE INDEX IF NOT EXISTS idx_snapshots_date ON portfolio_snapshots(snapshot_date);
CREATE INDEX IF NOT EXISTS idx_snapshots_portfolio ON portfolio_snapshots(portfolio_id);
