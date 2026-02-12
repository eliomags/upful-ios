//
//  SubscriptionViewModelTests.swift
//  UpfulTests
//
//  Unit tests for SubscriptionViewModel pure logic
//

import XCTest
@testable import Upful

final class SubscriptionViewModelTests: XCTestCase {

    private var storeKitService: StoreKitService!
    private var sut: SubscriptionViewModel!

    override func setUp() {
        super.setUp()
        storeKitService = StoreKitService()
        sut = SubscriptionViewModel(storeKitService: storeKitService)
    }

    override func tearDown() {
        sut = nil
        storeKitService = nil
        super.tearDown()
    }

    // MARK: - Initial State

    func testInitialState() {
        XCTAssertEqual(sut.state, .idle, "State should be .idle on init")
    }

    func testInitialState_noSelectedProduct() {
        // StoreKitService starts with empty products, so no yearly subscription can be auto-selected
        XCTAssertNil(sut.selectedProduct, "selectedProduct should be nil when no products are loaded")
    }

    func testInitialState_subscriptionProductsEmpty() {
        XCTAssertTrue(sut.subscriptionProducts.isEmpty,
                       "subscriptionProducts should be empty before products are loaded")
    }

    // MARK: - clearError

    func testClearError_fromErrorState() {
        // Force the state to error by attempting purchase with no product
        // We can't directly set state since it's private(set), so we test clearError via the ViewModel

        // The ViewModel starts at .idle -- clearError should be a no-op
        sut.clearError()
        XCTAssertEqual(sut.state, .idle, "clearError should leave .idle state unchanged")
    }

    func testClearError_doesNothingWhenIdle() {
        sut.clearError()
        XCTAssertEqual(sut.state, .idle, "clearError on .idle should remain .idle")
    }

    // MARK: - errorMessage

    func testErrorMessage_whenIdle_returnsNil() {
        XCTAssertNil(sut.errorMessage, "errorMessage should be nil when state is .idle")
    }

    func testErrorMessage_afterPurchaseWithNoProduct() async {
        // Calling purchase() with no selectedProduct triggers an error
        await sut.purchase()

        XCTAssertNotNil(sut.errorMessage, "errorMessage should be non-nil after failed purchase")
        XCTAssertEqual(sut.errorMessage, "Please select a subscription plan",
                        "Should show correct error when no product is selected")
    }

    func testClearError_afterError_resetsToIdle() async {
        // First put VM in error state
        await sut.purchase()
        XCTAssertEqual(sut.state, .error("Please select a subscription plan"))

        // Now clear the error
        sut.clearError()
        XCTAssertEqual(sut.state, .idle, "clearError should reset error state to .idle")
        XCTAssertNil(sut.errorMessage, "errorMessage should be nil after clearing")
    }

    // MARK: - isPremium delegation

    func testIsPremium_defaultsFalse() {
        // StoreKitService defaults isPremium to false
        XCTAssertFalse(sut.isPremium, "isPremium should default to false")
    }

    // MARK: - State Equatable

    func testStateEquatable_idleEqualsIdle() {
        let a: SubscriptionViewModel.State = .idle
        let b: SubscriptionViewModel.State = .idle
        XCTAssertEqual(a, b)
    }

    func testStateEquatable_errorMatchesMessage() {
        let a: SubscriptionViewModel.State = .error("oops")
        let b: SubscriptionViewModel.State = .error("oops")
        XCTAssertEqual(a, b)
    }

    func testStateEquatable_differentErrors() {
        let a: SubscriptionViewModel.State = .error("one")
        let b: SubscriptionViewModel.State = .error("two")
        XCTAssertNotEqual(a, b)
    }
}
