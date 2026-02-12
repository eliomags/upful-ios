//
//  PayoutEndpointsTests.swift
//  UpfulTests
//
//  Unit tests for PayoutEndpoints and PayoutMethod
//

import XCTest
@testable import Upful

final class PayoutEndpointsTests: XCTestCase {

    // MARK: - getPayoutHistory

    func testGetPayoutHistory_path() {
        let endpoint = PayoutEndpoints.getPayoutHistory()
        XCTAssertEqual(endpoint.path, "/api/payouts/history")
    }

    func testGetPayoutHistory_method() {
        let endpoint = PayoutEndpoints.getPayoutHistory()
        XCTAssertEqual(endpoint.method, .get)
    }

    func testGetPayoutHistory_noBody() {
        let endpoint = PayoutEndpoints.getPayoutHistory()
        XCTAssertNil(endpoint.body, "GET history should not have a body")
    }

    // MARK: - getPayoutBalance

    func testGetPayoutBalance_path() {
        let endpoint = PayoutEndpoints.getPayoutBalance()
        XCTAssertEqual(endpoint.path, "/api/payouts/balance")
    }

    func testGetPayoutBalance_method() {
        let endpoint = PayoutEndpoints.getPayoutBalance()
        XCTAssertEqual(endpoint.method, .get)
    }

    func testGetPayoutBalance_noBody() {
        let endpoint = PayoutEndpoints.getPayoutBalance()
        XCTAssertNil(endpoint.body, "GET balance should not have a body")
    }

    // MARK: - requestPayout

    func testRequestPayout_path() {
        let endpoint = PayoutEndpoints.requestPayout(amount: 100, method: .stripe)
        XCTAssertEqual(endpoint.path, "/api/payouts/request")
    }

    func testRequestPayout_method() {
        let endpoint = PayoutEndpoints.requestPayout(amount: 100, method: .stripe)
        XCTAssertEqual(endpoint.method, .post)
    }

    func testRequestPayout_hasBody() {
        let endpoint = PayoutEndpoints.requestPayout(amount: 50, method: .paypal)
        XCTAssertNotNil(endpoint.body, "POST request should have a body")
    }

    func testRequestPayout_requiresAuth() {
        let endpoint = PayoutEndpoints.requestPayout(amount: 50, method: .stripe)
        XCTAssertTrue(endpoint.requiresAuth, "Payout request should require auth")
    }

    // MARK: - PayoutMethod displayName

    func testPayoutMethodDisplayName_stripe() {
        XCTAssertEqual(PayoutMethod.stripe.displayName, "Stripe")
    }

    func testPayoutMethodDisplayName_paypal() {
        XCTAssertEqual(PayoutMethod.paypal.displayName, "PayPal")
    }

    // MARK: - PayoutMethod icon

    func testPayoutMethodIcon_stripe() {
        XCTAssertEqual(PayoutMethod.stripe.icon, "creditcard.fill")
    }

    func testPayoutMethodIcon_paypal() {
        XCTAssertEqual(PayoutMethod.paypal.icon, "dollarsign.circle.fill")
    }

    // MARK: - PayoutMethod Identifiable

    func testPayoutMethodID_matchesRawValue() {
        for method in PayoutMethod.allCases {
            XCTAssertEqual(method.id, method.rawValue,
                           "\(method) id should match its rawValue")
        }
    }

    // MARK: - PayoutMethod Codable

    func testPayoutMethodCodable_roundTrip() throws {
        for method in PayoutMethod.allCases {
            let encoded = try JSONEncoder().encode(method)
            let decoded = try JSONDecoder().decode(PayoutMethod.self, from: encoded)
            XCTAssertEqual(decoded, method, "Round-trip coding should preserve \(method)")
        }
    }

    // MARK: - PayoutMethod CaseIterable

    func testPayoutMethod_allCases() {
        XCTAssertEqual(PayoutMethod.allCases.count, 2, "Should have exactly 2 payout methods")
        XCTAssertTrue(PayoutMethod.allCases.contains(.stripe))
        XCTAssertTrue(PayoutMethod.allCases.contains(.paypal))
    }
}
