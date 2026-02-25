import { Hono } from 'hono';
import type { Env } from '../models/types';
import { optionalAuthMiddleware } from '../middleware/auth';
import { YahooFinanceClient } from '../services/market-data/yahoo-finance';

const marketRoutes = new Hono<{ Bindings: Env }>();

// KV caching helper
async function getCached<T>(
  kv: KVNamespace,
  key: string,
  ttl: number,
  fetcher: () => Promise<T>
): Promise<T> {
  try {
    const cached = await kv.get(key, 'json');
    if (cached !== null) {
      return cached as T;
    }
  } catch (error) {
    console.error('KV cache read error:', error);
  }

  const result = await fetcher();

  try {
    await kv.put(key, JSON.stringify(result), { expirationTtl: ttl });
  } catch (error) {
    console.error('KV cache write error:', error);
  }

  return result;
}

// All routes use optional auth (public but auth optional)
marketRoutes.use('*', optionalAuthMiddleware);

// GET /search - Universal search
marketRoutes.get('/search', async (c) => {
  const query = c.req.query('q');

  if (!query) {
    return c.json({ error: 'Query parameter "q" is required' }, 400);
  }

  const yahooClient = new YahooFinanceClient(c.env);
  const cacheKey = `search:${query}`;

  const results = await getCached(c.env.CACHE, cacheKey, 3600, async () => {
    return await yahooClient.search(query);
  });

  return c.json({ results });
});

// GET /quote/:symbol - Get quote
marketRoutes.get('/quote/:symbol', async (c) => {
  const symbol = c.req.param('symbol').toUpperCase();
  const yahooClient = new YahooFinanceClient(c.env);
  const cacheKey = `quote:${symbol}`;

  const quote = await getCached(c.env.CACHE, cacheKey, 900, async () => {
    const quoteData = await yahooClient.getQuote(symbol);

    if (quoteData) {
      // Upsert into D1 for persistence
      try {
        await c.env.DB.prepare(
          `INSERT INTO market_quotes
           (ticker, company_name, current_price, change_dollar, change_percent, volume, market_cap, open_price, day_high, day_low, previous_close, updated_at)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
           ON CONFLICT(ticker) DO UPDATE SET
           company_name = excluded.company_name,
           current_price = excluded.current_price,
           change_dollar = excluded.change_dollar,
           change_percent = excluded.change_percent,
           volume = excluded.volume,
           market_cap = excluded.market_cap,
           open_price = excluded.open_price,
           day_high = excluded.day_high,
           day_low = excluded.day_low,
           previous_close = excluded.previous_close,
           updated_at = excluded.updated_at`
        )
          .bind(
            quoteData.ticker,
            quoteData.company_name,
            quoteData.current_price,
            quoteData.change_dollar,
            quoteData.change_percent,
            quoteData.volume,
            quoteData.market_cap,
            quoteData.open_price,
            quoteData.day_high,
            quoteData.day_low,
            quoteData.previous_close,
            quoteData.updated_at
          )
          .run();
      } catch (error) {
        console.error('Error upserting quote to D1:', error);
      }
    }

    return quoteData;
  });

  if (!quote) {
    return c.json({ error: 'Quote not found' }, 404);
  }

  return c.json(quote);
});

// GET /chart/:symbol - Get chart data
marketRoutes.get('/chart/:symbol', async (c) => {
  const symbol = c.req.param('symbol').toUpperCase();
  const rawRange = (c.req.query('range') || '1D').toUpperCase();

  // Normalize: 5D → 1W (same Yahoo range), accept both cases
  const rangeAliases: Record<string, string> = { '5D': '1W' };
  const range = rangeAliases[rawRange] || rawRange;

  const validRanges = ['1D', '1W', '1M', '3M', '6M', '1Y', '5Y'];
  if (!validRanges.includes(range)) {
    return c.json({ error: 'Invalid range. Valid options: 1D, 5D, 1W, 1M, 3M, 6M, 1Y, 5Y' }, 400);
  }

  const yahooClient = new YahooFinanceClient(c.env);
  const cacheKey = `chart:${symbol}:${range}`;

  // Varying TTL based on range
  const ttlMap: Record<string, number> = {
    '1D': 300, // 5 minutes
    '1W': 900, // 15 minutes
    '1M': 3600, // 1 hour
    '3M': 3600,
    '6M': 3600,
    '1Y': 3600,
    '5Y': 3600,
  };

  const ttl = ttlMap[range] || 300;

  const chartData = await getCached(c.env.CACHE, cacheKey, ttl, async () => {
    return await yahooClient.getChart(symbol, range);
  });

  return c.json({ symbol, range, data: chartData });
});

