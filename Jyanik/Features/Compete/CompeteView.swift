//
//  CompeteView.swift
//  Jyanik
//
//  Leaderboard-first Compete tab matching Figma design.
//  Shows a flat ranked list with Free/Subscribed tabs, 5 period types,
//  and a My History tab for past competition results.
//

import SwiftUI

struct CompeteView: View {

    // MARK: - Dependencies

    @State private var viewModel: CompeteViewModel
    @Environment(AppRouter.self) private var router
    @Environment(AppState.self) private var appState

    // MARK: - Init

    init(competitionService: CompetitionService = CompetitionService()) {
        _viewModel = State(wrappedValue: CompeteViewModel(competitionService: competitionService))
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            JColor.background.ignoresSafeArea()

            Group {
                switch viewModel.selectedTab {
                case .leaderboard:
                    leaderboardTab
                case .myHistory:
                    historyTab
                }
            }
        }
        .task {
            if viewModel.loadState == .idle {
                if appState.isGuest {
                    viewModel.loadGuestData()
                } else {
                    await viewModel.load()
                }
            }
        }
    }
}

// MARK: - User Helpers

private extension CompeteView {

    var currentDisplayName: String {
        if let name = appState.currentUser?.displayName, !name.isEmpty {
            return name
        }
        if let username = appState.currentUser?.username, !username.isEmpty {
            return username
        }
        // Fallback for session-restored users where currentUser is nil
        return "You"
    }

    var currentUserInitials: String {
        let name = appState.currentUser?.displayName
            ?? appState.currentUser?.username ?? ""
        let parts = name.split(separator: " ")
        if parts.count >= 2 {
            return "\(parts[0].prefix(1))\(parts[1].prefix(1))"
        }
        return String(name.prefix(2))
    }
}

// MARK: - Leaderboard Tab

private extension CompeteView {

    @ViewBuilder
    var leaderboardTab: some View {
        switch viewModel.loadState {
        case .idle, .loading where !viewModel.hasEntries:
            VStack(spacing: 0) {
                viewSwitcher
                    .padding(.horizontal, JSpacing.md)
                    .padding(.top, JSpacing.sm)
                Spacer()
                JLoadingView("Loading leaderboard...")
                Spacer()
            }

        case .error(let msg) where !viewModel.hasEntries:
            VStack(spacing: 0) {
                viewSwitcher
                    .padding(.horizontal, JSpacing.md)
                    .padding(.top, JSpacing.sm)
                Spacer()
                JErrorView(msg) {
                    Task { await viewModel.refresh() }
                }
                Spacer()
            }

        default:
            leaderboardScrollView
        }
    }

    var leaderboardScrollView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                // View Switcher (Leaderboard / My History)
                viewSwitcher
                    .padding(.horizontal, JSpacing.md)
                    .padding(.bottom, JSpacing.sm)

                // Tier Picker (Free / Subscribed)
                tierPicker
                    .padding(.horizontal, JSpacing.md)
                    .padding(.bottom, JSpacing.sm)

                // Period Picker (Day, Week, Month, 3 months, 6 months)
                periodPicker
                    .padding(.horizontal, JSpacing.md)
                    .padding(.bottom, JSpacing.sm)

                // Your Position Card (Figma: avatar + name + $change + equity + position + growth%)
                if viewModel.myRanking != nil {
                    yourPositionCard
                        .padding(.horizontal, JSpacing.md)
                        .padding(.bottom, JSpacing.sm)
                }

                // Chevron divider
                if viewModel.myRanking != nil && viewModel.hasEntries {
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundStyle(JColor.textTertiary)
                        .padding(.bottom, JSpacing.xs)
                }

                // Flat ranked list (matching Figma)
                ForEach(viewModel.entries, id: \.stableID) { entry in
                    VStack(spacing: 0) {
                        leaderboardRow(entry)

                        if entry.stableID != viewModel.entries.last?.stableID {
                            Divider()
                                .foregroundStyle(JColor.divider)
                                .padding(.leading, 60)
                        }
                    }
                }

                // Empty state when filters yield no results
                if viewModel.entries.isEmpty && viewModel.loadState == .loaded {
                    JEmptyState(
                        icon: "trophy",
                        title: "No Rankings Yet",
                        description: "There are no rankings available for this period and category."
                    )
                    .padding(.top, JSpacing.xl)
                }
            }
            .padding(.top, JSpacing.sm)
            .padding(.bottom, JSpacing.xxl)
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
}

