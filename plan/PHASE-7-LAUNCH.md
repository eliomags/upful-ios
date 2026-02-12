# Phase 7: Polish & Launch (Weeks 24-28)

**Status:** IN PROGRESS (7.1 + 7.3 COMPLETE)
**Duration:** Weeks 24-28
**Build:** 119 Swift files + 5 test files — BUILD SUCCEEDED (0 errors, 0 warnings)

---

## 7.1 Testing
- [x] 7.1.1 Create `UpfulTests/PayoutViewModelTests.swift` — 13 tests: initial state, canRequestPayout, formatCurrency, formatDate, groupedHistory, simulatePayoutRequest
- [x] 7.1.2 Create `UpfulTests/SubscriptionViewModelTests.swift` — 10 tests: initial state, clearError, errorMessage, purchase errors, isPremium delegation, State equatable
- [x] 7.1.3 Create `UpfulTests/StoreKitServiceTests.swift` — 10 tests: initial state, filtered products, ProductID constants, ProductID sets (subscriptions/consumables/all), no overlap
- [x] 7.1.4 Create `UpfulTests/PayoutDTOsTests.swift` — 10 tests: JSON decoding (balance, history), encoding (request body), statusDisplayText, statusBadgeColor
- [x] 7.1.5 Create `UpfulTests/PayoutEndpointsTests.swift` — 10 tests: endpoint paths/methods/bodies, PayoutMethod properties, Codable round-trip, CaseIterable
- [x] 7.1.6 All 5 test files added to UpfulTests target in pbxproj (GG prefix UUIDs)
- [x] 7.1.7 Fix compilation: `XCTAssertEqual(json?["amount"], accuracy:)` — optional Double unwrapping via `XCTUnwrap`
- [x] 7.1.8 TEST BUILD SUCCEEDED — all 5 test files compile
- [ ] 7.1.9 Integration tests: API communication (deferred to backend deployment phase)
- [ ] 7.1.10 UI tests: Onboarding, Trading, Subscription flows (deferred — requires device testing)
- [x] 7.1.11 **COMMIT**: included in Phase 7 commit

## 7.2 Performance
- [ ] 7.2.1 Profile app launch time (<2 seconds target)
- [ ] 7.2.2 Profile list scrolling performance
- [ ] 7.2.3 Optimize image loading/caching
- [ ] 7.2.4 Verify KV cache hit rates on backend
- [ ] 7.2.5 Fix any memory leaks
- [ ] 7.2.6 **COMMIT**: "perf: optimize performance"

## 7.3 Accessibility
- [x] 7.3.1 Create `Jyanik/Design/Accessibility/AccessibilityModifiers.swift` — View extensions: stockAccessibilityLabel, portfolioAccessibilityLabel, rankAccessibilityLabel, tradeAccessibilityLabel, payoutAccessibilityLabel, priceAccessibilityTraits, headerAccessibility, accessibleTapTarget (44x44pt min)
- [x] 7.3.2 Edit `Jyanik/Design/Components/JStockRow.swift` — Added `.accessibilityElement(children: .combine)` + `.accessibilityLabel()` with ticker, price, change info
- [x] 7.3.3 Edit `Jyanik/Design/Components/JBadge.swift` — Added `.accessibilityLabel()` to JBadge ("X notifications"), JDotBadge ("Status indicator"), JTextBadge (text label)
- [x] 7.3.4 Accessibility PBXGroup created under Design group (GG prefix UUID)
- [x] 7.3.5 Dynamic Type support via JFont tokens (already Font type, scales with system)
- [x] 7.3.6 **COMMIT**: included in Phase 7 commit

## 7.4 App Store Preparation
- [ ] 7.4.1 Create app icons
- [ ] 7.4.2 Create screenshots
- [ ] 7.4.3 Write app description
- [ ] 7.4.4 Configure App Store Connect
- [ ] 7.4.5 TestFlight beta
- [ ] 7.4.6 Submit for review
- [ ] 7.4.7 **COMMIT**: "chore: prepare for App Store submission"
- [ ] 7.4.8 **PUSH all Phase 7 commits**

---

## Phase 7 File Summary (Completed)

| Group | Files | Lines (approx) |
|-------|-------|----------------|
| Unit Tests | 5 (PayoutViewModelTests, SubscriptionViewModelTests, StoreKitServiceTests, PayoutDTOsTests, PayoutEndpointsTests) | ~770 |
| Accessibility | 1 (AccessibilityModifiers.swift) | ~62 |
| Modified | 2 (JStockRow.swift, JBadge.swift) | +5 lines |
| **Total Phase 7** | **6 new files + 2 modified** | **~837 lines** |

## Build Integration

- 6 new files added to `project.pbxproj` (PBXFileReference + PBXBuildFile + PBXGroup + PBXSourcesBuildPhase)
- 1 new PBXGroup: Accessibility (GG prefix UUIDs)
- AccessibilityModifiers.swift added to Jyanik/Design/Accessibility/ (main target)
- 5 test files added to UpfulTests/ directory (test target PBXSourcesBuildPhase)
- **Total project: 119 Swift files + 5 test files — BUILD SUCCEEDED + TEST BUILD SUCCEEDED**

## Compilation Fixes Applied

| Fix | File | Issue | Solution |
|-----|------|-------|----------|
| Optional Double in XCTAssertEqual | PayoutDTOsTests.swift | `json?["amount"] as? Double` → `Double?` incompatible with `accuracy:` param | Used `XCTUnwrap(json)` then `dict["amount"] as! Double` |

## Architecture Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Test file location | `UpfulTests/` not `JyanikTests/` | Xcode test target uses `UpfulTests` directory and PBXGroup |
| Test module import | `@testable import Upful` | Module name is "Upful" (not "Jyanik") |
| Test target build phase | Added to existing UpfulTests PBXSourcesBuildPhase | Reuse existing test target infrastructure |
| Accessibility modifiers | View extensions with semantic labels | Reusable across all feature views via dot syntax |
| Min tap target | 44x44pt via `.accessibleTapTarget()` | Apple HIG accessibility guideline |

---

*Last updated: 2026-02-12*
*Phase: 7 — Testing & Accessibility (7.1 + 7.3 COMPLETE)*
*Branch: feature/jyanik-rebuild*
