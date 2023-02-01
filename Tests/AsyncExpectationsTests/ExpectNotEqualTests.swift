import XCTest
@testable import AsyncExpectations

final class ExpectNotEqualTests: XCTestCase {
    func testExpectNotEqualShouldFail() throws {
        XCTExpectFailure {
            let expectation = expectation(description: #function)
            Task {
                defer {
                    expectation.fulfill()
                }
                try await expectNotEqual(timeout: 0.1, { 2 }, { 2 })
            }
            wait(for: [expectation], timeout: 1)
            
        }
    }
    func testExpectNotEqualShouldFailAutoClosure() throws {
        XCTExpectFailure {
            let expectation = expectation(description: #function)
            Task {
                defer {
                    expectation.fulfill()
                }
                try await expectNotEqual(timeout: 0.1, 2, 2)
            }
            wait(for: [expectation], timeout: 1)
        }
    }
    func testExpectNotEqualShouldSucceed() async throws {
        try await expectNotEqual(1, 2)
    }
    func testExpectNotEqualShouldSucceedAutoClosure() async throws {
        try await expectNotEqual({ 1 }, { 2 })
    }
}
