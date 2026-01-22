'use client';

import { HomeHeader } from '@/components/layout/Header';
import { Card, CardHeader, CardTitle } from '@/components/ui/Card';
import { HoldingCard } from '@/components/cards/HoldingCard';
import { StockCard } from '@/components/cards/StockCard';
import { NewsCardCompact } from '@/components/cards/NewsCard';
import { TransactionCard } from '@/components/cards/TransactionCard';
import { PortfolioDonut, AllocationList } from '@/components/charts/PortfolioChart';
import { useStore, usePortfolioValue } from '@/store/useStore';
import { mockStocks, mockNews } from '@/data/mockData';
import { formatCurrency, formatPercent, cn } from '@/lib/utils';
import { TrendingUp, TrendingDown, ArrowRight, Wallet, PieChart, History, Newspaper } from 'lucide-react';
import { motion } from 'framer-motion';
import Link from 'next/link';

export default function HomePage() {
  const holdings = useStore((state) => state.holdings);
  const transactions = useStore((state) => state.transactions);
  const portfolio = usePortfolioValue();

  const isPositiveDay = portfolio.dayChange >= 0;
  const isPositiveTotal = portfolio.totalGain >= 0;

  // Get recommended stocks (not in holdings)
  const holdingTickers = holdings.map((h) => h.ticker);
  const recommendedStocks = mockStocks.filter((s) => !holdingTickers.includes(s.ticker)).slice(0, 5);

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-950">
      <HomeHeader />

      <div className="pt-14 px-4 pb-6 space-y-6">
        {/* Portfolio Summary Card */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="mt-4"
        >
          <Card variant="elevated" className="bg-gradient-to-br from-indigo-600 to-purple-700 text-white">
            <div className="flex items-start justify-between mb-4">
              <div>
                <p className="text-indigo-200 text-sm font-medium">Total Portfolio</p>
                <h2 className="text-3xl font-bold mt-1">{formatCurrency(portfolio.totalValue)}</h2>
              </div>
              <div className="w-10 h-10 bg-white/10 rounded-xl flex items-center justify-center">
                <Wallet className="w-5 h-5" />
              </div>
            </div>

            <div className="flex gap-6">
              <div>
                <p className="text-indigo-200 text-xs">Today</p>
                <div className={cn('flex items-center gap-1 mt-0.5', isPositiveDay ? 'text-emerald-300' : 'text-red-300')}>
                  {isPositiveDay ? <TrendingUp className="w-4 h-4" /> : <TrendingDown className="w-4 h-4" />}
                  <span className="font-semibold">{formatPercent(portfolio.dayChangePercent)}</span>
                </div>
              </div>
              <div>
                <p className="text-indigo-200 text-xs">All Time</p>
                <div className={cn('flex items-center gap-1 mt-0.5', isPositiveTotal ? 'text-emerald-300' : 'text-red-300')}>
                  {isPositiveTotal ? <TrendingUp className="w-4 h-4" /> : <TrendingDown className="w-4 h-4" />}
                  <span className="font-semibold">{formatCurrency(portfolio.totalGain)}</span>
                </div>
              </div>
            </div>

            <div className="mt-4 pt-4 border-t border-white/10 flex justify-between items-center">
              <div>
                <p className="text-indigo-200 text-xs">Cash Balance</p>
                <p className="font-semibold">{formatCurrency(portfolio.cashBalance)}</p>
              </div>
              <div>
                <p className="text-indigo-200 text-xs">Invested</p>
                <p className="font-semibold">{formatCurrency(portfolio.totalEquity)}</p>
              </div>
            </div>
          </Card>
        </motion.div>

        {/* Quick Actions */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
          className="grid grid-cols-3 gap-3"
        >
          <Link href="/explore">
            <Card className="flex flex-col items-center justify-center py-4 hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors cursor-pointer">
              <div className="w-10 h-10 bg-indigo-100 dark:bg-indigo-900/30 rounded-xl flex items-center justify-center mb-2">
                <TrendingUp className="w-5 h-5 text-indigo-600 dark:text-indigo-400" />
              </div>
              <span className="text-sm font-medium text-gray-900 dark:text-white">Invest</span>
            </Card>
          </Link>
          <Card className="flex flex-col items-center justify-center py-4 hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors cursor-pointer">
            <div className="w-10 h-10 bg-emerald-100 dark:bg-emerald-900/30 rounded-xl flex items-center justify-center mb-2">
              <PieChart className="w-5 h-5 text-emerald-600 dark:text-emerald-400" />
            </div>
            <span className="text-sm font-medium text-gray-900 dark:text-white">Allocate</span>
          </Card>
          <Card className="flex flex-col items-center justify-center py-4 hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors cursor-pointer">
            <div className="w-10 h-10 bg-purple-100 dark:bg-purple-900/30 rounded-xl flex items-center justify-center mb-2">
              <History className="w-5 h-5 text-purple-600 dark:text-purple-400" />
            </div>
            <span className="text-sm font-medium text-gray-900 dark:text-white">History</span>
          </Card>
        </motion.div>

        {/* Holdings Section */}
        <motion.section
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
        >
          <CardHeader className="px-0">
            <CardTitle>Holdings</CardTitle>
            <Link href="/holdings" className="flex items-center gap-1 text-sm text-indigo-600 dark:text-indigo-400 font-medium">
              View All
              <ArrowRight className="w-4 h-4" />
            </Link>
          </CardHeader>
          <div className="space-y-2">
            {holdings.slice(0, 3).map((holding, index) => (
              <HoldingCard key={holding.ticker} holding={holding} index={index} />
            ))}
          </div>
        </motion.section>

        {/* Asset Allocation */}
        <motion.section
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 }}
        >
          <Card variant="outline">
            <CardHeader>
              <CardTitle>Asset Allocation</CardTitle>
            </CardHeader>
            <div className="grid grid-cols-2 gap-4">
              <PortfolioDonut height={160} />
              <AllocationList />
            </div>
          </Card>
        </motion.section>

        {/* Recommended Stocks */}
        <motion.section
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.4 }}
        >
          <CardHeader className="px-0">
            <CardTitle>Recommended</CardTitle>
            <Link href="/explore" className="flex items-center gap-1 text-sm text-indigo-600 dark:text-indigo-400 font-medium">
              Explore
              <ArrowRight className="w-4 h-4" />
            </Link>
          </CardHeader>
          <div className="flex gap-3 overflow-x-auto scrollbar-hide -mx-4 px-4 pb-2">
            {recommendedStocks.map((stock, index) => (
              <StockCard key={stock.ticker} stock={stock} index={index} variant="compact" />
            ))}
          </div>
        </motion.section>

        {/* Recent Transactions */}
        <motion.section
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.5 }}
        >
          <CardHeader className="px-0">
            <CardTitle>Recent Activity</CardTitle>
          </CardHeader>
          <div className="space-y-2">
            {transactions.slice(0, 3).map((transaction, index) => (
              <TransactionCard key={transaction.id} transaction={transaction} index={index} />
            ))}
          </div>
        </motion.section>

        {/* News Section */}
        <motion.section
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.6 }}
        >
          <CardHeader className="px-0">
            <div className="flex items-center gap-2">
              <Newspaper className="w-5 h-5 text-gray-400" />
              <CardTitle>Market News</CardTitle>
            </div>
          </CardHeader>
          <div className="space-y-2">
            {mockNews.slice(0, 3).map((article, index) => (
              <NewsCardCompact key={article.id} article={article} index={index} />
            ))}
          </div>
        </motion.section>
      </div>
    </div>
  );
}
