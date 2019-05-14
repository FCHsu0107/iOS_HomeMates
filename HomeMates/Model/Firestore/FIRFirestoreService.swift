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
import FirebaseAuth

class FIRFirestoreSerivce {
    
    private init() {}
    
    static let shared = FIRFirestoreSerivce()
    
    func configure() {
        FirebaseApp.configure()
    }
    
    // Create func
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
    
    func createGroup<T: Encodable>(for encodableObject: T,
                                   in collectionReference: FIRCollectionReference,
                                   completion: @escaping (String?) -> Void) {
        
        var ref: DocumentReference?
        
        do {
            var json = try encodableObject.toJSON()
            
            ref = reference(to: collectionReference).document()
            
            guard let ref = ref else { return }
            json["docId"] = ref.documentID
            json["shortcup"] = ref.documentID.substring(toIndex: ref.documentID.length - 14)
            
            reference(to: collectionReference).document(ref.documentID).setData(json)
            UserDefaultManager.shared.groupId = ref.documentID
            completion(ref.documentID)
            
        } catch {
            
            print(error)
        }
    }
    
    func create<T: Encodable>(for encodableObject: T, in collectionReference: FIRCollectionReference) {
        
        var ref: DocumentReference?
        
        do {
            var json = try encodableObject.toJSON()
            
            ref = reference(to: collectionReference).document()
            
            guard let ref = ref else { return }
            json["docId"] = ref.documentID
            
            reference(to: collectionReference).document(ref.documentID).setData(json)
            
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
            var json = try encodableObject.toJSON()
            
            ref = subReference(to: collectionReference,
                               in: inDocument,
                               toNext: subCollectionReference).document()
            guard let ref = ref else { return }
            json["docId"] = ref.documentID
            subReference(to: collectionReference,
                         in: inDocument,
                         toNext: subCollectionReference)
                .document(ref.documentID)
                .setData(json)
            
        } catch {
            print(error)
        }
    }
    
    //read func
    func findGroup<T: Decodable>(groupId: String,
                                 returning objectType: T.Type,
                                 completion: @escaping ([T], [String]) -> Void) {
        let ref = reference(to: .groups).whereField(GroupObject.CodingKeys.groupId.rawValue, isEqualTo: groupId)
        ref.getDocuments { (snapshot, _) in
            guard let snapshot = snapshot else { return }
            do {
                var objects = [T]()
                var docIds = [String]()
                for documet in snapshot.documents {
                    let object = try documet.decode(as: objectType.self)
                    objects.append(object)
                }
                for document in snapshot.documents {
                    docIds.append(document.documentID)
                }
                completion(objects, docIds)
            } catch {
                print(error)
            }
        }
    }

    func readAllTasks(completionHandler: @escaping ([TaskObject]) -> Void) {
        subReference(to: .groups, in: UserDefaultManager.shared.groupId!, toNext: .tasks)
            .getDocuments { (snapshot, err) in
                guard let snapshot = snapshot else {
                    print(err as Any)
                    return }
                
                do {
                    var objects = [TaskObject]()
                    for document in snapshot.documents {
                        let object = try document.decode(as: TaskObject.self)
                        objects.append(object)
                    }
                    completionHandler(objects)
                } catch {
                    print(error)
                }
        }
    }

    //for statistic page
    func readDoneTask(completionHandler: @escaping ([TaskObject]) -> Void) {
        subReference(to: .groups, in: UserDefaultManager.shared.groupId!, toNext: .tasks)
            .whereField(TaskObject.CodingKeys.taskStatus.rawValue, isEqualTo: 4)
            .order(by: TaskObject.CodingKeys.completionTimeStamp.rawValue, descending: true)
            .getDocuments { (snapshot, err) in
                guard let snapshot = snapshot else {
                    print(err as Any)
                    return }
                
                do {
                    var objects = [TaskObject]()
                    for document in snapshot.documents {
                        let object = try document.decode(as: TaskObject.self)
                        objects.append(object)
                    }
                    completionHandler(objects)
                } catch {
                    print(error)
                }
        }
    }

