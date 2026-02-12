//
//  ScreenerView.swift
//  Jyanik
//
//  Stock screener with prebuilt and custom screener options
//

import SwiftUI

// MARK: - Screener Preset

struct ScreenerPreset: Identifiable {
    let id = UUID().uuidString
    let name: String
    let icon: String
    let description: String
    let filters: ScreenerFilters

    static let presets: [ScreenerPreset] = [
        ScreenerPreset(
            name: "Top Gainers",
            icon: "arrow.up.right.circle.fill",
            description: "Stocks with the highest daily gains",
            filters: ScreenerFilters(sortBy: "change_percent", sortOrder: "desc", limit: 25)
        ),
        ScreenerPreset(
            name: "Most Active",
            icon: "chart.bar.fill",
            description: "Highest trading volume today",
            filters: ScreenerFilters(sortBy: "volume", sortOrder: "desc", limit: 25)
        ),
        ScreenerPreset(
            name: "Undervalued",
            icon: "tag.fill",
            description: "Low P/E ratio stocks under $50",
            filters: ScreenerFilters(priceMax: 50, sortBy: "price", sortOrder: "asc", limit: 25)
        ),
        ScreenerPreset(
            name: "Large Cap",
            icon: "building.2.fill",
            description: "Market cap over $100B",
            filters: ScreenerFilters(marketCapMin: 100_000_000_000, sortBy: "market_cap", sortOrder: "desc", limit: 25)
        ),
        ScreenerPreset(
            name: "Penny Stocks",
            icon: "dollarsign.circle.fill",
            description: "Stocks priced under $5",
            filters: ScreenerFilters(priceMax: 5, sortBy: "volume", sortOrder: "desc", limit: 25)
        ),
        ScreenerPreset(
            name: "Tech Sector",
            icon: "laptopcomputer",
            description: "Technology sector stocks",
            filters: ScreenerFilters(sector: "Technology", sortBy: "market_cap", sortOrder: "desc", limit: 25)
        ),
        ScreenerPreset(
            name: "Healthcare",
            icon: "heart.fill",
            description: "Healthcare and biotech stocks",
            filters: ScreenerFilters(sector: "Healthcare", sortBy: "market_cap", sortOrder: "desc", limit: 25)
        ),
        ScreenerPreset(
            name: "Energy",
            icon: "bolt.fill",
            description: "Energy sector stocks",
            filters: ScreenerFilters(sector: "Energy", sortBy: "market_cap", sortOrder: "desc", limit: 25)
        ),
    ]
}

// MARK: - Screener View

struct ScreenerView: View {

    // MARK: - State

    @Environment(AppRouter.self) private var router
    @State private var showCustomBuilder = false
    @State private var customFilters: ScreenerFilters?

    private let presets = ScreenerPreset.presets

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: JSpacing.lg) {
                customScreenerButton

                presetScreenersSection
            }
            .padding(.horizontal, JSpacing.md)
            .padding(.bottom, JSpacing.xl)
        }
        .background(JColor.background)
        .navigationTitle("Screener")
        .sheet(isPresented: $showCustomBuilder) {
            NavigationStack {
                ScreenerBuilderView { filters in
                    customFilters = filters
                    showCustomBuilder = false
                }
            }
        }
        .navigationDestination(item: $customFilters) { filters in
            ScreenerResultsView(filters: filters, title: "Custom Screener")
        }
    }

    // MARK: - Custom Screener Button

    private var customScreenerButton: some View {
        Button {
            showCustomBuilder = true
        } label: {
            JCard {
                HStack(spacing: JSpacing.sm) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.title2)
                        .foregroundStyle(JColor.primary)
                        .frame(width: 44, height: 44)
                        .background(JColor.primary.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: JRadius.small))

                    VStack(alignment: .leading, spacing: JSpacing.xxs) {
                        Text("Create Custom Screener")
                            .font(JFont.headline)
                            .foregroundStyle(JColor.textPrimary)

                        Text("Filter by price, market cap, sector, and more")
                            .font(JFont.caption)
                            .foregroundStyle(JColor.textSecondary)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.subheadline)
                        .foregroundStyle(JColor.textTertiary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .buttonStyle(.plain)
        .padding(.top, JSpacing.xs)
    }

    // MARK: - Preset Screeners

    private var presetScreenersSection: some View {
        VStack(alignment: .leading, spacing: JSpacing.sm) {
            Text("Popular Screeners")
                .font(JFont.headline)
                .foregroundStyle(JColor.textPrimary)

            LazyVGrid(columns: gridColumns, spacing: JSpacing.sm) {
                ForEach(presets) { preset in
                    NavigationLink(value: preset) {
                        presetCard(preset)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var gridColumns: [GridItem] {
        [
            GridItem(.flexible(), spacing: JSpacing.sm),
            GridItem(.flexible(), spacing: JSpacing.sm),
        ]
    }

    private func presetCard(_ preset: ScreenerPreset) -> some View {
        JCard {
            VStack(alignment: .leading, spacing: JSpacing.sm) {
                Image(systemName: preset.icon)
                    .font(.title2)
                    .foregroundStyle(JColor.primary)
                    .frame(width: 40, height: 40)
                    .background(JColor.primary.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: JRadius.small))

                VStack(alignment: .leading, spacing: JSpacing.xxs) {
                    Text(preset.name)
                        .font(JFont.calloutMedium)
                        .foregroundStyle(JColor.textPrimary)
                        .lineLimit(1)

                    Text(preset.description)
                        .font(JFont.caption)
                        .foregroundStyle(JColor.textSecondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(minHeight: 100)
        }
    }
}

// MARK: - ScreenerFilters + Hashable

extension ScreenerFilters: Equatable, Hashable {
    public static func == (lhs: ScreenerFilters, rhs: ScreenerFilters) -> Bool {
        lhs.exchange == rhs.exchange
            && lhs.sector == rhs.sector
            && lhs.marketCapMin == rhs.marketCapMin
            && lhs.marketCapMax == rhs.marketCapMax
            && lhs.priceMin == rhs.priceMin
            && lhs.priceMax == rhs.priceMax
            && lhs.sortBy == rhs.sortBy
            && lhs.sortOrder == rhs.sortOrder
            && lhs.page == rhs.page
            && lhs.limit == rhs.limit
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(exchange)
        hasher.combine(sector)
        hasher.combine(marketCapMin)
        hasher.combine(marketCapMax)
        hasher.combine(priceMin)
        hasher.combine(priceMax)
        hasher.combine(sortBy)
        hasher.combine(sortOrder)
        hasher.combine(page)
        hasher.combine(limit)
    }
}

// MARK: - ScreenerPreset Navigation

extension ScreenerPreset: Hashable {
    static func == (lhs: ScreenerPreset, rhs: ScreenerPreset) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Previews

#Preview("Screener") {
    NavigationStack {
        ScreenerView()
            .environment(AppRouter())
            .navigationDestination(for: ScreenerPreset.self) { preset in
                ScreenerResultsView(filters: preset.filters, title: preset.name)
            }
    }
}
