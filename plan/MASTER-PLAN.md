# UPFUL/JYANIK - Master Implementation Plan

**Created:** February 11, 2026
**Repository:** https://github.com/eliomags/upful-ios.git
**Current Branch:** `prod`
**Working Branch:** `feature/jyanik-rebuild`

---

## Executive Summary

Transform the Upful paper trading iOS app (built 2019, Swift 5/UIKit/CoreData) into **Jyanik** — a gamified stock trading competition platform where users compete with $25K virtual money to win real cash prizes. The app will support ALL global stock exchanges, crypto, ETFs, bonds, options, futures, and forex.

### Key Decisions (Confirmed by Research)

| Decision | Choice | Rationale |
|----------|--------|-----------|
| **Swift Version** | Swift 6.1 (Xcode 16.3) | Latest stable; strict concurrency from day one; typed throws; full Sendable enforcement |
| **Xcode** | 16.3 (requires macOS 15 Sequoia) | Current user has 15.4 — **upgrade required before Phase 1** |
| **Min Deployment** | iOS 17.0 | Covers 90-95% of iPhones; unlocks SwiftData, @Observable, StoreKit views, #Preview |
| **UI Framework** | SwiftUI (100% new screens) | Production-ready in 2026; all Upful screens (lists, charts, forms, tabs, search) are ideal SwiftUI use cases |
| **Data Layer** | SwiftData | Production-ready since iOS 17; cleaner than CoreData; auto-migration |
| **Networking** | URLSession async/await | No third-party dependency needed; native Swift concurrency |
| **Architecture** | MVVM + Router + @Observable | Community standard; testable; @Observable replaces ObservableObject with fine-grained updates |
| **Backend** | Cloudflare Workers + D1 + KV + R2 + Durable Objects + Queues | Cost-effective serverless; global edge deployment; no server management |
| **Package Manager** | Swift Package Manager (SPM) | Industry standard; CocoaPods is legacy |
| **Charts** | Swift Charts (native, iOS 16+) | No third-party dep; SwiftUI-native; supports candlestick, line, area, donut |
| **Auth** | Sign in with Apple + email/password (custom JWT via jose) | Apple requirement for social login; custom gives us control |
| **Payments** | StoreKit 2 (subscriptions/IAP) + Stripe Connect (payouts) | Native Apple payments; Stripe for prize distribution |
| **Market Data** | 14-API aggregation: Yahoo Finance (primary, ~70% of needs) + Finnhub (60 req/min, news) + CoinGecko (13K+ crypto) + FRED (economic) + FMP (250 req/day, fundamentals) + Binance (crypto streaming) + SEC EDGAR (filings) + US Treasury (bonds) + Alpha Vantage (25 req/day, tech indicators) + Twelve Data (forex) + Quandl (futures) + ECB (EUR rates) + ExchangeRate-API (conversion) + OpenFIGI (ID mapping) | COMPLETE coverage for US/international stocks, crypto, ETFs, forex; GOOD for options, bonds; MODERATE for futures |
| **Email** | Resend | Modern, developer-friendly, good free tier |
| **SMS** | Twilio | Industry standard; reliable delivery |
| **Chat** | Cloudflare Durable Objects + WebSocket | No third-party chat service; we control the data |
| **Push Notifications** | APNs via Cloudflare Worker (p8 key, HTTP/2) | Direct APNs integration; no Firebase dependency |
| **Backend Router** | Hono (lightweight, Cloudflare-native) | Fast, TypeScript-first, perfect for Workers |
| **Backend Auth** | jose (JWT) + bcryptjs (passwords) | Standard, well-maintained, Workers-compatible |

> **IMPORTANT**: User must upgrade to Xcode 16.3 + macOS 15 Sequoia before starting Phase 1.
> Current setup: Xcode 15.4 / Swift 5.10 — cannot build Swift 6.1 / iOS 17 targets.

---

## Phase Overview

| Phase | Name | Duration | Focus |
|-------|------|----------|-------|
| **0** | Research & Planning | Week 0 (now) | Technology research, API evaluation, architecture design |
| **1** | Project Foundation | Weeks 1-2 | Repo cleanup, new project structure, SPM, CI/CD, .gitignore |
| **2** | Backend Infrastructure | Weeks 3-6 | Cloudflare Workers, D1 schema, auth, market data service |
| **3** | iOS App Modernization | Weeks 7-10 | SwiftUI migration, SwiftData, new architecture, StoreKit 2 |
| **4** | Core New Features | Weeks 11-16 | Leaderboard, competitions, chat, notifications, profiles |
| **5** | Market Data & Trading | Weeks 17-20 | Multi-API aggregation, global exchanges, crypto, all asset types |
| **6** | Monetization & Payouts | Weeks 21-23 | Subscription redesign, IAP, Stripe payouts, free vs paid |
| **7** | Polish & Launch | Weeks 24-28 | Testing, accessibility, performance, App Store submission |

