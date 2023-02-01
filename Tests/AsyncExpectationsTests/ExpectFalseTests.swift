import XCTest
@testable import AsyncExpectations

final class ExpectFalseTests: XCTestCase {
    func testExpectFalseShouldFail() throws {
        XCTExpectFailure {
            let expectation = expectation(description: #function)
            Task {
                defer {
                    expectation.fulfill()
                }
                try await expectFalse(timeout: 0.1, { return true })
            }
            wait(for: [expectation], timeout: 1)
            
        }
    }
    func testExpectFalseShouldFailAutoClosure() throws {
        XCTExpectFailure {
            let expectation = expectation(description: #function)
            Task {
                defer {
                    expectation.fulfill()
                }
                try await expectFalse(timeout: 0.1, true)
            }
            wait(for: [expectation], timeout: 1)
        }
    }
    
    func testExpectFalseShouldSucceed() async throws {
        try await expectFalse {
            try await Task.sleep(nanoseconds: NSEC_PER_SEC / 10)
            return false
        }
    }
    @MainActor
    func testExpectFalseShouldSucceedAutoClosure() async throws {
        var fulfilledInverted = true
        Task { @MainActor in
            try await Task.sleep(nanoseconds: NSEC_PER_SEC / 10)
            fulfilledInverted = false
        }
        try await expectFalse(fulfilledInverted)
    }
}
