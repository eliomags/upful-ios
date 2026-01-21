'use client';

import { cn, formatCurrency, formatDate } from '@/lib/utils';
import { Transaction } from '@/types';
import { ArrowDownLeft, ArrowUpRight } from 'lucide-react';
import { motion } from 'framer-motion';

interface TransactionCardProps {
  transaction: Transaction;
  index?: number;
}

export function TransactionCard({ transaction, index = 0 }: TransactionCardProps) {
  const isBuy = transaction.type === 'buy';

  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: index * 0.05 }}
      className="flex items-center justify-between p-4 bg-white dark:bg-gray-900 rounded-xl"
    >
      <div className="flex items-center gap-3">
        <div
          className={cn(
            'w-10 h-10 rounded-full flex items-center justify-center',
            isBuy
              ? 'bg-emerald-100 dark:bg-emerald-900/30'
              : 'bg-red-100 dark:bg-red-900/30'
          )}
        >
          {isBuy ? (
            <ArrowDownLeft className="w-5 h-5 text-emerald-600 dark:text-emerald-400" />
          ) : (
            <ArrowUpRight className="w-5 h-5 text-red-600 dark:text-red-400" />
          )}
        </div>
        <div>
          <div className="flex items-center gap-2">
            <span className="font-semibold text-gray-900 dark:text-white">
              {transaction.ticker}
            </span>
            <span
              className={cn(
                'text-xs font-medium px-2 py-0.5 rounded-full',
                isBuy
                  ? 'bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400'
                  : 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400'
              )}
            >
              {isBuy ? 'Buy' : 'Sell'}
            </span>
          </div>
          <p className="text-sm text-gray-500 dark:text-gray-400">
            {transaction.shares} shares @ {formatCurrency(transaction.price)}
          </p>
        </div>
      </div>

      <div className="text-right">
        <p className="font-semibold text-gray-900 dark:text-white">
          {isBuy ? '-' : '+'}{formatCurrency(transaction.total)}
        </p>
        <p className="text-sm text-gray-500 dark:text-gray-400">
          {formatDate(new Date(transaction.date))}
        </p>
      </div>
    </motion.div>
  );
}
