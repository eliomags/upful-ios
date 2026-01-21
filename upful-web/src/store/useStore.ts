'use client';

import { create } from 'zustand';
import { Holding, WatchlistItem, Transaction, SavedScreener, ScreenerFilters } from '@/types';
import { mockHoldings, mockWatchlist, mockTransactions, mockSavedScreeners } from '@/data/mockData';

interface AppState {
  // Portfolio
  holdings: Holding[];
  cashBalance: number;
  transactions: Transaction[];

  // Watchlist
  watchlist: WatchlistItem[];
  savedScreeners: SavedScreener[];

  // UI State
  isLoading: boolean;
  searchQuery: string;

  // Actions
  setSearchQuery: (query: string) => void;
  addToWatchlist: (item: WatchlistItem) => void;
  removeFromWatchlist: (ticker: string) => void;
  updateWatchlistNotes: (ticker: string, notes: string) => void;
  addScreener: (screener: SavedScreener) => void;
  removeScreener: (id: string) => void;
  executeTrade: (trade: Omit<Transaction, 'id'>) => void;
}

export const useStore = create<AppState>((set) => ({
  // Initial state
  holdings: mockHoldings,
  cashBalance: 25000.00,
  transactions: mockTransactions,
  watchlist: mockWatchlist,
  savedScreeners: mockSavedScreeners,
  isLoading: false,
  searchQuery: '',

  // Actions
  setSearchQuery: (query) => set({ searchQuery: query }),

  addToWatchlist: (item) =>
    set((state) => ({
      watchlist: [...state.watchlist, item],
    })),

  removeFromWatchlist: (ticker) =>
    set((state) => ({
      watchlist: state.watchlist.filter((item) => item.ticker !== ticker),
    })),

  updateWatchlistNotes: (ticker, notes) =>
    set((state) => ({
      watchlist: state.watchlist.map((item) =>
        item.ticker === ticker ? { ...item, notes } : item
      ),
    })),

  addScreener: (screener) =>
    set((state) => ({
      savedScreeners: [...state.savedScreeners, screener],
    })),

  removeScreener: (id) =>
    set((state) => ({
      savedScreeners: state.savedScreeners.filter((s) => s.id !== id),
    })),

  executeTrade: (trade) =>
    set((state) => {
      const newTransaction: Transaction = {
        ...trade,
        id: Date.now().toString(),
      };

      let newCashBalance = state.cashBalance;
      let newHoldings = [...state.holdings];

      if (trade.type === 'buy') {
        newCashBalance -= trade.total;

        const existingHolding = newHoldings.find((h) => h.ticker === trade.ticker);
        if (existingHolding) {
          const totalShares = existingHolding.shares + trade.shares;
          const totalCost = existingHolding.totalCost + trade.total;
          existingHolding.shares = totalShares;
          existingHolding.totalCost = totalCost;
          existingHolding.averageCost = totalCost / totalShares;
          existingHolding.totalValue = totalShares * existingHolding.currentPrice;
          existingHolding.gain = existingHolding.totalValue - totalCost;
          existingHolding.gainPercent = (existingHolding.gain / totalCost) * 100;
        } else {
          // Add new holding (would need stock data in real app)
          newHoldings.push({
            ticker: trade.ticker,
            companyName: trade.companyName,
            shares: trade.shares,
            averageCost: trade.price,
            currentPrice: trade.price,
            totalValue: trade.total,
            totalCost: trade.total,
            gain: 0,
            gainPercent: 0,
            change: 0,
            changePercent: 0,
          });
        }
      } else {
        newCashBalance += trade.total;

        const existingHolding = newHoldings.find((h) => h.ticker === trade.ticker);
        if (existingHolding) {
          existingHolding.shares -= trade.shares;
          if (existingHolding.shares <= 0) {
            newHoldings = newHoldings.filter((h) => h.ticker !== trade.ticker);
          } else {
            existingHolding.totalCost = existingHolding.shares * existingHolding.averageCost;
            existingHolding.totalValue = existingHolding.shares * existingHolding.currentPrice;
            existingHolding.gain = existingHolding.totalValue - existingHolding.totalCost;
            existingHolding.gainPercent = (existingHolding.gain / existingHolding.totalCost) * 100;
          }
        }
      }

      return {
        transactions: [newTransaction, ...state.transactions],
        cashBalance: newCashBalance,
        holdings: newHoldings,
      };
    }),
}));

// Computed values
export function usePortfolioValue() {
  const holdings = useStore((state) => state.holdings);
  const cashBalance = useStore((state) => state.cashBalance);

  const totalEquity = holdings.reduce((sum, h) => sum + h.totalValue, 0);
  const totalCost = holdings.reduce((sum, h) => sum + h.totalCost, 0);
  const totalGain = totalEquity - totalCost;
  const totalGainPercent = totalCost > 0 ? (totalGain / totalCost) * 100 : 0;
  const dayChange = holdings.reduce((sum, h) => sum + (h.change * h.shares), 0);
  const dayChangePercent = totalEquity > 0 ? (dayChange / (totalEquity - dayChange)) * 100 : 0;

  return {
    totalEquity,
    totalValue: totalEquity + cashBalance,
    cashBalance,
    totalGain,
    totalGainPercent,
    dayChange,
    dayChangePercent,
  };
}
