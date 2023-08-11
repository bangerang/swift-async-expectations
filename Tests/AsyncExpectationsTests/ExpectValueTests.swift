import XCTest
@testable import AsyncExpectations

final class ExpectValueTests: XCTestCase {
    func testExpectValueShouldFailAutoClosure() async throws {
        let value: Int? = nil
        do {
            try await expectValue(timeout: 0.1, value)
        } catch {
            XCTExpectFailure()
            return
        }
        XCTFail()
    }
    func testExpectValueShouldSucceed() async throws {
        try await expectValue({
            try await Task.sleep(nanoseconds: 10000)
            return 10
        })
    }
    func testExpectAsyncValueShouldFail() async throws {
        do {
            try await expectValue {
                try await Task.sleep(nanoseconds: 10000)
                return Optional<Int>.none
            }
        } catch {
            XCTExpectFailure()
            return
        }
        XCTFail()
    }
    func testExpectValueShouldSucceedAutoClosure() async throws {
        try await expectValue(2)
    }
    func testExpectValueShouldSucceedPublisher() async throws {
        let array = [3]
        let publisher = array.publisher
        let value = try await expectValue(publisher)
        XCTAssertEqual(value, 3)
    }

    func testExpectNil() async throws {
        let value: Int? = 5
        try await expectNil(timeout: 0.1, value)
        XCTExpectFailure()
    }
}
