# Phase 1: Project Foundation (Weeks 1-2)

**Status:** COMPLETE
**Duration:** Weeks 1-2

---

## 1.1 Repository Cleanup
- [x] 1.1.1 Create feature/jyanik-rebuild branch from prod
- [x] 1.1.2 Remove duplicate: Upful/Models/CompanyCalculations.swift (identical to IntrinioLookup.swift)
- [x] 1.1.3 Remove "2" and "3" copy files from Stock Detail feature (21 files removed)
- [x] 1.1.4 Remove corrupted BackgroundRefreshManager.swift (binary bookmark file)
- [x] 1.1.5 Remove orphaned TransactionLog.xcdatamodeld
- [x] 1.1.6 Rename "Upful/Features/New Group/" to "Upful/Features/StockTrade_Controllers/"
- [x] 1.1.7 Fix ColorManager.swift: rename VersionManager to ThemeManager (34+ files updated)
- [x] 1.1.8 Move SavedStocksViewModelTest.swift from Extensions/ to UpfulTests/
- [x] 1.1.9 Remove all hardcoded API keys from Constants.swift -> now uses Secrets.swift
- [x] 1.1.10 Remove hardcoded IEX key from StockDescriptionLoader.swift URL
- [x] 1.1.11 Remove IAP shared secret from IAPService.swift -> now uses Secrets.iapSharedSecret
- [x] 1.1.12 Remove Mixpanel token from Constants.swift -> now uses Secrets.mixpanelToken
- [x] 1.1.13 Create Secrets.example.swift with placeholder values
- [x] 1.1.14 Update .gitignore: add Secrets.swift, .env, *.xcuserdata, DerivedData/, Pods/, large PDFs
- [-] 1.1.15 Remove stale hardcoded date ranges in API queries -- SKIPPED: Intrinio API files will be entirely replaced in Phase 5
- [x] 1.1.16 Fix 12-hour time format bug (hh -> HH in Date.asString)
- [x] 1.1.17 Fix Double.twoDecimal() to actually use 2 decimals (was maximumFractionDigits=1)
- [x] 1.1.18 Fix typo: FirebaseAnayltics -> FirebaseAnalytics (in AnalyticsTrackers + AnalyticsMapper)
- [x] 1.1.19 Fix typo: sign_up_attempty -> sign_up_attempt
- [x] 1.1.20 Also: extracted hardcoded Intrinio key from StockScreeningService.swift
- [x] 1.1.21 Also: moved misplaced PersistedPerformanceDataPoint.swift from root to Upful/Models/
- [x] 1.1.22 **COMMIT**: "chore: cleanup codebase - remove duplicates, fix bugs, extract secrets" -- 74 files, +191/-2,837 lines

## 1.2 Dependency Migration (CocoaPods -> SPM)
- [x] 1.2.1 Documented all Pod dependencies: SwiftyStoreKit, Firebase (Analytics/Core/Crashlytics/DynamicLinks/Firestore), Mixpanel-swift, Charts
- [x] 1.2.2 Removed Podfile, Podfile.lock from git tracking
- [x] 1.2.3 Removed Pods/ directory from git tracking (8,163 files, 163MB)
- [x] 1.2.4 Removed Upful.xcworkspace from git tracking, updated .gitignore
- [x] 1.2.5 Added SPM packages to Upful.xcodeproj:
  - Firebase SDK 11.0+ (Analytics, Core, Crashlytics, DynamicLinks, Firestore)
  - Mixpanel-swift 4.0+
  - SwiftyStoreKit 0.16+ (temporary, will be replaced by StoreKit 2)
  - DGCharts 5.0+ (temporary, will be replaced by Swift Charts)
  - Kept existing: Kingfisher, YSDraggy
- [x] 1.2.6 Updated all `import Charts` -> `import DGCharts` across 7 files (SPM module name change)
- [x] 1.2.7 Cleaned all CocoaPods build phases and references from pbxproj (46 references removed)
- [x] 1.2.8 **COMMIT**: "chore: migrate from CocoaPods to SPM" -- 8,179 files, +129/-2,041,312 lines

## 1.3 New Project Structure
- [x] 1.3.1 Created Jyanik/ top-level directory for new app code
- [x] 1.3.2 Created full folder structure with .gitkeep files:
  - Jyanik/App/, Core/(Models, Protocols, Extensions, Utilities)
  - Features/, Services/(Networking, Analytics, Trading, MarketData, Auth, Storage)
  - Design/(Theme, Components), Resources/
- [-] 1.3.3-1.3.7 File migration DEFERRED to Phase 3 -- existing Upful/ stays as reference
  - Moving files in legacy xcodeproj is brittle and error-prone
  - All features will be rewritten as new SwiftUI files in Jyanik/
  - Old Upful/ code serves as reference during rebuild
- [x] 1.3.8 Structure ready for new Phase 3+ code
- [x] 1.3.9 Committed together with Phase 1.4 + 1.5

## 1.4 Development Infrastructure
- [-] 1.4.1 SwiftLint SPM plugin -- DEFERRED: install via `brew install swiftlint` (see Manual Actions #11)
- [x] 1.4.2 Created .swiftlint.yml with comprehensive rules (line_length:120, force_unwrapping:error, force_cast:error, etc.)
- [-] 1.4.3 Fix SwiftLint errors -- DEFERRED to Phase 3 (legacy code will be rewritten)
- [x] 1.4.4 Created .github/workflows/ci.yml (swiftlint + backend-lint jobs on macos-15 / ubuntu)
- [x] 1.4.5 Set minimum deployment target to iOS 17.0 (all 4 build configs updated in pbxproj)
- [!] 1.4.6 Update project signing -- REQUIRES XCODE (see Manual Actions #5)
- [!] 1.4.7 Add Push Notifications capability -- REQUIRES XCODE (see Manual Actions #6)
- [!] 1.4.8 Add Sign in with Apple capability -- REQUIRES XCODE (see Manual Actions #6)
- [!] 1.4.9 Add In-App Purchase capability -- REQUIRES XCODE (see Manual Actions #6)
- [!] 1.4.10 Add Background Modes capability -- REQUIRES XCODE (see Manual Actions #6)
- [x] 1.4.11 **COMMIT**: combined with Phase 1.3 + 1.5 commit

## 1.5 Security Foundation
- [x] 1.5.1 Created AppConfig.swift with environment enum (dev/staging/prod) + feature flags
- [x] 1.5.2 API config included in AppConfig.swift (baseURL, websocketURL per environment)
- [x] 1.5.3 Created KeychainService.swift using native Security framework (no third-party dependency)
- [x] 1.5.4 Verified: Secrets.swift is git-ignored, no secrets in committed files
- [x] 1.5.5 **COMMIT**: "feat: add project structure, dev infrastructure, and security foundation" -- 21 files, +528/-50
- [x] 1.5.6 **PUSHED all Phase 1 commits** -- 4 commits total on feature/jyanik-rebuild
