# Manual Actions Required

> These items cannot be done from CLI/terminal and need the developer to open Xcode and perform them manually.

---

## Before First Build (REQUIRED)

### 1. Upgrade to Xcode 16.3+
Current Xcode 15.4 cannot build for iOS 17.0 target. Also requires **macOS 15 Sequoia**.

### 2. Delete local CocoaPods artifacts
Files removed from git but still exist locally:
- Delete `Pods/` folder (163MB)
- Delete `Podfile` and `Podfile.lock`
- Delete `Upful.xcworkspace/` folder
- After deleting workspace, open `Upful.xcodeproj` directly (not workspace)

### 3. Resolve SPM packages
First time opening project after migration, Xcode will need to fetch:
- Firebase SDK 11.0+ (may take a few minutes)
- Mixpanel-swift 4.0+
- SwiftyStoreKit 0.16+
- DGCharts 5.0+ (formerly Charts)
- Kingfisher, YSDraggy (already existed)

### 4. Create Secrets.swift
If not already present, copy from template:
```bash
cp "Upful/Supporting Files/Secrets.example.swift" "Upful/Supporting Files/Secrets.swift"
```
Then fill in actual API keys.

---

## Xcode Settings (Do When Opening Project)

### 5. Update signing team
Select your Apple Developer team in project settings.

### 6. Add capabilities (Signing & Capabilities tab)
- Push Notifications
- Sign in with Apple
- In-App Purchase
- Background Modes (fetch, remote notifications)

### 7. Update Bundle Identifier
Change from `com.yaniksimpson.Upful` to `com.jyanik.app` (or your chosen ID).

### 8. Update Display Name
Change from "Upful" to "Jyanik" in target General settings.

### 9. Add GoogleService-Info.plist
Download from Firebase Console for the new Jyanik project (git-ignored).

---

## Firebase Crashlytics Run Script (Needs Update)

### 10. Update Crashlytics dSYM upload script
In Build Phases -> "Crashlytics Run Script":
- Current: placeholder comment (CocoaPods path removed)
- Replace with SPM path: `${BUILD_DIR%Build/*}SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/run`
- Or follow: https://firebase.google.com/docs/crashlytics/get-deobfuscated-reports?platform=ios

---

## Optional Cleanup

### 11. Install SwiftLint
```bash
brew install swiftlint
```
Config already at `.swiftlint.yml`.

### 12. Delete old Upful/ code
Only after Phase 3+ rewrite is complete and all features migrated to Jyanik/.

---

## Cloudflare Setup (Phase 2)

### 13. Create Cloudflare account
Sign up at https://dash.cloudflare.com and set up Workers paid plan ($5/month).

### 14. Login to Wrangler CLI
```bash
cd backend && npx wrangler login
```

### 15. Create production resources
After running `wrangler deploy` for the first time, create:
- D1 database: `wrangler d1 create jyanik-db`
- KV namespaces: `wrangler kv namespace create CACHE` and `wrangler kv namespace create SESSIONS`
- R2 bucket: `wrangler r2 bucket create jyanik-assets`
- Queue: `wrangler queues create jyanik-tasks`

### 16. Set production secrets
```bash
cd backend
npx wrangler secret put JWT_SECRET
npx wrangler secret put RESEND_API_KEY
npx wrangler secret put TWILIO_ACCOUNT_SID
npx wrangler secret put TWILIO_AUTH_TOKEN
npx wrangler secret put STRIPE_SECRET_KEY
npx wrangler secret put FINNHUB_API_KEY
npx wrangler secret put FMP_API_KEY
npx wrangler secret put ALPHA_VANTAGE_KEY
npx wrangler secret put TWELVE_DATA_KEY
```
