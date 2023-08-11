import XCTest
@testable import AsyncExpectations

final class ExpectLessThanTests: XCTestCase {
    func testExpectLessThanShouldFail() async throws {
        try await expectLessThan(timeout: 0.1, { 2 }, { 2 })
        XCTExpectFailure()
    }
    func testExpectLessThanShouldFailAutoClosure() async throws {
        try await expectLessThan(timeout: 0.1, 3, 2)
        XCTExpectFailure()
    }
    func testExpectLessThanShouldSucceed() async throws {
        try await expectLessThan(1, 2)
    }
    func testExpectLessThanShouldSucceedAutoClosure() async throws {
        try await expectLessThan({ 1.1 }, { 1.2 })
    }
}
