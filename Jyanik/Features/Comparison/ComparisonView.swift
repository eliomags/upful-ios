//
//  ComparisonView.swift
//  Jyanik
//
//  Side-by-side stock comparison with metrics table and chart overlay
//

import SwiftUI

struct ComparisonView: View {

    // MARK: - State

    @State private var viewModel: ComparisonViewModel

    // MARK: - Init

    init(primaryTicker: String, primaryName: String = "") {
        _viewModel = State(
            initialValue: ComparisonViewModel(
                primaryTicker: primaryTicker,
                primaryName: primaryName
            )
        )
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: JSpacing.lg) {
                stockHeaders

                if viewModel.isLoading && viewModel.stocks.allSatisfy({ $0.quote == nil }) {
                    JLoadingView("Loading quotes...")
                        .frame(height: 300)
                } else {
                    if viewModel.stocks.count >= 2 {
                        chartComparisonSection
                    }

                    metricsTable

                    if let error = viewModel.errorMessage {
                        JErrorBanner(error)
                            .padding(.horizontal, JSpacing.md)
                    }
                }
            }
            .padding(.bottom, JSpacing.xl)
        }
        .background(JColor.background)
        .navigationTitle("Compare")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if viewModel.canAddMore {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.isShowingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(JColor.primary)
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.isShowingAddSheet) {
            addStockSheet
        }
        .task {
            await viewModel.loadQuotes()
        }
    }

    // MARK: - Stock Headers

    private var stockHeaders: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: JSpacing.sm) {
                ForEach(Array(viewModel.stocks.enumerated()), id: \.element.id) { index, stock in
                    stockHeaderCard(stock: stock, index: index)
                }

                if viewModel.canAddMore {
                    addStockButton
                }
            }
            .padding(.horizontal, JSpacing.md)
            .padding(.top, JSpacing.sm)
        }
    }

    private func stockHeaderCard(stock: ComparedStock, index: Int) -> some View {
        JCard {
            VStack(spacing: JSpacing.xs) {
                HStack {
                    // Colored indicator circle
                    Circle()
                        .fill(stockColor(for: index))
                        .frame(width: 10, height: 10)

                    Text(stock.ticker)
                        .font(JFont.headline)
                        .foregroundStyle(JColor.textPrimary)

                    Spacer()

                    // Remove button (not for the primary stock)
                    if index > 0 {
                        Button {
                            withAnimation {
                                viewModel.removeStock(ticker: stock.ticker)
                            }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.callout)
                                .foregroundStyle(JColor.textTertiary)
                        }
                    }
                }

                Text(stock.companyName)
                    .font(JFont.caption)
                    .foregroundStyle(JColor.textSecondary)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if let quote = stock.quote {
                    HStack(spacing: JSpacing.xs) {
                        Text("$\(quote.currentPrice.formatted(.number.precision(.fractionLength(2))))")
                            .font(JFont.price)
                            .foregroundStyle(JColor.textPrimary)

                        JPriceChangeView(quote.changePercent, style: .percent)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    JShimmer(width: 80, height: 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .frame(width: 160)
    }

    private var addStockButton: some View {
        Button {
            viewModel.isShowingAddSheet = true
        } label: {
            VStack(spacing: JSpacing.xs) {
                Image(systemName: "plus.circle")
                    .font(.system(size: 28, weight: .light))
                    .foregroundStyle(JColor.primary)

                Text("Add Stock")
                    .font(JFont.caption)
                    .foregroundStyle(JColor.primary)
            }
            .frame(width: 100, height: 100)
            .background(JColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: JRadius.medium))
            .overlay {
                RoundedRectangle(cornerRadius: JRadius.medium)
                    .strokeBorder(JColor.primary.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [6]))
            }
        }
    }

    // MARK: - Chart Comparison

    private var chartComparisonSection: some View {
        VStack(alignment: .leading, spacing: JSpacing.sm) {
            Text("Price Trend")
                .font(JFont.headline)
                .foregroundStyle(JColor.textPrimary)
                .padding(.horizontal, JSpacing.md)

            JCard(padding: JSpacing.md) {
                VStack(spacing: JSpacing.sm) {
                    comparisonChartView
                        .frame(height: 160)

                    // Legend
                    HStack(spacing: JSpacing.md) {
                        ForEach(Array(viewModel.stocks.enumerated()), id: \.element.id) { index, stock in
                            HStack(spacing: JSpacing.xxs) {
                                Circle()
                                    .fill(stockColor(for: index))
                                    .frame(width: 8, height: 8)

                                Text(stock.ticker)
                                    .font(JFont.caption)
                                    .foregroundStyle(JColor.textSecondary)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, JSpacing.md)
        }
    }

    private var comparisonChartView: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let stocks = viewModel.stocks.filter { $0.quote != nil }

            ZStack {
                // Grid lines
                ForEach(0..<4, id: \.self) { i in
                    let y = size.height * CGFloat(i) / 3.0
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: size.width, y: y))
                    }
                    .stroke(JColor.divider, lineWidth: 0.5)
                }

                // Draw a normalized line for each stock using mock sparkline data
                ForEach(Array(stocks.enumerated()), id: \.element.id) { index, stock in
                    let data = mockSparkline(for: stock)
                    sparklinePath(data: data, in: size)
                        .stroke(
                            stockColor(for: viewModel.stocks.firstIndex(where: { $0.ticker == stock.ticker }) ?? index),
                            style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
                        )
                }
            }
        }
    }

    // MARK: - Metrics Table

    private var metricsTable: some View {
        VStack(alignment: .leading, spacing: JSpacing.sm) {
            Text("Comparison")
                .font(JFont.headline)
                .foregroundStyle(JColor.textPrimary)
                .padding(.horizontal, JSpacing.md)

            ScrollView(.horizontal, showsIndicators: false) {
                VStack(spacing: 0) {
                    // Header row
                    metricHeaderRow

                    Divider()
                        .background(JColor.divider)

                    // Data rows
                    ForEach(viewModel.comparisonMetrics) { metric in
                        metricDataRow(metric: metric)

                        Divider()
                            .background(JColor.divider)
                    }
                }
                .padding(.horizontal, JSpacing.md)
            }
        }
    }

    private var metricHeaderRow: some View {
        HStack(spacing: 0) {
            Text("Metric")
                .font(JFont.subheadlineMedium)
                .foregroundStyle(JColor.textSecondary)
                .frame(width: 100, alignment: .leading)

            ForEach(Array(viewModel.stocks.enumerated()), id: \.element.id) { index, stock in
                HStack(spacing: JSpacing.xxs) {
                    Circle()
                        .fill(stockColor(for: index))
                        .frame(width: 6, height: 6)

                    Text(stock.ticker)
                        .font(JFont.subheadlineMedium)
                        .foregroundStyle(JColor.textPrimary)
                }
                .frame(width: 110, alignment: .center)
            }
        }
        .padding(.vertical, JSpacing.sm)
    }

    private func metricDataRow(metric: ComparisonMetric) -> some View {
        HStack(spacing: 0) {
            Text(metric.name)
                .font(JFont.caption)
                .foregroundStyle(JColor.textSecondary)
                .frame(width: 100, alignment: .leading)

            ForEach(Array(metric.values.enumerated()), id: \.offset) { index, value in
                Text(value)
                    .font(JFont.priceSmall)
                    .foregroundStyle(
                        metric.bestIndex == index ? JColor.success : JColor.textPrimary
                    )
                    .fontWeight(metric.bestIndex == index ? .semibold : .regular)
                    .frame(width: 110, alignment: .center)
            }
        }
        .padding(.vertical, JSpacing.xs)
        .background(
            metric.bestIndex != nil
                ? JColor.success.opacity(0.03)
                : Color.clear
        )
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
            .navigationTitle("Add to Compare")
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
            Image(systemName: "chart.bar.doc.horizontal")
                .font(.system(size: 40, weight: .light))
                .foregroundStyle(JColor.textTertiary)

            Text("Search for stocks to compare")
                .font(JFont.subheadline)
                .foregroundStyle(JColor.textSecondary)

            Text("Up to \(ComparisonViewModel.maxStocks) stocks")
                .font(JFont.caption)
                .foregroundStyle(JColor.textTertiary)
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

                    if viewModel.isInComparison(result.symbol) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(JColor.success)
                    } else if viewModel.canAddMore {
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
                    } else {
                        Image(systemName: "minus.circle")
                            .font(.title3)
                            .foregroundStyle(JColor.textTertiary)
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

    // MARK: - Helpers

    private func stockColor(for index: Int) -> Color {
        let colors: [Color] = [JColor.primary, JColor.secondary, JColor.accent, JColor.success]
        return colors[index % colors.count]
    }

    private func mockSparkline(for stock: ComparedStock) -> [Double] {
        guard let quote = stock.quote else { return [] }

        // Generate 10 mock data points trending toward current price
        let basePrice = quote.currentPrice - (quote.changeDollar * 2)
        var points: [Double] = []
        let step = quote.changeDollar * 2 / 9.0

        for i in 0..<10 {
            let noise = Double.random(in: -1.5...1.5)
            let value = basePrice + (step * Double(i)) + noise
            points.append(max(1, value))
        }

        return points
    }

    private func sparklinePath(data: [Double], in size: CGSize) -> Path {
        guard data.count > 1 else { return Path() }

        let minVal = data.min() ?? 0
        let maxVal = data.max() ?? 1
        let range = maxVal - minVal
        let safeRange = range == 0 ? 1 : range

        let points = data.enumerated().map { index, value -> CGPoint in
            let x = size.width * CGFloat(index) / CGFloat(data.count - 1)
            let y = size.height * (1 - CGFloat((value - minVal) / safeRange))
            return CGPoint(x: x, y: y)
        }

        var path = Path()
        guard let first = points.first else { return path }
        path.move(to: first)
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        return path
    }
}

// MARK: - Previews

#Preview("Comparison - Single Stock") {
    NavigationStack {
        ComparisonView(primaryTicker: "AAPL", primaryName: "Apple Inc.")
    }
}

#Preview("Comparison - Multiple") {
    NavigationStack {
        ComparisonView(primaryTicker: "AAPL", primaryName: "Apple Inc.")
    }
}
