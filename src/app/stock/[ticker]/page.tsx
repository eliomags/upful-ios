'use client';

import { useState, use } from 'react';
import { useRouter } from 'next/navigation';
import { Header } from '@/components/layout/Header';
import { Card, CardHeader, CardTitle } from '@/components/ui/Card';
import { Button } from '@/components/ui/Button';
import { Badge } from '@/components/ui/Badge';
import { Input } from '@/components/ui/Input';
import { StockChart } from '@/components/charts/StockChart';
import { NewsCardCompact } from '@/components/cards/NewsCard';
import { mockStocks, mockNews } from '@/data/mockData';
import { useStore, usePortfolioValue } from '@/store/useStore';
import { formatCurrency, formatPercent, formatCompactCurrency, formatCompactNumber, getChangeColor, cn } from '@/lib/utils';
import {
  TrendingUp,
  TrendingDown,
  Bookmark,
  BookmarkCheck,
  Share2,
  ArrowUpRight,
  ArrowDownLeft,
  X,
  Info,
  Building2,
  BarChart3,
  DollarSign,
  Percent,
  Activity,
} from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';

interface PageProps {
  params: Promise<{ ticker: string }>;
}

export default function StockDetailPage({ params }: PageProps) {
  const { ticker } = use(params);
  const router = useRouter();

  const [showTradeModal, setShowTradeModal] = useState(false);
  const [tradeType, setTradeType] = useState<'buy' | 'sell'>('buy');
  const [shares, setShares] = useState('');

  const watchlist = useStore((state) => state.watchlist);
  const holdings = useStore((state) => state.holdings);
  const addToWatchlist = useStore((state) => state.addToWatchlist);
  const removeFromWatchlist = useStore((state) => state.removeFromWatchlist);
  const executeTrade = useStore((state) => state.executeTrade);
  const portfolio = usePortfolioValue();

  const stock = mockStocks.find((s) => s.ticker === ticker.toUpperCase());
  const holding = holdings.find((h) => h.ticker === ticker.toUpperCase());
  const isInWatchlist = watchlist.some((item) => item.ticker === ticker.toUpperCase());
  const relatedNews = mockNews.filter((n) => n.tickers?.includes(ticker.toUpperCase()));

  if (!stock) {
    return (
      <div className="min-h-screen bg-gray-50 dark:bg-gray-950 flex items-center justify-center">
        <div className="text-center">
          <h1 className="text-xl font-semibold text-gray-900 dark:text-white mb-2">Stock not found</h1>
          <Button onClick={() => router.back()}>Go Back</Button>
        </div>
      </div>
    );
  }

  const isPositive = stock.change >= 0;
  const sharesNum = parseFloat(shares) || 0;
  const tradeTotal = sharesNum * stock.currentPrice;
  const canBuy = tradeTotal <= portfolio.cashBalance && sharesNum > 0;
  const canSell = holding && sharesNum <= holding.shares && sharesNum > 0;

  const handleToggleWatchlist = () => {
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

  const handleTrade = () => {
    if ((tradeType === 'buy' && !canBuy) || (tradeType === 'sell' && !canSell)) return;

    executeTrade({
      ticker: stock.ticker,
      companyName: stock.companyName,
      type: tradeType,
      shares: sharesNum,
      price: stock.currentPrice,
      total: tradeTotal,
      date: new Date(),
    });

    setShowTradeModal(false);
    setShares('');
  };

  const openTradeModal = (type: 'buy' | 'sell') => {
    setTradeType(type);
    setShares('');
    setShowTradeModal(true);
  };

  const stats = [
    { label: 'Market Cap', value: formatCompactCurrency(stock.marketCap || 0), icon: Building2 },
    { label: 'Volume', value: formatCompactNumber(stock.volume || 0), icon: Activity },
    { label: 'P/E Ratio', value: stock.peRatio?.toFixed(1) || 'N/A', icon: BarChart3 },
    { label: 'Dividend', value: stock.dividendYield ? `${stock.dividendYield.toFixed(2)}%` : 'N/A', icon: DollarSign },
    { label: '52W High', value: formatCurrency(stock.high52Week || 0), icon: TrendingUp },
    { label: '52W Low', value: formatCurrency(stock.low52Week || 0), icon: TrendingDown },
  ];

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-950">
      <Header
        showBack
        rightAction={
          <div className="flex items-center gap-1">
            <button
              onClick={handleToggleWatchlist}
              className="p-2 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-full transition-colors"
            >
              {isInWatchlist ? (
                <BookmarkCheck className="w-5 h-5 text-indigo-600 dark:text-indigo-400" />
              ) : (
                <Bookmark className="w-5 h-5 text-gray-600 dark:text-gray-400" />
              )}
            </button>
            <button className="p-2 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-full transition-colors">
              <Share2 className="w-5 h-5 text-gray-600 dark:text-gray-400" />
            </button>
          </div>
        }
      />

      <div className="pt-14 px-4 pb-32 space-y-6">
        {/* Stock Header */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="mt-4"
        >
          <div className="flex items-start justify-between">
            <div>
              <div className="flex items-center gap-2">
                <h1 className="text-2xl font-bold text-gray-900 dark:text-white">{stock.ticker}</h1>
                {stock.sector && (
                  <Badge variant="default" size="sm">{stock.sector}</Badge>
                )}
              </div>
              <p className="text-gray-500 dark:text-gray-400 mt-1">{stock.companyName}</p>
            </div>
          </div>

          <div className="mt-4">
            <h2 className="text-4xl font-bold text-gray-900 dark:text-white">
              {formatCurrency(stock.currentPrice)}
            </h2>
            <div className={cn('flex items-center gap-2 mt-1', getChangeColor(stock.change))}>
              {isPositive ? (
                <TrendingUp className="w-5 h-5" />
              ) : (
                <TrendingDown className="w-5 h-5" />
              )}
              <span className="font-semibold">
                {isPositive ? '+' : ''}{formatCurrency(stock.change)} ({formatPercent(stock.changePercent)})
              </span>
              <span className="text-gray-500 dark:text-gray-400 text-sm">Today</span>
            </div>
          </div>
        </motion.div>

        {/* Chart */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
        >
          <Card>
            <StockChart ticker={stock.ticker} height={250} />
          </Card>
        </motion.div>

        {/* Your Position (if holding) */}
        {holding && (
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.2 }}
          >
            <Card variant="elevated" className="bg-gradient-to-br from-emerald-600 to-teal-700 text-white">
              <CardHeader>
                <CardTitle className="text-white/90 text-sm font-medium">Your Position</CardTitle>
              </CardHeader>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <p className="text-emerald-200 text-xs">Shares</p>
                  <p className="text-xl font-bold">{holding.shares}</p>
                </div>
                <div>
                  <p className="text-emerald-200 text-xs">Market Value</p>
                  <p className="text-xl font-bold">{formatCurrency(holding.totalValue)}</p>
                </div>
                <div>
                  <p className="text-emerald-200 text-xs">Avg Cost</p>
                  <p className="font-semibold">{formatCurrency(holding.averageCost)}</p>
                </div>
                <div>
                  <p className="text-emerald-200 text-xs">Total Return</p>
                  <p className={cn('font-semibold', holding.gain >= 0 ? 'text-white' : 'text-red-300')}>
                    {holding.gain >= 0 ? '+' : ''}{formatCurrency(holding.gain)} ({formatPercent(holding.gainPercent)})
                  </p>
                </div>
              </div>
            </Card>
          </motion.div>
        )}

        {/* Stats Grid */}
        <motion.section
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 }}
        >
          <CardHeader className="px-0">
            <CardTitle>Key Statistics</CardTitle>
          </CardHeader>
          <div className="grid grid-cols-2 gap-3">
            {stats.map((stat, index) => {
              const Icon = stat.icon;
              return (
                <Card key={stat.label} padding="sm" className="flex items-center gap-3">
                  <div className="w-8 h-8 bg-gray-100 dark:bg-gray-800 rounded-lg flex items-center justify-center">
                    <Icon className="w-4 h-4 text-gray-500 dark:text-gray-400" />
                  </div>
                  <div>
                    <p className="text-xs text-gray-500 dark:text-gray-400">{stat.label}</p>
                    <p className="font-semibold text-gray-900 dark:text-white">{stat.value}</p>
                  </div>
                </Card>
              );
            })}
          </div>
        </motion.section>

        {/* About */}
        <motion.section
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.4 }}
        >
          <Card variant="outline">
            <CardHeader>
              <div className="flex items-center gap-2">
                <Info className="w-5 h-5 text-gray-400" />
                <CardTitle>About {stock.companyName}</CardTitle>
              </div>
            </CardHeader>
            <p className="text-gray-600 dark:text-gray-400 text-sm leading-relaxed">
              {stock.companyName} operates in the {stock.industry || 'Technology'} industry within the {stock.sector || 'Technology'} sector.
              The company has a market capitalization of {formatCompactCurrency(stock.marketCap || 0)} and trades under the ticker symbol {stock.ticker}.
            </p>
            {stock.industry && (
              <div className="mt-3 flex flex-wrap gap-2">
                <Badge variant="info">{stock.sector}</Badge>
                <Badge variant="default">{stock.industry}</Badge>
              </div>
            )}
          </Card>
        </motion.section>

        {/* Related News */}
        {relatedNews.length > 0 && (
          <motion.section
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.5 }}
          >
            <CardHeader className="px-0">
              <CardTitle>Latest News</CardTitle>
            </CardHeader>
            <div className="space-y-2">
              {relatedNews.map((article, index) => (
                <NewsCardCompact key={article.id} article={article} index={index} />
              ))}
            </div>
          </motion.section>
        )}
      </div>

      {/* Fixed Bottom Trade Buttons */}
      <div className="fixed bottom-0 left-0 right-0 bg-white/80 dark:bg-gray-900/80 backdrop-blur-xl border-t border-gray-200/50 dark:border-gray-800/50 p-4 safe-area-bottom">
        <div className="flex gap-3 max-w-lg mx-auto">
          <Button
            variant="success"
            size="lg"
            className="flex-1"
            onClick={() => openTradeModal('buy')}
          >
            <ArrowDownLeft className="w-5 h-5 mr-2" />
            Buy
          </Button>
          <Button
            variant="danger"
            size="lg"
            className="flex-1"
            onClick={() => openTradeModal('sell')}
            disabled={!holding}
          >
            <ArrowUpRight className="w-5 h-5 mr-2" />
            Sell
          </Button>
        </div>
      </div>

      {/* Trade Modal */}
      <AnimatePresence>
        {showTradeModal && (
          <>
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              className="fixed inset-0 bg-black/50 z-50"
              onClick={() => setShowTradeModal(false)}
            />
            <motion.div
              initial={{ opacity: 0, y: '100%' }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: '100%' }}
              transition={{ type: 'spring', damping: 25, stiffness: 300 }}
              className="fixed bottom-0 left-0 right-0 bg-white dark:bg-gray-900 rounded-t-3xl z-50 safe-area-bottom"
            >
              <div className="p-6">
                <div className="flex items-center justify-between mb-6">
                  <h2 className="text-xl font-bold text-gray-900 dark:text-white">
                    {tradeType === 'buy' ? 'Buy' : 'Sell'} {stock.ticker}
                  </h2>
                  <button
                    onClick={() => setShowTradeModal(false)}
                    className="p-2 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-full transition-colors"
                  >
                    <X className="w-5 h-5 text-gray-600 dark:text-gray-400" />
                  </button>
                </div>

                {/* Trade Type Tabs */}
                <div className="flex gap-2 p-1 bg-gray-100 dark:bg-gray-800 rounded-xl mb-6">
                  <button
                    onClick={() => setTradeType('buy')}
                    className={cn(
                      'flex-1 py-2 text-sm font-medium rounded-lg transition-all',
                      tradeType === 'buy'
                        ? 'bg-emerald-600 text-white'
                        : 'text-gray-600 dark:text-gray-400'
                    )}
                  >
                    Buy
                  </button>
                  <button
                    onClick={() => setTradeType('sell')}
                    disabled={!holding}
                    className={cn(
                      'flex-1 py-2 text-sm font-medium rounded-lg transition-all',
                      tradeType === 'sell'
                        ? 'bg-red-600 text-white'
                        : 'text-gray-600 dark:text-gray-400',
                      !holding && 'opacity-50 cursor-not-allowed'
                    )}
                  >
                    Sell
                  </button>
                </div>

                {/* Stock Info */}
                <div className="flex items-center justify-between py-3 border-b border-gray-100 dark:border-gray-800">
                  <span className="text-gray-500 dark:text-gray-400">Current Price</span>
                  <span className="font-semibold text-gray-900 dark:text-white">
                    {formatCurrency(stock.currentPrice)}
                  </span>
                </div>

                {tradeType === 'buy' && (
                  <div className="flex items-center justify-between py-3 border-b border-gray-100 dark:border-gray-800">
                    <span className="text-gray-500 dark:text-gray-400">Available Cash</span>
                    <span className="font-semibold text-gray-900 dark:text-white">
                      {formatCurrency(portfolio.cashBalance)}
                    </span>
                  </div>
                )}

                {tradeType === 'sell' && holding && (
                  <div className="flex items-center justify-between py-3 border-b border-gray-100 dark:border-gray-800">
                    <span className="text-gray-500 dark:text-gray-400">Shares Owned</span>
                    <span className="font-semibold text-gray-900 dark:text-white">
                      {holding.shares}
                    </span>
                  </div>
                )}

                {/* Shares Input */}
                <div className="py-4">
                  <label className="text-sm text-gray-500 dark:text-gray-400 mb-2 block">
                    Number of Shares
                  </label>
                  <Input
                    type="number"
                    placeholder="0"
                    value={shares}
                    onChange={(e) => setShares(e.target.value)}
                    className="text-2xl font-bold text-center h-16"
                  />
                </div>

                {/* Estimated Total */}
                <div className="bg-gray-50 dark:bg-gray-800 rounded-xl p-4 mb-6">
                  <div className="flex items-center justify-between">
                    <span className="text-gray-500 dark:text-gray-400">Estimated Total</span>
                    <span className="text-2xl font-bold text-gray-900 dark:text-white">
                      {formatCurrency(tradeTotal)}
                    </span>
                  </div>
                </div>

                {/* Submit Button */}
                <Button
                  variant={tradeType === 'buy' ? 'success' : 'danger'}
                  size="lg"
                  className="w-full"
                  onClick={handleTrade}
                  disabled={tradeType === 'buy' ? !canBuy : !canSell}
                >
                  {tradeType === 'buy' ? 'Confirm Purchase' : 'Confirm Sale'}
                </Button>

                {/* Error Messages */}
                {tradeType === 'buy' && sharesNum > 0 && !canBuy && (
                  <p className="text-red-500 text-sm text-center mt-3">
                    Insufficient funds for this purchase
                  </p>
                )}
                {tradeType === 'sell' && sharesNum > 0 && holding && sharesNum > holding.shares && (
                  <p className="text-red-500 text-sm text-center mt-3">
                    You don&apos;t have enough shares
                  </p>
                )}
              </div>
            </motion.div>
          </>
        )}
      </AnimatePresence>
    </div>
  );
}
