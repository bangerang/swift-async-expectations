import XCTest
@testable import AsyncExpectations

final class ExpectLessThanOrEqualTests: XCTestCase {
    func testExpectLessThanOrEqualShouldFail() throws {
        XCTExpectFailure {
            let expectation = expectation(description: #function)
            Task {
                defer {
                    expectation.fulfill()
                }
                try await expectLessThanOrEqual(timeout: 0.1, { 3 }, { 2 })
            }
            wait(for: [expectation], timeout: 1)
            
        }
    }
    func testExpectLessThanOrEqualShouldFailAutoClosure() throws {
        XCTExpectFailure {
            let expectation = expectation(description: #function)
            Task {
                defer {
                    expectation.fulfill()
                }
                try await expectLessThanOrEqual(timeout: 0.1, 10, 2)
            }
            wait(for: [expectation], timeout: 1)
        }
    }
    func testExpectLessThanOrEqualShouldSucceed() async throws {
        try await expectLessThanOrEqual(2, 2)
    }
    func testExpectLessThanOrEqualShouldSucceedAutoClosure() async throws {
        try await expectLessThanOrEqual({ 1.1 }, { 1.2 })
    }
}
