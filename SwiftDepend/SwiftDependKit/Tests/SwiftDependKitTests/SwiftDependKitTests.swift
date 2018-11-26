import XCTest
@testable import SwiftDependKit

final class SwiftDependKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftDependKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
