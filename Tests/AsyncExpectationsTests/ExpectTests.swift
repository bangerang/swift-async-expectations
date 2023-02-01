import XCTest
@testable import AsyncExpectations

final class ExpectTests: XCTestCase {
    func testExpectShouldFail() throws {
        XCTExpectFailure {
            let expectation = expectation(description: #function)
            Task {
                defer {
                    expectation.fulfill()
                }
                try await expect(timeout: 0.1, { return false })
            }
            wait(for: [expectation], timeout: 1)
            
        }
    }
    func testExpectShouldFailAutoClosure() throws {
        XCTExpectFailure {
            let expectation = expectation(description: #function)
            Task {
                defer {
                    expectation.fulfill()
                }
                try await expect(timeout: 0.1, false)
            }
            wait(for: [expectation], timeout: 1)
        }
    }
    func testExpectShouldSucceed() async throws {
        try await expect {
            try await Task.sleep(nanoseconds: NSEC_PER_SEC / 10)
            return true
        }
    } 
    @MainActor
    func testExpectShouldSucceedAutoClosure() async throws {
        var fulfilled = false
        Task { @MainActor in
            try await Task.sleep(nanoseconds: NSEC_PER_SEC / 10)
            fulfilled = true
        }
        try await expect(fulfilled)
    }
}
