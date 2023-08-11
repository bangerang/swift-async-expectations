import XCTest
@testable import AsyncExpectations

final class ExpectFalseTests: XCTestCase {
    func testExpectFalseShouldFail() async throws {
        try await expectFalse(timeout: 0.1, { return true })
        XCTExpectFailure()
    }
    func testExpectFalseShouldFailAutoClosure() async throws {
        try await expectFalse(timeout: 0.1, true)
        XCTExpectFailure()
    }
    
    func testExpectFalseShouldSucceed() async throws {
        try await expectFalse {
            try await Task.sleep(nanoseconds: NSEC_PER_SEC / 10)
            return false
        }
    }
    @MainActor
    func testExpectFalseShouldSucceedAutoClosure() async throws {
        let fulfilledInverted = LockIsolated(true)
        Task { @MainActor in
            try await Task.sleep(nanoseconds: NSEC_PER_SEC / 10)
            fulfilledInverted.setValue(false)
        }
        try await expectFalse(fulfilledInverted.value)
    }
}
