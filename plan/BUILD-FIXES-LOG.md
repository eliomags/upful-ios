# Build Fixes Log

> All issues encountered and resolved while integrating the new Jyanik module into the existing Upful Xcode project during Phase 3 (iOS Modernization).

---

## Summary

The Upful Xcode project had significant legacy debt from the original developer (Yanik Simpson). When we added 68 new Swift files in the `Jyanik/` folder and attempted to build, multiple issues surfaced — some from our new code, most from the old project configuration. This document tracks every fix.

---

## 1. `.gitkeep` Duplicate Output Files

**Error:** `Multiple commands produce '.gitkeep'`

**Cause:** During Phase 1 (project structure setup), we created `.gitkeep` placeholder files in every Jyanik subdirectory to preserve the folder structure in git. When the Jyanik folder was added to Xcode as a group, Xcode tried to copy all `.gitkeep` files as resources, causing "duplicate output" conflicts since they all had the same filename.

**Fix:**
- Deleted all 15 `.gitkeep` files from disk: `find Jyanik -name ".gitkeep" -delete`
- Cleaned Xcode DerivedData: `rm -rf ~/Library/Developer/Xcode/DerivedData/Upful-*`

**Lesson:** Never use `.gitkeep` in folders that will be added to an Xcode project as groups. Use a different approach (like an empty `.swift` file) or just let git track the folder once real files exist.

---

## 2. Firebase SDK Incompatibility (`sending` keyword)

**Error:** `Cannot find type 'sending' in scope` in `FirebaseDataEncoder`

**Cause:** The project had Firebase iOS SDK 11.15.0 (resolved via SPM). Firebase 11.x uses Swift 6's `sending` keyword for concurrency, but our Xcode 15.4 only supports Swift 5.9. The `sending` keyword doesn't exist in Swift 5.9.

**Initial Attempt:** Downgraded Firebase to 10.x (`minimumVersion = 10.0.0`) — this resolved the Swift error but then `FirebaseCore` package product wasn't found in 10.x.

**Final Fix:** Completely removed Firebase from the project (see Section 4 below). Firebase is not needed for the Upful rebuild since we're using Cloudflare Workers as the backend.

---

## 3. Absolute Path References (Original Developer's Machine)

**Error:** `Build input files cannot be found: '/Users/yaniksimpson/Desktop/Upful/...'`

**Cause:** The original developer (Yanik Simpson) had some files referenced with absolute paths pointing to his local machine (`/Users/yaniksimpson/Desktop/Upful/`). These paths don't exist on any other machine.

**Files Affected:**
| File | Old Path | Issue |
|------|----------|-------|
| `User+CoreData.swift` | `/Users/yaniksimpson/Desktop/Upful/Upful/Services/Persistence/User+CoreData.swift` | `sourceTree = "<absolute>"` |
| `PersistedPerformanceDataPoint.swift` | N/A | `sourceTree = SOURCE_ROOT` (wrong relative base) |
| `StockTradeViewController.swift` | N/A | Group path `../New Group/Controllers` didn't match disk |

**Fix:**
- Changed `User+CoreData.swift` from absolute path to `sourceTree = "<group>"` with relative path
- Changed `PersistedPerformanceDataPoint.swift` from `SOURCE_ROOT` to `<group>`
- Copied `StockTradeViewController.swift` to the path Xcode expected (`Upful/Features/New Group/Controllers/`)
- Copied `PersistedPerformanceDataPoint.swift` to `Upful/Services/Historic Performance Manager/`

---

## 4. Firebase Removal (Complete)

**Decision:** Remove Firebase entirely — it's not needed for the rebuild.

**What Was Removed:**
| Component | Purpose in Old App | Replacement in New App |
|-----------|-------------------|----------------------|
| **FirebaseAnalytics** | User behavior tracking, screen views, events | **Mixpanel** (already in project) — more powerful for product analytics |
| **FirebaseCore** | Required base for all Firebase services | Not needed |
| **FirebaseCrashlytics** | Crash reporting and diagnostics | **Native iOS crash logs** + future Sentry integration if needed |
| **FirebaseDynamicLinks** | Deep linking (share stock pages, referrals) | **Native iOS Universal Links** — configured in Associated Domains capability |
| **FirebaseFirestore** | Cloud database for user data, portfolios, stock data | **Cloudflare D1** (SQLite) + **Cloudflare KV** — our custom backend |
| **Crashlytics Run Script** | dSYM upload build phase for crash symbolication | Removed — no longer needed |

