import XCTest
@testable import AsyncExpectations

final class ExpectLessThanOrEqualTests: XCTestCase {
    func testExpectLessThanOrEqualShouldFail() async throws {
        try await expectLessThanOrEqual(timeout: 0.1, { 3 }, { 2 })
        XCTExpectFailure()
    }
    func testExpectLessThanOrEqualShouldFailAutoClosure() async throws {
        try await expectLessThanOrEqual(timeout: 0.1, 10, 2)
        XCTExpectFailure()
    }
    func testExpectLessThanOrEqualShouldSucceed() async throws {
        try await expectLessThanOrEqual(2, 2)
    }
    func testExpectLessThanOrEqualShouldSucceedAutoClosure() async throws {
        try await expectLessThanOrEqual({ 1.1 }, { 1.2 })
    }
}
