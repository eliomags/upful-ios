'use client';

import { useState } from 'react';
import { Header } from '@/components/layout/Header';
import { Card, CardHeader, CardTitle } from '@/components/ui/Card';
import { Tabs, TabsList, TabsTrigger, TabsContent } from '@/components/ui/Tabs';
import { Button } from '@/components/ui/Button';
import { StockCard } from '@/components/cards/StockCard';
import { useStore } from '@/store/useStore';
import { formatDate } from '@/lib/utils';
import { Bookmark, Filter as FilterIcon, Trash2, StickyNote, ChevronRight, Plus } from 'lucide-react';
import { motion } from 'framer-motion';
import Link from 'next/link';

export default function SavedPage() {
  const watchlist = useStore((state) => state.watchlist);
  const savedScreeners = useStore((state) => state.savedScreeners);
  const removeFromWatchlist = useStore((state) => state.removeFromWatchlist);
  const removeScreener = useStore((state) => state.removeScreener);

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-950">
      <Header title="Saved" />

      <div className="pt-14 px-4 pb-6">
        <Tabs defaultValue="stocks" className="mt-4">
          <TabsList className="mb-6">
            <TabsTrigger value="stocks">
              <Bookmark className="w-4 h-4 mr-2" />
              Watchlist
            </TabsTrigger>
            <TabsTrigger value="screeners">
              <FilterIcon className="w-4 h-4 mr-2" />
              Screeners
            </TabsTrigger>
          </TabsList>

          <TabsContent value="stocks" className="space-y-4">
            {watchlist.length > 0 ? (
              <>
                <div className="flex items-center justify-between">
                  <p className="text-sm text-gray-500 dark:text-gray-400">
                    {watchlist.length} stocks saved
                  </p>
                  <Button variant="ghost" size="sm">
                    <Plus className="w-4 h-4 mr-1" />
                    Add
                  </Button>
                </div>

                <div className="space-y-2">
                  {watchlist.map((item, index) => (
                    <motion.div
                      key={item.ticker}
                      initial={{ opacity: 0, y: 20 }}
                      animate={{ opacity: 1, y: 0 }}
                      transition={{ delay: index * 0.05 }}
                    >
                      <div className="relative">
                        <StockCard stock={item} index={index} />

                        {item.notes && (
                          <div className="mt-1 ml-4 flex items-start gap-2 text-sm text-gray-500 dark:text-gray-400">
                            <StickyNote className="w-4 h-4 flex-shrink-0 mt-0.5" />
                            <p className="line-clamp-1">{item.notes}</p>
                          </div>
                        )}
                      </div>
                    </motion.div>
                  ))}
                </div>
              </>
            ) : (
              <Card className="flex flex-col items-center justify-center py-16 text-center">
                <div className="w-16 h-16 bg-gray-100 dark:bg-gray-800 rounded-2xl flex items-center justify-center mb-4">
                  <Bookmark className="w-8 h-8 text-gray-400" />
                </div>
                <h3 className="font-semibold text-gray-900 dark:text-white mb-2">
                  No stocks saved yet
                </h3>
                <p className="text-sm text-gray-500 dark:text-gray-400 max-w-xs mb-6">
                  Save stocks to your watchlist to track them and get notified about price changes
                </p>
                <Link href="/explore">
                  <Button>
                    Explore Stocks
                  </Button>
                </Link>
              </Card>
            )}
          </TabsContent>

          <TabsContent value="screeners" className="space-y-4">
            {savedScreeners.length > 0 ? (
              <>
                <div className="flex items-center justify-between">
                  <p className="text-sm text-gray-500 dark:text-gray-400">
                    {savedScreeners.length} screeners saved
                  </p>
                  <Button variant="ghost" size="sm">
                    <Plus className="w-4 h-4 mr-1" />
                    New
                  </Button>
                </div>

                <div className="space-y-3">
                  {savedScreeners.map((screener, index) => (
                    <motion.div
                      key={screener.id}
                      initial={{ opacity: 0, y: 20 }}
                      animate={{ opacity: 1, y: 0 }}
                      transition={{ delay: index * 0.05 }}
                      className="bg-white dark:bg-gray-900 rounded-2xl overflow-hidden"
                    >
                      <div className="flex items-center justify-between p-4">
                        <div className="flex-1 min-w-0">
                          <h3 className="font-semibold text-gray-900 dark:text-white">
                            {screener.name}
                          </h3>
                          {screener.description && (
                            <p className="text-sm text-gray-500 dark:text-gray-400 line-clamp-1">
                              {screener.description}
                            </p>
                          )}
                          <p className="text-xs text-gray-400 dark:text-gray-500 mt-1">
                            Created {formatDate(new Date(screener.createdAt))}
                          </p>
                        </div>
                        <div className="flex items-center gap-2">
                          <button
                            onClick={() => removeScreener(screener.id)}
                            className="p-2 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-full transition-colors"
                          >
                            <Trash2 className="w-4 h-4 text-gray-400 hover:text-red-500" />
                          </button>
                          <ChevronRight className="w-5 h-5 text-gray-400" />
                        </div>
                      </div>

                      {/* Filter Tags */}
                      <div className="px-4 pb-4 flex flex-wrap gap-2">
                        {screener.filters.sectors?.map((sector) => (
                          <span
                            key={sector}
                            className="px-2 py-1 text-xs bg-indigo-100 dark:bg-indigo-900/30 text-indigo-700 dark:text-indigo-400 rounded-full"
                          >
                            {sector}
                          </span>
                        ))}
                        {screener.filters.growthRate && (
                          <span className="px-2 py-1 text-xs bg-emerald-100 dark:bg-emerald-900/30 text-emerald-700 dark:text-emerald-400 rounded-full">
                            {screener.filters.growthRate} growth
                          </span>
                        )}
                        {screener.filters.dividendYieldMin && (
                          <span className="px-2 py-1 text-xs bg-amber-100 dark:bg-amber-900/30 text-amber-700 dark:text-amber-400 rounded-full">
                            {screener.filters.dividendYieldMin}%+ dividend
                          </span>
                        )}
                        {screener.filters.peRatioMax && (
                          <span className="px-2 py-1 text-xs bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-400 rounded-full">
                            P/E &lt; {screener.filters.peRatioMax}
                          </span>
                        )}
                      </div>
                    </motion.div>
                  ))}
                </div>
              </>
            ) : (
              <Card className="flex flex-col items-center justify-center py-16 text-center">
                <div className="w-16 h-16 bg-gray-100 dark:bg-gray-800 rounded-2xl flex items-center justify-center mb-4">
                  <FilterIcon className="w-8 h-8 text-gray-400" />
                </div>
                <h3 className="font-semibold text-gray-900 dark:text-white mb-2">
                  No screeners saved yet
                </h3>
                <p className="text-sm text-gray-500 dark:text-gray-400 max-w-xs mb-6">
                  Create custom screeners to find stocks that match your investment criteria
                </p>
                <Link href="/explore">
                  <Button>
                    Create Screener
                  </Button>
                </Link>
              </Card>
            )}
          </TabsContent>
        </Tabs>
      </div>
    </div>
  );
}
