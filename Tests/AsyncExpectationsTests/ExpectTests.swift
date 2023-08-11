import XCTest
@testable import AsyncExpectations

final class ExpectTests: XCTestCase {
    func testExpectShouldFail() async throws {
        try await expect(timeout: 0.1, { return false })
        XCTExpectFailure()
    }
    func testExpectShouldFailAutoClosure() async throws {
        try await expect(timeout: 0.1, false)
        XCTExpectFailure()
    }
    func testExpectShouldSucceed() async throws {
        try await expect {
            try await Task.sleep(nanoseconds: NSEC_PER_SEC / 10)
            return true
        }
    } 
    @MainActor
    func testExpectShouldSucceedAutoClosure() async throws {
        let fulfilled = LockIsolated(false)
        Task { @MainActor in
            try await Task.sleep(nanoseconds: NSEC_PER_SEC / 10)
            fulfilled.setValue(true)
        }
        try await expect(fulfilled.value)
    }
}
