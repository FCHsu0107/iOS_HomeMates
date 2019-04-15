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
    
    private func reference(to collectionReference: FIRCollectionReference) -> CollectionReference {

            return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    private func subReference(to collectionReference: FIRCollectionReference,
                              in document: String,
                              toNext subCollectionReference: FIRCollectionReference)
        -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue).document(document).collection(subCollectionReference.rawValue)
    }
    
    func createUser<T: Encodable>(uid: String,
                                  for encodableObject: T,
                                  in collectionReference: FIRCollectionReference) {
        do {
            let json = try encodableObject.toJSON()
            reference(to: collectionReference).document(uid).setData(json)
        } catch {
            print(error)
        }
    }
    
    func create<T: Encodable>(for encodableObject: T, in collectionReference: FIRCollectionReference) {
        var ref: DocumentReference?
        do {
            let json = try encodableObject.toJSON()
            
            ref = reference(to: collectionReference).addDocument(data: json)
            guard let ref = ref else { return }
            print(ref.documentID)
            UserDefaultManager.shared.groupId = ref.documentID
            print(UserDefaultManager.shared.userUid)
            
        } catch {
            print(error)
        }
    }
    
    func createSub<T: Encodable>(for encodableObject: T,
                                 in collectionReference: FIRCollectionReference,
                                 inDocument: String,
                                 inNext subCollectionReference: FIRCollectionReference) {
        var ref: DocumentReference?
        do {
            let json = try encodableObject.toJSON()
            
            ref = reference(to: collectionReference).document(inDocument).collection(subCollectionReference.rawValue).addDocument(data: json)
            guard let ref = ref else { return }
            print(ref.documentID)
            
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
    
    typealias BoolCompleionHandler = (Bool?) -> Void
    
    func findUser(completionHandler completion: @escaping BoolCompleionHandler) {
        
        guard let user = Auth.auth().currentUser else { return }
        let uid = user.uid
        reference(to: .users).document(uid).getDocument { (querySnapshot, _) in
            guard let querySnapshot = querySnapshot else { return }
            
            completion(querySnapshot.data()![UserObject.CodingKeys.finishSignUp.rawValue] as? Bool)
        }
    }
    
    func update<T: Encodable>(for encodableObject: T,
                                             in collectionReference: FIRCollectionReference) {
        
        do {
            let json = try encodableObject.toJSON()
            
//            reference(to: collectionReference).document(uid).setData(json)
        } catch {
            print(error)
        }
    }
    
    func delete(uid: String, in collectionReference: FIRCollectionReference) {
        do {
            
            reference(to: collectionReference).document(uid).delete()
        } catch {
            print(error)
        }
    }
}
