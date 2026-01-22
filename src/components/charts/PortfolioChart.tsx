'use client';

import { useState } from 'react';
import { AreaChart, Area, XAxis, YAxis, Tooltip, ResponsiveContainer, PieChart, Pie, Cell } from 'recharts';
import { cn, formatCurrency, formatCompactCurrency } from '@/lib/utils';
import { useStore } from '@/store/useStore';

const COLORS = ['#6366f1', '#8b5cf6', '#a855f7', '#d946ef', '#ec4899', '#f43f5e', '#f97316', '#eab308'];

interface PortfolioChartProps {
  height?: number;
}

export function PortfolioDonut({ height = 200 }: PortfolioChartProps) {
  const holdings = useStore((state) => state.holdings);
  const cashBalance = useStore((state) => state.cashBalance);

  const data = [
    ...holdings.map((h, i) => ({
      name: h.ticker,
      value: h.totalValue,
      color: COLORS[i % COLORS.length],
    })),
    {
      name: 'Cash',
      value: cashBalance,
      color: '#94a3b8',
    },
  ];

  const total = data.reduce((sum, item) => sum + item.value, 0);

  return (
    <div className="relative" style={{ height }}>
      <ResponsiveContainer width="100%" height="100%">
        <PieChart>
          <Pie
            data={data}
            cx="50%"
            cy="50%"
            innerRadius={60}
            outerRadius={80}
            paddingAngle={2}
            dataKey="value"
          >
            {data.map((entry, index) => (
              <Cell key={`cell-${index}`} fill={entry.color} />
            ))}
          </Pie>
          <Tooltip
            content={({ active, payload }) => {
              if (active && payload && payload.length) {
                const data = payload[0].payload;
                const percentage = ((data.value / total) * 100).toFixed(1);
                return (
                  <div className="bg-gray-900 dark:bg-gray-800 text-white px-3 py-2 rounded-lg shadow-lg">
                    <p className="text-sm font-medium">{data.name}</p>
                    <p className="text-xs text-gray-400">
                      {formatCurrency(data.value)} ({percentage}%)
                    </p>
                  </div>
                );
              }
              return null;
            }}
          />
        </PieChart>
      </ResponsiveContainer>
      <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
        <div className="text-center">
          <p className="text-2xl font-bold text-gray-900 dark:text-white">
            {formatCompactCurrency(total)}
          </p>
          <p className="text-sm text-gray-500 dark:text-gray-400">Total</p>
        </div>
      </div>
    </div>
  );
}

export function AllocationList() {
  const holdings = useStore((state) => state.holdings);
  const cashBalance = useStore((state) => state.cashBalance);

  const totalValue = holdings.reduce((sum, h) => sum + h.totalValue, 0) + cashBalance;

  const allocations = [
    ...holdings.map((h, i) => ({
      name: h.ticker,
      companyName: h.companyName,
      value: h.totalValue,
      percentage: (h.totalValue / totalValue) * 100,
      color: COLORS[i % COLORS.length],
    })),
    {
      name: 'Cash',
      companyName: 'Available Balance',
      value: cashBalance,
      percentage: (cashBalance / totalValue) * 100,
      color: '#94a3b8',
    },
  ].sort((a, b) => b.value - a.value);

  return (
    <div className="space-y-3">
      {allocations.map((item) => (
        <div key={item.name} className="flex items-center gap-3">
          <div
            className="w-3 h-3 rounded-full flex-shrink-0"
            style={{ backgroundColor: item.color }}
          />
          <div className="flex-1 min-w-0">
            <div className="flex items-center justify-between">
              <span className="font-medium text-gray-900 dark:text-white">{item.name}</span>
              <span className="text-sm text-gray-500 dark:text-gray-400">
                {item.percentage.toFixed(1)}%
              </span>
            </div>
            <div className="mt-1 h-1.5 bg-gray-100 dark:bg-gray-800 rounded-full overflow-hidden">
              <div
                className="h-full rounded-full transition-all duration-500"
                style={{ width: `${item.percentage}%`, backgroundColor: item.color }}
              />
            </div>
          </div>
        </div>
      ))}
    </div>
  );
}
