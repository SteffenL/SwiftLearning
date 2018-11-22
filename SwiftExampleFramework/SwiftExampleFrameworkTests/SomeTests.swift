//
//  SwiftExampleFrameworkTests.swift
//  SwiftExampleFrameworkTests
//
//  Created by Steffen André Langnes on 13/11/2018.
//  Copyright © 2018 Steffen André Langnes. All rights reserved.
//

import XCTest
@testable import SwiftExampleFramework

class SomeTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testArray() {
        let a = (0...5).map { "dice\($0)" } // dice0, dice1, ...
        var s = ""
        self.measure {
            for _ in 0...5000000 {
                for i in 0...5 {
                    s = a[i]
                }
            }
        }
        print(s)
    }

    func testConcat() {
        var s = ""
        self.measure {
            for _ in 0...5000000 {
                for i in 0...5 {
                    s = "dice\(i)"
                }
            }
        }
        print(s)
    }

    func testFibonacci1() {
        func fibonacci(until: Int) {
            var fibSum : [Int] = [0, 1]

            for number in 0...until {
                fibSum.append(fibSum[number] + fibSum[number+1])
                //print(fibSum[number])
            }

        }

        self.measure {
            for _ in 0...1000000 {
                fibonacci(until: 10)
            }
        }
    }

    func testFibonacci2() {
        func fibonacci(until: Int) -> [Int] {
            var a = [0, 1] + Array(0..<until)
            for i in 0..<until {
                a[i + 2] = a[i] + a[i + 1]
            }
            return a
        }

        self.measure {
            for _ in 0...1000000 {
                fibonacci(until: 10)
            }
        }
    }
}
