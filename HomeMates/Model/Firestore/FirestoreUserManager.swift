//
//  FirestoreUserManager.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/23.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation
import FirebaseFirestore

class FirestoreUserManager {
    
    private init() {}
    
    static var shared = FirestoreUserManager()
    
    private func reference(userUid: String, to collectionReference: FIRCollectionReference) -> CollectionReference {
        
        return Firestore.firestore()
            .collection(FIRCollectionReference.users.rawValue)
            .document(userUid)
            .collection(collectionReference.rawValue)
    }
    
    private func refInGroup(userUid: String, to collectionReference: FIRCollectionReference) -> CollectionReference {
        return Firestore
            .firestore()
            .collection(FIRCollectionReference.users.rawValue)
            .document(userUid)
            .collection(FIRCollectionReference.groups.rawValue)
            .document(UserDefaultManager.shared.groupId!)
            .collection(collectionReference.rawValue)
    }
    
    private func refInMonth(userUid: String,
                            monthId: String,
                            to collectionReference: FIRCollectionReference) -> CollectionReference {
        return Firestore
            .firestore()
            .collection(FIRCollectionReference.users.rawValue)
            .document(userUid)
            .collection(FIRCollectionReference.groups.rawValue)
            .document(UserDefaultManager.shared.groupId!)
            .collection(FIRCollectionReference.months.rawValue)
            .document(monthId)
            .collection(collectionReference.rawValue)
    }
    
    func createGroupInUser(for encodableObject: GroupInfoInUser) {
        do {
            let json = try encodableObject.toJSON()
            reference(userUid: UserDefaultManager.shared.userUid!, to: .groups)
                .document(UserDefaultManager.shared.groupId!)
                .setData(json)
        } catch {
            print(error)
        }
    }
    
    func addTaskTracker(for doneTask: TaskObject) {
        
        let currentMonth = DateProvider.shared.getCurrentMonths()
        refInGroup(userUid: doneTask.executorUid!, to: .months)
            .whereField(MonthObject.CodingKeys.month.rawValue, isEqualTo: currentMonth)
            .getDocuments { [weak self] (snapshots, error) in
                if error == nil {
                    guard let snapshots = snapshots else { return }
                    if snapshots.count == 0 {
                        let month = MonthObject(docId: nil, month: currentMonth, goal: nil)
                        let trackerObject = TaskTracker(docId: nil,
                                                       taskName: doneTask.taskName,
                                                       taskImage: doneTask.image,
                                                       executorName: doneTask.executorName!,
                                                       executorId: doneTask.executorUid!,
                                                       totalPoints: doneTask.taskPoint,
                                                       taskTimes: 1)
                        self?.addTaskInNewMonth(month: month, tracker: trackerObject)
                    } else {
                        //snapshots count != nil
                        var months = [MonthObject]()
                        for document in snapshots.documents {
                            do {
                                let month = try document.decode(as: MonthObject.self)
                                months.append(month)
                            } catch {
                                print(error)
                            }
                        }
                        let monthId = months[0].docId!
                        let trackerObject = TaskTracker(docId: nil,
                                                        taskName: doneTask.taskName,
                                                        taskImage: doneTask.image,
                                                        executorName: doneTask.executorName!,
                                                        executorId: doneTask.executorUid!,
                                                        totalPoints: doneTask.taskPoint,
                                                        taskTimes: 1)
                        self?.addTaskInCurrentMonth(monthId: monthId, tracker: trackerObject)
                    }
                } else {
                    //error != nil
                }
        }

    }
    
    private func addTaskInNewMonth(month: MonthObject, tracker: TaskTracker) {
        
        let ref = refInGroup(userUid: tracker.executorId, to: .months).document()
        let docId = ref.documentID
        
        do {
            var json = try month.toJSON()
            json["docId"] = docId
            refInGroup(userUid: tracker.executorId, to: .months).document(docId).setData(json)
            addTrackerInMonth(monthId: docId, tracker: tracker)
            
        } catch {
            print(error)
        }
        
    }
    
    private func addTaskInCurrentMonth(monthId: String, tracker: TaskTracker) {
        refInMonth(userUid: tracker.executorId, monthId: monthId, to: .taskTrackers)
            .whereField(TaskTracker.CodingKeys.taskName.rawValue, isEqualTo: tracker.taskName)
            .getDocuments { [weak self] (snapshots, err) in
                if err == nil {
                    guard let snapshots = snapshots else { return }
                    if snapshots.count == 0 {
                        self?.addTrackerInMonth(monthId: monthId, tracker: tracker)
                    } else {
                        //trackers.count != 0
                        var trackers = [TaskTracker]()
                        for document in snapshots.documents {
                            do {
                                let tracker = try document.decode(as: TaskTracker.self)
                                trackers.append(tracker)
                            } catch {
                                print(error)
                            }
                        }
                        var currentTracker = trackers[0]
                        
                        currentTracker.taskTimes += 1
                        currentTracker.totalPoints += tracker.totalPoints
                        
                        self?.updateTrackerInfo(monthId: monthId,
                                                trackerId: currentTracker.docId!,
                                                tracker: currentTracker)
                    }
                } else {
                    //err != nil
                }
        }
        
    }
    
    private func addTrackerInMonth(monthId: String, tracker: TaskTracker) {
        let ref = refInGroup(userUid: tracker.executorId, to: .months)
            .document(monthId)
            .collection(FIRCollectionReference.taskTrackers.rawValue)
            .document()
        let trackerId = ref.documentID
        do {
            let json = try tracker.toJSON()
            refInMonth(userUid: tracker.executorId, monthId: monthId, to: .taskTrackers)
                .document(trackerId)
                .setData(json)
            
        } catch {
            print(error)
        }
    }
    
    private func updateTrackerInfo(monthId: String, trackerId: String, tracker: TaskTracker) {
        
        do {
            let json = try tracker.toJSON()
            refInMonth(userUid: tracker.executorId, monthId: monthId, to: .taskTrackers)
                .document(trackerId)
                .setData(json)
        } catch {
            print(error)
        }
        
    }
}
