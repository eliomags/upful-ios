//
//  JStockRow.swift
//  Jyanik
//
//  Reusable stock list row showing ticker, name, price, change, and mini chart
//

import SwiftUI

struct JStockRow: View {
    let ticker: String
    let companyName: String
    let price: Double
    let changePercent: Double
    let sparklineData: [Double]

    init(
        ticker: String,
        companyName: String,
        price: Double,
        changePercent: Double,
        sparklineData: [Double] = []
    ) {
        self.ticker = ticker
        self.companyName = companyName
        self.price = price
        self.changePercent = changePercent
        self.sparklineData = sparklineData
    }

    var body: some View {
        HStack(spacing: JSpacing.sm) {
            // Ticker & Name
            VStack(alignment: .leading, spacing: JSpacing.xxxs) {
                Text(ticker)
                    .font(JFont.headline)
                    .foregroundStyle(JColor.textPrimary)

                Text(companyName)
                    .font(JFont.caption)
                    .foregroundStyle(JColor.textSecondary)
                    .lineLimit(1)
            }
            .frame(minWidth: 70, alignment: .leading)

            Spacer()

            // Mini Sparkline
            if !sparklineData.isEmpty {
                MiniSparkline(data: sparklineData, isPositive: changePercent >= 0)
                    .frame(width: 60, height: 28)
            }

            // Price & Change
            VStack(alignment: .trailing, spacing: JSpacing.xxxs) {
                Text(formattedPrice)
                    .font(JFont.price)
                    .foregroundStyle(JColor.textPrimary)

                JPriceChangeView(changePercent, style: .percent)
            }
            .frame(minWidth: 80, alignment: .trailing)
        }
        .padding(.vertical, JSpacing.xs)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(companyName) stock, \(formattedPrice), \(changePercent >= 0 ? "up" : "down") \(String(format: "%.2f", abs(changePercent))) percent")
    }

    private var formattedPrice: String {
        "$\(price.formatted(.number.precision(.fractionLength(2))))"
    }
}

// MARK: - Mini Sparkline Chart

private struct MiniSparkline: View {
    let data: [Double]
    let isPositive: Bool

    var body: some View {
        GeometryReader { geometry in
            let points = normalizedPoints(in: geometry.size)

            Path { path in
                guard let first = points.first else { return }
                path.move(to: first)
                for point in points.dropFirst() {
                    path.addLine(to: point)
                }
            }
            .stroke(
                isPositive ? JColor.gainPositive : JColor.gainNegative,
                style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round)
            )
        }
    }

    private func normalizedPoints(in size: CGSize) -> [CGPoint] {
        guard data.count > 1 else { return [] }

        let minVal = data.min() ?? 0
        let maxVal = data.max() ?? 1
        let range = maxVal - minVal
        let safeRange = range == 0 ? 1 : range

        return data.enumerated().map { index, value in
            let x = size.width * CGFloat(index) / CGFloat(data.count - 1)
            let y = size.height * (1 - CGFloat((value - minVal) / safeRange))
            return CGPoint(x: x, y: y)
        }
    }
}

// MARK: - Previews

#Preview("Stock Rows") {
    List {
        JStockRow(
            ticker: "AAPL",
            companyName: "Apple Inc.",
            price: 178.52,
            changePercent: 1.24,
            sparklineData: [170, 172, 171, 174, 176, 175, 178]
        )

        JStockRow(
            ticker: "TSLA",
            companyName: "Tesla, Inc.",
            price: 245.30,
            changePercent: -2.15,
            sparklineData: [255, 252, 250, 248, 249, 246, 245]
        )

        JStockRow(
            ticker: "MSFT",
            companyName: "Microsoft Corporation",
            price: 378.90,
            changePercent: 0.42,
            sparklineData: [375, 376, 377, 376, 378, 377, 379]
        )

        JStockRow(
            ticker: "NVDA",
            companyName: "NVIDIA Corporation",
            price: 875.28,
            changePercent: 3.56,
            sparklineData: [840, 845, 855, 850, 860, 870, 875]
        )

        JStockRow(
            ticker: "AMZN",
            companyName: "Amazon.com, Inc.",
            price: 178.25,
            changePercent: -0.18
        )
    }
    .listStyle(.plain)
}
