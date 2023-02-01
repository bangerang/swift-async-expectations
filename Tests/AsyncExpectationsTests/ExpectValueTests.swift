import XCTest
@testable import AsyncExpectations

final class ExpectValueTests: XCTestCase {
    func testExpectValueShouldFailAutoClosure() throws {
        XCTExpectFailure {
            let expectation = expectation(description: #function)
            Task {
                defer {
                    expectation.fulfill()
                }
                let value: Int? = nil
                _ = try await expectValue(timeout: 0.1, value)
            }
            wait(for: [expectation], timeout: 1)
        }
    }
    func testExpectValueShouldSucceed() async throws {
        _ = try await expectValue({
            try await Task.sleep(nanoseconds: 10000)
            return 10
        })
    }
    func testExpectValueShouldSucceedAutoClosure() async throws {
        _ = try await expectValue(2)
    }
    func testExpectValueShouldSucceedPublisher() async throws {
        let array = [3]
        let publisher = array.publisher
        let value = try await expectValue(publisher)
        XCTAssertEqual(value, 3)
    }
}
