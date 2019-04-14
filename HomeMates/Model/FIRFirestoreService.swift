//
//  FIRFirestoreService.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/13.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class FIRFirestoreSerivce {
    
    private init() {}
    
    static let shared = FIRFirestoreSerivce()
    
    func configure() {
        FirebaseApp.configure()
    }
    
    private func reference(to collectionReference: FIRCollectionReference
//        ,
//                           subCollection: Bool = false,
//                           into subCollectionReference: FIRCollectionReference?
        ) -> CollectionReference {
        
//        if !subCollection {
            return Firestore.firestore().collection(collectionReference.rawValue)
//        } else {
//            return Firestore.firestore().collection(collectionReference.rawValue).document()
//        }
    }
    
    func create<T: Encodable>(for encodableObject: T,
                              in collectionReference: FIRCollectionReference) {
        
        do {
            let json = try encodableObject.toJSON()
            reference(to: .users).addDocument(data: json)
        } catch {
            print(error)
        }
       
    }
    
    func read<T: Decodable>(from collectionReference: FIRCollectionReference,
                            returning objectType: T.Type,
                            completion: @escaping ([T]) -> Void) {
        
        reference(to: collectionReference).addSnapshotListener { (snapshot, _) in
            
            guard let snapshot = snapshot else { return }
            
            do {
                var objects = [T]()
                for document in snapshot.documents {
                    let object = try document.decode(as: objectType.self)
                    objects.append(object)
                }
                
                completion(objects)
            } catch {
                print(error)
            }
            
        }
    }
    
    func update<T: Encodable & Identifiable>(for encodableObject: T, in collectionReference: FIRCollectionReference) {
        
        do {
            let json = try encodableObject.toJSON(excluging: ["uid"])
            guard let uid = encodableObject.uid else { throw HMError.encodingError }
            reference(to: collectionReference).document(uid).setData(json)
        } catch {
            print(error)
        }
        
    }
    
    func delete<T: Identifiable>(_ identifiableObject: T,
                                 in collectionReference: FIRCollectionReference) {
        do {
            guard let uid = identifiableObject.uid else { throw HMError.encodingError }
            
            reference(to: collectionReference).document(uid).delete()
            
        } catch {
            print(error)
        }
        
    }
    
}