    typealias BoolCompleionHandler = (User?, Bool?, UserObject?) -> Void
    
    func findUser(completionHandler completion: @escaping BoolCompleionHandler) {
        
        guard let user = Auth.auth().currentUser else {
            completion(nil, false, nil)
            return }
        let uid = user.uid
        UserDefaultManager.shared.userUid = uid
        reference(to: .users).document(uid).getDocument { (querySnapshot, _) in
            guard let data = querySnapshot?.data() else {
                completion(user, false, nil)
                return
            }
            do {
                let userObject = try querySnapshot?.decode(as: UserObject.self)
                UserDefaultManager.shared.groupId = userObject?.mainGroupId
                completion(user, data[UserObject.CodingKeys.finishSignUp.rawValue] as? Bool, userObject)
            } catch {
                
            }

        }
    }
    
    func findMainGroup(completion: @escaping (GroupObject) -> Void) {
        let user = Auth.auth().currentUser
        guard let currentUser = user else { return }
        UserDefaultManager.shared.userUid = currentUser.uid
        let ref = reference(to: .users).document(currentUser.uid)
        ref.getDocument { [ weak self ] (documnet, err) in
            if let document = documnet, document.exists {
                
                guard document.data() != nil else { return }
                do {
                    let object = try document.decode(as: UserObject.self)
                    let groupId = object.mainGroupId
                    UserDefaultManager.shared.groupId = groupId
                    UserDefaultManager.shared.userName = object.name
                    
                    self?.reference(to: .groups).document(groupId!).getDocument(completion: { (snapshot, err) in
                        
                        do {
                            guard let snapshot = snapshot else {
                                print(err as Any)
                                return }
                            let object = try snapshot.decode(as: GroupObject.self)
                            
                            let currentDate = DateProvider.shared.getCurrentDate()
                            completion(object)
                            if currentDate == object.logInDate {
                                print("第二個登入的人")
                            } else {
                                print("第一個登入的人")
                                FirestoreGroupManager.shared.addtheRegularTaskEveryDay()
                                //新增每日任務
                                //修改日期
                            }
                            
                        } catch {
                            print(error)
                        }
                    })
                } catch {
                    print(error)
                }
                
            } else {
                print(err as Any)
            }
        }
    }

    //update func
    func updateUser<T: Encodable>(uid: String,
                                  for encodableObject: T,
                                  in collectionReference: FIRCollectionReference) {
        do {
            let json = try encodableObject.toJSON(excluding: ["name", "email"])
            reference(to: collectionReference).document(uid).updateData(json)
        } catch {
            print(error)
        }
    }
    
    func upadeSingleStatus(uid: String, in collectionReference: FIRCollectionReference, updateInfo: [String: Any]) {
        reference(to: collectionReference).document(uid).updateData(updateInfo) { err in
            if let err = err {
                 print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func updateTaskStatus<T: Encodable>(taskUid: String, for encodableOject: T) {
        
        do {
            let json = try encodableOject.toJSON()
            subReference(to: .groups,
                         in: UserDefaultManager.shared.groupId!,
                         toNext: .tasks)
                .document(taskUid)
                .setData(json)
        } catch {
            print(error)
        }
        
    }
    
}

extension FIRFirestoreSerivce {
    
    private func reference(to collectionReference: FIRCollectionReference) -> CollectionReference {
        
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    private func subReference(to collectionReference: FIRCollectionReference,
                              in document: String,
                              toNext subCollectionReference: FIRCollectionReference)
        -> CollectionReference {
            return Firestore.firestore()
                .collection(collectionReference.rawValue)
                .document(document)
                .collection(subCollectionReference.rawValue)
    }
    
}

//class FirestoreMock: FirebaseClient {
//    var ref: CollectionReference?
//    var completionIsAction = false
//    
////    var result
////    private let handler: (QuerySnapshot?, Error?) -> Void
//    
//
////    init(handler: @escaping (QuerySnapshot?, Error?) -> Void) {
////        self.handler = handler
////    }
//
//   
//}
