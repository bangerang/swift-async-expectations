import XCTest
@testable import AsyncExpectations

final class ExpectGreaterThanTests: XCTestCase {
    func testExpectGreaterThanShouldFail() async throws {
        try await expectGreaterThan(timeout: 0.1, { 2 }, { 3 })
        XCTExpectFailure()
    }
    func testExpectGreaterThanShouldFailAutoClosure() async throws {
        try await expectGreaterThan(timeout: 0.1, 2, 10)
        XCTExpectFailure()
    }
    func testExpectGreaterThanShouldSucceed() async throws {
        try await expectGreaterThan(10, 2.0)
    }
    func testExpectGreaterThanShouldSucceedAutoClosure() async throws {
        try await expectGreaterThan({ 2 }, { 1.2 })
    }
}
