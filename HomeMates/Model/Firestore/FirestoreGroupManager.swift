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
        let currentDate = DateProvider.shared.getCurrentMonths()
        
        reference(to: .months)
            .whereField(MonthObject.CodingKeys.month.rawValue, isEqualTo: currentDate)
            .getDocuments { [weak self ] (snapshot, err) in
                
            var ref: DocumentReference?
            var subRef: DocumentReference?
            if err == nil {
                guard let snapshot = snapshot else { return }
                if snapshot.count == 0 {
            
                    ref = self?.reference(to: .months).document()
                    guard let ref = ref else { return }
                    
                    self?.reference(to: .months).document(ref.documentID).setData(
                        [MonthObject.CodingKeys.docId.rawValue: ref.documentID,
                         MonthObject.CodingKeys.month.rawValue: currentDate])
                    do {
                        var json = try encodableObject.toJSON()
                        subRef = self?.reference(to: .months)
                            .document(ref.documentID)
                            .collection(FIRCollectionReference.tasks.rawValue)
                            .document()
                        guard let docId = subRef?.documentID else { return }
                        json[MonthObject.CodingKeys.docId.rawValue] = docId
                        self?.reference(to: .months)
                            .document(ref.documentID)
                            .collection(FIRCollectionReference.tasks.rawValue)
                            .document(docId)
                            .setData(json)
                    } catch {
                        print(error)
                    }
                   
                } else {
                    var docIds = [String]()
                    for document in snapshot.documents {
                        docIds.append(document.documentID)
                    }
                    do {
                        var json = try encodableObject.toJSON()
                        let subRef = self?.reference(to: .months)
                            .document(docIds[0])
                            .collection(FIRCollectionReference.tasks.rawValue)
                            .document()
                        
                        guard let subDocId = subRef?.documentID else { return }
                        json[MonthObject.CodingKeys.docId.rawValue] = subDocId
                        self?.reference(to: .months).document(docIds[0])
                            .collection(FIRCollectionReference.tasks.rawValue)
                            .document(subDocId)
                            .setData(json)
                    } catch {
                        print(error)
                    }
                }
            } else {
                print(err)
                //讀取月份資料失敗
            }
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
}
