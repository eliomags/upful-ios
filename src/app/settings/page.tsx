'use client';

import { useState } from 'react';
import { Header } from '@/components/layout/Header';
import { Card } from '@/components/ui/Card';
import { Badge } from '@/components/ui/Badge';
import { Button } from '@/components/ui/Button';
import { sectors } from '@/data/mockData';
import { cn } from '@/lib/utils';
import {
  User,
  Bell,
  Shield,
  Palette,
  HelpCircle,
  MessageSquare,
  Star,
  ChevronRight,
  Moon,
  Sun,
  Smartphone,
  TrendingUp,
  DollarSign,
  Building2,
  Crown,
  ExternalLink,
} from 'lucide-react';
import { motion } from 'framer-motion';

interface SettingItemProps {
  icon: React.ReactNode;
  label: string;
  description?: string;
  onClick?: () => void;
  rightElement?: React.ReactNode;
  badge?: string;
}

function SettingItem({ icon, label, description, onClick, rightElement, badge }: SettingItemProps) {
  return (
    <button
      onClick={onClick}
      className="w-full flex items-center gap-4 p-4 hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors text-left"
    >
      <div className="w-10 h-10 bg-gray-100 dark:bg-gray-800 rounded-xl flex items-center justify-center flex-shrink-0">
        {icon}
      </div>
      <div className="flex-1 min-w-0">
        <div className="flex items-center gap-2">
          <span className="font-medium text-gray-900 dark:text-white">{label}</span>
          {badge && <Badge variant="info" size="sm">{badge}</Badge>}
        </div>
        {description && (
          <p className="text-sm text-gray-500 dark:text-gray-400 line-clamp-1">{description}</p>
        )}
      </div>
      {rightElement || <ChevronRight className="w-5 h-5 text-gray-400 flex-shrink-0" />}
    </button>
  );
}

function ToggleSwitch({ enabled, onChange }: { enabled: boolean; onChange: () => void }) {
  return (
    <button
      onClick={onChange}
      className={cn(
        'relative w-12 h-7 rounded-full transition-colors',
        enabled ? 'bg-indigo-600' : 'bg-gray-300 dark:bg-gray-600'
      )}
    >
      <span
        className={cn(
          'absolute top-1 w-5 h-5 bg-white rounded-full transition-transform shadow-sm',
          enabled ? 'translate-x-6' : 'translate-x-1'
        )}
      />
    </button>
  );
}

