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
    
    private func groupDocument() -> DocumentReference {
        return Firestore.firestore()
            .collection(FIRCollectionReference.groups.rawValue)
            .document(UserDefaultManager.shared.groupId!)
    }
    
    func addTask<T: Encodable>(for encodableObject: T) {
        var ref: DocumentReference?
        
        do {
            var json = try encodableObject.toJSON()
            ref = reference(to: .tasks).document()
            guard let docId = ref?.documentID else { return }
            json[TaskObject.CodingKeys.docId.rawValue] = docId
            reference(to: .tasks).document(docId).setData(json)
        } catch {
            print(error)
        }
        
    }

    private func addTaskToList<T: Encodable>(for encodableObject: T, in collectionReference: FIRCollectionReference) {
        var ref: DocumentReference?
        
        do {
            var json = try encodableObject.toJSON()
            ref = reference(to: collectionReference).document()
            guard let docId = ref?.documentID else { return }
            json[TaskObject.CodingKeys.docId.rawValue] = docId
            reference(to: collectionReference).document(docId).setData(json)
            
        } catch {
            
        }
    }
    
    func addRegularTaskList(task: TaskObject) {
        addTaskToList(for: task, in: .regularTaskList)
    }
    
    func addDailyTaskList(task: TaskObject) {
        var dailyTask = task
        dailyTask.publisherName = "系統提示"
        addTaskToList(for: dailyTask, in: .dailyTasksList)
    }
    
    func readGroupInfo(completion: @escaping (GroupObject) -> Void) {
        groupDocument().getDocument { (document, err) in
            if err == nil {
                guard let document = document else { return }
                do {
                    
                    let object = try document.decode(as: GroupObject.self)
                     
                    completion(object)
                } catch {
                    print(error)
                }
            } else {
                //err != nil
            }
        }
    }
    
    private func readtaskList(from collectionReference: FIRCollectionReference,
                              completion: @escaping ([TaskObject]) -> Void) {
        reference(to: collectionReference).getDocuments { (snapshots, _) in
            guard let snapshots = snapshots else { return }
            
            do {
                var objects = [TaskObject]()
                for document in snapshots.documents {
                    let object = try document.decode(as: TaskObject.self)
                    objects.append(object)
                }
                completion(objects)
            } catch {
                print(error)
            }
        }
    }
    
    func readRegularTaskList(completionHandler: @escaping ([TaskObject]) -> Void) {
        readtaskList(from: .regularTaskList) { (tasks) in
            completionHandler(tasks)
        }
    }
    
    func readDailyTaskList(completionHandler: @escaping ([TaskObject]) -> Void) {
        readtaskList(from: .dailyTasksList) { (tasks) in
            completionHandler(tasks)
        }
    }
    
    func deleteTask(in collectionReference: FIRCollectionReference, docId: String) {
        reference(to: collectionReference).document(docId).delete()
    }
    
    func readGroupMembers(completion: @escaping ([MemberObject]) -> Void) {
        reference(to: .members).getDocuments { (snapshots, err) in
            if err == nil {
                guard let snapshots = snapshots else { return }
                var objects = [MemberObject]()
                for document in snapshots.documents {
                    do {
                        let object = try document.decode(as: MemberObject.self)
                        objects.append(object)
                    } catch {
                        print(error)
                    }
                }
                completion(objects)
            } else {
                // err != nil
            }
        }
    }
    
    func deleteMemberInGroup(memberDocId: String, userUid: String) {
        reference(to: .members).document(memberDocId).delete()
        //delete member Info
        let userRef = Firestore.firestore().collection(FIRCollectionReference.users.rawValue).document(userUid)
        
        userRef.collection(FIRCollectionReference.groups.rawValue).document(UserDefaultManager.shared.groupId!).delete()
        userRef.updateData([UserObject.CodingKeys.mainGroupId.rawValue: FieldValue.delete()])
    }
    
    func updateGroupInfo(groupName: String) {
        groupDocument().updateData([GroupObject.CodingKeys.name.rawValue: groupName])
    }
    
    func addtheRegularTaskEveryDay() {
        reference(to: .tasks)
            .whereField(TaskObject.CodingKeys.taskStatus.rawValue, isEqualTo: 1)
            .whereField(TaskObject.CodingKeys.taskPriodDay.rawValue, isEqualTo: 1)
            .getDocuments { [weak self] (snapshots, err) in
            if err == nil {
                guard let snapshots = snapshots else { return }
                if snapshots.count != 0 {
                    for documnet in snapshots.documents {
                        let taskDocId = documnet.documentID
                        self?.deleteTask(in: .tasks, docId: taskDocId)
                    }
                    self?.addDailyTask()
                } else {
                    //snapshots == 0
                    self?.addDailyTask()
                }

            } else {
                //err != nil
            }
        }
        
        groupDocument()
            .updateData([GroupObject.CodingKeys.logInDate.rawValue: DateProvider.shared.getCurrentDate()])
        
    }
    
    private func addDailyTask() {
        readDailyTaskList(completionHandler: { [weak self] (tasks) in
            for task in tasks {
                self?.addTask(for: task)
            }
        })
    }
    
    func readLobbyInfo(compleation: @escaping ([MemberObject], [TaskObject], [TaskObject], [TaskObject]) -> Void) {
        FirestoreGroupManager.shared.readGroupMembers(completion: { (members) in
//            var memberList = members
            
            FIRFirestoreSerivce.shared.readAllTasks(completionHandler: { (tasks) in
                var processTaskList: [TaskObject] = []
                var checkTaskList: [TaskObject] = []
                var taskList: [TaskObject] = []
                for task in tasks {
                    switch task.taskStatus {
                    case 1:
                        taskList.append(task)
                    case 2:
                        if task.executorUid == UserDefaultManager.shared.userUid {
                            processTaskList.append(task)
                        }
                    case 3:
                        if members.count == 1 {
                            checkTaskList.append(task)
                        } else if task.executorUid != UserDefaultManager.shared.userUid {
                            checkTaskList.append(task)
                        }
                    default: break
                    }
                }

                compleation(members, processTaskList, checkTaskList, taskList)
                
            })
            
        })

    }
  
}
