import Foundation
import XCTestDynamicOverlay
import Combine
import QuartzCore

/// Expects an expression to be true.
/// - Parameters:
///   - timeout: The amount of time to wait before recording a test failure.
///   - expression: An expression of Boolean type.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func expect(timeout: TimeInterval = 1,
                   _ expression: @Sendable @escaping () async throws -> Bool,
                   file: StaticString = #file,
                   line: UInt = #line) async throws {
    if try await !evaluate(expression, timeout: timeout) {
        failExpect(file: file, line: line)
    }
}
/// Expects an expression to be true.
/// - Parameters:
///   - timeout: The amount of time to wait before recording a test failure.
///   - expression: An expression of Boolean type.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func expect(timeout: TimeInterval = 1,
                   _ expression: @Sendable @escaping @autoclosure () throws -> Bool,
                   file: StaticString = #file,
                   line: UInt = #line) async throws {
    if try await !evaluate(expression, timeout: timeout) {
        failExpect(file: file, line: line)
    }
}
private func failExpect(file: StaticString, line: UInt) {
    XCTFail("Expression is false", file: file, line: line)
}

/// Expects an expression to be false.
/// - Parameters:
///   - timeout: The amount of time to wait before recording a test failure.
///   - expression: An expression of Boolean type.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func expectFalse(timeout: TimeInterval = 1,
                        _ expression: @Sendable @escaping () async throws -> Bool,
                        file: StaticString = #file,
                        line: UInt = #line) async throws {
    let inverted = { @Sendable in try await expression() != true }
    if try await !evaluate(inverted, timeout: timeout) {
        failExpecFalse(file: file, line: line)
    }
}
/// Expects an expression to be false.
/// - Parameters:
///   - timeout: The amount of time to wait before recording a test failure.
///   - expression: An expression of Boolean type.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func expectFalse(timeout: TimeInterval = 1,
                        _ expression: @Sendable @escaping @autoclosure () throws -> Bool,
                        file: StaticString = #file,
                        line: UInt = #line) async throws {
    let inverted = { @Sendable in try expression() != true }
    if try await !evaluate(inverted, timeout: timeout) {
        failExpecFalse(file: file, line: line)
    }
}
private func failExpecFalse(file: StaticString, line: UInt) {
    XCTFail("Expression is true", file: file, line: line)
}

