'use client';

import { cn } from '@/lib/utils';
import { forwardRef, InputHTMLAttributes } from 'react';
import { Search } from 'lucide-react';

interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
  icon?: React.ReactNode;
  error?: string;
}

export const Input = forwardRef<HTMLInputElement, InputProps>(
  ({ className, icon, error, type = 'text', ...props }, ref) => {
    return (
      <div className="relative">
        {icon && (
          <div className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400">
            {icon}
          </div>
        )}
        <input
          type={type}
          ref={ref}
          className={cn(
            'w-full h-12 bg-gray-100 dark:bg-gray-800 rounded-xl border-0 text-gray-900 dark:text-white placeholder:text-gray-500 focus:ring-2 focus:ring-indigo-500 focus:ring-offset-0 transition-all',
            icon ? 'pl-10 pr-4' : 'px-4',
            error && 'ring-2 ring-red-500',
            className
          )}
          {...props}
        />
        {error && (
          <p className="mt-1 text-sm text-red-500">{error}</p>
        )}
      </div>
    );
  }
);

Input.displayName = 'Input';

export const SearchInput = forwardRef<HTMLInputElement, Omit<InputProps, 'icon'>>(
  (props, ref) => {
    return (
      <Input
        ref={ref}
        icon={<Search className="w-5 h-5" />}
        placeholder="Search stocks..."
        {...props}
      />
    );
  }
);

SearchInput.displayName = 'SearchInput';
