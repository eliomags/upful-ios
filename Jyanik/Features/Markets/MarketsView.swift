//
//  MarketsView.swift
//  Jyanik
//
//  Markets tab: search, indices, trending, movers, gainers, losers
//

import SwiftUI

struct MarketsView: View {

    // MARK: - State

    @State private var viewModel = MarketsViewModel()

    // MARK: - Body

    var body: some View {
        ScrollView {
            LazyVStack(spacing: JSpacing.lg) {
                searchBar

                if viewModel.isShowingSearch {
                    searchResultsSection
                } else {
                    marketContent
                }
            }
            .padding(.horizontal, JSpacing.md)
            .padding(.bottom, JSpacing.xl)
        }
        .background(JColor.background)
        .navigationTitle("Markets")
        .refreshable {
            await viewModel.refresh()
        }
        .task {
            if viewModel.trendingStocks.isEmpty {
                await viewModel.loadMarketData()
            }
        }
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: JSpacing.xs) {
            HStack(spacing: JSpacing.xs) {
                Image(systemName: "magnifyingglass")
                    .font(.subheadline)
                    .foregroundStyle(JColor.textTertiary)

                TextField("Search stocks, ETFs, crypto...", text: $viewModel.searchText)
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
            .background(JColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: JRadius.medium))
            .overlay {
                RoundedRectangle(cornerRadius: JRadius.medium)
                    .strokeBorder(JColor.border, lineWidth: 1)
            }
        }
        .padding(.top, JSpacing.xs)
    }

    // MARK: - Main Market Content

    @ViewBuilder
    private var marketContent: some View {
        if viewModel.isLoading {
            loadingContent
        } else if let error = viewModel.errorMessage {
            JErrorView(error) {
                Task { await viewModel.loadMarketData() }
            }
        } else {
            LazyVStack(spacing: JSpacing.lg) {
                indicesRow
                stockSection(.trending)
                stockSection(.mostActive)
                stockSection(.topGainers)
                stockSection(.topLosers)
            }
        }
    }

    // MARK: - Loading Content

    private var loadingContent: some View {
        VStack(spacing: JSpacing.md) {
            // Skeleton indices
            HStack(spacing: JSpacing.sm) {
                ForEach(0..<3, id: \.self) { _ in
                    JShimmer(height: 72)
                }
            }

            // Skeleton stock rows
            ForEach(0..<6, id: \.self) { _ in
                JSkeletonStockRow()
            }
        }
    }

    // MARK: - Market Indices

    private var indicesRow: some View {
        VStack(alignment: .leading, spacing: JSpacing.sm) {
            Text("Indices")
                .font(JFont.headline)
                .foregroundStyle(JColor.textPrimary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: JSpacing.sm) {
                    ForEach(viewModel.indices) { index in
                        indexCard(index)
                    }
                }
            }
        }
    }

    private func indexCard(_ index: MarketIndex) -> some View {
        JCard(padding: JSpacing.sm) {
            VStack(alignment: .leading, spacing: JSpacing.xxs) {
                Text(index.shortName)
                    .font(JFont.captionMedium)
                    .foregroundStyle(JColor.textSecondary)

                Text(index.formattedValue)
                    .font(JFont.price)
                    .foregroundStyle(JColor.textPrimary)
                    .lineLimit(1)

                JPriceChangeView(index.changePercent, style: .percent)
            }
            .frame(width: 100, alignment: .leading)
        }
    }

    // MARK: - Stock Section

    private func stockSection(_ section: MarketSection) -> some View {
        VStack(alignment: .leading, spacing: JSpacing.sm) {
            sectionHeader(section)

            let items = viewModel.stocks(for: section)

            if items.isEmpty {
                emptySection
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(items) { stock in
                        NavigationLink(value: Route.stockDetail(ticker: stock.ticker)) {
                            JStockRow(
                                ticker: stock.ticker,
                                companyName: stock.companyName,
                                price: stock.price,
                                changePercent: stock.changePercent,
                                sparklineData: stock.sparkline
                            )
                        }
                        .buttonStyle(.plain)

                        if stock.id != items.last?.id {
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

    private func sectionHeader(_ section: MarketSection) -> some View {
        HStack(spacing: JSpacing.xs) {
            Image(systemName: section.icon)
                .font(.subheadline)
                .foregroundStyle(sectionColor(section.iconColor))

            Text(section.rawValue)
                .font(JFont.headline)
                .foregroundStyle(JColor.textPrimary)

            Spacer()
        }
    }

    private func sectionColor(_ color: MarketSectionColor) -> Color {
        switch color {
        case .orange: return JColor.accent
        case .blue: return JColor.info
        case .green: return JColor.gainPositive
        case .red: return JColor.gainNegative
        }
    }

    private var emptySection: some View {
        HStack {
            Spacer()
            Text("No data available")
                .font(JFont.subheadline)
                .foregroundStyle(JColor.textTertiary)
            Spacer()
        }
        .padding(.vertical, JSpacing.lg)
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
        } else if viewModel.searchResults.isEmpty {
            JEmptyState(
                icon: "magnifyingglass",
                title: "No Results",
                description: "No stocks found for \"\(viewModel.searchText)\". Try a different search."
            )
            .frame(minHeight: 300)
        } else {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.searchResults) { result in
                    NavigationLink(value: Route.stockDetail(ticker: result.symbol)) {
                        searchResultRow(result)
                    }
                    .buttonStyle(.plain)

                    if result.id != viewModel.searchResults.last?.id {
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

            if let exchange = result.exchange {
                JTextBadge(exchange, color: JColor.secondary)
            }

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(JColor.textTertiary)
        }
        .padding(.vertical, JSpacing.xs)
        .contentShape(Rectangle())
    }
}

// MARK: - Preview

#Preview("Markets") {
    NavigationStack {
        MarketsView()
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .stockDetail(let ticker):
                    StockDetailView(ticker: ticker)
                default:
                    EmptyView()
                }
            }
    }
}
