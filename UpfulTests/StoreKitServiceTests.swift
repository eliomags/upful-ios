//
//  StoreKitServiceTests.swift
//  UpfulTests
//
//  Unit tests for StoreKitService product ID configuration and initial state
//

import XCTest
@testable import Upful

final class StoreKitServiceTests: XCTestCase {

    private var sut: StoreKitService!

    override func setUp() {
        super.setUp()
        sut = StoreKitService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Initial State

    func testInitialState_productsEmpty() {
        XCTAssertTrue(sut.products.isEmpty, "Products should be empty before loading")
    }

    func testInitialState_notPremium() {
        XCTAssertFalse(sut.isPremium, "isPremium should be false initially")
    }

    func testInitialState_notLoading() {
        XCTAssertFalse(sut.isLoading, "isLoading should be false initially")
    }

    func testInitialState_purchasedSubscriptionsEmpty() {
        XCTAssertTrue(sut.purchasedSubscriptions.isEmpty,
                       "purchasedSubscriptions should be empty initially")
    }

    // MARK: - Filtered Products (empty when no products loaded)

    func testSubscriptionProducts_emptyWhenNoProducts() {
        XCTAssertTrue(sut.subscriptionProducts.isEmpty,
                       "subscriptionProducts should be empty when products are not loaded")
    }

    func testConsumableProducts_emptyWhenNoProducts() {
        XCTAssertTrue(sut.consumableProducts.isEmpty,
                       "consumableProducts should be empty when products are not loaded")
    }

    // MARK: - ProductID Constants

    func testProductID_premiumMonthly() {
        XCTAssertEqual(StoreKitService.ProductID.premiumMonthly, "com.jyanik.premium.monthly")
    }

    func testProductID_premiumYearly() {
        XCTAssertEqual(StoreKitService.ProductID.premiumYearly, "com.jyanik.premium.yearly")
    }

    func testProductID_cashSmall() {
        XCTAssertEqual(StoreKitService.ProductID.cashSmall, "com.jyanik.cash.small")
    }

    func testProductID_cashLarge() {
        XCTAssertEqual(StoreKitService.ProductID.cashLarge, "com.jyanik.cash.large")
    }

    // MARK: - ProductID Sets

    func testProductIDSets_subscriptionsContainsCorrectIDs() {
        let subs = StoreKitService.ProductID.subscriptions
        XCTAssertEqual(subs.count, 2, "Should have exactly 2 subscription product IDs")
        XCTAssertTrue(subs.contains(StoreKitService.ProductID.premiumMonthly))
        XCTAssertTrue(subs.contains(StoreKitService.ProductID.premiumYearly))
    }

    func testProductIDSets_consumablesContainsCorrectIDs() {
        let cons = StoreKitService.ProductID.consumables
        XCTAssertEqual(cons.count, 2, "Should have exactly 2 consumable product IDs")
        XCTAssertTrue(cons.contains(StoreKitService.ProductID.cashSmall))
        XCTAssertTrue(cons.contains(StoreKitService.ProductID.cashLarge))
    }

    func testProductIDSets_allEqualsUnionOfSubsAndConsumables() {
        let all = StoreKitService.ProductID.all
        let union = StoreKitService.ProductID.subscriptions.union(StoreKitService.ProductID.consumables)

        XCTAssertEqual(all, union, "all should equal subscriptions union consumables")
        XCTAssertEqual(all.count, 4, "all should have exactly 4 product IDs")
    }

    func testProductIDSets_noOverlap() {
        let overlap = StoreKitService.ProductID.subscriptions.intersection(
            StoreKitService.ProductID.consumables
        )
        XCTAssertTrue(overlap.isEmpty, "Subscription and consumable IDs should not overlap")
    }
}
