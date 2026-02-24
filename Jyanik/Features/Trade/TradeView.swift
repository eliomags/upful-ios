//
//  TradeView.swift
//  Jyanik
//
//  Trade execution screen for paper trading.
//  Supports stock search, buy/sell toggle, market/limit orders,
//  quantity input, order summary, and trade confirmation.
//

import SwiftUI

struct TradeView: View {

    // MARK: - State

    @Environment(AppState.self) private var appState

    @State private var viewModel: TradeViewModel
    @FocusState private var focusedField: Field?

    // MARK: - Init

    init(initialTicker: String? = nil, initialSide: TradeSide = .buy) {
        _viewModel = State(initialValue: TradeViewModel(initialTicker: initialTicker, initialSide: initialSide))
    }

    private enum Field: Hashable {
        case search
        case quantity
        case limitPrice
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            JColor.background
                .ignoresSafeArea()

            content
        }
        .navigationTitle("Trade")
        .navigationBarTitleDisplayMode(.large)
        .task {
            guard !appState.isGuest else { return }
            await viewModel.loadPortfolio()
        }
        .sheet(isPresented: $viewModel.showConfirmation) {
            if let transaction = viewModel.completedTransaction {
                TradeConfirmationSheet(
                    transaction: transaction,
                    onDone: {
                        viewModel.resetForm()
                    }
                )
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
            }
        }
        .alert(
            "Trade Error",
            isPresented: Binding(
                get: {
                    if case .error = viewModel.tradeState { return true }
                    return false
                },
                set: { if !$0 { viewModel.dismissError() } }
            )
        ) {
            Button("OK") { viewModel.dismissError() }
        } message: {
            if case .error(let msg) = viewModel.tradeState {
                Text(msg)
            }
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        if appState.isGuest {
            guestPrompt
        } else {
            switch viewModel.tradeState {
            case .loading:
                JLoadingView("Loading portfolio...")
            case .error(let message) where !viewModel.hasStockSelected && viewModel.portfolioId == nil:
                JErrorView(message) {
                    Task { await viewModel.loadPortfolio() }
                }
            default:
                tradeForm
            }
        }
    }

    // MARK: - Guest Prompt

