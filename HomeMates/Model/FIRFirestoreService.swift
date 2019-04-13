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
    
    let reference = Firestore.firestore().collection("users")
    
    func configure() {
        FirebaseApp.configure()
    }
    
}