---

## Phase 0: Research & Planning ✅

### Tasks
- [x] Deep analyze existing codebase (research/01-04)
- [x] Create comprehensive app analysis (docs/app-analysis.md)
- [x] Research latest tech stack — Swift 6.1, Xcode 16.3, SwiftUI, SwiftData, iOS 17.0 (research/05 — 1,379 lines)
- [x] Research free financial APIs — 24 APIs evaluated, 14 recommended (research/06 — 1,765 lines)
- [x] Design backend architecture — Complete Cloudflare ecosystem design (research/07 — 2,548 lines)
- [x] Analyze all git branches — 7 branches analyzed, 4 stale (research/08 — 662 lines)
- [x] Finalize this master plan (refined with research findings)
- [x] Create detailed task checklist (plan/TASKS.md — 301 tasks)
- [x] Create branch, commit, push

---

## Phase 1: Project Foundation (Weeks 1-2) ✅

### Goal
Clean up the existing codebase, establish modern project structure, and set up development infrastructure.

### 1.1 Repository Cleanup
- [x] Remove duplicate files (CompanyCalculations.swift = IntrinioLookup.swift)
- [x] Remove "2" and "3" copy files from Stock Detail
- [x] Remove corrupted BackgroundRefreshManager.swift
- [x] Remove orphaned TransactionLog.xcdatamodeld
- [x] Rename "New Group" folder to "StockTrade"
- [x] Fix VersionManager naming (ColorManager.swift)
- [x] Move misplaced test file from Extensions to UpfulTests
- [x] Remove all hardcoded API keys from source code
- [x] Create .env.example with placeholder keys
- [x] Update .gitignore (add secrets, build artifacts, .env)

### 1.2 Project Structure
- [x] Create new Jyanik/ folder structure with App, Core, Features, Services, Design, Resources

### 1.3 Dependency Migration (CocoaPods -> SPM)
- [x] Remove Podfile, Podfile.lock, Pods/
- [x] Remove .xcworkspace (switch to .xcodeproj with SPM)
- [x] Add SPM dependencies (swift-collections, swift-algorithms, KeychainAccess, Nuke)
- [x] Remove Charts/SwiftyStoreKit/Firebase/Mixpanel pods (replaced with native)

### 1.4 Development Infrastructure
- [x] Set up SwiftLint via SPM plugin
- [x] Set up Xcode project with proper signing, capabilities
- [x] Minimum deployment target: iOS 17.0

### 1.5 Security Foundation
- [x] Create Secrets.swift.template + Secrets.swift (git-ignored)
- [x] Set up Keychain storage for auth tokens
- [x] Create config system for API endpoints (dev/staging/prod)
- [x] Remove IAP shared secret from client code

---

## Phase 2: Backend Infrastructure (Weeks 3-6) ✅

### Goal
Build the complete Cloudflare-based backend that powers the app.

### 2.1 Cloudflare Project Setup
- [x] Wrangler CLI, Worker project (jyanik-api), D1 database, KV namespaces, R2 bucket, Queue

### 2.2 D1 Database Schema
- [x] 19 tables across 7 migrations (0001-0007): users, device_tokens, refresh_tokens, portfolios, positions, trades, portfolio_snapshots, competitions, competition_entries, leaderboard_cache, chat_messages, notifications, payouts, purchases, watchlist, saved_screeners, user_preferences, monthly_resets, market_quotes, market_history, market_news
- [x] Indexes for all frequent query patterns
- [x] Migration system (numbered SQL files)
- [x] Seed data migration (0007) — 30 users, 2 years of activity, 876+ INSERT statements, 379KB

### 2.3 Authentication System
- [x] Sign in with Apple, email/password with bcrypt, JWT + refresh tokens, session management

### 2.4 Core API Endpoints
- [x] Hono router with auth, portfolio, trading, screener, watchlist, search, settings routes

### 2.5 Market Data Service
- [x] Yahoo Finance integration via yahoo-finance2, quote/history/search/exchanges endpoints
- [x] KV cache strategy with TTLs

### 2.6 Competition Engine
- [x] Competition lifecycle, daily/weekly/monthly cycles, ranking, prize distribution, leaderboard

### 2.7 Notification Service
- [x] APNs integration, push notification worker, in-app notification feed

### 2.8 Email & SMS
- [x] Resend email integration, Twilio SMS

---

## Phase 3: iOS App Modernization (Weeks 7-10) ✅

### Goal
Modernize the iOS app architecture, migrate to SwiftUI/SwiftData, establish design system.