// GET /news - Get market news
marketRoutes.get('/news', async (c) => {
  const symbol = c.req.query('symbol');
  const limit = parseInt(c.req.query('limit') || '20', 10);

  const cacheKey = `news:${symbol || 'general'}`;

  const news = await getCached(c.env.CACHE, cacheKey, 3600, async () => {
    // Placeholder: Finnhub integration will be added later
    return [];
  });

  return c.json({ symbol: symbol || 'general', limit, news });
});

// GET /fundamentals/:symbol - Get fundamentals
marketRoutes.get('/fundamentals/:symbol', async (c) => {
  const symbol = c.req.param('symbol').toUpperCase();
  const cacheKey = `fundamentals:${symbol}`;

  const fundamentals = await getCached(c.env.CACHE, cacheKey, 86400, async () => {
    // Placeholder: FMP client will be added later
    return {
      symbol,
      message: 'Fundamentals coming soon',
    };
  });

  return c.json(fundamentals);
});

// GET /screener - Stock screener
marketRoutes.get('/screener', async (c) => {
  const sector = c.req.query('sector');
  const marketCapMin = c.req.query('market_cap_min');
  const marketCapMax = c.req.query('market_cap_max');
  const peMin = c.req.query('pe_min');
  const peMax = c.req.query('pe_max');
  const dividendMin = c.req.query('dividend_min');
  const limit = parseInt(c.req.query('limit') || '50', 10);
  const offset = parseInt(c.req.query('offset') || '0', 10);

  // Placeholder: FMP screener API will be added later
  return c.json({
    message: 'Screener coming soon',
    filters: {
      sector,
      market_cap_min: marketCapMin,
      market_cap_max: marketCapMax,
      pe_min: peMin,
      pe_max: peMax,
      dividend_min: dividendMin,
      limit,
      offset,
    },
    results: [],
  });
});

// GET /exchanges - List supported exchanges
marketRoutes.get('/exchanges', async (c) => {
  const exchanges = [
    { code: 'NYSE', name: 'New York Stock Exchange', country: 'US' },
    { code: 'NASDAQ', name: 'NASDAQ', country: 'US' },
    { code: 'LSE', name: 'London Stock Exchange', country: 'UK' },
    { code: 'TSE', name: 'Tokyo Stock Exchange', country: 'JP' },
    { code: 'HKEX', name: 'Hong Kong Stock Exchange', country: 'HK' },
    { code: 'TSX', name: 'Toronto Stock Exchange', country: 'CA' },
    { code: 'ASX', name: 'Australian Securities Exchange', country: 'AU' },
    { code: 'XETR', name: 'Deutsche Borse', country: 'DE' },
    { code: 'CRYPTO', name: 'Cryptocurrency', country: 'GLOBAL' },
  ];

  return c.json({ exchanges });
});

// GET /crypto - Top crypto
marketRoutes.get('/crypto', async (c) => {
  const cacheKey = 'crypto:top';

  const cryptoData = await getCached(c.env.CACHE, cacheKey, 300, async () => {
    try {
      const response = await fetch(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1&sparkline=false'
      );

      if (!response.ok) {
        console.error('CoinGecko API error:', response.status, response.statusText);
        return [];
      }

      const data = await response.json();

      // Map to simplified format
      return (data as any[]).map((coin: any) => ({
        symbol: coin.symbol.toUpperCase(),
        name: coin.name,
        price: coin.current_price,
        change: coin.price_change_24h,
        change_percent: coin.price_change_percentage_24h,
        market_cap: coin.market_cap,
        volume: coin.total_volume,
        rank: coin.market_cap_rank,
      }));
    } catch (error) {
      console.error('Error fetching crypto data:', error);
      return [];
    }
  });

  return c.json({ crypto: cryptoData });
});

export { marketRoutes };
