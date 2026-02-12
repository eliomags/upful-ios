//
//  PayoutDTOsTests.swift
//  UpfulTests
//
//  Unit tests for PayoutDTOs decoding, encoding, and helper properties
//

import XCTest
@testable import Upful

final class PayoutDTOsTests: XCTestCase {

    // MARK: - PayoutBalanceDTO Decoding

    func testPayoutBalanceDTODecoding() throws {
        let json = """
        {
            "available_balance": 245.50,
            "pending_balance": 75.00,
            "total_earned": 1250.75,
            "currency": "USD"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dto = try decoder.decode(PayoutBalanceDTO.self, from: json)

        XCTAssertEqual(dto.availableBalance, 245.50, accuracy: 0.001)
        XCTAssertEqual(dto.pendingBalance, 75.00, accuracy: 0.001)
        XCTAssertEqual(dto.totalEarned, 1250.75, accuracy: 0.001)
        XCTAssertEqual(dto.currency, "USD")
    }

    func testPayoutBalanceDTODecoding_zeroes() throws {
        let json = """
        {
            "available_balance": 0,
            "pending_balance": 0,
            "total_earned": 0,
            "currency": "EUR"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dto = try decoder.decode(PayoutBalanceDTO.self, from: json)

        XCTAssertEqual(dto.availableBalance, 0)
        XCTAssertEqual(dto.pendingBalance, 0)
        XCTAssertEqual(dto.totalEarned, 0)
        XCTAssertEqual(dto.currency, "EUR")
    }

    // MARK: - PayoutHistoryItemDTO Decoding

    func testPayoutHistoryItemDTODecoding_withCompletedAt() throws {
        let json = """
        {
            "id": "payout-123",
            "amount": 150.00,
            "method": "stripe",
            "status": "completed",
            "requested_at": "2026-02-01T10:00:00Z",
            "completed_at": "2026-02-03T14:30:00Z"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dto = try decoder.decode(PayoutHistoryItemDTO.self, from: json)

        XCTAssertEqual(dto.id, "payout-123")
        XCTAssertEqual(dto.amount, 150.00, accuracy: 0.001)
        XCTAssertEqual(dto.method, "stripe")
        XCTAssertEqual(dto.status, "completed")
        XCTAssertEqual(dto.requestedAt, "2026-02-01T10:00:00Z")
        XCTAssertEqual(dto.completedAt, "2026-02-03T14:30:00Z")
    }

    func testPayoutHistoryItemDTODecoding_withNilCompletedAt() throws {
        let json = """
        {
            "id": "payout-456",
            "amount": 75.00,
            "method": "paypal",
            "status": "pending",
            "requested_at": "2026-02-10T16:00:00Z",
            "completed_at": null
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dto = try decoder.decode(PayoutHistoryItemDTO.self, from: json)

        XCTAssertEqual(dto.id, "payout-456")
        XCTAssertEqual(dto.amount, 75.00, accuracy: 0.001)
        XCTAssertEqual(dto.method, "paypal")
        XCTAssertEqual(dto.status, "pending")
        XCTAssertNil(dto.completedAt, "completedAt should be nil for pending payouts")
    }

    // MARK: - PayoutRequestBody Encoding

    func testPayoutRequestBodyEncoding() throws {
        let body = PayoutRequestBody(amount: 100.0, method: "stripe")

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try encoder.encode(body)

        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        let dict = try XCTUnwrap(json)
        XCTAssertEqual(dict["amount"] as! Double, 100.0, accuracy: 0.001)
        XCTAssertEqual(dict["method"] as? String, "stripe")
    }

    func testPayoutRequestBodyEncoding_paypalMethod() throws {
        let body = PayoutRequestBody(amount: 25.50, method: "paypal")

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try encoder.encode(body)

        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        let dict = try XCTUnwrap(json)
        XCTAssertEqual(dict["amount"] as! Double, 25.50, accuracy: 0.001)
        XCTAssertEqual(dict["method"] as? String, "paypal")
    }

    // MARK: - statusDisplayText

    func testStatusDisplayText_completed() {
        let dto = PayoutHistoryItemDTO(
            id: "1", amount: 100, method: "stripe", status: "completed",
            requestedAt: "2026-02-01T10:00:00Z", completedAt: "2026-02-03T14:30:00Z"
        )
        XCTAssertEqual(dto.statusDisplayText, "Completed")
    }

    func testStatusDisplayText_pending() {
        let dto = PayoutHistoryItemDTO(
            id: "2", amount: 50, method: "paypal", status: "pending",
            requestedAt: "2026-02-01T10:00:00Z", completedAt: nil
        )
        XCTAssertEqual(dto.statusDisplayText, "Pending")
    }

    func testStatusDisplayText_failed() {
        let dto = PayoutHistoryItemDTO(
            id: "3", amount: 25, method: "stripe", status: "failed",
            requestedAt: "2026-02-01T10:00:00Z", completedAt: nil
        )
        XCTAssertEqual(dto.statusDisplayText, "Failed")
    }

    // MARK: - statusBadgeColor

    func testStatusBadgeColor_completed() {
        let dto = PayoutHistoryItemDTO(
            id: "1", amount: 100, method: "stripe", status: "completed",
            requestedAt: "2026-02-01T10:00:00Z", completedAt: "2026-02-03T14:30:00Z"
        )
        let color = dto.statusBadgeColor
        XCTAssertEqual(color.text, "success")
        XCTAssertEqual(color.background, "success")
    }

    func testStatusBadgeColor_pending() {
        let dto = PayoutHistoryItemDTO(
            id: "2", amount: 50, method: "paypal", status: "pending",
            requestedAt: "2026-02-01T10:00:00Z", completedAt: nil
        )
        let color = dto.statusBadgeColor
        XCTAssertEqual(color.text, "warning")
        XCTAssertEqual(color.background, "warning")
    }

    func testStatusBadgeColor_failed() {
        let dto = PayoutHistoryItemDTO(
            id: "3", amount: 25, method: "stripe", status: "failed",
            requestedAt: "2026-02-01T10:00:00Z", completedAt: nil
        )
        let color = dto.statusBadgeColor
        XCTAssertEqual(color.text, "error")
        XCTAssertEqual(color.background, "error")
    }

    func testStatusBadgeColor_unknown() {
        let dto = PayoutHistoryItemDTO(
            id: "4", amount: 10, method: "stripe", status: "refunded",
            requestedAt: "2026-02-01T10:00:00Z", completedAt: nil
        )
        let color = dto.statusBadgeColor
        XCTAssertEqual(color.text, "textSecondary")
        XCTAssertEqual(color.background, "surfaceSecondary")
    }
}
