# Agent 11: FK ID Length Mismatch Fixes

## Summary

Fixed all foreign key ID length mismatches in `backend/src/migrations/0007_seed_data.sql` across 4 categories.

## Canonical ID Formats (from source-of-truth tables)

| Entity | Length | Prefix | Example |
|--------|--------|--------|---------|
| User ID | 32 chars | `a` | `a0000000000000000000000000000001` |
| Portfolio ID | 33 chars | `b` | `b00000000000000000000000000000101` |
| Competition ID | 28 chars | `f1` | `f100000000000000000000202602` |

## Fix 1: User IDs (31 -> 32 chars)

**Problem:** Multiple sections used 31-char user IDs (missing one zero).

**Affected sections:** chat_messages, payouts, purchases

**Users fixed (14 total):**
- `a000000000000000000000000000001` -> `a0000000000000000000000000000001` (users 1-9)
- `a00000000000000000000000000000b` -> `a000000000000000000000000000000b` (user 0b - aishap)
- `a00000000000000000000000000000c` -> `a000000000000000000000000000000c` (user 0c - ryankim)
- `a000000000000000000000000000011` -> `a0000000000000000000000000000011` (user 11 - chloed)
- `a000000000000000000000000000016` -> `a0000000000000000000000000000016` (user 16 - masonc)
- `a000000000000000000000000000019` -> `a0000000000000000000000000000019` (user 19 - miat)
- `a00000000000000000000000000001e` -> `a000000000000000000000000000001e` (user 1e - danielk)

## Fix 2: Portfolio IDs in Positions & Trades (32 -> 33 chars)

**Problem:** Portfolio IDs were 32 chars (missing one zero) instead of canonical 33 chars.

**Affected sections:** positions (~30 rows), trades (~30 rows)

**Example fix:**
- `b0000000000000000000000000000101` (32 chars) -> `b00000000000000000000000000000101` (33 chars)

All 30 portfolio references in each section were fixed by adding one zero after the `b` prefix.

## Fix 3: Portfolio IDs in Snapshots (wrong format -> canonical 33 chars)

**Problem:** Portfolio snapshot IDs used entirely wrong encoding patterns (34 chars with `0300`/`0200`/`0100` suffixes).

**Affected section:** portfolio_snapshots (~330 rows)

**Mapping applied:**

| User Group | Wrong ID (34 chars) | Correct ID (33 chars) |
|------------|--------------------|-----------------------|
| Power users 01-05 | `b00000000000000000000000000010300` | `b00000000000000000000000000000101` through `b00000000000000000000000000000501` |
| Active users 06-0c | `b00000000000000000000000000060200` | `b00000000000000000000000000000601` through `b00000000000000000000000000000c01` |
| Casual users 0d-12 | `b000000000000000000000000000d0100` | `b00000000000000000000000000000d01` through `b00000000000000000000000000001201` |
| New users 13-18 | `b000000000000000000000000000130100` | `b00000000000000000000000000001301` through `b00000000000000000000000000001801` |
| Edge users 19-1e | `b000000000000000000000000000190100` | `b00000000000000000000000000001901` through `b00000000000000000000000000001e01` |

## Fix 4: Portfolio IDs in Competition Entries (31 -> 33 chars)

**Problem:** Portfolio IDs were 31 chars (missing two zeros) instead of canonical 33 chars.

**Affected section:** competition_entries (~90 rows)

**Example fix:**
- `b000000000000000000000000000101` (31 chars) -> `b00000000000000000000000000000101` (33 chars)

All portfolio references were fixed by adding two zeros after the `b` prefix.

## Fix 5: Competition IDs in Notification Metadata

**Problem:** Notification metadata JSON contained fake competition IDs in `f0000...` format instead of the real month-based format.

**Affected section:** notifications (prize_won and prize_paid type metadata)

**Mapping applied:**

| Wrong ID (32 chars) | Correct ID (28 chars) | Month |
|---------------------|-----------------------|-------|
| `f0000000000000000000000000000001` | `f100000000000000000000202510` | Oct 2025 |
| `f0000000000000000000000000000002` | `f100000000000000000000202511` | Nov 2025 |
| `f0000000000000000000000000000003` | `f100000000000000000000202512` | Dec 2025 |
| `f0000000000000000000000000000004` | `f100000000000000000000202601` | Jan 2026 |

## Verification Results

Post-fix verification confirmed:
- 0 remaining 31-char user IDs
- 0 remaining 31-char portfolio IDs
- 0 remaining 34-char portfolio IDs
- 0 remaining wrong-format competition IDs
- 1318 correct 32-char user IDs present
- 788 correct 33-char portfolio IDs present
- 85 correct 28-char competition IDs present