export default function SettingsPage() {
  const [notifications, setNotifications] = useState(true);
  const [darkMode, setDarkMode] = useState(false);
  const [selectedSectors, setSelectedSectors] = useState<string[]>(['Technology', 'Healthcare']);
  const [showPreferences, setShowPreferences] = useState(false);

  const toggleSector = (sector: string) => {
    setSelectedSectors((prev) =>
      prev.includes(sector)
        ? prev.filter((s) => s !== sector)
        : [...prev, sector]
    );
  };

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-950">
      <Header title="Settings" />

      <div className="pt-14 px-4 pb-6 space-y-6">
        {/* Premium Card */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="mt-4"
        >
          <Card className="bg-gradient-to-br from-amber-500 to-orange-600 text-white p-5">
            <div className="flex items-start gap-4">
              <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center">
                <Crown className="w-6 h-6" />
              </div>
              <div className="flex-1">
                <h3 className="font-semibold text-lg">Upgrade to Premium</h3>
                <p className="text-amber-100 text-sm mt-1">
                  Unlock advanced screeners, real-time alerts, and unlimited watchlists
                </p>
                <Button
                  variant="secondary"
                  size="sm"
                  className="mt-3 bg-white text-amber-600 hover:bg-amber-50"
                >
                  View Plans
                </Button>
              </div>
            </div>
          </Card>
        </motion.div>

        {/* Account Section */}
        <motion.section
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
        >
          <h2 className="text-sm font-medium text-gray-500 dark:text-gray-400 mb-2 px-1">
            Account
          </h2>
          <Card padding="none" variant="outline" className="overflow-hidden divide-y divide-gray-100 dark:divide-gray-800">
            <SettingItem
              icon={<User className="w-5 h-5 text-gray-600 dark:text-gray-400" />}
              label="Profile"
              description="Manage your account details"
            />
            <SettingItem
              icon={<Shield className="w-5 h-5 text-gray-600 dark:text-gray-400" />}
              label="Security"
              description="Password, 2FA, and login settings"
            />
          </Card>
        </motion.section>

        {/* Preferences Section */}
        <motion.section
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
        >
          <h2 className="text-sm font-medium text-gray-500 dark:text-gray-400 mb-2 px-1">
            Preferences
          </h2>
          <Card padding="none" variant="outline" className="overflow-hidden divide-y divide-gray-100 dark:divide-gray-800">
            <SettingItem
              icon={<Bell className="w-5 h-5 text-gray-600 dark:text-gray-400" />}
              label="Notifications"
              description="Price alerts and news updates"
              rightElement={
                <ToggleSwitch enabled={notifications} onChange={() => setNotifications(!notifications)} />
              }
            />
            <SettingItem
              icon={<Palette className="w-5 h-5 text-gray-600 dark:text-gray-400" />}
              label="Appearance"
              description="Light, dark, or system theme"
              rightElement={
                <div className="flex items-center gap-1 bg-gray-100 dark:bg-gray-800 rounded-lg p-1">
                  <button
                    onClick={() => setDarkMode(false)}
                    className={cn(
                      'p-1.5 rounded-md transition-colors',
                      !darkMode ? 'bg-white dark:bg-gray-700 shadow-sm' : ''
                    )}
                  >
                    <Sun className="w-4 h-4 text-gray-600 dark:text-gray-400" />
                  </button>
                  <button
                    onClick={() => setDarkMode(true)}
                    className={cn(
                      'p-1.5 rounded-md transition-colors',
                      darkMode ? 'bg-white dark:bg-gray-700 shadow-sm' : ''
                    )}
                  >
                    <Moon className="w-4 h-4 text-gray-600 dark:text-gray-400" />
                  </button>
                </div>
              }
            />
            <div className="p-4">
              <button
                onClick={() => setShowPreferences(!showPreferences)}
                className="w-full flex items-center gap-4 text-left"
              >
                <div className="w-10 h-10 bg-gray-100 dark:bg-gray-800 rounded-xl flex items-center justify-center flex-shrink-0">
                  <Building2 className="w-5 h-5 text-gray-600 dark:text-gray-400" />
                </div>
                <div className="flex-1">
                  <span className="font-medium text-gray-900 dark:text-white">Investment Preferences</span>
                  <p className="text-sm text-gray-500 dark:text-gray-400">
                    {selectedSectors.length} sectors selected
                  </p>
                </div>
                <ChevronRight className={cn(
                  'w-5 h-5 text-gray-400 transition-transform',
                  showPreferences && 'rotate-90'
                )} />
              </button>

              {showPreferences && (
                <motion.div
                  initial={{ opacity: 0, height: 0 }}
                  animate={{ opacity: 1, height: 'auto' }}
                  className="mt-4 pt-4 border-t border-gray-100 dark:border-gray-800"
                >
                  <p className="text-sm text-gray-500 dark:text-gray-400 mb-3">
                    Select sectors you&apos;re interested in for personalized recommendations
                  </p>
                  <div className="flex flex-wrap gap-2">
                    {sectors.map((sector) => (
                      <button
                        key={sector}
                        onClick={() => toggleSector(sector)}
                        className={cn(
                          'px-3 py-1.5 text-sm rounded-full transition-all',
                          selectedSectors.includes(sector)
                            ? 'bg-indigo-600 text-white'
                            : 'bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300'
                        )}
                      >
                        {sector}
                      </button>
                    ))}
                  </div>
                </motion.div>
              )}
            </div>
          </Card>
        </motion.section>

        {/* Support Section */}
        <motion.section
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 }}
        >
          <h2 className="text-sm font-medium text-gray-500 dark:text-gray-400 mb-2 px-1">
            Support
          </h2>
          <Card padding="none" variant="outline" className="overflow-hidden divide-y divide-gray-100 dark:divide-gray-800">
            <SettingItem
              icon={<HelpCircle className="w-5 h-5 text-gray-600 dark:text-gray-400" />}
              label="Help Center"
              description="FAQs and guides"
              rightElement={<ExternalLink className="w-4 h-4 text-gray-400" />}
            />
            <SettingItem
              icon={<MessageSquare className="w-5 h-5 text-gray-600 dark:text-gray-400" />}
              label="Send Feedback"
              description="Help us improve the app"
            />
            <SettingItem
              icon={<Star className="w-5 h-5 text-gray-600 dark:text-gray-400" />}
              label="Rate the App"
              description="Share your experience"
            />
          </Card>
        </motion.section>

        {/* App Info */}
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.4 }}
          className="text-center py-4"
        >
          <p className="text-sm text-gray-400 dark:text-gray-500">
            Upful v2.0.0
          </p>
          <p className="text-xs text-gray-400 dark:text-gray-600 mt-1">
            Made with care for investors
          </p>
        </motion.div>
      </div>
    </div>
  );
}
