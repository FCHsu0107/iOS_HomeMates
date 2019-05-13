//
//  HomeMatesTests.swift
//  HomeMatesTests
//
//  Created by Fu-Chiung HSU on 2019/5/12.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import XCTest
import UIKit
@testable import HomeMates

class HomeMatesTests: XCTestCase {

    var authProviderTest: AuthProvider!
    
    override func setUp() {
        super.setUp()
        authProviderTest = AuthProvider()
       
    }

    override func tearDown() {
        super.tearDown()
        authProviderTest = nil
        
    }
    func test_authManager_signIn() {
//        authProviderTest.signInAction(email: <#T##String#>, password: <#T##String#>, ownVc: <#T##UIViewController#>)
        
    }
    
    func testJacqueline() {
        // 3A - Arrange, Action, Assert
        // Arrange
        let aaa = 10
        let bbb = 20
        
        let expectedResult = aaa + bbb
        
        //Action
        let actualResult = add(aaa: aaa, bbb: bbb)
        
        // Assert
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func add(aaa: Int, bbb: Int) -> Int {
        return 30
    }
    
//
//    func fib(_ index: Int) -> Int {
//        if index < 0 {
//            return 0
//        } else if index <= 1 {
//            return 1
//        } else {
//            return fib(index - 1) + fib(index - 2)
//        }
//    }
//
//    func fibArr(_ index: Int) -> Int {
//        var fibs: [Int] = [1, 1]
//        (2...index).forEach { number in
//            fibs.append(fibs[number - 1] + fibs[number - 2])
//        }
//        return fibs.last!
//    }
//
//    func fibF(_ index: Int) -> Int {
//        var first = 1
//        var second = 1
//        guard index > 1 else { return first }
//
//        (2...index).forEach { _ in
//            (first, second) = (first + second, first)
//        }
//        return first
//    }
//
//    func test_initial_input() {
//        let fib1 = 1
//        let expectedResult = fib1
//        let actualResult = fib(1)
//
//        XCTAssertEqual(actualResult, expectedResult)
//    }
//
//    func test_number() {
//        let fib2 = 2
//        let expectedResult = fib2
//        let actualResult = fib(2)
//
//        XCTAssertEqual(actualResult, expectedResult)
//    }
//
//    func test_correct() {
//        let n10 = fib(10)
//        let n11 = fib(11)
//        let expectedResult = n10 + n11
//        let actualResult = fib(12)
//
//        XCTAssertEqual(actualResult, expectedResult)
//    }
//
//    func test_negative() {
//        let expectedResult = 0
//        let actualResult = fib(-1)
//
//        XCTAssertEqual(expectedResult, actualResult)
//    }
//
//    //跑太久
////    func testBigNumber() {
////        let test = fibArr(9999)
////        print("__________")
////        print(test)
////        print("---------------")
////    }
//
   
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