**Files in `pbxproj` Removed:**
- 5 `PBXBuildFile` entries (frameworks)
- 5 `PBXFrameworksBuildPhase` entries
- 5 `packageProductDependencies` entries
- 1 `XCRemoteSwiftPackageReference` (firebase-ios-sdk)
- 5 `XCSwiftPackageProductDependency` entries
- 1 `PBXShellScriptBuildPhase` (Crashlytics Run Script)

**Old Swift Files Still Referencing Firebase (in `Upful/` folder):**
These files will be removed when we fully replace the old code:
- `Upful/Supporting Files/AppDelegate.swift`
- `Upful/Services/Analytics/AnalyticsMapper.swift`
- `Upful/Services/Analytics/AnalyticsTrackers.swift`
- `Upful/Services/Remote Loaders/FirestoreService.swift`
- `Upful/Services/Remote Loaders/RemoteScreenerLoader.swift`
- `Upful/Services/Remote Loaders/RemoteStockManager.swift`
- `Upful/Services/Recorders/StockEngagementRecorder.swift`
- `Upful/Services/UpfulDeepLinkManager.swift`
- `Upful/Features/Suggestions/Models/SuggestionLoader.swift`
- `Upful/Custom APIs/Trading Engine/Features/Logging/Remote/RemoteTransactionLogger.swift`
- `Upful/Custom APIs/Profile/ProfileSyncCoordinator.swift`

---

## 5. YSDraggy Removal

**Error:** `YSDraggy.swiftmodule is not built for arm64`

