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
        addTaskToList(for: task, in: .dailyTasksList)
    }
    
    private func readtaskList(from collectionReference: FIRCollectionReference,
                              completion: @escaping ([TaskObject]) -> Void) {
        reference(to: collectionReference).addSnapshotListener { (snapshots, _) in
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
}