/// Expects two value to be equal.
/// - Parameters:
///   - timeout: The amount of time to wait before recording a test failure.
///   - expression1: An expression of type T, where T is Equatable.
///   - expression2: A second expression of type T, where T is Equatable.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func expectEqual<T: Equatable>(timeout: TimeInterval = 1,
                                      _ expression1: @Sendable @escaping @autoclosure () throws -> T,
                                      _ expression2: @Sendable @escaping @autoclosure () throws -> T,
                                      file: StaticString = #file,
                                      line: UInt = #line) async throws {
    let expression = { @Sendable in
        async let first = expression1()
        async let second = expression2()
        return try await first == second
    }
    if try await !evaluate(expression, timeout: timeout) {
        let first = try expression1()
        let second = try expression2()
        failExpectEqual(first: first, second: second, file: file, line: line)
    }
}
/// Expects two value to be equal.
/// - Parameters:
///   - timeout: The amount of time to wait before recording a test failure.
///   - expression1: An expression of type T, where T is Equatable.
///   - expression2: A second expression of type T, where T is Equatable.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func expectEqual<T: Equatable>(timeout: TimeInterval = 1,
                                      _ expression1: @Sendable @escaping () async throws -> T,
                                      _ expression2: @Sendable @escaping () async throws -> T,
                                      file: StaticString = #file,
                                      line: UInt = #line) async throws {
    let expression = { @Sendable in
        async let first = expression1()
        async let second = expression2()
        return try await first == second
    }
    if try await !evaluate(expression, timeout: timeout) {
        let first = try await expression1()
        let second = try await expression2()
        failExpectEqual(first: first, second: second, file: file, line: line)
    }
}
private func failExpectEqual<T>(first: T, second: T, file: StaticString, line: UInt) {
    XCTFail(#""\#(first)" is not equal to "\#(second)""#, file: file, line: line)
}

/// Expects two value to not be equal.
/// - Parameters:
///   - timeout: The amount of time to wait before recording a test failure.
///   - expression1: An expression of type T, where T is Equatable.
///   - expression2: A second expression of type T, where T is Equatable.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func expectNotEqual<T: Equatable>(timeout: TimeInterval = 1,
                                         _ expression1: @Sendable @escaping @autoclosure () throws -> T,
                                         _ expression2: @Sendable @escaping @autoclosure () throws -> T,
                                         file: StaticString = #file,
                                         line: UInt = #line) async throws {
    let expression = { @Sendable in
        async let first = expression1()
        async let second = expression2()
        return try await first != second
    }
    if try await !evaluate(expression, timeout: timeout) {
        let first = try expression1()
        let second = try expression2()
        failExpectNotEqual(first: first, second: second, file: file, line: line)
    }
}
/// Expects two value to not be equal.
/// - Parameters:
///   - timeout: The amount of time to wait before recording a test failure.
///   - expression1: An expression of type T, where T is Equatable.
///   - expression2: A second expression of type T, where T is Equatable.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func expectNotEqual<T: Equatable>(timeout: TimeInterval = 1,
                                         _ expression1: @Sendable @escaping () async throws -> T,
                                         _ expression2: @Sendable @escaping () async throws -> T,
                                         file: StaticString = #file,
                                         line: UInt = #line) async throws {
    let expression = { @Sendable in
        async let first = expression1()
        async let second = expression2()
        return try await first != second
    }
    if try await !evaluate(expression, timeout: timeout) {
        let first = try await expression1()
        let second = try await expression2()
        failExpectNotEqual(first: first, second: second, file: file, line: line)
    }
}
private func failExpectNotEqual<T>(first: T, second: T, file: StaticString, line: UInt) {
    XCTFail(#""\#(first)" is equal to "\#(second)""#, file: file, line: line)
}

/// Expects an expression to not be nil.
/// - Parameters:
///   - timeout: The amount of time to wait before recording a test failure.
///   - expression: An expression of type T.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func expectNotNil<T>(timeout: TimeInterval = 1,
                            _ expression: @Sendable @escaping @autoclosure () throws -> T?,
                            file: StaticString = #file,
                            line: UInt = #line) async throws {
    let expression = { @Sendable in return try expression() != nil }
    if try await !evaluate(expression, timeout: timeout) {
        failExpectNotNil(file: file, line: line)
    }
}
/// Expects an expression to not be nil.
/// - Parameters:
///   - timeout: The amount of time to wait before recording a test failure.
///   - expression: An expression of type T.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func expectNotNil<T>(timeout: TimeInterval = 1,
                            _ expression: @Sendable @escaping () async throws -> T?,
                            file: StaticString = #file,
                            line: UInt = #line) async throws {
    let expression = { @Sendable in return try await expression() != nil }
    if try await !evaluate(expression, timeout: timeout) {
        failExpectNotNil(file: file, line: line)
    }
}
private func failExpectNotNil(file: StaticString, line: UInt) {
    XCTFail("Expression is nil", file: file, line: line)
}

