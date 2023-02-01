import XCTest
@testable import AsyncExpectations

final class ExpectGreaterThanTests: XCTestCase {
    func testExpectGreaterThanShouldFail() throws {
        XCTExpectFailure {
            let expectation = expectation(description: #function)
            Task {
                defer {
                    expectation.fulfill()
                }
                try await expectGreaterThan(timeout: 0.1, { 2 }, { 3 })
            }
            wait(for: [expectation], timeout: 1)
            
        }
    }
    func testExpectGreaterThanShouldFailAutoClosure() throws {
        XCTExpectFailure {
            let expectation = expectation(description: #function)
            Task {
                defer {
                    expectation.fulfill()
                }
                try await expectGreaterThan(timeout: 0.1, 2, 10)
            }
            wait(for: [expectation], timeout: 1)
        }
    }
    func testExpectGreaterThanShouldSucceed() async throws {
        try await expectGreaterThan(10, 2.0)
    }
    func testExpectGreaterThanShouldSucceedAutoClosure() async throws {
        try await expectGreaterThan({ 2 }, { 1.2 })
    }
}
