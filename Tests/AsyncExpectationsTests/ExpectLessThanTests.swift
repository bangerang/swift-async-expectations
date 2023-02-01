import XCTest
@testable import AsyncExpectations

final class ExpectLessThanTests: XCTestCase {
    func testExpectLessThanShouldFail() throws {
        XCTExpectFailure {
            let expectation = expectation(description: #function)
            Task {
                defer {
                    expectation.fulfill()
                }
                try await expectLessThan(timeout: 0.1, { 2 }, { 2 })
            }
            wait(for: [expectation], timeout: 1)
            
        }
    }
    func testExpectLessThanShouldFailAutoClosure() throws {
        XCTExpectFailure {
            let expectation = expectation(description: #function)
            Task {
                defer {
                    expectation.fulfill()
                }
                try await expectLessThan(timeout: 0.1, 3, 2)
            }
            wait(for: [expectation], timeout: 1)
        }
    }
    func testExpectLessThanShouldSucceed() async throws {
        try await expectLessThan(1, 2)
    }
    func testExpectLessThanShouldSucceedAutoClosure() async throws {
        try await expectLessThan({ 1.1 }, { 1.2 })
    }
}
