import XCTest
@testable import AsyncExpectations

final class ExpectEqualTests: XCTestCase {
    func testExpectEqualShouldFail() async throws {
        try await expectEqual(timeout: 0.1, { 1 }, { 2 })
        XCTExpectFailure()
    }
    func testExpectEqualShouldFailAutoClosure() async throws {
        try await expectEqual(timeout: 0.1, 1, 2)
        XCTExpectFailure()
    }
    func testExpectEqualShouldSucceed() async throws {
        try await expectEqual(1, 1)
    }
    func testExpectEqualShouldSucceedAutoClosure() async throws {
        try await expectEqual({ 1 }, { 1 })
    }
}
