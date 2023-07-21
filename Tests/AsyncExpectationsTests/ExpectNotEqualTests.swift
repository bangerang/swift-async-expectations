import XCTest
@testable import AsyncExpectations

final class ExpectNotEqualTests: XCTestCase {
    func testExpectNotEqualShouldFail() async throws {
        try await expectNotEqual(timeout: 0.1, { 2 }, { 2 })
        XCTExpectFailure()
    }
    func testExpectNotEqualShouldFailAutoClosure() async throws {
        try await expectNotEqual(timeout: 0.1, 2, 2)
        XCTExpectFailure()
    }
    func testExpectNotEqualShouldSucceed() async throws {
        try await expectNotEqual(1, 2)
    }
    func testExpectNotEqualShouldSucceedAutoClosure() async throws {
        try await expectNotEqual({ 1 }, { 2 })
    }
}
