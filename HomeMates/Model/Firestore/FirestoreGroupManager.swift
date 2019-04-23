//
//  FirestoreGroupManager.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/22.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation
import Firebase

class FirestoreGroupManager {
    
    private init() {}
    
    static var shared = FirestoreGroupManager()
    
    private func reference(to collectionReference: FIRCollectionReference) -> CollectionReference {
        
        return Firestore.firestore()
            .collection(FIRCollectionReference.groups.rawValue)
            .document(UserDefaultManager.shared.groupId!)
            .collection(collectionReference.rawValue)
    }
    
}