/// Expects an expression to be nil.
/// - Parameters:
///   - timeout: The amount of time to wait before recording a test failure.
///   - expression: An expression of type T.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func expectNil<T>(timeout: TimeInterval = 1,
                         _ expression: @Sendable @escaping @autoclosure () throws -> T?,
                         file: StaticString = #file,
                         line: UInt = #line) async throws {
    let expression = { @Sendable in return try expression() == nil }
    if try await !evaluate(expression, timeout: timeout) {
        failExpectNil(file: file, line: line)
    }
}
/// Expects an expression to be nil.
/// - Parameters:
///   - timeout: The amount of time to wait before recording a test failure.
///   - expression: An expression of type T.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func expectNil<T>(timeout: TimeInterval = 1,
                         _ expression: @Sendable @escaping () async throws -> T?,
                         file: StaticString = #file,
                         line: UInt = #line) async throws {
    let expression = { @Sendable in return try await expression() == nil }
    if try await !evaluate(expression, timeout: timeout) {
        failExpectNil(file: file, line: line)
    }
}
private func failExpectNil(file: StaticString, line: UInt) {
    XCTFail("Expression is not nil", file: file, line: line)
}

/// Expects an expression to throw an error.
/// - Parameters:
///   - timeout: The amount of time to wait before recording a test failure.
///   - expression: An expression of type T.
///   - errorHandler: An optional error handler.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func expectThrowsError<T>(timeout: TimeInterval = 1,
                                 _ expression:  @Sendable @escaping @autoclosure () throws -> T,
                                 errorHandler: ((Error) -> Void)? = nil,
                                 file: StaticString = #file,
                                 line: UInt = #line) async throws {
    let expression = { @Sendable in
        do {
            _ = try expression()
            return false
        } catch {
            errorHandler?(error)
            return true
        }
    }
    if try await !evaluate(expression, timeout: timeout) {
        failExpectThrowsError(file: file, line: line)
    }
}
/// Expects an expression to throw an error.
/// - Parameters:
///   - timeout: The amount of time to wait before recording a test failure.
///   - expression: An expression of type T.
///   - errorHandler: An optional error handler.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func expectThrowsError<T>(timeout: TimeInterval = 1,
                                 _ expression: @Sendable @escaping () async throws -> T,
                                 errorHandler: ((Error) -> Void)? = nil,
                                 file: StaticString = #file,
                                 line: UInt = #line) async throws {
    let expression = { @Sendable in
        do {
            _ = try await expression()
            return false
        } catch {
            errorHandler?(error)
            return true
        }
    }
    if try await !evaluate(expression, timeout: timeout) {
        failExpectThrowsError(file: file, line: line)
    }
}
private func failExpectThrowsError(file: StaticString, line: UInt) {
    XCTFail("Expression does not throw", file: file, line: line)
}

/// Expects an expression to not throw an error.
/// - Parameters:
///   - timeout: The amount of time to wait before recording a test failure.
///   - expression: An expression of type T.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func expectNoThrow<T>(timeout: TimeInterval = 1,
                             _ expression: @autoclosure @escaping () throws -> T,
                             file: StaticString = #file,
                             line: UInt = #line) async throws {
    let expression = { @Sendable in
        do {
            _ = try expression()
            return true
        } catch {
            return false
        }
    }
    if try await !evaluate(expression, timeout: timeout) {
        failExpectNoThrow(file: file, line: line)
    }
}
/// Expects an expression to not throw an error.
/// - Parameters:
///   - timeout: The amount of time to wait before recording a test failure.
///   - expression: An expression of type T.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func expectNoThrow<T>(timeout: TimeInterval = 1,
                             _ expression: @Sendable @escaping () async throws -> T,
                             file: StaticString = #file,
                             line: UInt = #line) async throws {
    let expression = { @Sendable in
        do {
            _ = try await expression()
            return true
        } catch {
            return false
        }
    }
    if try await !evaluate(expression, timeout: timeout) {
        failExpectNoThrow(file: file, line: line)
    }
}
private func failExpectNoThrow(file: StaticString, line: UInt) {
    XCTFail("Expression throws", file: file, line: line)
}

