-- Migration 006: Market Data Cache
-- Creates: market_quotes, market_history, market_news

CREATE TABLE IF NOT EXISTS market_quotes (
    ticker          TEXT PRIMARY KEY,
    asset_type      TEXT NOT NULL DEFAULT 'stock',
    company_name    TEXT,
    current_price   REAL,
    previous_close  REAL,
    open_price      REAL,
    day_high        REAL,
    day_low         REAL,
    volume          INTEGER,
    market_cap      REAL,
    pe_ratio        REAL,
    dividend_yield  REAL,
    change_dollar   REAL,
    change_percent  REAL,
    updated_at      TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS market_history (
    id              TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    ticker          TEXT NOT NULL,
    date            TEXT NOT NULL,
    open_price      REAL,
    high_price      REAL,
    low_price       REAL,
    close_price     REAL NOT NULL,
    volume          INTEGER,
    created_at      TEXT DEFAULT (datetime('now')),
    UNIQUE(ticker, date)
);

CREATE INDEX IF NOT EXISTS idx_history_ticker_date ON market_history(ticker, date);

CREATE TABLE IF NOT EXISTS market_news (
    id              TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    ticker          TEXT,
    title           TEXT NOT NULL,
    summary         TEXT,
    source          TEXT,
    url             TEXT NOT NULL,
    image_url       TEXT,
    published_at    TEXT NOT NULL,
    fetched_at      TEXT DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_news_ticker ON market_news(ticker);
CREATE INDEX IF NOT EXISTS idx_news_published ON market_news(published_at);
