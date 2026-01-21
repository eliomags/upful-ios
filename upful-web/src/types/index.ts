// Core Types for UPFUL Stock Portfolio App

export interface Stock {
  ticker: string;
  companyName: string;
  currentPrice: number;
  previousClose: number;
  change: number;
  changePercent: number;
  marketCap?: number;
  volume?: number;
  high52Week?: number;
  low52Week?: number;
  peRatio?: number;
  dividendYield?: number;
  sector?: string;
  industry?: string;
}

export interface Holding {
  ticker: string;
  companyName: string;
  shares: number;
  averageCost: number;
  currentPrice: number;
  totalValue: number;
  totalCost: number;
  gain: number;
  gainPercent: number;
  change: number;
  changePercent: number;
}

export interface Transaction {
  id: string;
  ticker: string;
  companyName: string;
  type: 'buy' | 'sell';
  shares: number;
  price: number;
  total: number;
  date: Date;
}

export interface Portfolio {
  holdings: Holding[];
  cashBalance: number;
  totalEquity: number;
  totalValue: number;
  dayChange: number;
  dayChangePercent: number;
  totalGain: number;
  totalGainPercent: number;
}

export interface WatchlistItem {
  ticker: string;
  companyName: string;
  currentPrice: number;
  change: number;
  changePercent: number;
  notes?: string;
  addedAt: Date;
}

export interface SavedScreener {
  id: string;
  name: string;
  description?: string;
  filters: ScreenerFilters;
  createdAt: Date;
}

export interface ScreenerFilters {
  sectors?: string[];
  industries?: string[];
  marketCapMin?: number;
  marketCapMax?: number;
  peRatioMin?: number;
  peRatioMax?: number;
  dividendYieldMin?: number;
  dividendYieldMax?: number;
  growthRate?: 'high' | 'medium' | 'low' | 'negative';
  profitability?: 'profitable' | 'unprofitable' | 'all';
}

export interface ChartDataPoint {
  date: string;
  price: number;
  volume?: number;
}

export interface NewsArticle {
  id: string;
  title: string;
  summary: string;
  source: string;
  url: string;
  publishedAt: Date;
  tickers?: string[];
  imageUrl?: string;
}

export interface UserPreferences {
  preferredSectors: string[];
  preferredGrowth: string[];
  preferredDividend: boolean;
  notifications: boolean;
  darkMode: boolean;
}

export type TimeRange = '1D' | '1W' | '1M' | '3M' | '1Y' | '5Y' | 'ALL';
