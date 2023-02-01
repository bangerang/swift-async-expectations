import XCTest
@testable import AsyncExpectations

final class ExpectGreaterThanOrEqualTests: XCTestCase {
    func testExpectGreaterThanOrEqualShouldFail() throws {
        XCTExpectFailure {
            let expectation = expectation(description: #function)
            Task {
                defer {
                    expectation.fulfill()
                }
                try await expectGreaterThanOrEqual(timeout: 0.1, { 2 }, { 3 })
            }
            wait(for: [expectation], timeout: 1)
            
        }
    }
    func testExpectGreaterThanOrEqualShouldFailAutoClosure() throws {
        XCTExpectFailure {
            let expectation = expectation(description: #function)
            Task {
                defer {
                    expectation.fulfill()
                }
                try await expectGreaterThanOrEqual(timeout: 0.1, 2, 10)
            }
            wait(for: [expectation], timeout: 1)
        }
    }
    func testExpectGreaterThanOrEqualShouldSucceed() async throws {
        try await expectGreaterThanOrEqual(2.0, 2.0)
    }
    func testExpectGreaterThanOrEqualShouldSucceedAutoClosure() async throws {
        try await expectGreaterThanOrEqual({ 2 }, { 1.2 })
    }
}
