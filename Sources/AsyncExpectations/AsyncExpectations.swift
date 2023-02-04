import Foundation
import XCTest
import Combine

/// Expects an expression to be true.
/// - Parameters:
///   - expression: An expression of Boolean type.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expect(_ expression: @MainActor @escaping () async throws -> Bool,
                              file: StaticString = #file,
                              line: UInt = #line,
                              timeout: TimeInterval = 1) async throws {
    if try await !evaluate(expression, timeout: timeout) {
        failExpect(file: file, line: line)
    }
}
/// Expects an expression to be true.
/// - Parameters:
///   - expression: An expression of Boolean type.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expect(_ expression: @escaping @autoclosure () throws -> Bool,
                              file: StaticString = #file,
                              line: UInt = #line,
                              timeout: TimeInterval = 1) async throws {
    if try await !evaluate(expression, timeout: timeout) {
        failExpect(file: file, line: line)
    }
}
private func failExpect(file: StaticString, line: UInt) {
    XCTFail("Expression is false", file: file, line: line)
}

/// Expects an expression to be false.
/// - Parameters:
///   - expression: An expression of Boolean type.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expectFalse(_ expression: @MainActor @escaping () async throws -> Bool,
                                   file: StaticString = #file,
                                   line: UInt = #line,
                                   timeout: TimeInterval = 1) async throws {
    let inverted = { try await expression() != true }
    if try await !evaluate(inverted, timeout: timeout) {
        failExpecFalse(file: file, line: line)
    }
}
/// Expects an expression to be false.
/// - Parameters:
///   - expression: An expression of Boolean type.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expectFalse(_ expression: @escaping @autoclosure () throws -> Bool,
                                   file: StaticString = #file,
                                   line: UInt = #line,
                                   timeout: TimeInterval = 1) async throws {
    let inverted = { try expression() != true }
    if try await !evaluate(inverted, timeout: timeout) {
        failExpecFalse(file: file, line: line)
    }
}
private func failExpecFalse(file: StaticString, line: UInt) {
    XCTFail("Expression is true", file: file, line: line)
}

/// Expects two value to be equal.
/// - Parameters:
///   - expression1: An expression of type T, where T is Equatable.
///   - expression2: A second expression of type T, where T is Equatable.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expectEqual<T: Equatable>(_ expression1: @escaping @autoclosure () throws -> T,
                                                 _ expression2: @escaping @autoclosure () throws -> T,
                                                 file: StaticString = #file,
                                                 line: UInt = #line,
                                                 timeout: TimeInterval = 1) async throws {
    let expression = {
        let first = try expression1()
        let second = try expression2()
        return first == second
    }
    if try await !evaluate(expression, timeout: timeout) {
        let first = try expression1()
        let second = try expression2()
        failExpectEqual(first: first, second: second, file: file, line: line)
    }
}
/// Expects two value to be equal.
/// - Parameters:
///   - expression1: An expression of type T, where T is Equatable.
///   - expression2: A second expression of type T, where T is Equatable.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expectEqual<T: Equatable>(_ expression1: @MainActor @escaping () async throws -> T,
                                                 _ expression2: @MainActor @escaping () async throws -> T,
                                                 file: StaticString = #file,
                                                 line: UInt = #line,
                                                 timeout: TimeInterval = 1) async throws {
    let expression = {
        let first = try await expression1()
        let second = try await expression2()
        return first == second
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
///   - expression1: An expression of type T, where T is Equatable.
///   - expression2: A second expression of type T, where T is Equatable.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expectNotEqual<T: Equatable>(_ expression1: @escaping @autoclosure () throws -> T,
                                                    _ expression2: @escaping @autoclosure () throws -> T,
                                                    file: StaticString = #file,
                                                    line: UInt = #line,
                                                    timeout: TimeInterval = 1) async throws {
    let expression = {
        let first = try expression1()
        let second = try expression2()
        return first != second
    }
    if try await !evaluate(expression, timeout: timeout) {
        let first = try expression1()
        let second = try expression2()
        failExpectNotEqual(first: first, second: second, file: file, line: line)
    }
}
/// Expects two value to not be equal.
/// - Parameters:
///   - expression1: An expression of type T, where T is Equatable.
///   - expression2: A second expression of type T, where T is Equatable.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expectNotEqual<T: Equatable>(_ expression1: @MainActor @escaping () async throws -> T,
                                                    _ expression2: @MainActor @escaping () async throws -> T,
                                                    file: StaticString = #file,
                                                    line: UInt = #line,
                                                    timeout: TimeInterval = 1) async throws {
    let expression = {
        let first = try await expression1()
        let second = try await expression2()
        return first != second
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
///   - expression: An expression of type T.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expectNotNil<T>(_ expression: @escaping @autoclosure () throws -> T?,
                                       file: StaticString = #file,
                                       line: UInt = #line,
                                       timeout: TimeInterval = 1) async throws {
    let expression = { return try expression() != nil }
    if try await !evaluate(expression, timeout: timeout) {
        failExpectNotNil(file: file, line: line)
    }
}
/// Expects an expression to not be nil.
/// - Parameters:
///   - expression: An expression of type T.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expectNotNil<T>(_ expression: @MainActor @escaping () async throws -> T?,
                                       file: StaticString = #file,
                                       line: UInt = #line,
                                       timeout: TimeInterval = 1) async throws {
    let expression = { return try await expression() != nil }
    if try await !evaluate(expression, timeout: timeout) {
        failExpectNotNil(file: file, line: line)
    }
}
private func failExpectNotNil(file: StaticString, line: UInt) {
    XCTFail("Expression is nil", file: file, line: line)
}

