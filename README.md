# swift-async-expectations

AsyncExpectations is a testing library for Swift that brings structured testing to unstructured concurrency.

## Motivation
Writing unit tests for structured concurrency is straightforward and simple.

```swift
func testSearch() async throws {
    let text = "Hello, is it me your looking for?"
    let searchService = SearchService()
  
    let searchResult = try await searchService.search(for: "Hello", in: text)
  
    XCTAssertEqual(searchResult.count, 1)
    XCTAssertEqual(text[searchResult[0]], "Hello")
}
```

But for unstructured concurrency this can be more challenging. For example, when writing integration tests to evaluate how a view model interacts with the SearchService.

```swift
class ViewModel: ObservableObject {
    @Published var text = "Hello, is it me your looking for?"
    @Published var searchText = ""
    @Published var searchResult: [Range<String.Index>] = []
    // ...
    init(searchService: SearchService) {
        self.searchService = searchService
        self.cancellable = $searchText
            .filter { !$0.isEmpty }
            .sink(receiveValue: { [weak self] searchText in
                guard let self else {
                    return
                }
                self.searchTask?.cancel()
                self.searchTask = Task {
                    let result = try await searchService.search(for: searchText, 
                                                                in: self.text)
                    await MainActor.run {
                        self.searchResult = result
                    }
                }
        })
    }
}
```

To write a test that passes using async await we need to introduce a delay.

```swift
func testSearch() async throws {
    let text = "Hello, is it me your looking for?"
    let viewModel = ViewModel(text: text, searchService: .init())

    viewModel.searchText = "Hello"
    try await Task.sleep(until: .now + .seconds(0.2), clock: .continuous)

    XCTAssertEqual(viewModel.searchResult.count, 1)
    XCTAssertEqual(text[viewModel.searchResult[0]], "Hello")
}
```

However, relying on arbitrary delays can make the test unreliable. Additionally, the test will run slower since it requires a wait time of at least 0.2 seconds.

Another more reliable approach would be to use Combine with an `XCTestExpectation`.
```swift
private var cancellables: Set<AnyCancellable>!

override func setUp() {
    super.setUp()
    cancellables = []
}

func testSearch() {
    let expectation = expectation(description: #function)
    let text = "Hello, is it me your looking for?"
    let viewModel = ViewModel(text: text, searchService: .init())
    viewModel.$searchResult
        .dropFirst()
        .sink { searchResult in
            XCTAssertEqual(searchResult.count, 1)
            XCTAssertEqual(text[searchResult[0]], "Hello")
            expectation.fulfill()
        }
        .store(in: &cancellables)

    viewModel.searchText = "Hello"

    wait(for: [expectation], timeout: 1)
}
```
But this approach not only necessitates the use of more boilerplate code, but it also results in less readable code due to its non-linear nature. Furthermore, it requires us to maintain a reference to a cancellable object and perform necessary cleanup after each test.

With AsyncExpectations, we can remove the delay and the boilerplate, resulting in much simpler code.

```swift
func testSearch() async throws {
    let text = "Hello, is it me your looking for?"
    let viewModel = ViewModel(text: text, searchService: .init())
  
    viewModel.searchText = "Hello"
  
    try await expectEqual(viewModel.searchResult.count, 1)
    try await expectEqual(text[viewModel.searchResult[0]], "Hello")
}
```

## Expectations

AsyncExpectations provides a number of different expectations.

### `expectValue`

The `expectValue` can be used to await a value, useful for testing Combine publishers or unwrapping optionals.

```swift
class Queue {
    let messages: AnyPublisher<String, Never>
    func sendMessage(_ string: String)
}

func testQueue() async throws {
    let queue = Queue()
  
    queue.sendMessage("Foo")
  
    let value = try await expectValue(queue.messages)
    XCTAssertEqual(value, "Foo")
}
```

### `expect`

Waits for a specified time for an expectation to be true.

```swift
class SomeMock: SomeProtocol {
    var callback: () -> Void
    var didCallFoo = false
    func foo() {
        didCallFoo = true
    }
}

func testMock() async throws {
    let mock = SomeMock()
    var fulfilled = false
    mock.callback = {
        fulfilled = true
    }
    let model = SomeModel(mock)
  
    model.thisWillEventuallyCallTheMock()
    
    try await expect(model.didCallFoo)
    try await expect(fulfilled)
}
```

Full list of expectations includes.

* expect

* expectFalse

* expectEqual

* expectNotEqual

* expectNotNil

* expectNil

* expectThrowsError

* expectNoThrow

* expectLessThan

* expectLessThanOrEqual

* expectGreaterThan

* expectGreaterThanOrEqual

* expectValue


If needed, we can easlily extend this list with additional expectations.

```swift
@MainActor func expectNumbers(_ expression: @MainActor @escaping () async throws -> String,
                              file: StaticString = #file,
                              line: UInt = #line,
                              timeout: TimeInterval = 1) async throws {
    let allNumbers = { try await expression().allSatisfy { $0.isNumber } }
    if try await !evaluate(allNumbers, timeout: timeout) {
        let value = try await expression()
        XCTFail(#""\#(value)" is not all numbers"#, file: file, line: line)
    }
}
```

## Cancellation

Unlike XCTest, AsyncExpectations will cancel the current task in the event of a test timeout. Failure to cancel the task could result in the current test run freezing if the task never completes.

## Installation

You can add AsyncExpectations as a package dependency `https://github.com/bangerang/swift-async-expectations`. Make sure you add it to your test target and not the main target.

