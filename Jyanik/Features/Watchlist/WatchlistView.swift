//
//  WatchlistView.swift
//  Jyanik
//
//  Full watchlist management screen with add, remove, reorder, and search
//

import SwiftUI

struct WatchlistView: View {

    // MARK: - State

    @State private var viewModel = WatchlistViewModel()
    @Environment(AppRouter.self) private var router

    // MARK: - Body

    var body: some View {
        Group {
            switch viewModel.loadState {
            case .idle, .loading:
                JLoadingView("Loading watchlist...")

            case .loaded:
                if viewModel.watchlistItems.isEmpty {
                    emptyState
                } else {
                    watchlistContent
                }

            case .error(let message):
                JErrorView(message) {
                    Task { await viewModel.loadWatchlist() }
                }
            }
        }
        .background(JColor.background)
        .navigationTitle("Watchlist")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                toolbarButtons
            }
        }
        .sheet(isPresented: $viewModel.isShowingAddSheet) {
            addStockSheet
        }
        .task {
            if case .idle = viewModel.loadState {
                await viewModel.loadWatchlist()
            }
        }
    }

    // MARK: - Toolbar

    private var toolbarButtons: some View {
        HStack(spacing: JSpacing.md) {
            if !viewModel.watchlistItems.isEmpty {
                Button {
                    withAnimation {
                        viewModel.isEditing.toggle()
                    }
                } label: {
                    Text(viewModel.isEditing ? "Done" : "Edit")
                        .font(JFont.subheadlineMedium)
                        .foregroundStyle(JColor.primary)
                }
            }

            Button {
                viewModel.isShowingAddSheet = true
            } label: {
                Image(systemName: "plus")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(JColor.primary)
            }
        }
    }

    // MARK: - Watchlist Content

    private var watchlistContent: some View {
        List {
            ForEach(viewModel.watchlistItems) { item in
                Button {
                    router.navigate(to: .stockDetail(ticker: item.ticker))
                } label: {
                    JStockRow(
                        ticker: item.ticker,
                        companyName: item.companyName,
                        price: item.currentPrice,
                        changePercent: item.changePercent
                    )
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        withAnimation {
                            viewModel.removeStock(ticker: item.ticker)
                        }
                    } label: {
                        Label("Remove", systemImage: "trash")
                    }
                }
            }
            .onMove { source, destination in
                viewModel.moveStock(from: source, to: destination)
            }
            .listRowBackground(JColor.surface)
            .listRowSeparatorTint(JColor.divider)
        }
        .listStyle(.plain)
        .environment(\.editMode, .constant(viewModel.isEditing ? .active : .inactive))
        .refreshable {
            await viewModel.refresh()
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        JEmptyState(
            icon: "star",
            title: "Start Watching Stocks",
            description: "Add stocks to your watchlist to track their prices and performance.",
            actionTitle: "Add Stock"
        ) {
            viewModel.isShowingAddSheet = true
        }
    }

    // MARK: - Add Stock Sheet

    private var addStockSheet: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchBar
                    .padding(.horizontal, JSpacing.md)
                    .padding(.top, JSpacing.sm)

                if viewModel.isSearching {
                    JLoadingView("Searching...")
                } else if viewModel.searchResults.isEmpty && viewModel.searchText.isEmpty {
                    searchPlaceholder
                } else if viewModel.searchResults.isEmpty {
                    JEmptyState(
                        icon: "magnifyingglass",
                        title: "No Results",
                        description: "Try a different search term."
                    )
                } else {
                    searchResultsList
                }
            }
            .background(JColor.background)
            .navigationTitle("Add Stock")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        viewModel.clearSearch()
                        viewModel.isShowingAddSheet = false
                    }
                    .font(JFont.subheadlineMedium)
                    .foregroundStyle(JColor.primary)
                }
            }
        }
    }

    private var searchBar: some View {
        HStack(spacing: JSpacing.xs) {
            Image(systemName: "magnifyingglass")
                .font(.subheadline)
                .foregroundStyle(JColor.textTertiary)

            TextField("Search by ticker or name...", text: $viewModel.searchText)
                .font(JFont.body)
                .foregroundStyle(JColor.textPrimary)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)

            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.clearSearch()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.subheadline)
                        .foregroundStyle(JColor.textTertiary)
                }
            }
        }
        .padding(.horizontal, JSpacing.sm)
        .padding(.vertical, JSpacing.sm)
        .background(JColor.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: JRadius.medium))
    }

    private var searchPlaceholder: some View {
        VStack(spacing: JSpacing.md) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40, weight: .light))
                .foregroundStyle(JColor.textTertiary)

            Text("Search for stocks to add")
                .font(JFont.subheadline)
                .foregroundStyle(JColor.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var searchResultsList: some View {
        List {
            ForEach(viewModel.searchResults) { result in
                HStack {
                    VStack(alignment: .leading, spacing: JSpacing.xxxs) {
                        Text(result.symbol)
                            .font(JFont.headline)
                            .foregroundStyle(JColor.textPrimary)

                        Text(result.name)
                            .font(JFont.caption)
                            .foregroundStyle(JColor.textSecondary)
                            .lineLimit(1)
                    }

                    Spacer()

                    if viewModel.isInWatchlist(result.symbol) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(JColor.success)
                    } else {
                        Button {
                            viewModel.addStock(
                                ticker: result.symbol,
                                companyName: result.name
                            )
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                                .foregroundStyle(JColor.primary)
                        }
                    }
                }
                .padding(.vertical, JSpacing.xs)
                .contentShape(Rectangle())
            }
            .listRowBackground(JColor.surface)
            .listRowSeparatorTint(JColor.divider)
        }
        .listStyle(.plain)
    }
}

// MARK: - Previews

#Preview("Watchlist") {
    NavigationStack {
        WatchlistView()
    }
    .environment(AppRouter())
}

#Preview("Watchlist - Empty") {
    NavigationStack {
        WatchlistView()
    }
    .environment(AppRouter())
}
