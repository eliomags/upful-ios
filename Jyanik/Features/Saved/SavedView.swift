//
//  SavedView.swift
//  Jyanik
//
//  Saved items view with Watchlist and Screeners tabs
//

import SwiftUI

struct SavedView: View {

    // MARK: - State

    @Environment(AppRouter.self) private var router
    @Environment(AppState.self) private var appState
    @State private var viewModel = SavedViewModel()

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            segmentedPicker

            TabView(selection: $viewModel.selectedTab) {
                watchlistTab
                    .tag(SavedViewModel.Tab.watchlist)

                screenersTab
                    .tag(SavedViewModel.Tab.screeners)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .background(JColor.background)
        .navigationTitle("Saved")
        .task {
            if !appState.isGuest {
                await viewModel.loadWatchlist()
            }
        }
    }

    // MARK: - Segmented Picker

    private var segmentedPicker: some View {
        Picker("Tab", selection: $viewModel.selectedTab) {
            ForEach(SavedViewModel.Tab.allCases) { tab in
                Text(tab.rawValue).tag(tab)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, JSpacing.md)
        .padding(.vertical, JSpacing.sm)
    }

    // MARK: - Watchlist Tab

    private var watchlistTab: some View {
        Group {
            if viewModel.savedStocks.isEmpty {
                JEmptyState(
                    icon: "star",
                    title: "No Saved Stocks",
                    description: "Add stocks to your watchlist to track them here.",
                    actionTitle: "Browse Markets"
                ) {
                    router.navigate(to: .watchlist, in: .market)
                }
            } else {
                watchlistList
            }
        }
    }

    private var watchlistList: some View {
        List {
            ForEach(viewModel.savedStocks, id: \.id) { stock in
                NavigationLink(value: Route.stockDetail(ticker: stock.ticker)) {
                    watchlistRow(stock)
                }
                .buttonStyle(.plain)
                .listRowBackground(JColor.surface)
            }
            .onDelete { offsets in
                viewModel.removeStock(at: offsets)
            }
            .onMove { source, destination in
                viewModel.reorderStocks(from: source, to: destination)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .environment(\.editMode, .constant(.active))
    }

    private func watchlistRow(_ stock: SavedStock) -> some View {
        HStack(spacing: JSpacing.sm) {
            VStack(alignment: .leading, spacing: JSpacing.xxxs) {
                Text(stock.ticker)
                    .font(JFont.headline)
                    .foregroundStyle(JColor.textPrimary)

                if let name = stock.companyName {
                    Text(name)
                        .font(JFont.caption)
                        .foregroundStyle(JColor.textSecondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(JColor.textTertiary)
        }
        .padding(.vertical, JSpacing.xxs)
        .contentShape(Rectangle())
    }

    // MARK: - Screeners Tab

    private var screenersTab: some View {
        Group {
            if viewModel.savedScreeners.isEmpty {
                JEmptyState(
                    icon: "slider.horizontal.3",
                    title: "No Saved Screeners",
                    description: "Create and save custom screeners to quickly find stocks matching your criteria."
                )
            } else {
                screenersList
            }
        }
    }

    private var screenersList: some View {
        List {
            ForEach(viewModel.savedScreeners, id: \.id) { screener in
                screenerCard(screener)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(
                        top: JSpacing.xxs,
                        leading: JSpacing.md,
                        bottom: JSpacing.xxs,
                        trailing: JSpacing.md
                    ))
            }
            .onDelete { offsets in
                viewModel.removeScreener(at: offsets)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private func screenerCard(_ screener: SavedScreener) -> some View {
        let filters = viewModel.decodeFilters(from: screener)

        return NavigationLink(value: screenerRoute(for: screener, filters: filters)) {
            JCard {
                VStack(alignment: .leading, spacing: JSpacing.sm) {
                    HStack {
                        Image(systemName: "slider.horizontal.3")
                            .font(.subheadline)
                            .foregroundStyle(JColor.primary)

                        Text(screener.name)
                            .font(JFont.headline)
                            .foregroundStyle(JColor.textPrimary)

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(JColor.textTertiary)
                    }

                    Text(viewModel.filterSummary(for: screener))
                        .font(JFont.subheadline)
                        .foregroundStyle(JColor.textSecondary)
                        .lineLimit(1)

                    Text(formattedDate(screener.updatedAt))
                        .font(JFont.caption)
                        .foregroundStyle(JColor.textTertiary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Helpers

    private func screenerRoute(for screener: SavedScreener, filters: ScreenerFilters?) -> Route {
        .screenerDetail(id: screener.id)
    }

    private func formattedDate(_ dateString: String) -> String {
        guard let date = Self.isoFormatter.date(from: dateString) else {
            return dateString
        }
        return "Updated \(Self.mediumDateFormatter.string(from: date))"
    }

    private static let isoFormatter = ISO8601DateFormatter()

    private static let mediumDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

// MARK: - Previews

#Preview("Saved - Watchlist") {
    NavigationStack {
        SavedView()
            .environment(AppRouter())
    }
}

#Preview("Saved - Empty") {
    NavigationStack {
        SavedView()
            .environment(AppRouter())
    }
}
