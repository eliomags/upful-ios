//
//  ScreenerBuilderView.swift
//  Jyanik
//
//  Custom screener builder with form-based filter controls
//

import SwiftUI

struct ScreenerBuilderView: View {

    // MARK: - Callback

    let onRunScreener: (ScreenerFilters) -> Void

    // MARK: - Form State

    @Environment(\.dismiss) private var dismiss

    @State private var selectedAssetType: AssetType = .all
    @State private var minPriceText = ""
    @State private var maxPriceText = ""
    @State private var selectedMarketCap: MarketCapOption = .any
    @State private var selectedVolume: VolumeOption = .any
    @State private var selectedExchange: ExchangeOption = .any
    @State private var selectedSector: SectorOption = .any
    @State private var selectedSortBy: SortOption = .marketCap

    @State private var screenerName = ""
    @State private var showSaveField = false

    // MARK: - Enums

    enum AssetType: String, CaseIterable, Identifiable {
        case all = "All"
        case stocks = "Stocks"
        case crypto = "Crypto"
        case etfs = "ETFs"

        var id: String { rawValue }
    }

    enum MarketCapOption: String, CaseIterable, Identifiable {
        case any = "Any"
        case small = "Small (< $2B)"
        case mid = "Mid ($2B - $10B)"
        case large = "Large ($10B - $200B)"
        case mega = "Mega (> $200B)"

        var id: String { rawValue }

        var minValue: Double? {
            switch self {
            case .any: return nil
            case .small: return nil
            case .mid: return 2_000_000_000
            case .large: return 10_000_000_000
            case .mega: return 200_000_000_000
            }
        }

        var maxValue: Double? {
            switch self {
            case .any: return nil
            case .small: return 2_000_000_000
            case .mid: return 10_000_000_000
            case .large: return 200_000_000_000
            case .mega: return nil
            }
        }
    }

    enum VolumeOption: String, CaseIterable, Identifiable {
        case any = "Any"
        case low = "Low (< 500K)"
        case medium = "Medium (500K - 5M)"
        case high = "High (> 5M)"

        var id: String { rawValue }
    }

    enum ExchangeOption: String, CaseIterable, Identifiable {
        case any = "Any"
        case nyse = "NYSE"
        case nasdaq = "NASDAQ"
        case amex = "AMEX"

        var id: String { rawValue }

        var apiValue: String? {
            switch self {
            case .any: return nil
            default: return rawValue
            }
        }
    }

    enum SectorOption: String, CaseIterable, Identifiable {
        case any = "Any"
        case technology = "Technology"
        case healthcare = "Healthcare"
        case finance = "Finance"
        case energy = "Energy"
        case consumer = "Consumer"
        case industrial = "Industrial"
        case utilities = "Utilities"
        case realEstate = "Real Estate"
        case communications = "Communications"

        var id: String { rawValue }

        var apiValue: String? {
            self == .any ? nil : rawValue
        }
    }

    enum SortOption: String, CaseIterable, Identifiable {
        case marketCap = "Market Cap"
        case price = "Price"
        case volume = "Volume"
        case changePercent = "Change %"
        case name = "Name"

        var id: String { rawValue }

        var apiValue: String {
            switch self {
            case .marketCap: return "market_cap"
            case .price: return "price"
            case .volume: return "volume"
            case .changePercent: return "change_percent"
            case .name: return "name"
            }
        }
    }

    // MARK: - Body

