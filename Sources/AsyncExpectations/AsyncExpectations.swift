import Foundation
import XCTest

public protocol Expectable {
    var failureReason: () -> String { get }
    var expression: () async throws -> Bool { get }
    var file: StaticString { get }
    var line: UInt { get }
}

/// Expects an expression to be true.
public struct Expect: Expectable {
    public let failureReason: () -> String
    public let file: StaticString
    public let line: UInt
    public let expression: () async throws -> Bool
    public init(expression: @escaping () async throws -> Bool,
                file: StaticString = #file,
                line: UInt = #line) {
        self.failureReason = { "Expectation failed" }
        self.expression = expression
        self.line = line
        self.file = file
    }
}

/// Expects two value to be equal.
public struct ExpectEqual: Expectable {
    public let failureReason: () -> String
    public let file: StaticString
    public let line: UInt
    public let expression: () async throws -> Bool
    public init<T: Equatable>(_ expression1: @escaping @autoclosure () -> T,
                              _ expression2: @escaping @autoclosure () -> T,
                              file: StaticString = #file,
                              line: UInt = #line) {
        failureReason = { #"ExpectEqual failed: "\#(expression1())" is not equal to "\#(expression2())""# }
        self.expression = { return expression1() == expression2() }
        self.line = line
        self.file = file
    }
}

/// Expects two value to not be equal.
public struct ExpectNotEqual: Expectable {
    public let failureReason: () -> String
    public let file: StaticString
    public let line: UInt
    public let expression: () async throws -> Bool
    public init<T: Equatable>(_ expression1: @escaping @autoclosure () -> T,
                              _ expression2: @escaping @autoclosure () -> T,
                              file: StaticString = #file,
                              line: UInt = #line) {
        failureReason = { #"ExpectNotEqual failed: "\#(expression1())" is equal to "\#(expression2())""# }
        self.expression = { return expression1() != expression2() }
        self.line = line
        self.file = file
    }
}

/// Expects an expression to not be nil.
public struct ExpectNotNil: Expectable {
    public let failureReason: () -> String
    public let file: StaticString
    public let line: UInt
    public let expression: () async throws -> Bool
    public init<T>(_ expression: @escaping @autoclosure () -> T?,
                   file: StaticString = #file,
                   line: UInt = #line) {
        failureReason = { "ExpectNotNil failed: Expression is nil" }
        self.expression = { return expression() != nil }
        self.line = line
        self.file = file
        
    }
    public init<T>(_ expression: @escaping () async throws -> T?,
                   file: StaticString = #file,
                   line: UInt = #line) {
        failureReason = { "ExpectNotNil failed: Expression is nil" }
        self.expression = { return try await expression() != nil }
        self.line = line
        self.file = file
    }
}

/// Expects an expression to be nil.
public struct ExpectNil: Expectable {
    public let failureReason: () -> String
    public let file: StaticString
    public let line: UInt
    public let expression: () async throws -> Bool
    public init<T>(_ expression: @escaping @autoclosure () -> T?,
                   file: StaticString = #file,
                   line: UInt = #line) {
        failureReason = { "ExpectNil failed: Expression is not nil" }
        self.expression = { return expression() == nil }
        self.line = line
        self.file = file
    }
}

/// Expects an expression to throw an error.
public struct ExpectThrowsError: Expectable {
    public let failureReason: () -> String
    public let file: StaticString
    public let line: UInt
    public let expression: () async throws -> Bool
    public init<T>(_ expression:  @escaping () async throws -> T,
                _ errorHandler: ((Error) -> Void)? = nil,
                file: StaticString = #file,
                line: UInt = #line) {
        failureReason = { "ExpectThrowsError failed: Expression does not throw" }
        self.expression = {
            do {
                _ = try await expression()
                return false
            } catch {
                errorHandler?(error)
                return true
            }
        }
        self.line = line
        self.file = file
    }
}

/// Expects an expression to not throw an error.
public struct ExpectNoThrow: Expectable {
    public let failureReason: () -> String
    public let file: StaticString
    public let line: UInt
    public let expression: () async throws -> Bool
    public init<T>(_ expression:  @escaping () async throws -> T,
                   file: StaticString = #file,
                   line: UInt = #line) {
        failureReason = { "ExpectThrows failed: Expression throws" }
        self.expression = {
            do {
                _ = try await expression()
                return true
            } catch {
                return false
            }
        }
        self.line = line
        self.file = file
    }
}

/// Expects first expression to be less than the value of the second expression.
public struct ExpectLessThan: Expectable {
    public let failureReason: () -> String
    public let file: StaticString
    public let line: UInt
    public let expression: () async throws -> Bool
    public init<T: Comparable>(_ expression1: @escaping @autoclosure () -> T,
                               _ expression2: @escaping  @autoclosure () -> T,
                               file: StaticString = #file,
                               line: UInt = #line) {
        failureReason = { #"ExpectLessThan failed: "\#(expression1())" is not less than "\#(expression2())""# }
        self.expression = { return expression1() < expression2() }
        self.line = line
        self.file = file
    }
}

/// Expects first expression to be less than or equal to the value of the second expression.
public struct ExpectLessThanOrEqual: Expectable {
    public let failureReason: () -> String
    public let file: StaticString
    public let line: UInt
    public let expression: () async throws -> Bool
    public init<T: Comparable>(_ expression1: @escaping @autoclosure () -> T,
                               _ expression2: @escaping  @autoclosure () -> T,
                               file: StaticString = #file,
                               line: UInt = #line) {
        failureReason = { #"ExpectLessThanOrEqual failed: "\#(expression1())" is not greater than or equal to "\#(expression2())""# }
        self.expression = { return expression1() <= expression2() }
        self.line = line
        self.file = file
    }
}

/// Expects first expression to be greater than the value of the second expression.
public struct ExpectGreaterThan: Expectable {
    public let failureReason: () -> String
    public let file: StaticString
    public let line: UInt
    public let expression: () async throws -> Bool
    public init<T: Comparable>(_ expression1: @escaping @autoclosure () -> T,
                               _ expression2: @escaping  @autoclosure () -> T,
                               file: StaticString = #file,
                               line: UInt = #line) {
        failureReason = { #"ExpectGreaterThan failed: "\#(expression1())" is not greater than "\#(expression2())""# }
        self.expression = { return expression1() > expression2() }
        self.line = line
        self.file = file
    }
}

/// Expects first expression to be greater than or equal to the value of the second expression.
public struct ExpectGreaterThanOrEqual: Expectable {
    public let failureReason: () -> String
    public let file: StaticString
    public let line: UInt
    public let expression: () async throws -> Bool
    public init<T: Comparable>(_ expression1: @escaping @autoclosure () -> T,
                       _ expression2: @escaping  @autoclosure () -> T,
                       file: StaticString = #file,
                       line: UInt = #line) {
        failureReason = { #"ExpectGreaterThanOrEqual failed: "\#(expression1())" is not greater than or equal to "\#(expression2())""# }
        self.expression = { return expression1() >= expression2() }
        self.line = line
        self.file = file
    }
}

@resultBuilder
public struct AsyncExpectationsBuilder {
    static func buildBlock() -> [Expectable] { [] }
}

public extension AsyncExpectationsBuilder {
    static func buildBlock(_ predicates: Expectable...) -> [Expectable] {
        predicates
    }
}

public struct AsyncExpectations {
    @discardableResult
    public init(@AsyncExpectationsBuilder builder: () -> [Expectable],
                timeout: TimeInterval = 1,
                file: StaticString = #file,
                line: UInt = #line) async throws {
        
        let expectations = builder()
        let start = Date().timeIntervalSinceReferenceDate
        var fulfilled = Array(repeating: false, count: expectations.count)
        while fulfilled.contains(false) && Date().timeIntervalSinceReferenceDate - start < timeout {
            for (offset, element) in expectations.enumerated() {
                let task = Task<Bool, Error> {
                    if try await element.expression() == true {
                        return true
                    } else {
                        return false
                    }
                }
                Task {
                    try await Task.sleep(nanoseconds: NSEC_PER_SEC * UInt64(timeout))
                    task.cancel()
                }
                fulfilled[offset] = try await task.value

            }
            try await Task.sleep(nanoseconds: NSEC_PER_SEC / 10)
        }
        
        if fulfilled.allSatisfy({ $0 == true }) {
            return
        } else {
            let result = expectations.enumerated().map { index, element in
                (element, fulfilled[index])
            }
            failTest(using: result)
        }
    }
    
    private func failTest(using tuples: [(expectation: Expectable, fulfilled: Bool)]) {
        for tuple in tuples {
            let fulfilled = tuple.fulfilled
            let expectation = tuple.expectation
            if !fulfilled {
                XCTFail(expectation.failureReason(), file: expectation.file, line: expectation.line)
            }
        }
    }
}
