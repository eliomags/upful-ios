'use client';

import Link from 'next/link';
import { cn, formatCurrency, formatPercent, getChangeColor, formatCompactCurrency } from '@/lib/utils';
import { Stock, WatchlistItem } from '@/types';
import { TrendingUp, TrendingDown, Bookmark, BookmarkCheck } from 'lucide-react';
import { motion } from 'framer-motion';
import { useStore } from '@/store/useStore';

interface StockCardProps {
  stock: Stock | WatchlistItem;
  index?: number;
  showBookmark?: boolean;
  variant?: 'default' | 'compact';
}

export function StockCard({ stock, index = 0, showBookmark = false, variant = 'default' }: StockCardProps) {
  const isPositive = stock.change >= 0;
  const watchlist = useStore((state) => state.watchlist);
  const addToWatchlist = useStore((state) => state.addToWatchlist);
  const removeFromWatchlist = useStore((state) => state.removeFromWatchlist);

  const isInWatchlist = watchlist.some((item) => item.ticker === stock.ticker);

  const handleBookmark = (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();

    if (isInWatchlist) {
      removeFromWatchlist(stock.ticker);
    } else {
      addToWatchlist({
        ticker: stock.ticker,
        companyName: stock.companyName,
        currentPrice: stock.currentPrice,
        change: stock.change,
        changePercent: stock.changePercent,
        addedAt: new Date(),
      });
    }
  };

  if (variant === 'compact') {
    return (
      <motion.div
        initial={{ opacity: 0, scale: 0.95 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ delay: index * 0.05 }}
      >
        <Link href={`/stock/${stock.ticker}`}>
          <div className="p-3 bg-white dark:bg-gray-900 rounded-xl hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors active:scale-[0.98] min-w-[140px]">
            <div className="flex items-center justify-between mb-2">
              <span className="font-semibold text-gray-900 dark:text-white">{stock.ticker}</span>
              <div className={cn('flex items-center gap-0.5 text-xs', getChangeColor(stock.change))}>
                {isPositive ? <TrendingUp className="w-3 h-3" /> : <TrendingDown className="w-3 h-3" />}
              </div>
            </div>
            <p className="text-lg font-bold text-gray-900 dark:text-white">
              {formatCurrency(stock.currentPrice)}
            </p>
            <p className={cn('text-sm', getChangeColor(stock.change))}>
              {formatPercent(stock.changePercent)}
            </p>
          </div>
        </Link>
      </motion.div>
    );
  }

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: index * 0.05 }}
    >
      <Link href={`/stock/${stock.ticker}`}>
        <div className="flex items-center justify-between p-4 bg-white dark:bg-gray-900 rounded-2xl hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors active:scale-[0.98]">
          <div className="flex items-center gap-3">
            <div className="w-12 h-12 bg-gradient-to-br from-indigo-100 to-indigo-200 dark:from-indigo-900/30 dark:to-indigo-800/30 rounded-xl flex items-center justify-center">
              <span className="text-sm font-bold text-indigo-600 dark:text-indigo-400">
                {stock.ticker.slice(0, 2)}
              </span>
            </div>
            <div>
              <h3 className="font-semibold text-gray-900 dark:text-white">{stock.ticker}</h3>
              <p className="text-sm text-gray-500 dark:text-gray-400 line-clamp-1 max-w-[160px]">
                {stock.companyName}
              </p>
            </div>
          </div>

          <div className="flex items-center gap-3">
            <div className="text-right">
              <p className="font-semibold text-gray-900 dark:text-white">
                {formatCurrency(stock.currentPrice)}
              </p>
              <div className={cn('flex items-center justify-end gap-1 text-sm', getChangeColor(stock.change))}>
                {isPositive ? (
                  <TrendingUp className="w-3 h-3" />
                ) : (
                  <TrendingDown className="w-3 h-3" />
                )}
                <span>{formatPercent(stock.changePercent)}</span>
              </div>
            </div>

            {showBookmark && (
              <button
                onClick={handleBookmark}
                className="p-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-full transition-colors"
              >
                {isInWatchlist ? (
                  <BookmarkCheck className="w-5 h-5 text-indigo-600 dark:text-indigo-400" />
                ) : (
                  <Bookmark className="w-5 h-5 text-gray-400" />
                )}
              </button>
            )}
          </div>
        </div>
      </Link>
    </motion.div>
  );
}

export function StockCardSkeleton({ variant = 'default' }: { variant?: 'default' | 'compact' }) {
  if (variant === 'compact') {
    return (
      <div className="p-3 bg-white dark:bg-gray-900 rounded-xl animate-pulse min-w-[140px]">
        <div className="w-12 h-4 bg-gray-200 dark:bg-gray-700 rounded mb-2" />
        <div className="w-16 h-6 bg-gray-200 dark:bg-gray-700 rounded mb-1" />
        <div className="w-12 h-4 bg-gray-200 dark:bg-gray-700 rounded" />
      </div>
    );
  }

  return (
    <div className="flex items-center justify-between p-4 bg-white dark:bg-gray-900 rounded-2xl animate-pulse">
      <div className="flex items-center gap-3">
        <div className="w-12 h-12 bg-gray-200 dark:bg-gray-700 rounded-xl" />
        <div>
          <div className="w-16 h-5 bg-gray-200 dark:bg-gray-700 rounded mb-1" />
          <div className="w-28 h-4 bg-gray-200 dark:bg-gray-700 rounded" />
        </div>
      </div>
      <div className="text-right">
        <div className="w-20 h-5 bg-gray-200 dark:bg-gray-700 rounded mb-1 ml-auto" />
        <div className="w-16 h-4 bg-gray-200 dark:bg-gray-700 rounded ml-auto" />
      </div>
    </div>
  );
}