    var body: some View {
        Form {
            assetTypeSection
            priceRangeSection
            marketCapSection
            volumeSection
            exchangeSection
            sectorSection
            sortBySection
            saveSection
            runSection
        }
        .scrollContentBackground(.hidden)
        .background(JColor.background)
        .navigationTitle("Custom Screener")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundStyle(JColor.primary)
            }
        }
    }

    // MARK: - Sections

    private var assetTypeSection: some View {
        Section {
            Picker("Asset Type", selection: $selectedAssetType) {
                ForEach(AssetType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .font(JFont.body)
            .foregroundStyle(JColor.textPrimary)
        } header: {
            Text("Asset Type")
                .font(JFont.caption)
        }
    }

    private var priceRangeSection: some View {
        Section {
            HStack(spacing: JSpacing.sm) {
                VStack(alignment: .leading, spacing: JSpacing.xxs) {
                    Text("Min Price")
                        .font(JFont.caption)
                        .foregroundStyle(JColor.textSecondary)

                    TextField("$0", text: $minPriceText)
                        .font(JFont.body)
                        .foregroundStyle(JColor.textPrimary)
                        .keyboardType(.decimalPad)
                }

                Divider()
                    .frame(height: 40)

                VStack(alignment: .leading, spacing: JSpacing.xxs) {
                    Text("Max Price")
                        .font(JFont.caption)
                        .foregroundStyle(JColor.textSecondary)

                    TextField("No limit", text: $maxPriceText)
                        .font(JFont.body)
                        .foregroundStyle(JColor.textPrimary)
                        .keyboardType(.decimalPad)
                }
            }
        } header: {
            Text("Price Range")
                .font(JFont.caption)
        }
    }

    private var marketCapSection: some View {
        Section {
            Picker("Market Cap", selection: $selectedMarketCap) {
                ForEach(MarketCapOption.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .font(JFont.body)
            .foregroundStyle(JColor.textPrimary)
        } header: {
            Text("Market Cap")
                .font(JFont.caption)
        }
    }

    private var volumeSection: some View {
        Section {
            Picker("Volume", selection: $selectedVolume) {
                ForEach(VolumeOption.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .font(JFont.body)
            .foregroundStyle(JColor.textPrimary)
        } header: {
            Text("Trading Volume")
                .font(JFont.caption)
        }
    }

    private var exchangeSection: some View {
        Section {
            Picker("Exchange", selection: $selectedExchange) {
                ForEach(ExchangeOption.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .font(JFont.body)
            .foregroundStyle(JColor.textPrimary)
        } header: {
            Text("Exchange")
                .font(JFont.caption)
        }
    }

    private var sectorSection: some View {
        Section {
            Picker("Sector", selection: $selectedSector) {
                ForEach(SectorOption.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .font(JFont.body)
            .foregroundStyle(JColor.textPrimary)
        } header: {
            Text("Sector")
                .font(JFont.caption)
        }
    }

    private var sortBySection: some View {
        Section {
            Picker("Sort By", selection: $selectedSortBy) {
                ForEach(SortOption.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .font(JFont.body)
            .foregroundStyle(JColor.textPrimary)
        } header: {
            Text("Sort By")
                .font(JFont.caption)
        }
    }

    private var saveSection: some View {
        Section {
            if showSaveField {
                TextField("Screener Name", text: $screenerName)
                    .font(JFont.body)
                    .foregroundStyle(JColor.textPrimary)
            } else {
                Button {
                    withAnimation { showSaveField = true }
                } label: {
                    HStack(spacing: JSpacing.xs) {
                        Image(systemName: "bookmark")
                            .foregroundStyle(JColor.primary)
                        Text("Save This Screener")
                            .font(JFont.body)
                            .foregroundStyle(JColor.primary)
                    }
                }
            }
        }
    }

    private var runSection: some View {
        Section {
            JButton("Run Screener", style: .primary, size: .large) {
                let filters = buildFilters()
                onRunScreener(filters)
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
        }
    }

    // MARK: - Build Filters

    private func buildFilters() -> ScreenerFilters {
        let minPrice = Double(minPriceText)
        let maxPrice = Double(maxPriceText)

        return ScreenerFilters(
            exchange: selectedExchange.apiValue,
            sector: selectedSector.apiValue,
            marketCapMin: selectedMarketCap.minValue,
            marketCapMax: selectedMarketCap.maxValue,
            priceMin: minPrice,
            priceMax: maxPrice,
            sortBy: selectedSortBy.apiValue,
            sortOrder: "desc",
            limit: 25
        )
    }
}

// MARK: - Previews

#Preview("Screener Builder") {
    NavigationStack {
        ScreenerBuilderView { filters in
            print("Run with filters: \(filters)")
        }
    }
}