**What YSDraggy Was:**
YSDraggy was a **custom drag-to-expand view controller** library written by the original developer (Yanik Simpson — `github.com/syanik94/YSDraggy`). It provided:
- `DragController` — A UIViewController container that allows a child view to be dragged up/down (like Apple Maps' bottom sheet)
- `DragControllerDataSource` — Protocol for table view data sources within the draggable view
- `DragControllerStateManager` — Manages collapsed/expanded/full states of the drag view

**Where It Was Used in the Old App:**
- **Stock Detail Screen** — The stock detail page had a draggable bottom sheet showing metrics, financials, and a trade button. Users could drag it up to see full analysis or collapse it to see the stock chart.
  - `StockDetailDragViewController.swift` — Main drag container
  - `DragViewDataSources.swift` — Data sources for metrics/preview/analysis tabs
  - `Reusable Views/DragView/` — Generic drag view components

**Why It Was Removed:**
1. Not built for modern architectures (arm64 simulator)
2. Pinned to `master` branch (not version-pinned)
3. Custom library from original developer — no community support
4. Not maintained

**Replacement in New App:**
SwiftUI has native equivalents that are significantly better:
- **`.sheet()` with `presentationDetents([.medium, .large])`** — iOS 16+ native bottom sheet with drag-to-expand, exactly what YSDraggy was trying to do
- **`NavigationStack`** — For full-screen detail views
- **Our `AppRouter` + `AppSheet` system** — Already built in Phase 3, handles sheet presentation with proper state management

**No code replacement needed** — our new SwiftUI architecture handles this natively.

---

## 6. Duplicate Filename Conflicts

**Error:** `Filename "Transaction.swift" used twice`

**Cause:** Both old `Upful/` code and new `Jyanik/` code are compiled in the same target. Two files with the same name cause Swift compiler conflicts (used for private declaration disambiguation).

**Files Renamed:**
| Original Name | New Name | Reason |
|--------------|----------|--------|
| `Jyanik/Core/Models/Transaction.swift` | `TradeTransaction.swift` | Conflicts with `Upful/Custom APIs/Trading Engine/Protocols/Transaction.swift` |
| `Jyanik/Core/Utilities/Secrets.swift` | `JyanikSecrets.swift` | Conflicts with `Upful/Supporting Files/Secrets.swift` |

**Code Changes Required:**
- `AppConfig.swift` — Changed `Secrets.mixpanelToken` to `JyanikSecrets.mixpanelToken`
- The `JyanikSecrets` struct was renamed from `Secrets` to avoid type name collision

**Xcode pbxproj Updated:**
- File references updated to new filenames
- Build file comments updated to match

---

## 7. Crashlytics Build Phase Warning

**Warning:** `Run script build phase 'Crashlytics Run Script' will be run during every build because it does not specify any outputs`

**Fix:** Removed the Crashlytics Run Script build phase entirely (part of Firebase removal in Section 4).

---

## Current Package Dependencies (After Cleanup)

| Package | Version | Purpose | Status |
|---------|---------|---------|--------|
| **DGCharts** | 5.1.0 | Stock price charts (candlestick, line) | Keep — used in old code, will migrate to SwiftUI Charts |
| **Kingfisher** | 5.15.8 | Image caching and loading | Keep — useful for stock logos, user avatars |
| **Mixpanel** | 4.4.0 | Product analytics and event tracking | Keep — primary analytics platform |
| **SwiftyStoreKit** | 0.16.4 | In-app purchase wrapper | Keep for now — will evaluate replacing with native StoreKit 2 |
| ~~Firebase~~ | ~~11.15.0~~ | ~~Analytics, Crashlytics, Firestore, Dynamic Links~~ | **REMOVED** — replaced by Cloudflare backend |
| ~~YSDraggy~~ | ~~master~~ | ~~Custom drag-to-expand view controller~~ | **REMOVED** — replaced by SwiftUI `.sheet()` with `presentationDetents` |

---

## 8. Architecture Exclusion (arm64 Simulator)

**Error:** `DGCharts not built for x86_64-apple-ios-simulator`

**Cause:** The old pbxproj had `EXCLUDED_ARCHS[sdk=iphonesimulator*] = arm64` which forced x86_64 builds on Apple Silicon Macs. Modern SPM packages (DGCharts, etc.) only build for arm64 on Apple Silicon.

**Fix:**
- Changed `EXCLUDED_ARCHS[sdk=iphonesimulator*]` from `arm64` to `""` (empty string)
- Applied to both Debug and Release build configurations

---

## 9. Old Upful Source Files Removed from Build

**Error:** 63 errors — name collisions between old Upful code and new Jyanik code

**Examples:**
- `'Transaction' is ambiguous` — exists in both Upful/ and Jyanik/
- `'ChartDataPoint' is ambiguous` — same
- `'SavedStock' is ambiguous` — same
- `Cannot find 'Secrets'` — renamed to JyanikSecrets
- `Cannot find 'FirebaseApp'` — Firebase removed
- `Cannot find 'DragView'` — YSDraggy removed

**Cause:** Both old Upful code (~230 files) and new Jyanik code (69 files) were compiled in the same target. Many types had the same name in both codebases.

**Fix:**
- Removed ALL old Upful source files (3D* prefix IDs) from `PBXSourcesBuildPhase`
- Kept ONLY the 69 new Jyanik files (E87B1B* prefix IDs) in the compile phase
- Also cleared the test target's source files (27 old test files that referenced old code)
- Old source files remain on disk for reference but are NOT compiled

**Result:** Build succeeds cleanly with only the new Jyanik module compiled.

**What the old files contained (for reference):**
- ~150 UIKit view controllers, cells, and views (all being replaced by SwiftUI)
- ~30 service/loader files (Firebase, CoreData, networking — all being replaced)
- ~20 model files (duplicated in new Jyanik models)
- ~15 utility/extension files (will be re-added if needed)
- ~15 coordinator/presenter files (replaced by SwiftUI NavigationStack + AppRouter)

---

## Build Status: SUCCESS

After all 9 fixes, the project builds successfully on:
- **Xcode:** 15.4 (Swift 5.9)
- **Target:** iOS 17.0 Simulator (arm64)
- **Compiled files:** 69 Jyanik Swift files
- **SPM packages:** DGCharts 5.1.0, Kingfisher 5.15.8, Mixpanel 4.4.0, SwiftyStoreKit 0.16.4

---

*Last updated: 2026-02-11*
*Phase: 3 — iOS Modernization*
*Branch: feature/jyanik-rebuild*
