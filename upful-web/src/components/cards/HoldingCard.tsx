'use client';

import Link from 'next/link';
import { cn, formatCurrency, formatPercent, getChangeColor } from '@/lib/utils';
import { Holding } from '@/types';
import { TrendingUp, TrendingDown } from 'lucide-react';
import { motion } from 'framer-motion';

interface HoldingCardProps {
  holding: Holding;
  index?: number;
}

export function HoldingCard({ holding, index = 0 }: HoldingCardProps) {
  const isPositive = holding.gain >= 0;

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: index * 0.05 }}
    >
      <Link href={`/stock/${holding.ticker}`}>
        <div className="flex items-center justify-between p-4 bg-white dark:bg-gray-900 rounded-2xl hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors active:scale-[0.98]">
          <div className="flex items-center gap-3">
            <div className="w-12 h-12 bg-gradient-to-br from-gray-100 to-gray-200 dark:from-gray-800 dark:to-gray-700 rounded-xl flex items-center justify-center">
              <span className="text-sm font-bold text-gray-700 dark:text-gray-300">
                {holding.ticker.slice(0, 2)}
              </span>
            </div>
            <div>
              <h3 className="font-semibold text-gray-900 dark:text-white">{holding.ticker}</h3>
              <p className="text-sm text-gray-500 dark:text-gray-400">
                {holding.shares} shares
              </p>
            </div>
          </div>

          <div className="text-right">
            <p className="font-semibold text-gray-900 dark:text-white">
              {formatCurrency(holding.totalValue)}
            </p>
            <div className={cn('flex items-center justify-end gap-1 text-sm', getChangeColor(holding.gain))}>
              {isPositive ? (
                <TrendingUp className="w-3 h-3" />
              ) : (
                <TrendingDown className="w-3 h-3" />
              )}
              <span>{formatPercent(holding.gainPercent)}</span>
            </div>
          </div>
        </div>
      </Link>
    </motion.div>
  );
}

export function HoldingCardSkeleton() {
  return (
    <div className="flex items-center justify-between p-4 bg-white dark:bg-gray-900 rounded-2xl animate-pulse">
      <div className="flex items-center gap-3">
        <div className="w-12 h-12 bg-gray-200 dark:bg-gray-700 rounded-xl" />
        <div>
          <div className="w-16 h-5 bg-gray-200 dark:bg-gray-700 rounded mb-1" />
          <div className="w-20 h-4 bg-gray-200 dark:bg-gray-700 rounded" />
        </div>
      </div>
      <div className="text-right">
        <div className="w-20 h-5 bg-gray-200 dark:bg-gray-700 rounded mb-1 ml-auto" />
        <div className="w-16 h-4 bg-gray-200 dark:bg-gray-700 rounded ml-auto" />
      </div>
    </div>
  );
}
