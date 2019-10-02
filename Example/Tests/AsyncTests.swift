import XCTest
@testable import Espresso

class AsyncTests: XCTestCase {
    
    private enum TestError: Error {
        
        struct Specific: Error {}
        
        case generic
        
    }
    
    private let int: Int = 23
    private let intArray = [0, 1, 2, 3]
    
    private let string: String = "Hello, world!"
    private let stringArray = ["0", "1", "2", "3"]
    
    // MARK: Tests
    
    func testDone() {
        
        weak var exp = self.expectation(description: "Fulfilled with expected value")

        var string = ""
        
        let async = Async<String>(value: self.string).done { _string in
            
            string = _string
            exp?.fulfill()
            
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssert(string == self.string)
        XCTAssert(async.isFulfilled)
        
    }
    
    func testThenDone() {
        
        weak var exp = self.expectation(description: "Fulfilled with expected values")
        
        var string = ""
        var int = 0
        
        let async = Async<String>(value: self.string).then { _string -> Async<Int> in
            
            string = _string
            return Async<Int>(value: self.int)
            
        }.done { _int in
            
            int = _int
            exp?.fulfill()
            
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssert(string == self.string)
        XCTAssert(int == self.int)
        XCTAssert(async.isFulfilled)
        
    }
    
    func testCatchAny() {
        
        weak var exp = self.expectation(description: "Rejected when any error is thrown")
        
        var error: Error?
        
        let async = Async<Void>(error: TestError.generic)
        async.catch { _error in
            
            error = _error
            exp?.fulfill()
            
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertNotNil(error)
        XCTAssert(async.isRejected)
        
    }
    
    func testCatchSpecific() {
        
        weak var exp = self.expectation(description: "Rejected when a specific error is thrown")
        
        var error: Error?
        
        let async = Async<Void>(error: TestError.Specific())
        async.catch(type: TestError.Specific.self) { _error in
            
            error = _error
            exp?.fulfill()
            
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssert(error is TestError.Specific)
        XCTAssert(async.isRejected)
        
    }
    
    func testFinally() {
        
        weak var exp = self.expectation(description: "Finally is run after everything, regardless of resolution")
                        
        Async<String>(value: self.string).then { _ in
            return Async<Int>(value: self.int)
        }.done { _ in
            throw TestError.generic
        }.catch { _ in
            //
        }
        .finally {
            exp?.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
    }
    
    func testMap() {
        
        weak var exp = self.expectation(description: "Fulfilled with the expected mapped value")
                        
        var int = 0
        
        let async = Async<Int>(value: self.int)
            .map { $0 + 10 }
            .done { _int in
                
                int = _int
                exp?.fulfill()
                
            }
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssert(int == (self.int + 10))
        XCTAssert(async.isFulfilled)
        
    }
    
    func testCompactMap() {
        
        weak var exp = self.expectation(description: "Rejected with `AsyncError.compactMap`")
                        
        var error: Error?
        
        Async<String>(value: self.string).compactMap { string -> String? in
                
            if string.count < 100 { return nil }
            return string
                
        }.catch { _error in
            
            error = _error
            exp?.fulfill()
            
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssert((error as? AsyncError) == .compactMap)
        
    }
    
    func testMapSequenceValues() {
        
        weak var exp = self.expectation(description: "Fulfilled with the expected mapped sequence values")
                        
        var strings = [String]()
        
        Async<[Int]>(value: self.intArray)
            .mapValues { "\($0)" }
            .done { _strings in
                
                strings = _strings
                exp?.fulfill()
                
            }
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssert(strings == self.stringArray)
        
    }
    
    func testFlatMapSequenceValues() {
        
        weak var exp = self.expectation(description: "Fulfilled with the expected flat-mapped sequence values")
                        
        var ints = [Int]()
        
        Async<[Int]>(value: self.intArray)
            .flatMapValues { [$0, $0] }
            .done { _ints in
                
                ints = _ints
                exp?.fulfill()
                
            }
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssert(ints.count == (self.intArray.count * 2))
        
    }
    
    func testCompactMapSequenceValues() {
        
        weak var exp = self.expectation(description: "Fulfilled with the expected compact-mapped sequence values`")
        
        var array = self.stringArray
        array.append("x")
        array.append("y")
        array.append("z")
        
        var ints = [Int]()
        
        Async<[String]>(value: array)
            .compactMapValues { Int($0) }
            .done { _ints in
                
                ints = _ints
                exp?.fulfill()
                
            }
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssert(ints == self.intArray)
        
    }
    
    func testSortSequenceValues() {
        
        weak var exp = self.expectation(description: "Fulfilled with the expected sorted sequence values")
        
        var ints = [Int]()
        
        Async<[Int]>(value: self.intArray.shuffled())
            .sortedValues()
            .done { _ints in
                
                ints = _ints
                exp?.fulfill()
                
            }
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssert(ints.first == self.intArray.first)
        XCTAssert(ints.last == self.intArray.last)

    }
    
    func testGuard() {
        
        weak var exp = self.expectation(description: "Rejected with `AsyncError.guard`")
                        
        var error: Error?
        
        Async<String>(value: self.string)
            .guard { $0 == "nope" }
            .catch { _error in
                
                error = _error
                exp?.fulfill()
                
            }
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssert((error as? AsyncError) == .guard)
        
    }
    
    func testDo() {
        
        weak var exp = self.expectation(description: "Fulfilled after running chained do-block")

        var int = 0
        
        Async<String>(value: self.string).do { _ in
            int = self.int
        }.done { _ in
            exp?.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssert(int == self.int)
        
    }
    
    func testTimeout() {
        
        weak var exp = self.expectation(description: "Rejected with `AsyncError.timeout`")
        
        var error: Error?
        
        asyncInt()
            .timeout(0.1)
            .catch { _error in
                
                error = _error
                exp?.fulfill()
                
            }
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssert((error as? AsyncError) == .timeout)
        
    }
    
    func testRecoverAny() {
        
        weak var exp = self.expectation(description: "Fulfilled on any error with recovered value")
        
        var string: String?
        
        asyncError().recover { _ in
            
            return Async<String>(value: self.string)
            
        }.done { _string in
            
            string = _string
            exp?.fulfill()
            
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssert(string == self.string)
                
    }
    
    func testRecoverSpecific() {
        
        weak var exp = self.expectation(description: "Fulfilled on specific error with recovered value")
        
        var string: String?
        
        asyncError(specific: true).recover(type: TestError.Specific.self) { _ in
            
            return Async<String>(value: self.string)
            
        }.done { _string in
            
            string = _string
            exp?.fulfill()
            
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssert(string == self.string)
        
    }
    
    func testVoid() {
        
        weak var exp = self.expectation(description: "Fulfilled with a void value")
        
        var value: Any?
        
        _ = Async<Int>(value: self.int)
            .voided()
            .done { _value in
            
                value = _value
                exp?.fulfill()
            
            }
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssert(value is Void)
        
    }
    
    func testErased() {
        
        weak var exp = self.expectation(description: "Fulfilled with a void value")
        
        var string: String?
        
        let erased = Async<String>(value: self.string).erased()
        erased.done { _string in
            
            string = _string
            exp?.fulfill()
            
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssert(string == self.string)

    }
    
    // MARK: Globals
    
    func testGlobalAsync() {
        
        weak var exp = self.expectation(description: "Fulfilled with expected value")
        
        var string: String?
        
        async {
            
            self.asyncString()
            
        }.done { _string in
            
            string = _string
            exp?.fulfill()
            
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssert(string == self.string)
        
    }
    
    // MARK: Helpers
    
    private func asyncInt() -> Async<Int> {
        
        return Async<Int> { resolver in
            
            delay(0.5).done { _ in
                resolver.fulfill(23)
            }
            
        }
        
    }
    
    private func asyncString() -> Async<String> {
        
        return Async<String> { resolver in
            
            delay(0.5).done { _ in
                resolver.fulfill("Hello, world!")
            }
            
        }
        
    }
    
    private func asyncError(specific: Bool = false) -> Async<String> {
        
        let error: Error = specific ? TestError.Specific() : TestError.generic

        return Async<String> { resolver in
            
            delay(0.5).done { _ in
                resolver.reject(error)
            }
            
        }
        
    }
    
}