    private var guestPrompt: some View {
        VStack(spacing: JSpacing.lg) {
            Spacer()

            Image(systemName: "arrow.up.arrow.down.circle")
                .font(.system(size: 56))
                .foregroundStyle(JColor.primary)

            VStack(spacing: JSpacing.sm) {
                Text("Sign Up to Trade")
                    .font(JFont.title2)
                    .foregroundStyle(JColor.textPrimary)

                Text("Create an account to start paper trading with $25,000 in virtual cash. Compete against other traders and win real prizes.")
                    .font(JFont.subheadline)
                    .foregroundStyle(JColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, JSpacing.lg)
            }

            Button {
                appState.logout()
            } label: {
                Text("Create Account")
                    .font(JFont.calloutMedium)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, JSpacing.sm)
                    .background(JColor.primary, in: RoundedRectangle(cornerRadius: JRadius.medium))
            }
            .padding(.horizontal, JSpacing.xl)

            Spacer()
            Spacer()
        }
    }

    // MARK: - Trade Form

    private var tradeForm: some View {
        ScrollView {
            VStack(spacing: JSpacing.lg) {

                // Cash balance header
                cashBalanceHeader

                // Stock selector or selected stock display
                if viewModel.hasStockSelected {
                    selectedStockCard
                } else {
                    stockSearchSection
                }

                // Order configuration (only if a stock is selected)
                if viewModel.hasStockSelected {
                    sideSelector
                    quantitySection
                    orderTypeSection
                    orderSummaryCard
                    placeTradeButton
                    holdingsSection
                }
            }
            .padding(.horizontal, JSpacing.md)
            .padding(.bottom, JSpacing.xxl)
        }
        .scrollDismissesKeyboard(.interactively)
    }

    // MARK: - Cash Balance Header

    private var cashBalanceHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: JSpacing.xxxs) {
                Text("Available Cash")
                    .font(JFont.caption)
                    .foregroundStyle(JColor.textSecondary)

                Text(viewModel.formattedCashBalance)
                    .font(JFont.priceLarge)
                    .foregroundStyle(JColor.textPrimary)
            }

            Spacer()

            JTextBadge("Paper Trading", color: JColor.accent, style: .tinted)
        }
        .padding(.top, JSpacing.xs)
    }

    // MARK: - Stock Search

    private var stockSearchSection: some View {
        VStack(spacing: JSpacing.sm) {
            JTextField(
                "Search Stock",
                text: $viewModel.searchQuery,
                placeholder: "Search by ticker or company name...",
                keyboardType: .default,
                autocapitalization: .characters
            )
            .focused($focusedField, equals: .search)
            .onChange(of: viewModel.searchQuery) { _, _ in
                Task { await viewModel.searchStocks() }
            }

            if viewModel.isSearching {
                JInlineLoading("Searching...")
                    .padding(.vertical, JSpacing.xs)
            }

            if !viewModel.searchResults.isEmpty {
                searchResultsList
            } else if !viewModel.searchQuery.isEmpty && !viewModel.isSearching {
                emptySearchState
            }
        }
    }

    private var searchResultsList: some View {
        JCard {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.searchResults.prefix(8)) { result in
                    Button {
                        viewModel.selectStock(result)
                        focusedField = nil
                    } label: {
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

                            if let exchange = result.exchange {
                                Text(exchange)
                                    .font(JFont.caption)
                                    .foregroundStyle(JColor.textTertiary)
                            }

                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(JColor.textTertiary)
                        }
                        .padding(.vertical, JSpacing.sm)
                    }

                    if result.id != viewModel.searchResults.prefix(8).last?.id {
                        Divider()
                            .foregroundStyle(JColor.divider)
                    }
                }
            }
        }
    }

    private var emptySearchState: some View {
        HStack(spacing: JSpacing.xs) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(JColor.textTertiary)
            Text("No results found")
                .font(JFont.subheadline)
                .foregroundStyle(JColor.textSecondary)
        }
        .padding(.vertical, JSpacing.md)
    }

    // MARK: - Selected Stock Card

    private var selectedStockCard: some View {
        JCard {
            VStack(spacing: JSpacing.sm) {
                HStack {
                    VStack(alignment: .leading, spacing: JSpacing.xxxs) {
                        Text(viewModel.selectedTicker)
                            .font(JFont.title2)
                            .foregroundStyle(JColor.textPrimary)

                        if let name = viewModel.quote?.companyName {
                            Text(name)
                                .font(JFont.subheadline)
                                .foregroundStyle(JColor.textSecondary)
                                .lineLimit(1)
                        }
                    }

                    Spacer()

                    Button {
                        viewModel.clearSelection()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(JColor.textTertiary)
                    }
                }

                if viewModel.isLoadingQuote {
                    JInlineLoading("Fetching price...")
                } else if let quote = viewModel.quote {
                    HStack(alignment: .bottom) {
                        Text("$\(quote.currentPrice.formatted(.number.precision(.fractionLength(2))))")
                            .font(JFont.priceLarge)
                            .foregroundStyle(JColor.textPrimary)

                        Spacer()

                        VStack(alignment: .trailing, spacing: JSpacing.xxxs) {
                            JPriceChangeView(quote.changeDollar, style: .dollar)
                            JPriceChangeView(quote.changePercent, style: .percent)
                        }
                    }

                    // Price details row
                    HStack(spacing: JSpacing.md) {
                        priceDetailItem(label: "Open", value: quote.openPrice)
                        priceDetailItem(label: "High", value: quote.dayHigh)
                        priceDetailItem(label: "Low", value: quote.dayLow)
                        priceDetailItem(label: "Prev Close", value: quote.previousClose)
                    }
                    .padding(.top, JSpacing.xxs)
                }
            }
        }
    }

    private func priceDetailItem(label: String, value: Double?) -> some View {
        VStack(spacing: JSpacing.xxxs) {
            Text(label)
                .font(JFont.caption2)
                .foregroundStyle(JColor.textTertiary)

            if let value {
                Text("$\(value.formatted(.number.precision(.fractionLength(2))))")
                    .font(JFont.priceSmall)
                    .foregroundStyle(JColor.textSecondary)
            } else {
                Text("--")
                    .font(JFont.priceSmall)
                    .foregroundStyle(JColor.textTertiary)
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Side Selector

    private var sideSelector: some View {
        VStack(alignment: .leading, spacing: JSpacing.xs) {
            Text("Direction")
                .font(JFont.subheadlineMedium)
                .foregroundStyle(JColor.textSecondary)

            HStack(spacing: 0) {
                sideButton(.buy, label: "Buy", color: JColor.gainPositive)
                sideButton(.sell, label: "Sell", color: JColor.gainNegative)
            }
            .background(JColor.surfaceSecondary)
            .clipShape(RoundedRectangle(cornerRadius: JRadius.small))
        }
    }

    private func sideButton(_ tradeSide: TradeSide, label: String, color: Color) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                viewModel.toggleSide(tradeSide)
            }
        } label: {
            Text(label)
                .font(JFont.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, JSpacing.sm)
                .foregroundStyle(viewModel.side == tradeSide ? .white : JColor.textSecondary)
                .background(viewModel.side == tradeSide ? color : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: JRadius.small))
        }
    }

    // MARK: - Quantity Section

    private var quantitySection: some View {
        VStack(alignment: .leading, spacing: JSpacing.xs) {
            HStack {
                Text("Shares")
                    .font(JFont.subheadlineMedium)
                    .foregroundStyle(JColor.textSecondary)

                Spacer()

                Button {
                    viewModel.setMaxQuantity()
                } label: {
                    Text(viewModel.side == .buy ? "Max Buy" : "Max Sell")
                        .font(JFont.captionMedium)
                        .foregroundStyle(JColor.primary)
                }
            }

            HStack(spacing: JSpacing.sm) {
                // Stepper minus button
                Button {
                    let current = viewModel.quantity
                    if current > 1 {
                        viewModel.quantityText = String(format: "%.0f", current - 1)
                    }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(viewModel.quantity > 1 ? JColor.primary : JColor.textTertiary)
                }
                .disabled(viewModel.quantity <= 1)

                TextField("0", text: $viewModel.quantityText)
                    .font(JFont.priceLarge)
                    .foregroundStyle(JColor.textPrimary)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .quantity)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, JSpacing.sm)
                    .background(JColor.surfaceSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: JRadius.small))

                // Stepper plus button
                Button {
                    let current = viewModel.quantity
                    viewModel.quantityText = String(format: "%.0f", current + 1)
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(JColor.primary)
                }
            }

            if viewModel.side == .sell && viewModel.sharesOwned > 0 {
                Text("You own \(String(format: "%.0f", viewModel.sharesOwned)) shares")
                    .font(JFont.caption)
                    .foregroundStyle(JColor.textTertiary)
            }
        }
    }

    // MARK: - Order Type Section

    private var orderTypeSection: some View {
        VStack(alignment: .leading, spacing: JSpacing.xs) {
            Text("Order Type")
                .font(JFont.subheadlineMedium)
                .foregroundStyle(JColor.textSecondary)

            Picker("Order Type", selection: $viewModel.orderType) {
                ForEach(OrderType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(.segmented)

            if viewModel.orderType == .limit {
                limitPriceInput
            }
        }
    }

    private var limitPriceInput: some View {
        VStack(alignment: .leading, spacing: JSpacing.xs) {
            Text("Limit Price")
                .font(JFont.subheadlineMedium)
                .foregroundStyle(JColor.textSecondary)

            HStack(spacing: JSpacing.xs) {
                Text("$")
                    .font(JFont.priceLarge)
                    .foregroundStyle(JColor.textSecondary)

                TextField("0.00", text: $viewModel.limitPriceText)
                    .font(JFont.priceLarge)
                    .foregroundStyle(JColor.textPrimary)
                    .keyboardType(.decimalPad)
                    .focused($focusedField, equals: .limitPrice)
            }
            .padding(.horizontal, JSpacing.sm)
            .padding(.vertical, JSpacing.sm)
            .background(JColor.surfaceSecondary)
            .clipShape(RoundedRectangle(cornerRadius: JRadius.small))

            Text("Order executes when price reaches your limit")
                .font(JFont.caption)
                .foregroundStyle(JColor.textTertiary)
        }
        .transition(.opacity.combined(with: .move(edge: .top)))
    }

    // MARK: - Order Summary

    private var orderSummaryCard: some View {
        JCardBordered {
            VStack(spacing: JSpacing.sm) {
                Text("Order Summary")
                    .font(JFont.headline)
                    .foregroundStyle(JColor.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Divider()
                    .foregroundStyle(JColor.divider)

                summaryRow(
                    label: "\(viewModel.side == .buy ? "Buy" : "Sell") \(viewModel.selectedTicker)",
                    value: "\(viewModel.quantityText.isEmpty ? "0" : viewModel.quantityText) shares"
                )

                summaryRow(
                    label: viewModel.orderType == .market ? "Market Price" : "Limit Price",
                    value: "$\(viewModel.effectivePrice.formatted(.number.precision(.fractionLength(2))))"
                )

                Divider()
                    .foregroundStyle(JColor.divider)

                HStack {
                    Text("Estimated \(viewModel.side == .buy ? "Cost" : "Proceeds")")
                        .font(JFont.headline)
                        .foregroundStyle(JColor.textPrimary)

                    Spacer()

                    Text("$\(viewModel.totalAmount.formatted(.number.precision(.fractionLength(2))))")
                        .font(JFont.priceLarge)
                        .foregroundStyle(viewModel.side == .buy ? JColor.gainNegative : JColor.gainPositive)
                }

                summaryRow(
                    label: "Cash After Trade",
                    value: "$\(viewModel.estimatedCashAfter.formatted(.number.precision(.fractionLength(2))))",
                    valueColor: viewModel.estimatedCashAfter >= 0 ? JColor.textSecondary : JColor.gainNegative
                )

                // Validation error
                if let error = viewModel.validationError {
                    HStack(spacing: JSpacing.xs) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.caption)
                        Text(error)
                            .font(JFont.caption)
                    }
                    .foregroundStyle(JColor.error)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, JSpacing.xxs)
                }
            }
        }
    }

    private func summaryRow(label: String, value: String, valueColor: Color = JColor.textSecondary) -> some View {
        HStack {
            Text(label)
                .font(JFont.subheadline)
                .foregroundStyle(JColor.textSecondary)
            Spacer()
            Text(value)
                .font(JFont.price)
                .foregroundStyle(valueColor)
        }
    }

    // MARK: - Place Trade Button

    private var placeTradeButton: some View {
        JButton(
            viewModel.side == .buy ? "Buy \(viewModel.selectedTicker)" : "Sell \(viewModel.selectedTicker)",
            style: .primary,
            size: .large,
            isLoading: viewModel.tradeState == .executing,
            isDisabled: !viewModel.canPlaceTrade
        ) {
            focusedField = nil
            Task { await viewModel.placeTrade() }
        }
    }

    // MARK: - Holdings Section

    private var holdingsSection: some View {
        Group {
            if !viewModel.positions.isEmpty {
                VStack(alignment: .leading, spacing: JSpacing.sm) {
                    Text("Your Holdings")
                        .font(JFont.headline)
                        .foregroundStyle(JColor.textPrimary)

                    JCard {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.positions, id: \.id) { position in
                                holdingRow(position)

                                if position.id != viewModel.positions.last?.id {
                                    Divider()
                                        .foregroundStyle(JColor.divider)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private func holdingRow(_ position: PositionDTO) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: JSpacing.xxxs) {
                Text(position.ticker)
                    .font(JFont.headline)
                    .foregroundStyle(JColor.textPrimary)

                Text("\(String(format: "%.0f", position.quantity)) shares")
                    .font(JFont.caption)
                    .foregroundStyle(JColor.textSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: JSpacing.xxxs) {
                Text("$\(position.marketValue.formatted(.number.precision(.fractionLength(2))))")
                    .font(JFont.price)
                    .foregroundStyle(JColor.textPrimary)

                JPriceChangeView(position.unrealizedPnl, style: .dollar)
            }
        }
        .padding(.vertical, JSpacing.xs)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.selectStock(
                SearchResultDTO(
                    symbol: position.ticker,
                    name: "",
                    exchange: nil,
                    type: nil,
                    score: nil
                )
            )
        }
    }
}

// MARK: - Trade Confirmation Sheet

private struct TradeConfirmationSheet: View {
    let transaction: TransactionDTO
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: JSpacing.lg) {
            Spacer()

            // Success icon
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64, weight: .light))
                .foregroundStyle(JColor.success)

            VStack(spacing: JSpacing.xs) {
                Text("Trade Executed!")
                    .font(JFont.title2)
                    .foregroundStyle(JColor.textPrimary)

                Text("Your \(transaction.side) order has been filled")
                    .font(JFont.subheadline)
                    .foregroundStyle(JColor.textSecondary)
            }

            // Trade details
            JCardBordered {
                VStack(spacing: JSpacing.sm) {
                    confirmationRow(label: "Stock", value: transaction.ticker)
                    confirmationRow(label: "Side", value: transaction.side.capitalized)
                    confirmationRow(
                        label: "Quantity",
                        value: String(format: "%.0f shares", transaction.quantity)
                    )
                    confirmationRow(
                        label: "Price",
                        value: "$\(transaction.price.formatted(.number.precision(.fractionLength(2))))"
                    )

                    Divider()
                        .foregroundStyle(JColor.divider)

                    HStack {
                        Text("Total")
                            .font(JFont.headline)
                            .foregroundStyle(JColor.textPrimary)
                        Spacer()
                        Text("$\(transaction.totalValue.formatted(.number.precision(.fractionLength(2))))")
                            .font(JFont.priceLarge)
                            .foregroundStyle(JColor.textPrimary)
                    }
                }
            }
            .padding(.horizontal, JSpacing.md)

            Spacer()

            JButton("Done", style: .primary, size: .large) {
                onDone()
            }
            .padding(.horizontal, JSpacing.md)
            .padding(.bottom, JSpacing.md)
        }
        .background(JColor.background)
    }

    private func confirmationRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(JFont.subheadline)
                .foregroundStyle(JColor.textSecondary)
            Spacer()
            Text(value)
                .font(JFont.price)
                .foregroundStyle(JColor.textPrimary)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        TradeView()
    }
}
