//
//  asdfTests.m
//  asdfTests
//
//  Created by Steffen André Langnes on 15/11/2018.
//  Copyright © 2018 Steffen André Langnes. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface asdfTests : XCTestCase

@end

@implementation asdfTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}


func testConcat() {
    let a = (0...5).map { "dice\($0)" } // dice0, dice1, ...
    var s = ""
    self.measure {
        for _ in 0...10000000 {
            for i in 0...5 {
                s = a[i]
            }
        }
    }
    print(s)
}
- (void)testPerformanceExample {
    NSString* s;
    [self measureBlock:^{
        for (int i = 0; i < 10000000; ++i) {
            for (int j = 0; j <= 5; ++j) {
                s = 
            }
        }
    }];
    printf("%@", s)
}

@end