// MARK: - Your Position Card (Figma: avatar + name + stats + position + growth)

private extension CompeteView {

    var yourPositionCard: some View {
        JCard {
            HStack(alignment: .top, spacing: JSpacing.sm) {
                // User avatar (large, squircle per Figma)
                JAvatar(
                    urlString: appState.currentUser?.avatarUrl,
                    initials: currentUserInitials,
                    size: .large,
                    shape: .squircle
                )

                // Name + dollar change + equity + position
                VStack(alignment: .leading, spacing: 4) {
                    // Display name
                    Text(currentDisplayName)
                        .font(JFont.subheadlineMedium)
                        .foregroundStyle(JColor.textPrimary)
                        .lineLimit(1)

                    // +2,980   $20,635
                    HStack(spacing: JSpacing.xs) {
                        Text(rawDollarChange(viewModel.myRanking?.totalEquity ?? 25_000))
                            .font(JFont.caption)
                            .foregroundStyle(
                                (viewModel.myRanking?.totalEquity ?? 25_000) >= 25_000
                                    ? JColor.success : JColor.error
                            )

                        Text(formattedEquity(viewModel.myRanking?.totalEquity ?? 25_000))
                            .font(JFont.caption)
                            .foregroundStyle(JColor.textSecondary)
                    }

                    // Your Position:  26  🏆$X  🔄
                    HStack(spacing: 4) {
                        Text("Your Position:")
                            .font(JFont.footnote)
                            .foregroundStyle(JColor.textSecondary)

                        Text(viewModel.formattedRank)
                            .font(JFont.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(JColor.textPrimary)

                        // Prize amount from backend
                        if let prize = viewModel.myRanking?.prizeAmount, prize > 0 {
                            HStack(spacing: 2) {
                                Image(systemName: "trophy.fill")
                                    .font(.system(size: 10))
                                    .foregroundStyle(JColor.warning)
                                Text(formattedPrize(prize))
                                    .font(JFont.caption)
                                    .foregroundStyle(JColor.warning)
                            }
                        }

                        Image(systemName: "arrow.clockwise")
                            .font(.caption2)
                            .foregroundStyle(JColor.accent)
                    }
                }

                Spacer()

                // Growth % as colored text (Figma: "+09%" at top-right, not filled capsule)
                Text(growthText(viewModel.formattedGrowth))
                    .font(JFont.calloutMedium)
                    .foregroundStyle(
                        viewModel.formattedGrowth > 0 ? JColor.success
                            : viewModel.formattedGrowth < 0 ? JColor.error
                            : JColor.textSecondary
                    )
            }
        }
    }
}

// MARK: - Leaderboard Row (Figma: rank → avatar → name + "+$change |+%growth 🏆$prize" → $equity)

private extension CompeteView {

