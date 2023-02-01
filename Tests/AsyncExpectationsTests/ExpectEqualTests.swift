import XCTest
@testable import AsyncExpectations

final class ExpectEqualTests: XCTestCase {
    func testExpectEqualShouldFail() throws {
        XCTExpectFailure {
            let expectation = expectation(description: #function)
            Task {
                defer {
                    expectation.fulfill()
                }
                try await expectEqual(timeout: 0.1, { 1 }, { 2 })
            }
            wait(for: [expectation], timeout: 1)
            
        }
    }
    func testExpectEqualShouldFailAutoClosure() throws {
        XCTExpectFailure {
            let expectation = expectation(description: #function)
            Task {
                defer {
                    expectation.fulfill()
                }
                try await expectEqual(timeout: 0.1, 1, 2)
            }
            wait(for: [expectation], timeout: 1)
        }
    }
    func testExpectEqualShouldSucceed() async throws {
        try await expectEqual(1, 1)
    }
    func testExpectEqualShouldSucceedAutoClosure() async throws {
        try await expectEqual({ 1 }, { 1 })
    }
}
