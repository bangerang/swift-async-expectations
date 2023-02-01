import XCTest
@testable import AsyncExpectations

final class ExpectThrowsTests: XCTestCase {
    func testExpectThrowsShouldFail() throws {
        @Sendable func noThrow() async throws {}
        XCTExpectFailure {
            let expectation = expectation(description: #function)
            Task {
                defer {
                    expectation.fulfill()
                }
                try await expectThrowsError(timeout: 0.1) {
                    try await noThrow()
                }
            }
            wait(for: [expectation], timeout: 1)
        }
    }
    func testExpectThrowsShouldFailAutoClosure() throws {
        @Sendable func noThrow() throws {}
        XCTExpectFailure {
            let expectation = expectation(description: #function)
            Task {
                defer {
                    expectation.fulfill()
                }
                try await expectThrowsError(timeout: 0.1, try noThrow())
            }
            wait(for: [expectation], timeout: 1)
        }
    }
    func testExpectThrowsShouldSucceed() async throws {
        func funcThatThrows() throws {
            throw "Foo"
        }
        try await expectThrowsError(try funcThatThrows())
    }
    func testExpectThrowsShouldSucceedAutoClosure() async throws {
        func funcThatThrows() async throws {
            try await Task.sleep(nanoseconds: NSEC_PER_SEC / 10)
            throw "Foo"
        }
        try await expectThrowsError {
            try await funcThatThrows()
        }
    }
}

extension String: Error {}