/// Expects an expression to be nil.
/// - Parameters:
///   - expression: An expression of type T.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expectNil<T>(_ expression: @escaping @autoclosure () throws -> T?,
                                    file: StaticString = #file,
                                    line: UInt = #line,
                                    timeout: TimeInterval = 1) async throws {
    let expression = { return try expression() == nil }
    if try await !evaluate(expression, timeout: timeout) {
        failExpectNil(file: file, line: line)
    }
}
/// Expects an expression to be nil.
/// - Parameters:
///   - expression: An expression of type T.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expectNil<T>(_ expression: @MainActor @escaping () async throws -> T?,
                                    file: StaticString = #file,
                                    line: UInt = #line,
                                    timeout: TimeInterval = 1) async throws {
    let expression = { return try await expression() == nil }
    if try await !evaluate(expression, timeout: timeout) {
        failExpectNil(file: file, line: line)
    }
}
private func failExpectNil(file: StaticString, line: UInt) {
    XCTFail("Expression is not nil", file: file, line: line)
}

/// Expects an expression to throw an error.
/// - Parameters:
///   - expression: An expression of type T.
///   - errorHandler: An optional error handler.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expectThrowsError<T>(_ expression:  @escaping @autoclosure () throws -> T,
                                            errorHandler: ((Error) -> Void)? = nil,
                                            file: StaticString = #file,
                                            line: UInt = #line,
                                            timeout: TimeInterval = 1) async throws {
    let expression = {
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
///   - expression: An expression of type T.
///   - errorHandler: An optional error handler.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expectThrowsError<T>(_ expression: @MainActor @escaping () async throws -> T,
                                            errorHandler: ((Error) -> Void)? = nil,
                                            file: StaticString = #file,
                                            line: UInt = #line,
                                            timeout: TimeInterval = 1) async throws {
    let expression = {
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
///   - expression: An expression of type T.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expectNoThrow<T>(_ expression: @autoclosure @escaping () throws -> T,
                                        file: StaticString = #file,
                                        line: UInt = #line,
                                        timeout: TimeInterval = 1) async throws {
    let expression = {
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
///   - expression: An expression of type T.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expectNoThrow<T>(_ expression: @MainActor @escaping () async throws -> T,
                                        file: StaticString = #file,
                                        line: UInt = #line,
                                        timeout: TimeInterval = 1) async throws {
    let expression = {
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
///   - expression1: An expression of type T, where T is Comparable.
///   - expression2: A second expression of type T, where T is Comparable.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expectLessThan<T: Comparable>(_ expression1: @escaping @autoclosure () throws -> T,
                                                     _ expression2: @escaping @autoclosure () throws -> T,
                                                     file: StaticString = #file,
                                                     line: UInt = #line,
                                                     timeout: TimeInterval = 1) async throws {
    let expression = {
        let first = try expression1()
        let second = try expression2()
        return first < second
    }
    if try await !evaluate(expression, timeout: timeout) {
        let first = try expression1()
        let second = try expression2()
        failExpectLessThan(first: first, second: second, file: file, line: line)
    }
}
/// Expects first expression to be less than the value of the second expression..
/// - Parameters:
///   - expression1: An expression of type T, where T is Comparable.
///   - expression2: A second expression of type T, where T is Comparable.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expectLessThan<T: Comparable>(_ expression1: @MainActor @escaping () async throws -> T,
                                                     _ expression2: @MainActor @escaping () async throws -> T,
                                                     file: StaticString = #file,
                                                     line: UInt = #line,
                                                     timeout: TimeInterval = 1) async throws {
    let expression = {
        let first = try await expression1()
        let second = try await expression2()
        return first < second
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
///   - expression1: An expression of type T, where T is Comparable.
///   - expression2: A second expression of type T, where T is Comparable.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expectLessThanOrEqual<T: Comparable>(_ expression1: @escaping @autoclosure () throws -> T,
                                                            _ expression2: @escaping  @autoclosure () throws -> T,
                                                            file: StaticString = #file,
                                                            line: UInt = #line,
                                                            timeout: TimeInterval = 1) async throws {
    let expression = {
        let first = try expression1()
        let second = try expression2()
        return first <= second
    }
    if try await !evaluate(expression, timeout: timeout) {
        let first = try expression1()
        let second = try expression2()
        failExpectLessThanOrEqual(first: first, second: second, file: file, line: line)
    }
}
/// Expects first expression to be less than or equal to the value of the second expression.
/// - Parameters:
///   - expression1: An expression of type T, where T is Comparable.
///   - expression2: A second expression of type T, where T is Comparable.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expectLessThanOrEqual<T: Comparable>(_ expression1: @MainActor @escaping () async throws -> T,
                                                            _ expression2: @MainActor @escaping () async throws -> T,
                                                            file: StaticString = #file,
                                                            line: UInt = #line,
                                                            timeout: TimeInterval = 1) async throws {
    let expression = {
        let first = try await expression1()
        let second = try await expression2()
        return first <= second
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
///   - expression1: An expression of type T, where T is Comparable.
///   - expression2: A second expression of type T, where T is Comparable.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expectGreaterThan<T: Comparable>(_ expression1: @escaping @autoclosure () throws -> T,
                                                        _ expression2: @escaping  @autoclosure () throws -> T,
                                                        file: StaticString = #file,
                                                        line: UInt = #line,
                                                        timeout: TimeInterval = 1) async throws {
    let expression = {
        let first = try expression1()
        let second = try expression2()
        return first > second
    }
    if try await !evaluate(expression, timeout: timeout) {
        let first = try expression1()
        let second = try expression2()
        failExpectGreaterThan(first: first, second: second, file: file, line: line)
    }
}
/// Expects first expression to be greater than the value of the second expression.
/// - Parameters:
///   - expression1: An expression of type T, where T is Comparable.
///   - expression2: A second expression of type T, where T is Comparable.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expectGreaterThan<T: Comparable>(_ expression1: @MainActor @escaping () async throws -> T,
                                                        _ expression2: @MainActor @escaping () async throws -> T,
                                                        file: StaticString = #file,
                                                        line: UInt = #line,
                                                        timeout: TimeInterval = 1) async throws {
    let expression = {
        let first = try await expression1()
        let second = try await expression2()
        return first > second
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
///   - expression1: An expression of type T, where T is Comparable.
///   - expression2: A second expression of type T, where T is Comparable.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expectGreaterThanOrEqual<T: Comparable>(_ expression1: @escaping @autoclosure () throws -> T,
                                                               _ expression2: @escaping @autoclosure () throws -> T,
                                                               file: StaticString = #file,
                                                               line: UInt = #line,
                                                               timeout: TimeInterval = 1) async throws {
    let expression = {
        let first = try expression1()
        let second = try expression2()
        return first >= second
    }
    if try await !evaluate(expression, timeout: timeout) {
        let first = try expression1()
        let second = try expression2()
        failExpectGreaterThanOrEqual(first: first, second: second, file: file, line: line)
    }
}
/// Expects first expression to be greater than or equal to the value of the second expression.
/// - Parameters:
///   - expression1: An expression of type T, where T is Comparable.
///   - expression2: A second expression of type T, where T is Comparable.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expectGreaterThanOrEqual<T: Comparable>(_ expression1: @MainActor @escaping () async throws -> T,
                                                               _ expression2: @MainActor @escaping () async throws -> T,
                                                               file: StaticString = #file,
                                                               line: UInt = #line,
                                                               timeout: TimeInterval = 1) async throws {
    let expression = {
        let first = try await expression1()
        let second = try await expression2()
        return first >= second
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
///   - expression: An expression of type T.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expectValue<T>(_ expression: @MainActor @escaping () async throws -> T?,
                                      file: StaticString = #file,
                                      line: UInt = #line,
                                      timeout: TimeInterval = 1) async throws -> T {
    let expressionToSend = {
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
///   - expression: An expression of type T.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expectValue<T>(_ expression: @escaping @autoclosure () throws -> T?,
                                      file: StaticString = #file,
                                      line: UInt = #line,
                                      timeout: TimeInterval = 1) async throws -> T {
    let expressionToSend = {
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
///   - expression: An expression of type T.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expectValue<T>(_ expression: @MainActor @escaping () async throws -> T,
                                      file: StaticString = #file,
                                      line: UInt = #line,
                                      timeout: TimeInterval = 1) async throws -> T {
    let expressionToSend = {
        _ = try await expression()
        return true
    }
    if try await evaluate(expressionToSend, timeout: timeout) {
        return try await expression()
    } else {
        failExpectValue(file: file, line: line)
        throw ExpectValueFailed()
    }
}
/// Expects the expression to return a value.
/// - Parameters:
///   - expression: An expression of type T.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expectValue<T>(_ expression: @escaping @autoclosure () throws -> T,
                                      file: StaticString = #file,
                                      line: UInt = #line,
                                      timeout: TimeInterval = 1) async throws -> T {
    let expressionToSend = {
        _ = try expression()
        return true
    }
    if try await evaluate(expressionToSend, timeout: timeout) {
        return try expression()
    } else {
        failExpectValue(file: file, line: line)
        throw ExpectValueFailed()
    }
}
/// Expects the expression to return a value.
/// - Parameters:
///   - publisher: A publisher of type T.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - timeout: The amount of time to wait before recording a test failure.
@MainActor public func expectValue<T: Publisher>(_ publisher: T,
                                                 file: StaticString = #file,
                                                 line: UInt = #line,
                                                 timeout: TimeInterval = 1) async throws -> T.Output {
    var value: T.Output?
    let cancellable = publisher.sink { _ in
    } receiveValue: { output in
        value = output
    }
    
    let expression = { return value != nil }
    if try await evaluate(expression, timeout: timeout), let value {
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
@MainActor public func evaluate(_ expression: @MainActor @escaping () async throws -> Bool,
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
            if try await expression() {
                return true
            } else {
                return false
            }
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
