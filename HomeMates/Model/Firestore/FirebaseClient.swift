//
//  FIrebaseClient.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/5/7.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation
import Firebase

enum Result<T> {
    
    case success(T)
    
    case createSuccessfully
    
    case failure(Error)
}

enum HMFirebaseClientError: Error {
    
    case encodingError
    
    case decodingError
    
    case clientError(Data)
    
    case serverError
    
    case unexpectedError
}

enum HMFirebaseMethod: String {
    
    case create
    
    case createWithUid
    
    case getMultiDocuments
    
    case getSingleDocument
    
    case update
    
    case delete
}

//
//protocol HMRequest {
//
//    var method: String { get }
//
//    var data
//
//}


class FirebaseClient {
    
    private init() {}
    
    static let shared = FirebaseClient()
    
    func configure() {
        FirebaseApp.configure()
    }
    
    func create<T: Encodable>(for encodableObject: T,
                              in collectionRef: CollectionReference,
                              completion:  @escaping (Result<T>) -> Void) {
        
        var ref: DocumentReference?
        do {
            let json = try encodableObject.toJSON()
            ref = collectionRef.document()
            guard let ref = ref else { return }
            json["docId"] = ref.documentID
            collectionRef.document(ref.documentID).setData(json) { (err) in
                if err == nil {
                    completion(Result.createSuccessfully)
                } else {
                    completion(Result.failure(HMFirebaseClientError.clientError(err)))
                }
            }
        } catch {
            completion(Result.failure(HMError.encodingError))
        }
 
    }
    
    func createWithUid<T: Encodable>(for encodableObject: T,
                                     in collectionRef: CollectionReference,
                                     uid: String,
                                     completion: @escaping (Result<T>) -> Void) {
        do {
            let json = try encodableObject.toJSON()
            collectionRef.document(uid).setData(json) { (err) in
                if err == nil {
                    completion(Result.createSuccessfully)
                } else {
                    completion(Result.failure(err))
                }
            }
        } catch {
            completion(Result.failure(HMFirebaseClientError.encodingError))
        }

    }

    func getMultiDocuments() {}
}
