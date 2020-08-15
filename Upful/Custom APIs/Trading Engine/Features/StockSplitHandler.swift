import Foundation

final class StockSplitHandler {
    
    let ticker: String
    private(set) var transactions: [Transaction]
    
    typealias StockSplitDownloader = ((String), @escaping (Result<[StockSplit], Error>) -> Void) -> ()
    var fetchSplit: StockSplitDownloader? = StockSplitFetcher().getStockSplit
    
    // MARK: - Initializer
    
    init(ticker: String, transactions: [Transaction]) {
        self.ticker = ticker
        self.transactions = transactions.filter{ $0.ticker == ticker }
    }
    
    // MARK: - Methods
    
    func start(_ dispatchGroup: DispatchGroup? = nil, completion: ((Bool) -> Void)? = nil) {
        dispatchGroup?.enter()
        let applySplit = apply
        let needsApply = checkIfTransactionsNeedsApply
        
        getLatestSplit { latestSplit in
            guard let latestSplit = latestSplit else {
                completion?(false)
                dispatchGroup?.leave()
                return
            }
            let shouldApply = needsApply(latestSplit.exDateAsDate)
            if shouldApply { applySplit(latestSplit) }
            
            completion?(shouldApply)
            dispatchGroup?.leave()
        }
    }
    
    func getLatestSplit(_ completion: @escaping (StockSplit?) -> Void) {
        fetchSplit?(ticker) { result in
            let splits = try? result.get()
            let latestStockSplit = splits?.getRecent()
            completion((latestStockSplit))
        }
    }
    
    func checkIfTransactionsNeedsApply(exDate: Date) -> Bool {
        guard let transaction = transactions.getRecentTransaction() else { return false }
        let transactionDate = DateTransformer.convertStringToDate(transaction.transactionDate!)
        
        let isEXDateAfterTransactionDate = exDate.timeIntervalSince(transactionDate) > 0
        let isEXDateAfterLastAppliedStockSplitDate =
            exDate.timeIntervalSince(transaction.lastAppliedStockSplit ?? Date.distantPast) > 0
        
        return isEXDateAfterTransactionDate && isEXDateAfterLastAppliedStockSplitDate
    }
    
    func apply(_ stockSplitInfo: StockSplit) {
        for transaction in transactions {
            transaction.tradePrice = Double((Float(transaction.tradePrice) / stockSplitInfo.ratio))
            transaction.numberOfShares = Int32(Float(transaction.numberOfShares) * stockSplitInfo.ratio)
            transaction.lastAppliedStockSplit = stockSplitInfo.exDateAsDate
        }
    }
}

extension Array where Element == StockSplitHandler {
    func begin(dispatchGroup: DispatchGroup?) {
        forEach({ $0.start(dispatchGroup, completion: nil)})
    }
}

extension Array where Element == StockSplit {
    func getRecent() -> Element? {
        var latestSplit: StockSplit?
        
        for split in self {
            let currDate = split.exDateAsDate
            if currDate.timeIntervalSince(latestSplit?.exDateAsDate ??
                    Date.distantPast) > 0 {
                latestSplit = split
            }
        }
        return latestSplit
    }
}

extension Array where Element == Transaction {
    func getRecentTransaction() -> Transaction? {
        let transaction = self.sorted(by: {
            $0.transactionDate ?? "\(Date())" >
            $1.transactionDate ?? "\(Date())" }
        ).first

        return transaction
    }
}
