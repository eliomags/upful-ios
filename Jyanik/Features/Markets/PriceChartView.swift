//
//  PriceChartView.swift
//  Jyanik
//
//  Reusable price chart using Swift Charts: line with gradient fill,
//  interactive crosshair, and chart range selector.
//

import SwiftUI
import Charts

// MARK: - Price Chart View

struct PriceChartView: View {

    // MARK: - Properties

    let dataPoints: [ChartDataPointDTO]
    let selectedRange: ChartRange
    let isCompact: Bool
    let onRangeChanged: ((ChartRange) -> Void)?

    @State private var selectedPoint: ChartDataPointDTO?
    @State private var hasAppeared = false

    // MARK: - Init

    init(
        dataPoints: [ChartDataPointDTO],
        selectedRange: ChartRange = .oneDay,
        isCompact: Bool = false,
        onRangeChanged: ((ChartRange) -> Void)? = nil
    ) {
        self.dataPoints = dataPoints
        self.selectedRange = selectedRange
        self.isCompact = isCompact
        self.onRangeChanged = onRangeChanged
    }

    // MARK: - Computed

    private var isPositiveOverall: Bool {
        guard let first = dataPoints.first, let last = dataPoints.last else { return true }
        return last.close >= first.close
    }

    private var lineColor: Color {
        isPositiveOverall ? JColor.gainPositive : JColor.gainNegative
    }

    private var chartHeight: CGFloat {
        isCompact ? 120 : 240
    }

    private var minPrice: Double {
        dataPoints.map(\.close).min() ?? 0
    }

    private var maxPrice: Double {
        dataPoints.map(\.close).max() ?? 100
    }

