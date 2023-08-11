import XCTest
@testable import AsyncExpectations

final class ExpectThrowsTests: XCTestCase {
    func testExpectThrowsShouldFail() async throws {
        @Sendable func noThrow() async throws {}
        try await expectThrowsError(timeout: 0.1) {
            try await noThrow()
        }
        XCTExpectFailure()
    }
    func testExpectThrowsShouldFailAutoClosure() async throws {
        @Sendable func noThrow() throws {}
        try await expectThrowsError(timeout: 0.1, try noThrow())
        XCTExpectFailure()
    }
    func testExpectThrowsShouldSucceed() async throws {
        @Sendable func funcThatThrows() throws {
            throw "Foo"
        }
        try await expectThrowsError(try funcThatThrows())
    }
    func testExpectThrowsShouldSucceedAutoClosure() async throws {
        @Sendable func funcThatThrows() async throws {
            try await Task.sleep(nanoseconds: NSEC_PER_SEC / 10)
            throw "Foo"
        }
        try await expectThrowsError {
            try await funcThatThrows()
        }
    }
}

extension String: Error {}
