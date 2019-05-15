//
//  ProfileInfoProvider.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/5/13.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

class ProfileProvider {
    
    private let firebaseClient: FirebaseManageable
    
    init(firebaseClient: FirebaseManageable = FirebaseClient.shared) {
        self.firebaseClient = firebaseClient
    }
    
    func readUserInfo(completion: @escaping (Result<UserObject>) -> Void) {
        let ref = FIRCollectionRef.users.collectionRef()
        firebaseClient.readDocWithPath(
            uid: UserDefaultManager.shared.userUid!, form: ref,
            returning: UserObject.self) { (result) in
            switch result {
            case .success(let object):
                completion(Result.success(object))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func readMemberInfo(completion: @escaping (Result<[MemberObject]>) -> Void) {
        let ref = FIRCollectionRef.members.collectionRef(uid: UserDefaultManager.shared.groupId!)
        
        firebaseClient.read(form: ref, returning: MemberObject.self,
                            query: { $0 }, completion: { (result) in
                switch result {
                case .success(let members):
                    completion(Result.success(members))
                case .failure(let err):
                    completion(Result.failure(err))
                }
        })
    }
    
    func dropOutMainGroup(memberNumber: Int, completion: @escaping (Bool) -> Void) {
        
        let userDocId = UserDefaultManager.shared.userUid!
        let groupDocId = UserDefaultManager.shared.groupId!
        
        let dispatchGroup = DispatchGroup()
        // delete memner info in the group collection
        dispatchGroup.enter()
        if memberNumber == 1 {
            firebaseClient.delete(uid: groupDocId,
                                  in: FIRCollectionRef.groups.collectionRef()) { (result) in
                print(result)
                dispatchGroup.leave()
            }
        } else {
            let ref = FIRCollectionRef.members.collectionRef(uid: groupDocId)
            firebaseClient.read(form: ref, returning: MemberObject.self, query: { (query) in
                return query.whereField(MemberObject.CodingKeys.userId.rawValue, isEqualTo: userDocId)
            }) { [weak self] (result) in
                switch result {
                case .success(let members):
                    guard let memberDocId = members[0].docId else { return }
                    self?.firebaseClient.delete(uid: memberDocId, in: ref) { (result) in
                        print(result)
                        dispatchGroup.leave()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        let userCollectionRef = FIRCollectionRef.users.collectionRef()
        let userDocRef = userCollectionRef.document(userDocId)
        
        dispatchGroup.enter()
        firebaseClient.delete(
            uid: groupDocId,
            in: userDocRef.collection(FIRCollectionReference.groups.rawValue)) { (result) in
                print(result)
                dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        firebaseClient.deleteTheStatus(uid: userDocId, in: FIRCollectionRef.users.collectionRef(), deleteItem: UserObject.CodingKeys.mainGroupId.rawValue) { (result) in
            print(result)
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            completion(true)
        }
    }

    
}