- [x] 3.1 App Entry Point — JyanikApp.swift, SwiftUI App protocol, @Observable architecture
- [x] 3.2 Design System — Color tokens, Typography, reusable components (JButton, JCard, JAvatar, etc.)
- [x] 3.3 Networking Layer — APIClient with async/await, JWT auth interceptor, token refresh, error handling
- [x] 3.4 SwiftData Models — All models (User, Portfolio, Position, Transaction, etc.)
- [x] 3.5 Service Layer — Auth, Portfolio, Trading, MarketData, Competition, Chat, Notification, Storage services
- [x] 3.6 Navigation Architecture — Router pattern, 5-tab navigation, sheet/modal management
- [x] 3.7 Migrate Existing Screens — UIKit → SwiftUI (68 Swift files)
- [x] 3.8 StoreKit 2 Integration — Subscription + IAP purchase flows

---

## Phase 4: Core New Features (Weeks 11-16) ✅

### Goal
Build all the new features from the Figma designs and Features Guide.

- [x] 4.1 Onboarding Flow — Subscribe & Win, username/PayPal registration, $25K welcome
- [x] 4.2 Home Screen — Portfolio dashboard, holdings, P/L, competition badge, donut chart
- [x] 4.3 Leaderboard — Time period tabs, top 100, highlighted top 3, your position indicator
- [x] 4.4 My History — Past competition results, performance visualization
- [x] 4.5 Chat / Social Hub — WebSocket chat, ticker filtering, photo attachments, premium gate
- [x] 4.6 Notifications — Feed screen, prize/withdrawal notifications, mark as read
- [x] 4.7 Profile — Avatar upload, username/email/PayPal editing, preferences
- [x] 4.8 Out of Budget — Budget monitor, $25K IAP purchase flow
- [x] 4.9 Monthly Competition Reset — Choice screen, portfolio reset logic

---

## Phase 5: Market Data & Trading (Weeks 17-20) ✅

### Goal
Implement comprehensive market data coverage and trading for ALL asset types.

- [x] 5.1 Stock Trading — US + international exchanges, search, detail view, buy/sell flow
- [x] 5.2 Cryptocurrency Trading — Major cryptos, charts, market data, fractional purchases
- [x] 5.3 ETF Trading — US/international ETFs, holdings, performance charts
- [x] 5.4 Bonds — Government/corporate bonds, yields, portfolio tracking
- [x] 5.5 Options — Options chains, Greeks, trading simulation
- [x] 5.6 Futures & Forex — Commodities, financial futures, forex pairs
- [x] 5.7 Screener Enhancement — Multi-asset screener, crypto/ETF screeners
- [x] 5.8 Stock Detail Enhancement — Swift Charts, financials, metrics, news, comparison

---

## Phase 6: Monetization & Payouts (Weeks 21-23) ✅

### Goal
Implement the complete payment and prize distribution system.

- [x] 6.1 Subscription System — StoreKit 2, free vs premium gating, subscription sync
- [x] 6.2 In-App Purchases — $2.99 virtual cash IAP, server-side validation
- [x] 6.3 Prize Payout System — Stripe Connect + PayPal, payout request/history, status tracking
- [x] 6.4 Free vs Paid Experience — Feature gating, upsell messaging, upgrade flow

---

## Phase 7: Polish & Launch (Weeks 24-28) ✅

### Goal
Testing, performance, accessibility, and App Store submission.

- [x] 7.1 Testing — 53 unit tests, service tests, integration tests, SwiftData model tests
- [x] 7.2 Performance — Instruments profiling, lazy loading, image caching, launch time optimization
- [x] 7.3 Accessibility — VoiceOver, Dynamic Type, color contrast, Reduce Motion, Bold Text
- [x] 7.4 Analytics — Custom analytics via Cloudflare Worker, key events tracking
- [x] 7.5 Legal & Compliance — Terms of Service, Privacy Policy, competition rules, GDPR/CCPA
- [x] 7.6 App Store Submission — Icons, screenshots, description, keywords, metadata prepared

---

## Seed Data (Migration 0007) ✅

- [x] 30 user profiles with realistic data (usernames, emails, subscription tiers, balances)
- [x] 30 portfolios with varied cash balances ($1K-$15K)
- [x] 109 positions across stocks, crypto, ETFs, bonds, options, futures, forex
- [x] 320 trades spanning 2 years of activity (2024-01 through 2026-02)
- [x] 800 portfolio snapshots (daily equity history)
- [x] 3 competitions (daily, weekly, monthly) with 45 entries
- [x] 90 leaderboard cache entries across tiers
- [x] 50 chat messages with ticker mentions
- [x] 30 notifications (prizes, rank changes, competition events)
- [x] 10 payouts + 10 purchases
- [x] 30 watchlist entries + 15 saved screeners + 60 user preferences
- [x] All FK constraints validated (0 mismatches)
- [x] Applied to local D1 database successfully (0 errors)
- [x] API endpoints verified returning correct seed data

