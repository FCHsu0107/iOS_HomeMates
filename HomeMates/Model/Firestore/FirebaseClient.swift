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
    
    case failure(Error)
}

enum HMFirebaseClientError: Error {
    
    case decodingError
    
    case clientError(Data)
    
    case serverError
    
    case documentDoesNotExist
    
    case unexpectedError
    
}

enum HMFirebaseMethod: String {
    
    case create
    
    case createWithUid
    
    case read
    
    case readDocWithPath
    
    case update
    
    case updateTheStatus
    
    case delete
}

class FirebaseClient {
    
    private init() {}
    
    static let shared = FirebaseClient()
    
    func configure() {
        FirebaseApp.configure()
    }
    
    func create<T: Encodable>(for encodableObject: T,
                              in collectionRef: CollectionReference,
                              completion:  @escaping (Result<Bool>) -> Void) {
        
        var ref: DocumentReference?
        do {
            var json = try encodableObject.toJSON()
            ref = collectionRef.document()
            guard let ref = ref else { return }
            json["docId"] = ref.documentID
            collectionRef.document(ref.documentID).setData(json) { (err) in
                if err == nil {
                    completion(Result.success(true))
                } else {
                    guard let err = err else { return }
                    completion(Result.failure(err))
                }
            }
        } catch {
            completion(Result.failure(error))
        }
 
    }
    
    func createWithUid<T: Encodable>(for encodableObject: T,
                                     in collectionRef: CollectionReference,
                                     uid: String,
                                     completion: @escaping (Result<Bool>) -> Void) {
        do {
            let json = try encodableObject.toJSON()
            collectionRef.document(uid).setData(json) { (err) in
                
                if err == nil {
                    completion(Result.success(true))
                } else {
                    guard let err = err else { return }
                    completion(Result.failure(err))
                }
            }
        } catch {
            completion(Result.failure(error))
        }

    }

    func read<T: Decodable>(form collectionRef: CollectionReference,
                            returning objectType: T.Type,
                            query: Query?,
                            completion: @escaping (Result<[T]>) -> Void) {
        if query == nil {
            let ref = collectionRef
            
        } else {
            let ref = query
        }
    
        collectionRef.getDocuments { (snapshot, err) in
            if err == nil {
                guard let snapshot = snapshot else {
                    return completion(Result.failure(HMFirebaseClientError.documentDoesNotExist))
                }
                do {
                    var objects = [T]()
                    for document in snapshot.documents {
                        let object = try document.decode(as: objectType.self)
                        objects.append(object)
                    }
                    completion(Result.success(objects))
                } catch {
                    completion(Result.failure(error))
                }
                
            } else {
                guard let err = err else { return }
                completion(Result.failure(err))
            }
        }
    }
    
    func readDocWithPath<T: Decodable>(uid: String,
                                           form collectionRef: CollectionReference,
                                           returning objectType: T.Type,
                                           completion: @escaping (Result<T>) -> Void) {
        collectionRef.document(uid).getDocument { (document, err) in
            if err == nil {
                guard let document = document else {
                    return completion(Result.failure(HMFirebaseClientError.documentDoesNotExist))
                }
                do {
                    let object = try document.decode(as: objectType.self)
                    completion(Result.success(object))
                } catch {
                    completion(Result.failure(HMFirebaseClientError.decodingError))
                }
            } else {
                guard let err = err else { return }
                completion(Result.failure(err))
            }
        }
    }
    
    func update<T: Encodable>(uid: String,
                              in collectionRef: CollectionReference,
                              for encodableObject: T,
                              completion: @escaping (Result<Bool>) -> Void) {

        do {
            let json = try encodableObject.toJSON()
            collectionRef.document(uid).updateData(json) { (err) in
                if err == nil {
                    completion(Result.success(true))
                } else {
                    guard let err = err else { return }
                    completion(Result.failure(err))
                }
            }
        } catch {
            completion(Result.failure(error))
        }
        
    }
    
    func updateTheStatus(uid: String,
                         in collectionRef: CollectionReference,
                         updateItem: [String: Any],
                         completion: @escaping (Result<Bool>) -> Void) {
        collectionRef.document(uid).updateData(updateItem) { (err) in
            if err == nil {
                completion(Result.success(true))
            } else {
                guard let err = err else { return }
                completion(Result.failure(err))
            }
        }
    }
    
    func delete(uid: String,
                in collectionRef: CollectionReference,
                completion: @escaping (Result<Bool>) -> Void) {
        collectionRef.document(uid).delete { (err) in
            if err == nil {
                completion(Result.success(true))
            } else {
                guard let err = err else { return }
                completion(Result.failure(err))
            }
        }
    }
    
    
    
}
