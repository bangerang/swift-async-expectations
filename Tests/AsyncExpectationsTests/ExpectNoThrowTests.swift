import XCTest
@testable import AsyncExpectations

final class ExpectNoThrowTests: XCTestCase {
    func testExpectNoThrowShouldFail() throws {
        @Sendable func funcThatThrows() async throws {
            try await Task.sleep(nanoseconds: NSEC_PER_SEC / 10)
            throw "Foo"
        }
        XCTExpectFailure {
            let expectation = expectation(description: #function)
            Task {
                defer {
                    expectation.fulfill()
                }
                try await expectNoThrow(timeout: 0.1) {
                    try await funcThatThrows()
                }
            }
            wait(for: [expectation], timeout: 1)
        }
    }
    func testExpectNoThrowShouldFailAutoClosure() throws {
        @Sendable func funcThatThrows() throws {
            throw "Foo"
        }
        XCTExpectFailure {
            let expectation = expectation(description: #function)
            Task {
                defer {
                    expectation.fulfill()
                }
                try await expectNoThrow(timeout: 0.1, try funcThatThrows())
            }
            wait(for: [expectation], timeout: 1)
        }
    }
    func testExpectNoThrowShouldSucceed() async throws {
        @Sendable func noThrow() async throws {}
        try await expectNoThrow {
            try await noThrow()
        }
    }
    func testExpectNoThrowShouldSucceedAutoClosure() async throws {
        func noThrow() async throws {
            try await Task.sleep(nanoseconds: NSEC_PER_SEC / 10)
        }
        try await expectNoThrow {
            try await noThrow()
        }
    }
}
