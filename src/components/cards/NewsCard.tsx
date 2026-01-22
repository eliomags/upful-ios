'use client';

import { formatDate, formatTime } from '@/lib/utils';
import { NewsArticle } from '@/types';
import { ExternalLink } from 'lucide-react';
import { motion } from 'framer-motion';
import { Badge } from '../ui/Badge';

interface NewsCardProps {
  article: NewsArticle;
  index?: number;
}

export function NewsCard({ article, index = 0 }: NewsCardProps) {
  return (
    <motion.article
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: index * 0.05 }}
      className="bg-white dark:bg-gray-900 rounded-2xl overflow-hidden hover:shadow-lg transition-shadow"
    >
      {article.imageUrl && (
        <div className="aspect-video bg-gray-100 dark:bg-gray-800 overflow-hidden">
          <img
            src={article.imageUrl}
            alt={article.title}
            className="w-full h-full object-cover"
          />
        </div>
      )}
      <div className="p-4">
        <div className="flex items-center gap-2 mb-2">
          <span className="text-xs font-medium text-indigo-600 dark:text-indigo-400">
            {article.source}
          </span>
          <span className="text-xs text-gray-400">
            {formatDate(new Date(article.publishedAt))}
          </span>
        </div>

        <h3 className="font-semibold text-gray-900 dark:text-white mb-2 line-clamp-2">
          {article.title}
        </h3>

        <p className="text-sm text-gray-600 dark:text-gray-400 line-clamp-2 mb-3">
          {article.summary}
        </p>

        {article.tickers && article.tickers.length > 0 && (
          <div className="flex flex-wrap gap-1">
            {article.tickers.map((ticker) => (
              <Badge key={ticker} variant="info" size="sm">
                ${ticker}
              </Badge>
            ))}
          </div>
        )}
      </div>
    </motion.article>
  );
}

export function NewsCardCompact({ article, index = 0 }: NewsCardProps) {
  return (
    <motion.article
      initial={{ opacity: 0, x: -10 }}
      animate={{ opacity: 1, x: 0 }}
      transition={{ delay: index * 0.05 }}
      className="flex gap-3 p-3 bg-white dark:bg-gray-900 rounded-xl hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors"
    >
      {article.imageUrl && (
        <div className="w-20 h-20 flex-shrink-0 bg-gray-100 dark:bg-gray-800 rounded-lg overflow-hidden">
          <img
            src={article.imageUrl}
            alt={article.title}
            className="w-full h-full object-cover"
          />
        </div>
      )}
      <div className="flex-1 min-w-0">
        <p className="text-xs text-gray-500 dark:text-gray-400 mb-1">
          {article.source} · {formatDate(new Date(article.publishedAt))}
        </p>
        <h4 className="font-medium text-gray-900 dark:text-white text-sm line-clamp-2">
          {article.title}
        </h4>
      </div>
    </motion.article>
  );
}