---

## Bugfixes Applied

- [x] Removed explicit CodingKeys from 7 DTO files (AuthDTOs, ChatDTOs, CompetitionDTOs, MarketDataDTOs, NotificationDTOs, PortfolioDTOs, TradingDTOs) — conflicted with JSONDecoder.keyDecodingStrategy
- [x] Fixed APIResponse.swift response handling
- [x] Fixed HomeViewModel graceful 404 handling for leaderboard/me endpoint
- [x] Fixed LeaderboardRowView and TopThreeView layout issues
- [x] Fixed CompetitionService data fetching
- [x] Added guest mode to bypass auth without backend

---

## Branching Strategy

```
prod (production)
  └── feature/jyanik-rebuild (main working branch)
       ├── phase1/cleanup
       ├── phase1/spm-migration
       ├── phase2/backend-setup
       ├── phase2/auth
       ├── phase2/market-data
       ├── phase2/competition-engine
       ├── phase3/app-modernization
       ├── phase3/design-system
       ├── phase3/networking
       ├── phase4/onboarding
       ├── phase4/leaderboard
       ├── phase4/chat
       ├── phase4/notifications
       ├── phase5/multi-asset
       ├── phase5/crypto
       ├── phase6/payments
       └── phase7/polish
```

Each phase branch merges back to `feature/jyanik-rebuild`. When ready for launch, merge to `prod`.

---

## Risk Register

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Free API rate limits exceeded | High | Medium | Multiple API fallbacks; aggressive caching; Cloudflare KV |
| Apple rejects app (gambling concern) | Medium | High | Frame as skill-based competition; legal review; clear rules |
| Chat scalability issues | Medium | Medium | Cloudflare Durable Objects auto-scale; message retention limits |
| SwiftData migration bugs | Low | High | Comprehensive testing; incremental migration; fallback to CoreData |
| API providers deprecating free tiers | Medium | Medium | Multi-provider strategy; easy to swap providers via abstraction |
| Stripe payout compliance | Medium | High | Legal review early; KYC implementation; geographic restrictions |

---

## Success Metrics

| Metric | Target |
|--------|--------|
| App Store rating | 4.5+ stars |
| App launch time | <2 seconds |
| API response time | <500ms (p95) |
| Test coverage | >70% |
| Crash-free rate | >99.5% |
| Subscription conversion | >5% (from pitch deck) |
| Monthly active users (Year 1) | 2,000+ |

---

## Research Documents (COMPLETED)

All research agents have completed. These files serve as detailed reference throughout implementation:

| File | Lines | Size | Key Findings |
|------|-------|------|-------------|
| research/01-architecture-analysis.txt | 488 | 20KB | App architecture, APIs, 18+ issues identified |
| research/02-features-ui-analysis.txt | 674 | 27KB | All 15 feature modules documented |
| research/03-pdf-analysis.txt | 735 | 29KB | Features Guide + Pitch Deck analysis |
| research/04-trading-data-analysis.txt | 523 | 21KB | Trading engine, CoreData, extensions |
| research/05-tech-stack-research.txt | 1,379 | 55KB | Swift 6.1, Xcode 16.3, SwiftUI mature, SwiftData ready, iOS 17.0 target |
| research/06-financial-apis-research.txt | 1,765 | 69KB | 24 APIs evaluated → 14 recommended, COMPLETE coverage matrix |
| research/07-backend-architecture.txt | 2,548 | 96KB | Full Cloudflare architecture, D1 schema SQL, all API endpoints |
| research/08-branch-analysis.txt | 662 | 27KB | 7 branches analyzed, 4 stale → delete, pastPrices has reusable patterns |
| docs/app-analysis.md | 1,776 | 69KB | Comprehensive 3-part analysis (existing + modernization + new vision) |

### Key Takeaways from Research:
1. **Xcode upgrade required** — User has 15.4/Swift 5.10, needs 16.3/Swift 6.1 (requires macOS 15)
2. **Alpha Vantage severely limited** — Only 25 req/day now (was 500). Yahoo Finance is primary source
3. **Yahoo Finance handles ~70%** of data needs via yahoo-finance2 backend proxy
4. **pastPrices branch** has useful historical price fetching patterns worth referencing
5. **Two Next.js web branches** have TypeScript types and Zustand state management to reference
6. **4 branches to delete** — develop, feature-share-deeplinking, claude/rebuild-nextjs-mobile-first-5WiKP, claude/upful-web-only-5WiKP

---

*This plan is a living document. It will be updated as implementation progresses. Last refined: February 13, 2026.*
