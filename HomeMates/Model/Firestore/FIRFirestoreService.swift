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
    
    func createGroup<T: Encodable>(for encodableObject: T, in collectionReference: FIRCollectionReference) {
        
        var ref: DocumentReference?
        
        do {
            var json = try encodableObject.toJSON()
            
            ref = reference(to: collectionReference).document()
            
            guard let ref = ref else { return }
            json["docId"] = ref.documentID
            json["shortcup"] = ref.documentID.substring(toIndex: ref.documentID.length - 14)
            
            reference(to: collectionReference).document(ref.documentID).setData(json)
            UserDefaultManager.shared.groupId = ref.documentID
   
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
        
    func readAssigningTasks(completionHandler: @escaping ([TaskObject]) -> Void) {
        readGroupTasks(status: 1) { (tasks) in
            completionHandler(tasks)
        }
    }
    
    func readCheckTasks(comletionHandler: @escaping ([TaskObject]) -> Void) {
        readGroupTasks(status: 3) { (tasks) in
            comletionHandler(tasks)
        }
    }

    func readDoneTask(comletionHandler: @escaping ([TaskObject]) -> Void) {
        subReference(to: .groups, in: UserDefaultManager.shared.groupId!, toNext: .tasks)
            .whereField(TaskObject.CodingKeys.taskStatus.rawValue, isEqualTo: 4)
            .order(by: TaskObject.CodingKeys.completionTimeStamp.rawValue, descending: true)
            .addSnapshotListener { (snapshot, err) in
                guard let snapshot = snapshot else {
                    print(err as Any)
                    return }
                
                do {
                    var objects = [TaskObject]()
                    for document in snapshot.documents {
                        let object = try document.decode(as: TaskObject.self)
                        objects.append(object)
                    }
                    comletionHandler(objects)
                } catch {
                    print(error)
                }
        }
    }
    
    private func readGroupTasks(status: Int,
                                completion: @escaping ([TaskObject]) -> Void) {
        subReference(to: .groups, in: UserDefaultManager.shared.groupId!, toNext: .tasks)
            .whereField(TaskObject.CodingKeys.taskStatus.rawValue, isEqualTo: status)
            .addSnapshotListener { (snapshot, err) in
            guard let snapshot = snapshot else {
                print(err as Any)
                return }
            
            do {
                var objects = [TaskObject]()
                for document in snapshot.documents {
                    let object = try document.decode(as: TaskObject.self)
                    objects.append(object)
                }
                completion(objects)
            } catch {
                print(error)
            }
        }
    }
    
    func readDoingTasks(completionHandler: @escaping ([TaskObject]) -> Void) {
        subReference(to: .groups, in: UserDefaultManager.shared.groupId!, toNext: .tasks)
            .whereField(TaskObject.CodingKeys.taskStatus.rawValue, isEqualTo: 2)
            .whereField(TaskObject.CodingKeys.executorUid.rawValue,
                        isEqualTo: UserDefaultManager.shared.userUid!)
            .addSnapshotListener { (snapshot, err) in
                guard let snapshpt = snapshot else {
                    print(err as Any)
                    return }
                do {
                    var objects = [TaskObject]()
                    for document in snapshpt.documents {
                        let object = try document.decode(as: TaskObject.self)
                        objects.append(object)
                    }
                    completionHandler(objects)
                } catch {
                    print(error)
                }
        }
    }
    
    typealias BoolCompleionHandler = (Bool?, UserObject?) -> Void
    
    func findUser(completionHandler completion: @escaping BoolCompleionHandler) {
        
        guard let user = Auth.auth().currentUser else {
            completion(false, nil)
            return }
        let uid = user.uid
        
        reference(to: .users).document(uid).getDocument { (querySnapshot, _) in
            guard let data = querySnapshot?.data() else {
                completion(false, nil)
                return
            }
            do {
                let userObject = try querySnapshot?.decode(as: UserObject.self)
                completion(data[UserObject.CodingKeys.finishSignUp.rawValue] as? Bool, userObject)
            } catch {
                
            }

        }
    }

    func upadeSingleStatus(uid: String, in collectionReference: FIRCollectionReference, status: String, bool: Bool) {
        reference(to: collectionReference).document(uid).updateData([status: bool]) { err in
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
    
    func findMainGroup(completion: @escaping (GroupObject) -> Void) {
        let user = Auth.auth().currentUser
        guard let currentUser = user else { return }
        UserDefaultManager.shared.userUid = currentUser.uid
        let ref = reference(to: .users).document(currentUser.uid)
        ref.getDocument { [ weak self ](documnet, err) in
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
    
}
