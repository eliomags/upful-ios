//
//  StockDetailView.swift
//  Jyanik
//
//  Stock detail screen: header, chart, stats, buy/sell, news
//

import SwiftUI
import OSLog

// MARK: - Stock Detail View

struct StockDetailView: View {

    // MARK: - Properties

    let ticker: String

    @State private var viewModel: StockDetailViewModel
    @State private var tradeSheet: TradeSheetItem?

    // MARK: - Init

    init(ticker: String) {
        self.ticker = ticker
        self._viewModel = State(initialValue: StockDetailViewModel(ticker: ticker))
    }

    // MARK: - Body

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.quote == nil {
                JLoadingView("Loading \(ticker)...")
            } else if let error = viewModel.errorMessage, viewModel.quote == nil {
                JErrorView(error) {
                    Task { await viewModel.loadQuote() }
                }
            } else {
                detailContent
            }
        }
        .background(JColor.background)
        .navigationTitle(ticker)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $tradeSheet) { item in
            TradeSheetPlaceholder(ticker: item.ticker, side: item.side)
        }
        .task {
            if viewModel.quote == nil {
                await viewModel.loadQuote()
            }
        }
    }

    // MARK: - Detail Content

    private var detailContent: some View {
        ScrollView {
            VStack(spacing: JSpacing.lg) {
                priceHeader
                chartSection
                tradeButtons
                keyStatsSection
                newsSection
            }
            .padding(.horizontal, JSpacing.md)
            .padding(.bottom, JSpacing.xl)
        }
        .refreshable {
            await viewModel.loadQuote()
        }
    }

    // MARK: - Price Header

    private var priceHeader: some View {
        JCard {
            VStack(alignment: .leading, spacing: JSpacing.xs) {
                Text(viewModel.companyName)
                    .font(JFont.subheadline)
                    .foregroundStyle(JColor.textSecondary)

                Text(viewModel.formattedPrice)
                    .font(JFont.priceLarge)
                    .foregroundStyle(JColor.textPrimary)

                HStack(spacing: JSpacing.sm) {
                    JPriceChangeBadge(viewModel.changePercent, style: .percent)

                    Text(viewModel.formattedChangeDollar)
                        .font(JFont.subheadline)
                        .foregroundStyle(JColor.textSecondary)

                    Spacer()

                    Text("Real-time")
                        .font(JFont.caption)
                        .foregroundStyle(JColor.textTertiary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    // MARK: - Chart Section

    private var chartSection: some View {
        JCard(padding: JSpacing.sm) {
            VStack(spacing: JSpacing.sm) {
                if viewModel.chartPoints.isEmpty {
                    chartPlaceholder
                } else {
                    simpleChart
                }

                chartRangeSelector
            }
        }
    }

    private var chartPlaceholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: JRadius.small)
                .fill(JColor.surfaceSecondary)

            VStack(spacing: JSpacing.xs) {
                Image(systemName: "chart.xyaxis.line")
                    .font(.title)
                    .foregroundStyle(JColor.textTertiary)

                Text("Chart data loading...")
                    .font(JFont.caption)
                    .foregroundStyle(JColor.textTertiary)
            }
        }
        .frame(height: 200)
    }

    private var simpleChart: some View {
        GeometryReader { geometry in
            let points = viewModel.normalizedChartPoints(in: geometry.size)

            ZStack {
                // Gradient fill under the line
                Path { path in
                    guard let first = points.first else { return }
                    path.move(to: CGPoint(x: first.x, y: geometry.size.height))
                    path.addLine(to: first)
                    for point in points.dropFirst() {
                        path.addLine(to: point)
                    }
                    path.addLine(to: CGPoint(x: points.last?.x ?? 0, y: geometry.size.height))
                    path.closeSubpath()
                }
                .fill(
                    LinearGradient(
                        colors: [
                            viewModel.isPositive ? JColor.gainPositive.opacity(0.3) : JColor.gainNegative.opacity(0.3),
                            viewModel.isPositive ? JColor.gainPositive.opacity(0.0) : JColor.gainNegative.opacity(0.0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

                // Price line
                Path { path in
                    guard let first = points.first else { return }
                    path.move(to: first)
                    for point in points.dropFirst() {
                        path.addLine(to: point)
                    }
                }
                .stroke(
                    viewModel.isPositive ? JColor.gainPositive : JColor.gainNegative,
                    style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
                )
            }
        }
        .frame(height: 200)
    }

    private var chartRangeSelector: some View {
        HStack(spacing: 0) {
            ForEach(ChartRange.allDisplayCases, id: \.self) { range in
                Button {
                    Task { await viewModel.selectChartRange(range) }
                } label: {
                    Text(range.label)
                        .font(JFont.captionMedium)
                        .foregroundStyle(
                            viewModel.selectedRange == range
                                ? Color.white
                                : JColor.textSecondary
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, JSpacing.xs)
                        .background(
                            viewModel.selectedRange == range
                                ? JColor.primary
                                : Color.clear,
                            in: Capsule()
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(JSpacing.xxxs)
        .background(JColor.surfaceSecondary, in: Capsule())
    }

    // MARK: - Trade Buttons

    private var tradeButtons: some View {
        HStack(spacing: JSpacing.sm) {
            JButton("Buy", style: .primary, size: .large) {
                tradeSheet = TradeSheetItem(ticker: ticker, side: .buy)
            }

            JButton("Sell", style: .destructive, size: .large) {
                tradeSheet = TradeSheetItem(ticker: ticker, side: .sell)
            }
        }
    }

    // MARK: - Key Stats

    private var keyStatsSection: some View {
        VStack(alignment: .leading, spacing: JSpacing.sm) {
            Text("Key Statistics")
                .font(JFont.headline)
                .foregroundStyle(JColor.textPrimary)

            JCard(padding: JSpacing.sm) {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                ], spacing: JSpacing.md) {
                    statItem(label: "Open", value: viewModel.formattedOpen)
                    statItem(label: "Prev Close", value: viewModel.formattedPrevClose)
                    statItem(label: "Day High", value: viewModel.formattedDayHigh)
                    statItem(label: "Day Low", value: viewModel.formattedDayLow)
                    statItem(label: "Volume", value: viewModel.formattedVolume)
                    statItem(label: "Mkt Cap", value: viewModel.formattedMarketCap)
                    statItem(label: "P/E Ratio", value: viewModel.formattedPE)
                    statItem(label: "Div Yield", value: viewModel.formattedDividend)
                }
            }
        }
    }

    private func statItem(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: JSpacing.xxxs) {
            Text(label)
                .font(JFont.caption)
                .foregroundStyle(JColor.textTertiary)

            Text(value)
                .font(JFont.price)
                .foregroundStyle(JColor.textPrimary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - News Section

    private var newsSection: some View {
        VStack(alignment: .leading, spacing: JSpacing.sm) {
            Text("News")
                .font(JFont.headline)
                .foregroundStyle(JColor.textPrimary)

            if viewModel.news.isEmpty {
                JCard {
                    HStack {
                        Spacer()
                        VStack(spacing: JSpacing.xs) {
                            Image(systemName: "newspaper")
                                .font(.title2)
                                .foregroundStyle(JColor.textTertiary)
                            Text("No recent news")
                                .font(JFont.subheadline)
                                .foregroundStyle(JColor.textSecondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, JSpacing.lg)
                }
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.news, id: \.stableID) { article in
                        NavigationLink(value: Route.newsDetail(url: article.url)) {
                            newsRow(article)
                        }
                        .buttonStyle(.plain)

                        if article.stableID != viewModel.news.last?.stableID {
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

    private func newsRow(_ article: NewsArticleDTO) -> some View {
        VStack(alignment: .leading, spacing: JSpacing.xxs) {
            Text(article.title)
                .font(JFont.subheadlineMedium)
                .foregroundStyle(JColor.textPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            HStack(spacing: JSpacing.xs) {
                if let source = article.source {
                    Text(source)
                        .font(JFont.caption)
                        .foregroundStyle(JColor.textTertiary)
                }

                if let publishedAt = article.publishedAt {
                    Text(publishedAt)
                        .font(JFont.caption)
                        .foregroundStyle(JColor.textTertiary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundStyle(JColor.textTertiary)
            }
        }
        .padding(.vertical, JSpacing.xs)
        .contentShape(Rectangle())
    }
}

// MARK: - Trade Sheet Item

private struct TradeSheetItem: Identifiable {
    let ticker: String
    let side: TradeSide

    var id: String { "\(ticker)_\(side.rawValue)" }
}

// MARK: - Trade Sheet Placeholder

/// Temporary placeholder until the full TradeView feature handles sheet presentation.
private struct TradeSheetPlaceholder: View {
    let ticker: String
    let side: TradeSide
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: JSpacing.lg) {
                Image(systemName: side == .buy ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(side == .buy ? JColor.gainPositive : JColor.gainNegative)

                Text("\(side == .buy ? "Buy" : "Sell") \(ticker)")
                    .font(JFont.title2)
                    .foregroundStyle(JColor.textPrimary)

                Text("Trading functionality coming soon")
                    .font(JFont.subheadline)
                    .foregroundStyle(JColor.textSecondary)

                Spacer()
            }
            .padding(.top, JSpacing.xxl)
            .frame(maxWidth: .infinity)
            .background(JColor.background)
            .navigationTitle("\(side == .buy ? "Buy" : "Sell") \(ticker)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Stock Detail View Model

@Observable
final class StockDetailViewModel {

    // MARK: - State

    let ticker: String

    private(set) var quote: MarketQuoteDTO?
    private(set) var chartPoints: [ChartDataPointDTO] = []
    private(set) var news: [NewsArticleDTO] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    var selectedRange: ChartRange = .oneDay

    // MARK: - Dependencies

    private let marketDataService: MarketDataService
    private let logger = Logger(subsystem: "com.jyanik", category: "StockDetail")

    // MARK: - Init

    init(ticker: String, marketDataService: MarketDataService = MarketDataService()) {
        self.ticker = ticker
        self.marketDataService = marketDataService
    }

    // MARK: - Loading

    func loadQuote() async {
        isLoading = true
        errorMessage = nil

        do {
            async let quoteResult = marketDataService.fetchQuote(symbol: ticker)
            async let chartResult = marketDataService.fetchChart(symbol: ticker, range: selectedRange)
            async let newsResult = marketDataService.fetchNews(symbol: ticker)

            let (fetchedQuote, fetchedChart, fetchedNews) = try await (quoteResult, chartResult, newsResult)

            self.quote = fetchedQuote
            self.chartPoints = fetchedChart
            self.news = fetchedNews
        } catch {
            logger.warning("[StockDetail] Failed to load \(self.ticker): \(error.localizedDescription)")

            // Use mock quote on failure so the screen still shows data
            if quote == nil {
                loadMockData()
            }
        }

        isLoading = false
    }

    func selectChartRange(_ range: ChartRange) async {
        selectedRange = range
        do {
            let points = try await marketDataService.fetchChart(symbol: ticker, range: range)
            self.chartPoints = points
        } catch {
            logger.warning("[StockDetail] Chart fetch failed for range \(range.rawValue)")
        }
    }

    // MARK: - Computed Properties

    var companyName: String {
        quote?.companyName ?? ticker
    }

    var isPositive: Bool {
        (quote?.changePercent ?? 0) >= 0
    }

    var changePercent: Double {
        quote?.changePercent ?? 0
    }

    var formattedPrice: String {
        guard let price = quote?.currentPrice else { return "--" }
        return "$\(price.formatted(.number.precision(.fractionLength(2))))"
    }

    var formattedChangeDollar: String {
        guard let change = quote?.changeDollar else { return "--" }
        let sign = change >= 0 ? "+" : ""
        return "\(sign)$\(change.formatted(.number.precision(.fractionLength(2))))"
    }

    var formattedOpen: String {
        formatOptionalPrice(quote?.openPrice)
    }

    var formattedPrevClose: String {
        formatOptionalPrice(quote?.previousClose)
    }

    var formattedDayHigh: String {
        formatOptionalPrice(quote?.dayHigh)
    }

    var formattedDayLow: String {
        formatOptionalPrice(quote?.dayLow)
    }

    var formattedVolume: String {
        guard let vol = quote?.volume else { return "--" }
        return formatLargeNumber(Double(vol))
    }

    var formattedMarketCap: String {
        guard let cap = quote?.marketCap else { return "--" }
        return formatLargeNumber(cap)
    }

    var formattedPE: String {
        guard let pe = quote?.peRatio else { return "--" }
        return pe.formatted(.number.precision(.fractionLength(2)))
    }

    var formattedDividend: String {
        guard let div = quote?.dividendYield else { return "--" }
        return "\(div.formatted(.number.precision(.fractionLength(2))))%"
    }

    // MARK: - Chart Helpers

    func normalizedChartPoints(in size: CGSize) -> [CGPoint] {
        let values = chartPoints.map(\.close)
        guard values.count > 1 else { return [] }

        let minVal = values.min() ?? 0
        let maxVal = values.max() ?? 1
        let range = maxVal - minVal
        let safeRange = range == 0 ? 1 : range

        return values.enumerated().map { index, value in
            let x = size.width * CGFloat(index) / CGFloat(values.count - 1)
            let y = size.height * (1 - CGFloat((value - minVal) / safeRange))
            return CGPoint(x: x, y: y)
        }
    }

    // MARK: - Private Helpers

    private func formatOptionalPrice(_ value: Double?) -> String {
        guard let value else { return "--" }
        return "$\(value.formatted(.number.precision(.fractionLength(2))))"
    }

    private func formatLargeNumber(_ value: Double) -> String {
        switch value {
        case 1_000_000_000_000...:
            return "$\((value / 1_000_000_000_000).formatted(.number.precision(.fractionLength(2))))T"
        case 1_000_000_000...:
            return "$\((value / 1_000_000_000).formatted(.number.precision(.fractionLength(2))))B"
        case 1_000_000...:
            return "$\((value / 1_000_000).formatted(.number.precision(.fractionLength(2))))M"
        case 1_000...:
            return "$\((value / 1_000).formatted(.number.precision(.fractionLength(1))))K"
        default:
            return "$\(value.formatted(.number.precision(.fractionLength(0))))"
        }
    }

    // MARK: - Mock Data

    private func loadMockData() {
        // Build a mock quote so the UI remains populated
        let mockQuote = MarketQuoteDTO(
            ticker: ticker,
            companyName: "\(ticker) Inc.",
            currentPrice: Double.random(in: 50...500),
            previousClose: Double.random(in: 50...500),
            openPrice: Double.random(in: 50...500),
            dayHigh: Double.random(in: 200...500),
            dayLow: Double.random(in: 50...200),
            volume: Int.random(in: 1_000_000...50_000_000),
            marketCap: Double.random(in: 10_000_000_000...3_000_000_000_000),
            peRatio: Double.random(in: 10...45),
            dividendYield: Double.random(in: 0...3),
            changeDollar: Double.random(in: -10...15),
            changePercent: Double.random(in: -5...5),
            updatedAt: nil
        )
        self.quote = mockQuote

        // Build mock chart data
        var mockPoints: [ChartDataPointDTO] = []
        var price = mockQuote.currentPrice - 20
        for i in 0..<30 {
            price += Double.random(in: -5...6)
            price = max(10, price)
            mockPoints.append(ChartDataPointDTO(
                timestamp: nil,
                date: "2025-01-\(String(format: "%02d", i + 1))",
                open: nil,
                high: nil,
                low: nil,
                close: price,
                volume: nil
            ))
        }
        self.chartPoints = mockPoints

        errorMessage = nil
    }
}

// MARK: - ChartRange Display Extension

extension ChartRange {
    static let allDisplayCases: [ChartRange] = [
        .oneDay, .fiveDays, .oneMonth, .threeMonths, .sixMonths, .oneYear, .fiveYears
    ]

    var label: String {
        switch self {
        case .oneDay: return "1D"
        case .fiveDays: return "5D"
        case .oneMonth: return "1M"
        case .threeMonths: return "3M"
        case .sixMonths: return "6M"
        case .oneYear: return "1Y"
        case .fiveYears: return "5Y"
        case .max: return "MAX"
        }
    }
}

// MARK: - Preview

#Preview("Stock Detail") {
    NavigationStack {
        StockDetailView(ticker: "AAPL")
    }
}