/// Expects first expression to be less than the value of the second expression..
/// - Parameters:
///   - timeout: The amount of time to wait before recording a test failure.
///   - expression1: An expression of type T, where T is Comparable.
///   - expression2: A second expression of type T, where T is Comparable.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func expectLessThan<T: Comparable>(timeout: TimeInterval = 1,
                                          _ expression1: @Sendable @escaping @autoclosure () throws -> T,
                                          _ expression2: @Sendable @escaping @autoclosure () throws -> T,
                                          file: StaticString = #file,
                                          line: UInt = #line) async throws {
    let expression = { @Sendable in
        async let first = expression1()
        async let second = expression2()
        return try await first < second
    }
    if try await !evaluate(expression, timeout: timeout) {
        let first = try expression1()
        let second = try expression2()
        failExpectLessThan(first: first, second: second, file: file, line: line)
    }
}
/// Expects first expression to be less than the value of the second expression..
/// - Parameters:
///   - timeout: The amount of time to wait before recording a test failure.
///   - expression1: An expression of type T, where T is Comparable.
///   - expression2: A second expression of type T, where T is Comparable.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func expectLessThan<T: Comparable>(timeout: TimeInterval = 1,
                                          _ expression1: @Sendable @escaping () async throws -> T,
                                          _ expression2: @Sendable @escaping () async throws -> T,
                                          file: StaticString = #file,
                                          line: UInt = #line) async throws {
    let expression = { @Sendable in
        async let first = expression1()
        async let second = expression2()
        return try await first < second
    }
    if try await !evaluate(expression, timeout: timeout) {
        let first = try await expression1()
        let second = try await expression2()
        failExpectLessThan(first: first, second: second, file: file, line: line)
    }
}
private func failExpectLessThan<T>(first: T, second: T, file: StaticString, line: UInt) {
    XCTFail(#""\#(first)" is not less than "\#(second)""#, file: file, line: line)
}

/// Expects first expression to be less than or equal to the value of the second expression.
/// - Parameters:
///   - timeout: The amount of time to wait before recording a test failure.
///   - expression1: An expression of type T, where T is Comparable.
///   - expression2: A second expression of type T, where T is Comparable.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func expectLessThanOrEqual<T: Comparable>(timeout: TimeInterval = 1,
                                                 _ expression1: @Sendable @escaping @autoclosure () throws -> T,
                                                 _ expression2: @escaping  @autoclosure () throws -> T,
                                                 file: StaticString = #file,
                                                 line: UInt = #line) async throws {
    let expression = { @Sendable in
        async let first = expression1()
        async let second = expression2()
        return try await first <= second
    }
    if try await !evaluate(expression, timeout: timeout) {
        let first = try expression1()
        let second = try expression2()
        failExpectLessThanOrEqual(first: first, second: second, file: file, line: line)
    }
}
/// Expects first expression to be less than or equal to the value of the second expression.
/// - Parameters:
///   - timeout: The amount of time to wait before recording a test failure.
///   - expression1: An expression of type T, where T is Comparable.
///   - expression2: A second expression of type T, where T is Comparable.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func expectLessThanOrEqual<T: Comparable>(timeout: TimeInterval = 1,
                                                 _ expression1: @Sendable @escaping () async throws -> T,
                                                 _ expression2: @Sendable @escaping () async throws -> T,
                                                 file: StaticString = #file,
                                                 line: UInt = #line) async throws {
    let expression = { @Sendable in
        async let first = expression1()
        async let second = expression2()
        return try await first <= second
    }
    if try await !evaluate(expression, timeout: timeout) {
        let first = try await expression1()
        let second = try await expression2()
        failExpectLessThanOrEqual(first: first, second: second, file: file, line: line)
    }
}
private func failExpectLessThanOrEqual<T>(first: T, second: T, file: StaticString, line: UInt) {
    XCTFail(#""\#(first)" is not less or equal to "\#(second)""#, file: file, line: line)
}

/// Expects first expression to be greater than the value of the second expression.
/// - Parameters:
///   - timeout: The amount of time to wait before recording a test failure.
///   - expression1: An expression of type T, where T is Comparable.
///   - expression2: A second expression of type T, where T is Comparable.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func expectGreaterThan<T: Comparable>(timeout: TimeInterval = 1,
                                             _ expression1: @Sendable @escaping @autoclosure () throws -> T,
                                             _ expression2: @escaping  @autoclosure () throws -> T,
                                             file: StaticString = #file,
                                             line: UInt = #line) async throws {
    let expression = { @Sendable in
        async let first = expression1()
        async let second = expression2()
        return try await first > second
    }
    if try await !evaluate(expression, timeout: timeout) {
        let first = try expression1()
        let second = try expression2()
        failExpectGreaterThan(first: first, second: second, file: file, line: line)
    }
}
/// Expects first expression to be greater than the value of the second expression.
/// - Parameters:
///   - timeout: The amount of time to wait before recording a test failure.
///   - expression1: An expression of type T, where T is Comparable.
///   - expression2: A second expression of type T, where T is Comparable.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func expectGreaterThan<T: Comparable>(timeout: TimeInterval = 1,
                                             _ expression1: @Sendable @escaping () async throws -> T,
                                             _ expression2: @Sendable @escaping () async throws -> T,
                                             file: StaticString = #file,
                                             line: UInt = #line) async throws {
    let expression = { @Sendable in
        async let first = expression1()
        async let second = expression2()
        return try await first > second
    }
    if try await !evaluate(expression, timeout: timeout) {
        let first = try await expression1()
        let second = try await expression2()
        failExpectGreaterThan(first: first, second: second, file: file, line: line)
    }
}
private func failExpectGreaterThan<T>(first: T, second: T, file: StaticString, line: UInt) {
    XCTFail(#""\#(first)" is not greater than "\#(second)""#, file: file, line: line)
}

/// Expects first expression to be greater than or equal to the value of the second expression.
/// - Parameters:
///   - timeout: The amount of time to wait before recording a test failure.
///   - expression1: An expression of type T, where T is Comparable.
///   - expression2: A second expression of type T, where T is Comparable.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func expectGreaterThanOrEqual<T: Comparable>(timeout: TimeInterval = 1,
                                                    _ expression1: @Sendable @escaping @autoclosure () throws -> T,
                                                    _ expression2: @Sendable @escaping @autoclosure () throws -> T,
                                                    file: StaticString = #file,
                                                    line: UInt = #line) async throws {
    let expression = { @Sendable in
        async let first = expression1()
        async let second = expression2()
        return try await first >= second
    }
    if try await !evaluate(expression, timeout: timeout) {
        let first = try expression1()
        let second = try expression2()
        failExpectGreaterThanOrEqual(first: first, second: second, file: file, line: line)
    }
}
/// Expects first expression to be greater than or equal to the value of the second expression.
/// - Parameters:
///   - timeout: The amount of time to wait before recording a test failure.
///   - expression1: An expression of type T, where T is Comparable.
///   - expression2: A second expression of type T, where T is Comparable.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func expectGreaterThanOrEqual<T: Comparable>(timeout: TimeInterval = 1,
                                                    _ expression1: @Sendable @escaping () async throws -> T,
                                                    _ expression2: @Sendable @escaping () async throws -> T,
                                                    file: StaticString = #file,
                                                    line: UInt = #line) async throws {
    let expression = { @Sendable in
        async let first = expression1()
        async let second = expression2()
        return try await first >= second
    }
    if try await !evaluate(expression, timeout: timeout) {
        let first = try await expression1()
        let second = try await expression2()
        failExpectGreaterThanOrEqual(first: first, second: second, file: file, line: line)
    }
}
private func failExpectGreaterThanOrEqual<T>(first: T, second: T, file: StaticString, line: UInt) {
    XCTFail(#""\#(first)" is not greater than or equal to "\#(second)""#, file: file, line: line)
}

/// Expects the expression to return a value.
/// - Parameters:
///   - timeout: The amount of time to wait before recording a test failure.
///   - expression: An expression of type T.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
@discardableResult
public func expectValue<T>(timeout: TimeInterval = 1,
                           _ expression: @Sendable @escaping () async throws -> T?,
                           file: StaticString = #file,
                           line: UInt = #line) async throws -> T? {
    let expressionToSend = { @Sendable in
        try await expression() != nil
    }
    if try await evaluate(expressionToSend, timeout: timeout) {
        return try await expression()!
    } else {
        failExpectValue(file: file, line: line)
        throw ExpectValueFailed()
    }
}
/// Expects the expression to return a value.
/// - Parameters:
///   - timeout: The amount of time to wait before recording a test failure.
///   - expression: An expression of type T.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
@discardableResult
public func expectValue<T>(timeout: TimeInterval = 1,
                           _ expression: @Sendable @escaping @autoclosure () throws -> T?,
                           file: StaticString = #file,
                           line: UInt = #line) async throws -> T {
    let expressionToSend = { @Sendable in
        try expression() != nil
    }
    if try await evaluate(expressionToSend, timeout: timeout) {
        return try expression()!
    } else {
        failExpectValue(file: file, line: line)
        throw ExpectValueFailed()
    }
}

/// Expects the expression to return a value.
/// - Parameters:
///   - timeout: The amount of time to wait before recording a test failure.
///   - publisher: A publisher of type T.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
@discardableResult
public func expectValue<T: Publisher>(timeout: TimeInterval = 1,
                                      _ publisher: T,
                                      file: StaticString = #file,
                                      line: UInt = #line) async throws -> T.Output {
    let value = LockIsolated<T.Output?>(nil)
    let cancellable = publisher.sink { _ in
    } receiveValue: { output in
        value.setValue(output)
    }
    
    let expression = { @Sendable in return value.value != nil }
    if try await evaluate(expression, timeout: timeout), let value = value.value {
        cancellable.cancel()
        return value
    } else {
        cancellable.cancel()
        failExpectValue(file: file, line: line)
        throw ExpectValueFailed()
    }
}
struct ExpectValueFailed: Error {}
private func failExpectValue(file: StaticString, line: UInt) {
    XCTFail("Expected value from expression", file: file, line: line)
}

/// Tries to evaluate an expression for a specified timeout.
/// - Parameters:
///   - expression: An expression of Boolean type.
///   - timeout: The amount of time to wait to evaluate the expression.
public func evaluate(_ expression: @Sendable @escaping () async throws -> Bool,
                     timeout: TimeInterval) async throws -> Bool {
    actor ExpressionStatus {
        var isFulfilled = false
        func setIsFulfilled() {
            isFulfilled = true
        }
    }
    let start = CACurrentMediaTime()
    let status = ExpressionStatus()
    while await !status.isFulfilled && CACurrentMediaTime() - start < timeout {
        await Task.yield()
        let task = Task<Bool, Error> { @MainActor in
            return try await expression()
        }
        Task { [status] in
            try await Task.sleep(nanoseconds: NSEC_PER_SEC * UInt64(timeout))
            if await !status.isFulfilled {
                task.cancel()
            }
        }
        if try await task.value {
            await status.setIsFulfilled()
        }
        
    }
    return await status.isFulfilled
}

final class LockIsolated<Value>: @unchecked Sendable {
  private var _value: Value
  private let lock = NSRecursiveLock()

  init(_ value: @autoclosure @Sendable () throws -> Value) rethrows {
    self._value = try value()
  }

  func setValue(_ newValue: @autoclosure @Sendable () throws -> Value) rethrows {
    try self.lock.sync {
      self._value = try newValue()
    }
  }
}

extension LockIsolated where Value: Sendable {
  /// The lock-isolated value.
  var value: Value {
    self.lock.sync {
      self._value
    }
  }
}

extension NSRecursiveLock {
  @inlinable @discardableResult
  func sync<R>(work: () throws -> R) rethrows -> R {
    self.lock()
    defer { self.unlock() }
    return try work()
  }
}
