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

//class MockFirestore: Firestore {
//    var path: String = " "
//    
//    init(test: String) {
//        
//    }
//    
//    override func collection(_ collectionPath: String) -> CollectionReference {
//        path += (collectionPath + "/")
//        
//        return super.collection(collectionPath)
//    }
//    
//    override func document(_ documentPath: String) -> DocumentReference {
//        path += (documentPath + "/")
//        return super.document(documentPath)
//    }
//}
//
//class MockCollectionReference: CollectionReference {
//    init(test: String) {
//        
//    }
//}
//
//class MockDocumentReference: DocumentReference {
//    init(test: String) {
//        
//    }
//}

class FirebaseClientMock: FirebaseManageable {
    
    var user: UserObject!
    
    func readDocWithPath<T>(
        uid: String, form collectionRef: CollectionReference, returning objectType: T.Type,
        completion: @escaping (Result<T>) -> Void) where T: Decodable {
        
        do {
            
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
    
    func test_readUserInfo_getData() {
        //Arrange
        let firebasClient = FirebaseClientMock()
        let provider = ProfileProvider(firebaseClient: firebasClient)
//        let expectedResult = Result<UserObject>.failure(HMFirebaseClientError.decodingError)

        let user = UserObject(
            docId: nil, name: "test", email: "unitTest@mail.com", picture: nil, creator: false,
            application: false, finishSignUp: true, mainGroupId: "test", fcmToken: "unitTest")
        
        firebasClient.user = user
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
