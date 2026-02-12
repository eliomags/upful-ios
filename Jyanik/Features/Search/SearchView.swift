//
//  SearchView.swift
//  Jyanik
//
//  Universal search screen presented as a sheet: search bar, asset type filters,
//  recent searches, and results list with navigation to stock detail.
//

import SwiftUI

struct SearchView: View {

    // MARK: - State

    @State private var viewModel = SearchViewModel()
    @Environment(AppRouter.self) private var router
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isSearchFieldFocused: Bool

    // MARK: - Body

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchBar
                    .padding(.horizontal, JSpacing.md)
                    .padding(.top, JSpacing.xs)

                filterChips
                    .padding(.top, JSpacing.sm)

                Divider()
                    .foregroundStyle(JColor.divider)
                    .padding(.top, JSpacing.sm)

                ScrollView {
                    VStack(spacing: JSpacing.lg) {
                        if viewModel.hasSearchText {
                            searchResultsSection
                        } else {
                            recentSearchesSection
                        }
                    }
                    .padding(.horizontal, JSpacing.md)
                    .padding(.top, JSpacing.md)
                    .padding(.bottom, JSpacing.xl)
                }
            }
            .background(JColor.background)
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundStyle(JColor.primary)
                }
            }
            .onAppear {
                isSearchFieldFocused = true
            }
        }
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: JSpacing.xs) {
            Image(systemName: "magnifyingglass")
                .font(.subheadline)
                .foregroundStyle(JColor.textTertiary)

            TextField("Search stocks, crypto, ETFs...", text: $viewModel.searchText)
                .font(JFont.body)
                .foregroundStyle(JColor.textPrimary)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .focused($isSearchFieldFocused)
                .submitLabel(.search)

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
        .background(JColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: JRadius.medium))
        .overlay {
            RoundedRectangle(cornerRadius: JRadius.medium)
                .strokeBorder(JColor.border, lineWidth: 1)
        }
    }

    // MARK: - Asset Type Filter Chips

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: JSpacing.xs) {
                ForEach(SearchAssetFilter.allCases) { assetType in
                    filterChip(assetType)
                }
            }
            .padding(.horizontal, JSpacing.md)
        }
    }

    private func filterChip(_ assetType: SearchAssetFilter) -> some View {
        let isSelected = viewModel.selectedSearchAssetFilter == assetType

        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                viewModel.selectedSearchAssetFilter = assetType
            }
        } label: {
            Text(assetType.rawValue)
                .font(JFont.captionMedium)
                .foregroundStyle(isSelected ? .white : JColor.textSecondary)
                .padding(.horizontal, JSpacing.sm)
                .padding(.vertical, JSpacing.xs)
                .background(
                    isSelected ? JColor.primary : JColor.surfaceSecondary,
                    in: Capsule()
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Recent Searches

    @ViewBuilder
    private var recentSearchesSection: some View {
        if viewModel.recentSearches.isEmpty {
            JEmptyState(
                icon: "magnifyingglass",
                title: "Search for Assets",
                description: "Find stocks, crypto, ETFs, and more by name or ticker symbol."
            )
            .frame(minHeight: 280)
        } else {
            VStack(alignment: .leading, spacing: JSpacing.sm) {
                HStack {
                    Text("Recent Searches")
                        .font(JFont.headline)
                        .foregroundStyle(JColor.textPrimary)

                    Spacer()

                    Button {
                        withAnimation {
                            viewModel.clearRecent()
                        }
                    } label: {
                        Text("Clear")
                            .font(JFont.subheadlineMedium)
                            .foregroundStyle(JColor.primary)
                    }
                }

                LazyVStack(spacing: 0) {
                    ForEach(viewModel.recentSearches, id: \.self) { symbol in
                        Button {
                            viewModel.addToRecent(symbol: symbol)
                            dismiss()
                            router.navigate(to: .stockDetail(ticker: symbol))
                        } label: {
                            recentSearchRow(symbol)
                        }
                        .buttonStyle(.plain)

                        if symbol != viewModel.recentSearches.last {
                            Divider()
                                .foregroundStyle(JColor.divider)
                        }
                    }
                }
                .padding(.horizontal, JSpacing.md)
                .padding(.vertical, JSpacing.xs)
                .background(JColor.surface)
                .clipShape(RoundedRectangle(cornerRadius: JRadius.medium))
            }
        }
    }

    private func recentSearchRow(_ symbol: String) -> some View {
        HStack(spacing: JSpacing.sm) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.subheadline)
                .foregroundStyle(JColor.textTertiary)

            Text(symbol)
                .font(JFont.body)
                .foregroundStyle(JColor.textPrimary)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(JColor.textTertiary)
        }
        .padding(.vertical, JSpacing.sm)
        .contentShape(Rectangle())
    }

    // MARK: - Search Results

    @ViewBuilder
    private var searchResultsSection: some View {
        if viewModel.isSearching {
            VStack(spacing: JSpacing.md) {
                ForEach(0..<4, id: \.self) { _ in
                    JSkeletonStockRow()
                }
            }
        } else if viewModel.filteredResults.isEmpty {
            JEmptyState(
                icon: "magnifyingglass",
                title: "No Results",
                description: "No assets found for \"\(viewModel.searchText)\". Try a different search term."
            )
            .frame(minHeight: 280)
        } else {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.filteredResults) { result in
                    Button {
                        viewModel.addToRecent(symbol: result.symbol)
                        dismiss()
                        router.navigate(to: .stockDetail(ticker: result.symbol))
                    } label: {
                        searchResultRow(result)
                    }
                    .buttonStyle(.plain)

                    if result.id != viewModel.filteredResults.last?.id {
                        Divider()
                            .foregroundStyle(JColor.divider)
                    }
                }
            }
            .padding(.horizontal, JSpacing.md)
            .padding(.vertical, JSpacing.xs)
            .background(JColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: JRadius.medium))
        }
    }

    private func searchResultRow(_ result: SearchResultDTO) -> some View {
        HStack(spacing: JSpacing.sm) {
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

            if let type = result.type, !type.isEmpty {
                JTextBadge(type.capitalized, color: JColor.secondary)
            }

            if let exchange = result.exchange {
                Text(exchange)
                    .font(JFont.caption)
                    .foregroundStyle(JColor.textTertiary)
            }

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(JColor.textTertiary)
        }
        .padding(.vertical, JSpacing.xs)
        .contentShape(Rectangle())
    }
}

// MARK: - Previews

#Preview("Search - Empty") {
    SearchView()
        .environment(AppRouter())
}

#Preview("Search - With Recent") {
    let view = SearchView()
    UserDefaults.standard.set(["AAPL", "TSLA", "GOOGL", "NVDA"], forKey: "recentSearches")
    return view
        .environment(AppRouter())
}
