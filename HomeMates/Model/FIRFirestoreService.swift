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
        do {
            let json = try encodableObject.toJSON()
            reference(to: collectionReference).addDocument(data: json)
            
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
    
    func findUser(uid: String) -> Bool {
        var documentExists: Bool = true
        self.reference(to: .users).document(uid).getDocument() { (document, _) in
                
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                documentExists = true
            } else {
                print("Document does not exist.")
                documentExists = false
            }
        }
        return documentExists
    }
    
    func update<T: Encodable & Identifiable>(for encodableObject: T,
                                             in collectionReference: FIRCollectionReference) {
        
        do {
            let json = try encodableObject.toJSON(excluding: ["uid"])
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