    func leaderboardRow(_ entry: LeaderboardEntryDTO) -> some View {
        Button {
            if let userId = entry.userId {
                router.navigate(to: .userProfile(id: userId))
            }
        } label: {
            HStack(spacing: JSpacing.sm) {
                // Rank number in colored circle
                rankBadge(entry.rank)

                // Avatar (medium, squircle per Figma)
                JAvatar(
                    urlString: entry.avatarUrl,
                    initials: initials(for: entry),
                    size: .medium,
                    shape: .squircle
                )

                // Name + "+$change |+%growth  🏆$prize"
                VStack(alignment: .leading, spacing: JSpacing.xxxs) {
                    Text(entry.displayName ?? entry.username)
                        .font(JFont.subheadlineMedium)
                        .foregroundStyle(JColor.textPrimary)
                        .lineLimit(1)

                    HStack(spacing: 4) {
                        // Dollar change (Figma: "+2,980")
                        Text(rawDollarChange(entry.totalEquity))
                            .font(JFont.caption)
                            .foregroundStyle(
                                entry.totalEquity >= 25_000 ? JColor.success : JColor.error
                            )

                        Text("|")
                            .font(JFont.caption)
                            .foregroundStyle(JColor.textTertiary)

                        // Growth %
                        Text(growthText(entry.growthPct))
                            .font(JFont.caption)
                            .foregroundStyle(
                                entry.growthPct >= 0 ? JColor.success : JColor.error
                            )

                        // Prize amount (🏆 $XX) from backend
                        if let prize = entry.prizeAmount, prize > 0 {
                            HStack(spacing: 2) {
                                Image(systemName: "trophy.fill")
                                    .font(.system(size: 9))
                                    .foregroundStyle(JColor.warning)

                                Text(formattedPrize(prize))
                                    .font(JFont.caption)
                                    .foregroundStyle(JColor.warning)
                            }
                        }
                    }
                }

                Spacer()

                // Portfolio value (large, right-aligned)
                Text(formattedEquity(entry.totalEquity))
                    .font(JFont.calloutMedium)
                    .fontWeight(.semibold)
                    .foregroundStyle(JColor.textPrimary)
            }
            .padding(.vertical, JSpacing.xs)
            .padding(.horizontal, JSpacing.md)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    func rankBadge(_ rank: Int) -> some View {
        ZStack {
            Circle()
                .fill(rankColor(rank).opacity(rank <= 3 ? 0.2 : 0.1))
                .frame(width: 36, height: 36)

            Text("\(rank)")
                .font(JFont.calloutMedium)
                .fontWeight(rank <= 3 ? .bold : .medium)
                .foregroundStyle(rankColor(rank))
        }
        .frame(width: 36, height: 36)
    }

    func rankColor(_ rank: Int) -> Color {
        switch rank {
        case 1: return .yellow.opacity(0.9)
        case 2: return .gray
        case 3: return .orange
        default: return JColor.textSecondary
        }
    }

    /// Format prize amount from backend (e.g. 5 → "$5", 2000 → "$2,000")
    func formattedPrize(_ amount: Double) -> String {
        let intVal = Int(amount)
        if intVal >= 1_000 {
            return "$\(Self.numberFormatter.string(from: NSNumber(value: intVal)) ?? "\(intVal)")"
        }
        return "$\(intVal)"
    }

    /// Dollar change without $ sign (Figma: "+2,980")
    func rawDollarChange(_ totalEquity: Double) -> String {
        let change = totalEquity - 25_000
        let prefix = change >= 0 ? "+" : "-"
        let formatted = Self.numberFormatter.string(from: NSNumber(value: abs(change)))
            ?? "\(Int(abs(change)))"
        return "\(prefix)\(formatted)"
    }

    private static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    func growthText(_ pct: Double) -> String {
        let prefix = pct >= 0 ? "+" : ""
        return "\(prefix)\(String(format: "%.0f", pct))%"
    }

    func formattedEquity(_ value: Double) -> String {
        Self.equityFormatter.string(from: NSNumber(value: value))
            ?? "$\(Int(value))"
    }

    func initials(for entry: LeaderboardEntryDTO) -> String {
        if let displayName = entry.displayName, !displayName.isEmpty {
            let parts = displayName.split(separator: " ")
            if parts.count >= 2 {
                return "\(parts[0].prefix(1))\(parts[1].prefix(1))"
            }
            return String(displayName.prefix(2))
        }
        return String(entry.username.prefix(2))
    }

    private static let equityFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter
    }()
}

// MARK: - Pickers & Controls

private extension CompeteView {

    // View Switcher (Leaderboard / My History)
    var viewSwitcher: some View {
        HStack(spacing: 0) {
            ForEach(CompeteTab.allCases, id: \.self) { tab in
                Button {
                    Task { await viewModel.switchTab(tab) }
                } label: {
                    Text(tab.displayName)
                        .font(viewModel.selectedTab == tab ? JFont.calloutMedium : JFont.callout)
                        .foregroundStyle(viewModel.selectedTab == tab ? JColor.textPrimary : JColor.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, JSpacing.sm)
                        .background(
                            viewModel.selectedTab == tab ? JColor.surface : Color.clear,
                            in: RoundedRectangle(cornerRadius: JRadius.medium)
                        )
                        .shadow(color: viewModel.selectedTab == tab ? .black.opacity(0.06) : .clear, radius: 2, y: 1)
                }
                .buttonStyle(.plain)
            }
        }
        .background(JColor.surfaceSecondary, in: RoundedRectangle(cornerRadius: JRadius.medium))
    }

    // Tier Picker (Free / Subscribed)
    var tierPicker: some View {
        HStack(spacing: 0) {
            tierTab(.free)
            tierTab(.premium)
        }
        .background(JColor.surfaceSecondary, in: RoundedRectangle(cornerRadius: JRadius.medium))
    }

