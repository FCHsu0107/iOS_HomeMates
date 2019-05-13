//
//  ProfileInfoProvider.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/5/13.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

class ProfileProvider {
    
    func readUserInfo(completion: @escaping (Result<UserObject>) -> Void) {
        FirebaseClient.shared.readDocWithPath(
        uid: UserDefaultManager.shared.userUid!,
        form: FIRCollectionRef.users.collectionRef(uid: nil),
        returning: UserObject.self) { (result) in
            switch result {
            case .success(let object):
                completion(Result.success(object))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
}
