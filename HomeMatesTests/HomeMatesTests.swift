//
//  HomeMatesTests.swift
//  HomeMatesTests
//
//  Created by Fu-Chiung HSU on 2019/5/12.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import XCTest
import UIKit
import Firebase
@testable import HomeMates

class FirebaseClientMock: FirebaseManageable {
    
    var user: UserObject!
//    var dictData: [[String: Any]]!
    
    func readDocWithPath<T>(
        uid: String, form collectionRef: CollectionReference, returning objectType: T.Type,
        completion: @escaping (Result<T>) -> Void) where T: Decodable {
        
        do {
            
//            let dataDict = try JSONSerialization.data(withJSONObject: dictData!, options: [])
//            let dictResult = try JSONDecoder().decode(T.self, from: dataDict)
//            completion(Result.success(dictResult))
            
            let data = try JSONEncoder().encode(user)
            let result = try JSONDecoder().decode(T.self, from: data)
            
            completion(Result.success(result))
            
        } catch {
            completion(Result.failure(error))
        }
    }
    
}

class HomeMatesTests: XCTestCase {

    var firebaseClientTest: FirebaseClient!
    
    override func setUp() {
        super.setUp()
       
    }

    override func tearDown() {
        super.tearDown()
        
    }
    
    func test_profileProvieder_readUserInfo_getDataSuccessfully() {
        //Arrange
        let firebasClient = FirebaseClientMock()
        let provider = ProfileProvider(firebaseClient: firebasClient)

        let user = UserObject(
            docId: nil, name: "test", email: "unitTest@mail.com", picture: nil, creator: false,
            application: false, finishSignUp: true, mainGroupId: "test", fcmToken: "unitTest")
        firebasClient.user = user
        
//        let userObject: [[String: Any]] = [[ "email": "unitTest@mail.com", "creator": false]]
//        firebasClient.dictData = userObject
        //Action
        var actualResult: UserObject?
        
        var actualError: Error?
        
        provider.readUserInfo { (result) in
            
            switch result {
                
            case .success(let userObject):
                
                actualResult = userObject
                
            case .failure(let error):
                
                actualError = error
            }
        }

        // Assert
        
        XCTAssertNil(actualError)
        XCTAssertEqual(user.email, actualResult?.email)
    }
    
    func test_profileProvieder_readUserInfo_getDataWithError() {
        //Arrange
        let firebasClient = FirebaseClientMock()
        let provider = ProfileProvider(firebaseClient: firebasClient)
        
        //Action
        var actualResult: UserObject?
        var actualError: Error?
        
        provider.readUserInfo { (result) in
            
            switch result {
                
            case .success(let userObject):
                
                actualResult = userObject
                
            case .failure(let error):
                
                actualError = error
            }
        }
        
        // Assert
        
        XCTAssertNotNil(actualError)
    }
    
    func test_dateProvider_getCorrectString() {
        //Arrange
        let timeStamp = 1557886002000
        let expectedResult = "2019/05/15"
        
        //Action
        let actualResult = DateProvider.shared.getCurrentDate(currentTimeStamp: timeStamp)
        
        //Assert
        XCTAssertEqual(actualResult, expectedResult)
        
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

}
