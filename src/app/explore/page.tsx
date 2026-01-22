'use client';

import { useState } from 'react';
import { Header } from '@/components/layout/Header';
import { Card, CardHeader, CardTitle } from '@/components/ui/Card';
import { SearchInput } from '@/components/ui/Input';
import { Button } from '@/components/ui/Button';
import { Badge } from '@/components/ui/Badge';
import { Tabs, TabsList, TabsTrigger, TabsContent } from '@/components/ui/Tabs';
import { StockCard } from '@/components/cards/StockCard';
import { mockStocks, mockSavedScreeners, sectors } from '@/data/mockData';
import { useStore } from '@/store/useStore';
import { cn } from '@/lib/utils';
import { Search, Filter, Sparkles, TrendingUp, DollarSign, BarChart3, Zap, ChevronRight, X } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';

const quickScreeners = [
  { id: 'trending', label: 'Trending', icon: TrendingUp, color: 'bg-rose-500' },
  { id: 'dividend', label: 'High Dividend', icon: DollarSign, color: 'bg-emerald-500' },
  { id: 'growth', label: 'Growth', icon: BarChart3, color: 'bg-blue-500' },
  { id: 'value', label: 'Value', icon: Zap, color: 'bg-amber-500' },
];

export default function ExplorePage() {
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedSectors, setSelectedSectors] = useState<string[]>([]);
  const [showFilters, setShowFilters] = useState(false);
  const savedScreeners = useStore((state) => state.savedScreeners);

  const filteredStocks = mockStocks.filter((stock) => {
    const matchesSearch = searchQuery === '' ||
      stock.ticker.toLowerCase().includes(searchQuery.toLowerCase()) ||
      stock.companyName.toLowerCase().includes(searchQuery.toLowerCase());

    const matchesSector = selectedSectors.length === 0 ||
      (stock.sector && selectedSectors.includes(stock.sector));

    return matchesSearch && matchesSector;
  });

  const toggleSector = (sector: string) => {
    setSelectedSectors((prev) =>
      prev.includes(sector)
        ? prev.filter((s) => s !== sector)
        : [...prev, sector]
    );
  };

  const clearFilters = () => {
    setSelectedSectors([]);
    setSearchQuery('');
  };

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-950">
      <Header title="Explore" />

      <div className="pt-14 px-4 pb-6 space-y-6">
        {/* Search Bar */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="mt-4"
        >
          <div className="flex gap-2">
            <div className="flex-1">
              <SearchInput
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Search stocks, companies..."
              />
            </div>
            <Button
              variant={showFilters || selectedSectors.length > 0 ? 'primary' : 'secondary'}
              onClick={() => setShowFilters(!showFilters)}
              className="px-3"
            >
              <Filter className="w-5 h-5" />
              {selectedSectors.length > 0 && (
                <span className="ml-1 text-xs">{selectedSectors.length}</span>
              )}
            </Button>
          </div>
        </motion.div>

        {/* Filters Panel */}
        <AnimatePresence>
          {showFilters && (
            <motion.div
              initial={{ opacity: 0, height: 0 }}
              animate={{ opacity: 1, height: 'auto' }}
              exit={{ opacity: 0, height: 0 }}
              className="overflow-hidden"
            >
              <Card variant="outline" padding="sm">
                <div className="flex items-center justify-between mb-3">
                  <span className="text-sm font-medium text-gray-900 dark:text-white">Sectors</span>
                  {selectedSectors.length > 0 && (
                    <button
                      onClick={clearFilters}
                      className="text-xs text-indigo-600 dark:text-indigo-400 font-medium"
                    >
                      Clear all
                    </button>
                  )}
                </div>
                <div className="flex flex-wrap gap-2">
                  {sectors.map((sector) => (
                    <button
                      key={sector}
                      onClick={() => toggleSector(sector)}
                      className={cn(
                        'px-3 py-1.5 text-sm rounded-full transition-all',
                        selectedSectors.includes(sector)
                          ? 'bg-indigo-600 text-white'
                          : 'bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-700'
                      )}
                    >
                      {sector}
                    </button>
                  ))}
                </div>
              </Card>
            </motion.div>
          )}
        </AnimatePresence>

        {/* Active Filters */}
        {selectedSectors.length > 0 && !showFilters && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            className="flex flex-wrap gap-2"
          >
            {selectedSectors.map((sector) => (
              <Badge key={sector} variant="info" className="flex items-center gap-1">
                {sector}
                <button onClick={() => toggleSector(sector)}>
                  <X className="w-3 h-3" />
                </button>
              </Badge>
            ))}
          </motion.div>
        )}

        {/* Quick Screeners */}
        <motion.section
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
        >
          <CardHeader className="px-0">
            <div className="flex items-center gap-2">
              <Sparkles className="w-5 h-5 text-amber-500" />
              <CardTitle>Quick Screeners</CardTitle>
            </div>
          </CardHeader>
          <div className="grid grid-cols-2 gap-3">
            {quickScreeners.map((screener, index) => {
              const Icon = screener.icon;
              return (
                <motion.button
                  key={screener.id}
                  initial={{ opacity: 0, scale: 0.95 }}
                  animate={{ opacity: 1, scale: 1 }}
                  transition={{ delay: 0.1 + index * 0.05 }}
                  className="flex items-center gap-3 p-4 bg-white dark:bg-gray-900 rounded-2xl hover:shadow-md transition-all active:scale-[0.98]"
                >
                  <div className={cn('w-10 h-10 rounded-xl flex items-center justify-center', screener.color)}>
                    <Icon className="w-5 h-5 text-white" />
                  </div>
                  <span className="font-medium text-gray-900 dark:text-white">{screener.label}</span>
                </motion.button>
              );
            })}
          </div>
        </motion.section>

        {/* Saved Screeners */}
        {savedScreeners.length > 0 && (
          <motion.section
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.2 }}
          >
            <CardHeader className="px-0">
              <CardTitle>Your Screeners</CardTitle>
            </CardHeader>
            <div className="space-y-2">
              {savedScreeners.map((screener, index) => (
                <motion.button
                  key={screener.id}
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ delay: 0.2 + index * 0.05 }}
                  className="w-full flex items-center justify-between p-4 bg-white dark:bg-gray-900 rounded-xl hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors"
                >
                  <div className="text-left">
                    <h3 className="font-medium text-gray-900 dark:text-white">{screener.name}</h3>
                    {screener.description && (
                      <p className="text-sm text-gray-500 dark:text-gray-400">{screener.description}</p>
                    )}
                  </div>
                  <ChevronRight className="w-5 h-5 text-gray-400" />
                </motion.button>
              ))}
            </div>
          </motion.section>
        )}

        {/* Stock Results */}
        <motion.section
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 }}
        >
          <CardHeader className="px-0">
            <CardTitle>
              {searchQuery || selectedSectors.length > 0 ? 'Results' : 'Popular Stocks'}
            </CardTitle>
            <span className="text-sm text-gray-500 dark:text-gray-400">
              {filteredStocks.length} stocks
            </span>
          </CardHeader>
          <div className="space-y-2">
            {filteredStocks.map((stock, index) => (
              <StockCard key={stock.ticker} stock={stock} index={index} showBookmark />
            ))}
          </div>
          {filteredStocks.length === 0 && (
            <Card className="flex flex-col items-center justify-center py-12 text-center">
              <Search className="w-12 h-12 text-gray-300 dark:text-gray-600 mb-4" />
              <h3 className="font-medium text-gray-900 dark:text-white mb-1">No stocks found</h3>
              <p className="text-sm text-gray-500 dark:text-gray-400">
                Try adjusting your search or filters
              </p>
            </Card>
          )}
        </motion.section>
      </div>
    </div>
  );
}
