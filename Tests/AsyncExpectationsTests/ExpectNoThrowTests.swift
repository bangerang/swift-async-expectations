import XCTest
@testable import AsyncExpectations

final class ExpectNoThrowTests: XCTestCase {
    func testExpectNoThrowShouldFail() async throws {
        @Sendable func funcThatThrows() async throws {
            try await Task.sleep(nanoseconds: NSEC_PER_SEC / 10)
            throw "Foo"
        }
        try await expectNoThrow(timeout: 0.1) {
            try await funcThatThrows()
        }
        XCTExpectFailure()
    }
    func testExpectNoThrowShouldFailAutoClosure() async throws {
        @Sendable func funcThatThrows() throws {
            throw "Foo"
        }
        try await expectNoThrow(timeout: 0.1, try funcThatThrows())
        XCTExpectFailure()
    }
    func testExpectNoThrowShouldSucceed() async throws {
        @Sendable func noThrow() async throws {}
        try await expectNoThrow {
            try await noThrow()
        }
    }
    func testExpectNoThrowShouldSucceedAutoClosure() async throws {
        @Sendable func noThrow() async throws {
            try await Task.sleep(nanoseconds: NSEC_PER_SEC / 10)
        }
        try await expectNoThrow {
            try await noThrow()
        }
    }
}
