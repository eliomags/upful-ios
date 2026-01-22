'use client';

import { useState } from 'react';
import { AreaChart, Area, XAxis, YAxis, Tooltip, ResponsiveContainer } from 'recharts';
import { cn } from '@/lib/utils';
import { ChartDataPoint, TimeRange } from '@/types';
import { generateChartData } from '@/data/mockData';

interface StockChartProps {
  ticker: string;
  color?: string;
  height?: number;
}

const timeRanges: { label: string; value: TimeRange; days: number }[] = [
  { label: '1D', value: '1D', days: 1 },
  { label: '1W', value: '1W', days: 7 },
  { label: '1M', value: '1M', days: 30 },
  { label: '3M', value: '3M', days: 90 },
  { label: '1Y', value: '1Y', days: 365 },
  { label: 'ALL', value: 'ALL', days: 1825 },
];

export function StockChart({ ticker, color = '#6366f1', height = 200 }: StockChartProps) {
  const [selectedRange, setSelectedRange] = useState<TimeRange>('1M');
  const days = timeRanges.find((r) => r.value === selectedRange)?.days || 30;
  const data = generateChartData(days);

  const isPositive = data.length >= 2 && data[data.length - 1].price >= data[0].price;
  const chartColor = isPositive ? '#10b981' : '#ef4444';

  const formatTooltipValue = (value: number) => `$${value.toFixed(2)}`;
  const formatDate = (dateStr: string) => {
    const date = new Date(dateStr);
    if (selectedRange === '1D') {
      return date.toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' });
    }
    return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
  };

  return (
    <div>
      <div className="mb-4" style={{ height }}>
        <ResponsiveContainer width="100%" height="100%">
          <AreaChart data={data} margin={{ top: 0, right: 0, left: 0, bottom: 0 }}>
            <defs>
              <linearGradient id={`gradient-${ticker}`} x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stopColor={chartColor} stopOpacity={0.3} />
                <stop offset="100%" stopColor={chartColor} stopOpacity={0} />
              </linearGradient>
            </defs>
            <XAxis
              dataKey="date"
              axisLine={false}
              tickLine={false}
              tick={false}
            />
            <YAxis
              domain={['dataMin', 'dataMax']}
              axisLine={false}
              tickLine={false}
              tick={false}
              width={0}
            />
            <Tooltip
              content={({ active, payload }) => {
                if (active && payload && payload.length) {
                  const data = payload[0].payload as ChartDataPoint;
                  return (
                    <div className="bg-gray-900 dark:bg-gray-800 text-white px-3 py-2 rounded-lg shadow-lg">
                      <p className="text-sm font-medium">{formatTooltipValue(data.price)}</p>
                      <p className="text-xs text-gray-400">{formatDate(data.date)}</p>
                    </div>
                  );
                }
                return null;
              }}
            />
            <Area
              type="monotone"
              dataKey="price"
              stroke={chartColor}
              strokeWidth={2}
              fill={`url(#gradient-${ticker})`}
            />
          </AreaChart>
        </ResponsiveContainer>
      </div>

      <div className="flex gap-1 p-1 bg-gray-100 dark:bg-gray-800 rounded-xl">
        {timeRanges.map((range) => (
          <button
            key={range.value}
            onClick={() => setSelectedRange(range.value)}
            className={cn(
              'flex-1 py-2 text-sm font-medium rounded-lg transition-all',
              selectedRange === range.value
                ? 'bg-white dark:bg-gray-900 text-gray-900 dark:text-white shadow-sm'
                : 'text-gray-500 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white'
            )}
          >
            {range.label}
          </button>
        ))}
      </div>
    </div>
  );
}

export function MiniChart({ data, color = '#6366f1', height = 40 }: { data: ChartDataPoint[]; color?: string; height?: number }) {
  return (
    <ResponsiveContainer width="100%" height={height}>
      <AreaChart data={data} margin={{ top: 0, right: 0, left: 0, bottom: 0 }}>
        <defs>
          <linearGradient id="miniGradient" x1="0" y1="0" x2="0" y2="1">
            <stop offset="0%" stopColor={color} stopOpacity={0.2} />
            <stop offset="100%" stopColor={color} stopOpacity={0} />
          </linearGradient>
        </defs>
        <Area
          type="monotone"
          dataKey="price"
          stroke={color}
          strokeWidth={1.5}
          fill="url(#miniGradient)"
        />
      </AreaChart>
    </ResponsiveContainer>
  );
}
