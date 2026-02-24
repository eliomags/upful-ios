import type { Env, MarketQuote } from '../../models/types';

export interface SearchResult {
  symbol: string;
  name: string;
  type: string;
  exchange: string;
}

export interface ChartPoint {
  timestamp: number;
  open: number;
  high: number;
  low: number;
  close: number;
  volume: number;
}

interface YahooChartResponse {
  chart: {
    result: Array<{
      meta: {
        regularMarketPrice: number;
        previousClose: number;
        chartPreviousClose: number;
        currency: string;
        symbol: string;
      };
      timestamp: number[];
      indicators: {
        quote: Array<{
          open: number[];
          high: number[];
          low: number[];
          close: number[];
          volume: number[];
        }>;
      };
    }>;
    error: null | { code: string; description: string };
  };
}

interface YahooSearchResponse {
  quotes: Array<{
    symbol: string;
    shortname?: string;
    longname?: string;
    quoteType: string;
    exchDisp: string;
  }>;
}

export class YahooFinanceClient {
  private baseUrl = 'https://query1.finance.yahoo.com/v8/finance';
  private searchUrl = 'https://query1.finance.yahoo.com/v1/finance';

  constructor(private env: Env) {}

  async getQuote(ticker: string): Promise<MarketQuote | null> {
    try {
      const url = `${this.baseUrl}/chart/${ticker}?interval=1d&range=1d`;
      const response = await fetch(url, {
        headers: {
          'User-Agent': 'Mozilla/5.0 (compatible; Jyanik/1.0)',
        },
      });

      if (!response.ok) {
        console.error(`Yahoo Finance API error: ${response.status} ${response.statusText}`);
        return null;
      }

      const data: YahooChartResponse = await response.json();

      if (!data.chart?.result || data.chart.result.length === 0) {
        console.error('No chart data returned for ticker:', ticker);
        return null;
      }

      if (data.chart.error) {
        console.error('Yahoo Finance chart error:', data.chart.error);
        return null;
      }

      const result = data.chart.result[0];
      const meta = result.meta;
      const quote = result.indicators?.quote?.[0];

      if (!meta || !quote) {
        console.error('Missing meta or quote data');
        return null;
      }

      const currentPrice = meta.regularMarketPrice;
      const previousClose = meta.previousClose || meta.chartPreviousClose;
      const change = currentPrice - previousClose;
      const changePercent = (change / previousClose) * 100;

      // Get latest OHLCV data
      const lastIndex = quote.close.length - 1;
      const open = quote.open[lastIndex] || currentPrice;
      const high = quote.high[lastIndex] || currentPrice;
      const low = quote.low[lastIndex] || currentPrice;
      const volume = quote.volume[lastIndex] || 0;

      const marketQuote: MarketQuote = {
        ticker: meta.symbol,
        company_name: meta.symbol, // Will be enriched from search if needed
        asset_type: 'stock',
        current_price: currentPrice,
        previous_close: previousClose,
        open_price: open,
        day_high: high,
        day_low: low,
        volume,
        market_cap: null,
        pe_ratio: null,
        dividend_yield: null,
        change_dollar: change,
        change_percent: changePercent,
        updated_at: new Date().toISOString(),
      };

      return marketQuote;
    } catch (error) {
      console.error('Error fetching quote from Yahoo Finance:', error);
      return null;
    }
  }

  async search(query: string): Promise<SearchResult[]> {
    try {
      const url = `${this.searchUrl}/search?q=${encodeURIComponent(query)}&quotesCount=10&newsCount=0`;
      const response = await fetch(url, {
        headers: {
          'User-Agent': 'Mozilla/5.0 (compatible; Jyanik/1.0)',
        },
      });

      if (!response.ok) {
        console.error(`Yahoo Finance search error: ${response.status} ${response.statusText}`);
        return [];
      }

      const data: YahooSearchResponse = await response.json();

      if (!data.quotes || data.quotes.length === 0) {
        return [];
      }

      return data.quotes.map((quote) => ({
        symbol: quote.symbol,
        name: quote.longname || quote.shortname || quote.symbol,
        type: quote.quoteType || 'EQUITY',
        exchange: quote.exchDisp || 'Unknown',
      }));
    } catch (error) {
      console.error('Error searching Yahoo Finance:', error);
      return [];
    }
  }

  async getChart(ticker: string, range: string): Promise<ChartPoint[]> {
    try {
      // Map range to Yahoo Finance parameters
      const rangeMap: Record<string, { range: string; interval: string }> = {
        '1D': { range: '1d', interval: '5m' },
        '1W': { range: '5d', interval: '15m' },
        '1M': { range: '1mo', interval: '1d' },
        '3M': { range: '3mo', interval: '1d' },
        '6M': { range: '6mo', interval: '1d' },
        '1Y': { range: '1y', interval: '1wk' },
        '5Y': { range: '5y', interval: '1mo' },
      };

      const params = rangeMap[range] || rangeMap['1D'];
      const url = `${this.baseUrl}/chart/${ticker}?interval=${params.interval}&range=${params.range}`;

      const response = await fetch(url, {
        headers: {
          'User-Agent': 'Mozilla/5.0 (compatible; Jyanik/1.0)',
        },
      });

      if (!response.ok) {
        console.error(`Yahoo Finance chart error: ${response.status} ${response.statusText}`);
        return [];
      }

      const data: YahooChartResponse = await response.json();

      if (!data.chart?.result || data.chart.result.length === 0) {
        return [];
      }

      if (data.chart.error) {
        console.error('Yahoo Finance chart error:', data.chart.error);
        return [];
      }

      const result = data.chart.result[0];
      const timestamps = result.timestamp || [];
      const quote = result.indicators?.quote?.[0];

      if (!quote) {
        return [];
      }

      const chartPoints: ChartPoint[] = [];

      for (let i = 0; i < timestamps.length; i++) {
        // Skip null/undefined values
        if (
          quote.open[i] === null ||
          quote.high[i] === null ||
          quote.low[i] === null ||
          quote.close[i] === null
        ) {
          continue;
        }

        chartPoints.push({
          timestamp: timestamps[i],
          open: quote.open[i],
          high: quote.high[i],
          low: quote.low[i],
          close: quote.close[i],
          volume: quote.volume[i] || 0,
        });
      }

      return chartPoints;
    } catch (error) {
      console.error('Error fetching chart from Yahoo Finance:', error);
      return [];
    }
  }
}