    func tierTab(_ tier: LeaderboardTier) -> some View {
        let isSelected = viewModel.selectedTier == tier

        return Button {
            Task { await viewModel.changeTier(tier) }
        } label: {
            HStack(spacing: JSpacing.xxs) {
                Image(systemName: tier == .premium ? "star.fill" : "gift.fill")
                    .font(.caption2)
                    .foregroundStyle(isSelected
                        ? (tier == .premium ? JColor.warning : JColor.success)
                        : JColor.textTertiary
                    )

                Text(tier.displayName)
                    .font(isSelected ? JFont.calloutMedium : JFont.callout)
                    .foregroundStyle(isSelected ? JColor.textPrimary : JColor.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, JSpacing.sm)
            .background(
                isSelected ? JColor.surface : Color.clear,
                in: RoundedRectangle(cornerRadius: JRadius.medium)
            )
            .shadow(color: isSelected ? .black.opacity(0.06) : .clear, radius: 2, y: 1)
        }
        .buttonStyle(.plain)
    }

    // Period Picker (scrollable capsule pills)
    var periodPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: JSpacing.xs) {
                ForEach(LeaderboardPeriod.allCases, id: \.self) { period in
                    periodButton(period)
                }
            }
        }
    }

    func periodButton(_ period: LeaderboardPeriod) -> some View {
        let isSelected = viewModel.selectedPeriod == period

        return Button {
            Task { await viewModel.changePeriod(period) }
        } label: {
            Text(period.displayName)
                .font(isSelected ? JFont.subheadlineMedium : JFont.subheadline)
                .foregroundStyle(isSelected ? .white : JColor.textSecondary)
                .padding(.horizontal, JSpacing.md)
                .padding(.vertical, JSpacing.xs)
                .background(
                    isSelected ? JColor.primary : JColor.surfaceSecondary,
                    in: Capsule()
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - My History Tab

private extension CompeteView {

    @ViewBuilder
    var historyTab: some View {
        switch viewModel.historyLoadState {
        case .idle, .loading:
            VStack(spacing: 0) {
                viewSwitcher
                    .padding(.horizontal, JSpacing.md)
                    .padding(.top, JSpacing.sm)

                tierPicker
                    .padding(.horizontal, JSpacing.md)
                    .padding(.top, JSpacing.sm)

                Spacer()
                JLoadingView("Loading history...")
                Spacer()
            }

        case .error(let msg):
            VStack(spacing: 0) {
                viewSwitcher
                    .padding(.horizontal, JSpacing.md)
                    .padding(.top, JSpacing.sm)
                Spacer()
                JErrorView(msg) {
                    Task { await viewModel.loadHistory() }
                }
                Spacer()
            }

        case .loaded:
            historyScrollView
        }
    }

    var historyScrollView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                // View Switcher
                viewSwitcher
                    .padding(.horizontal, JSpacing.md)
                    .padding(.bottom, JSpacing.sm)

                // Tier Picker
                tierPicker
                    .padding(.horizontal, JSpacing.md)
                    .padding(.bottom, JSpacing.sm)

                // Period type filter (All / Day / Week / ...)
                historyPeriodFilter
                    .padding(.horizontal, JSpacing.md)
                    .padding(.bottom, JSpacing.sm)

                // Your Position summary (same card as leaderboard)
                if viewModel.myRanking != nil {
                    yourPositionCard
                        .padding(.horizontal, JSpacing.md)
                        .padding(.bottom, JSpacing.sm)
                }

                // History entries
                if viewModel.hasHistory {
                    ForEach(viewModel.filteredHistory) { entry in
                        historyRow(entry)
                    }
                } else if viewModel.historyEntries.isEmpty {
                    JEmptyState(
                        icon: "clock",
                        title: "No History Yet",
                        description: "Your past competition results will appear here once you complete a competition."
                    )
                    .padding(.top, JSpacing.xl)
                } else {
                    // Has entries but filter excludes all
                    JEmptyState(
                        icon: "line.3.horizontal.decrease.circle",
                        title: "No Results",
                        description: "No history for this period type. Try a different filter."
                    )
                    .padding(.top, JSpacing.xl)
                }
            }
            .padding(.top, JSpacing.sm)
            .padding(.bottom, JSpacing.xxl)
        }
        .refreshable {
            await viewModel.loadHistory()
        }
    }

    // History Period Filter (capsule pills: All, Day, Week, ...)
    var historyPeriodFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: JSpacing.xs) {
                historyFilterButton(nil, label: "All")
                ForEach(LeaderboardPeriod.allCases, id: \.self) { period in
                    historyFilterButton(period, label: period.displayName)
                }
            }
        }
    }

    func historyFilterButton(_ period: LeaderboardPeriod?, label: String) -> some View {
        let isSelected = viewModel.historyPeriodFilter == period

        return Button {
            viewModel.historyPeriodFilter = period
        } label: {
            Text(label)
                .font(isSelected ? JFont.subheadlineMedium : JFont.subheadline)
                .foregroundStyle(isSelected ? .white : JColor.textSecondary)
                .padding(.horizontal, JSpacing.md)
                .padding(.vertical, JSpacing.xs)
                .background(
                    isSelected ? JColor.primary : JColor.surfaceSecondary,
                    in: Capsule()
                )
        }
        .buttonStyle(.plain)
    }

    // History Row (Figma: ↑/↓ arrow → period + "Your Position: XX" → growth% + $amount)
    func historyRow(_ entry: CompetitionHistoryEntryDTO) -> some View {
        let growth = entry.growthPct ?? 0
        let isPositive = growth >= 0
        let equity = entry.endingEquity ?? entry.startingEquity
        let dollarChange = equity - entry.startingEquity

        return HStack(spacing: JSpacing.sm) {
            // Up/Down arrow icon (squircle background)
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(isPositive ? JColor.success.opacity(0.12) : JColor.error.opacity(0.12))
                    .frame(width: 36, height: 36)

                Image(systemName: isPositive ? "arrow.up" : "arrow.down")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(isPositive ? JColor.success : JColor.error)
            }

            // Period label + "Your Position: XX"
            VStack(alignment: .leading, spacing: JSpacing.xxxs) {
                Text(historyPeriodLabel(entry))
                    .font(JFont.subheadlineMedium)
                    .foregroundStyle(JColor.textPrimary)

                if let rank = entry.rank {
                    HStack(spacing: JSpacing.xxxs) {
                        Text("Your Position:")
                            .font(JFont.caption)
                            .foregroundStyle(JColor.textSecondary)

                        Text("\(rank)")
                            .font(JFont.captionMedium)
                            .fontWeight(.bold)
                            .foregroundStyle(JColor.textPrimary)
                    }
                }
            }

            Spacer()

            // Growth % + prize/dollar amount (right side)
            VStack(alignment: .trailing, spacing: JSpacing.xxxs) {
                // Growth %
                Text(growthText(growth))
                    .font(JFont.calloutMedium)
                    .foregroundStyle(isPositive ? JColor.success : JColor.error)

                // Prize amount from DB (if available)
                if let prize = entry.prizeAmount, prize > 0 {
                    HStack(spacing: 2) {
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 9))
                            .foregroundStyle(JColor.warning)
                        Text(formattedPrize(prize))
                            .font(JFont.caption)
                            .foregroundStyle(JColor.warning)
                    }
                } else {
                    // Dollar change
                    Text(rawDollarChange(equity))
                        .font(JFont.caption)
                        .foregroundStyle(JColor.textSecondary)
                }
            }
        }
        .padding(.vertical, JSpacing.sm)
        .padding(.horizontal, JSpacing.md)
    }

    /// Period label matching Figma (e.g. "Monthly", "Tuesday", "Weekly Jan 20–26")
    func historyPeriodLabel(_ entry: CompetitionHistoryEntryDTO) -> String {
        let type = (entry.type ?? "").lowercased()

        switch type {
        case "daily":
            // Show day name (e.g. "Tuesday") if available
            if let startDate = entry.startDate {
                return dayName(from: startDate)
            }
            return "Daily"
        case "weekly":
            if let start = entry.startDate, let end = entry.endDate {
                return "Weekly \(shortDate(start)) – \(shortDate(end))"
            }
            return "Weekly"
        case "monthly":
            return "Monthly"
        case "quarterly":
            return "Quarterly"
        case "semiannual":
            return "6-Month"
        default:
            if let start = entry.startDate, let end = entry.endDate {
                return "\(JFormatters.mediumDateString(from: start)) – \(JFormatters.mediumDateString(from: end))"
            }
            return type.capitalized
        }
    }

    /// Extract day-of-week name from date string (e.g. "2026-01-15" → "Wednesday")
    private func dayName(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return "Daily" }
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }

    /// Short date format (e.g. "Jan 20")
    private func shortDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return dateString }
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        CompeteView(competitionService: CompetitionService())
    }
    .environment(AppRouter())
    .environment(AppState(keychainService: KeychainService(serviceName: "preview")))
}
