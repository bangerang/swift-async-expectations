import XCTest
@testable import AsyncExpectations

final class ExpectGreaterThanOrEqualTests: XCTestCase {
    func testExpectGreaterThanOrEqualShouldFail() async throws {
        try await expectGreaterThanOrEqual(timeout: 0.1, { 2 }, { 3 })
        XCTExpectFailure()
    }
    func testExpectGreaterThanOrEqualShouldFailAutoClosure() async throws {
        try await expectGreaterThanOrEqual(timeout: 0.1, 2, 10)
        XCTExpectFailure()
    }
    func testExpectGreaterThanOrEqualShouldSucceed() async throws {
        try await expectGreaterThanOrEqual(2.0, 2.0)
    }
    func testExpectGreaterThanOrEqualShouldSucceedAutoClosure() async throws {
        try await expectGreaterThanOrEqual({ 2 }, { 1.2 })
    }
}