    private var priceRange: Double {
        let range = maxPrice - minPrice
        return range == 0 ? 1 : range
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: isCompact ? JSpacing.xs : JSpacing.sm) {
            if dataPoints.isEmpty {
                chartPlaceholder
            } else {
                VStack(spacing: JSpacing.xs) {
                    if let selectedPoint {
                        selectedPointOverlay(selectedPoint)
                    }

                    chartContent
                }
            }

            if !isCompact {
                rangeSelector
            }
        }
    }

    // MARK: - Chart Content

    private var chartContent: some View {
        Chart {
            ForEach(Array(dataPoints.enumerated()), id: \.element.id) { index, point in
                LineMark(
                    x: .value("Index", index),
                    y: .value("Price", point.close)
                )
                .foregroundStyle(lineColor)
                .lineStyle(StrokeStyle(lineWidth: isCompact ? 1.5 : 2, lineCap: .round, lineJoin: .round))
                .interpolationMethod(.catmullRom)

                AreaMark(
                    x: .value("Index", index),
                    yStart: .value("Min", minPrice - priceRange * 0.05),
                    yEnd: .value("Price", point.close)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            lineColor.opacity(0.3),
                            lineColor.opacity(0.05)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)
            }

            if let selectedPoint, let index = dataPoints.firstIndex(where: { $0.id == selectedPoint.id }) {
                RuleMark(x: .value("Selected", index))
                    .foregroundStyle(JColor.textTertiary.opacity(0.5))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))

                PointMark(
                    x: .value("Index", index),
                    y: .value("Price", selectedPoint.close)
                )
                .foregroundStyle(lineColor)
                .symbolSize(isCompact ? 30 : 50)
            }
        }
        .chartXAxis(isCompact ? .hidden : .visible)
        .chartYAxis(isCompact ? .hidden : .visible)
        .chartYScale(domain: (minPrice - priceRange * 0.05)...(maxPrice + priceRange * 0.05))
        .chartOverlay { proxy in
            GeometryReader { geometry in
                Rectangle()
                    .fill(Color.clear)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                handleChartInteraction(at: value.location, proxy: proxy, geometry: geometry)
                            }
                            .onEnded { _ in
                                selectedPoint = nil
                            }
                    )
            }
        }
        .frame(height: chartHeight)
        .opacity(hasAppeared ? 1 : 0)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                hasAppeared = true
            }
        }
    }

    // MARK: - Selected Point Overlay

    private func selectedPointOverlay(_ point: ChartDataPointDTO) -> some View {
        HStack(spacing: JSpacing.sm) {
            Text(formatSelectedPrice(point.close))
                .font(JFont.headline)
                .foregroundStyle(JColor.textPrimary)

            if let dateString = point.date ?? formatTimestamp(point.timestamp) {
                Text(dateString)
                    .font(JFont.caption)
                    .foregroundStyle(JColor.textSecondary)
            }

            Spacer()
        }
        .padding(.horizontal, JSpacing.xs)
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.15), value: point.id)
    }

    // MARK: - Chart Placeholder

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
        .frame(height: chartHeight)
    }

    // MARK: - Range Selector

    private var rangeSelector: some View {
        HStack(spacing: 0) {
            ForEach(ChartRange.allDisplayCases, id: \.self) { range in
                Button {
                    onRangeChanged?(range)
                } label: {
                    Text(range.label)
                        .font(JFont.captionMedium)
                        .foregroundStyle(
                            selectedRange == range
                                ? Color.white
                                : JColor.textSecondary
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, JSpacing.xs)
                        .background(
                            selectedRange == range
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

    // MARK: - Interaction

    private func handleChartInteraction(
        at location: CGPoint,
        proxy: ChartProxy,
        geometry: GeometryProxy
    ) {
        guard !dataPoints.isEmpty,
              let plotFrame = proxy.plotFrame else { return }

        let xPosition = location.x - geometry[plotFrame].origin.x
        guard let index: Int = proxy.value(atX: xPosition) else { return }

        let clampedIndex = max(0, min(index, dataPoints.count - 1))
        selectedPoint = dataPoints[clampedIndex]
    }

    // MARK: - Formatting

    private func formatSelectedPrice(_ price: Double) -> String {
        "$\(price.formatted(.number.precision(.fractionLength(2))))"
    }

    private func formatTimestamp(_ timestamp: Double?) -> String? {
        guard let ts = timestamp else { return nil }
        let date = Date(timeIntervalSince1970: ts)
        let formatter = selectedRange == .oneDay
            ? Self.dateTimeFormatter
            : Self.dateOnlyFormatter
        return formatter.string(from: date)
    }

    private static let dateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    private static let dateOnlyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

// MARK: - Previews

#Preview("Price Chart - Full") {
    let mockData: [ChartDataPointDTO] = (0..<30).map { i in
        let basePrice = 150.0 + Double(i) * 1.5 + Double.random(in: -5...5)
        return ChartDataPointDTO(
            timestamp: nil,
            date: "2025-01-\(String(format: "%02d", i + 1))",
            open: nil,
            high: nil,
            low: nil,
            close: basePrice,
            volume: nil
        )
    }

    return JCard(padding: JSpacing.sm) {
        PriceChartView(
            dataPoints: mockData,
            selectedRange: .oneMonth,
            onRangeChanged: { _ in }
        )
    }
    .padding()
    .background(JColor.background)
}

#Preview("Price Chart - Compact") {
    let mockData: [ChartDataPointDTO] = (0..<20).map { i in
        let basePrice = 200.0 - Double(i) * 0.8 + Double.random(in: -3...3)
        return ChartDataPointDTO(
            timestamp: nil,
            date: "2025-02-\(String(format: "%02d", i + 1))",
            open: nil,
            high: nil,
            low: nil,
            close: basePrice,
            volume: nil
        )
    }

    return JCard(padding: JSpacing.sm) {
        PriceChartView(
            dataPoints: mockData,
            selectedRange: .oneMonth,
            isCompact: true
        )
    }
    .padding()
    .background(JColor.background)
}

#Preview("Price Chart - Empty") {
    JCard(padding: JSpacing.sm) {
        PriceChartView(
            dataPoints: [],
            selectedRange: .oneDay,
            onRangeChanged: { _ in }
        )
    }
    .padding()
    .background(JColor.background)
}
