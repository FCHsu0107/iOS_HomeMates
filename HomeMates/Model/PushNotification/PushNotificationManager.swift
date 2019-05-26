//
//  PushNotification.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/5/5.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseMessaging
import UserNotificationsUI

class PushNotificationManager: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    static let shared = PushNotificationManager()
    
    private override init() {}
    
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func updateFirestorePushTokenIfNeeded() {
        if let token = Messaging.messaging().fcmToken {
            let usersRef = usersReference()
            usersRef.setData([UserObject.CodingKeys.fcmToken.rawValue: token], merge: true)
            
            let memberRef = membersReference()
            memberRef
                .whereField(MemberObject.CodingKeys.userId.rawValue, isEqualTo: UserDefaultManager.shared.userUid!)
                .getDocuments { (snapshots, err) in
                if err == nil {
                    guard let snapshots = snapshots else { return }
                    let memberId = snapshots.documents[0].documentID
                    memberRef.document(memberId).setData([UserObject.CodingKeys.fcmToken.rawValue: token], merge: true)
                }
            }
        }
    }
    
    func deletePushToken() {
        
        let usersRef = usersReference()
        usersRef.updateData([UserObject.CodingKeys.fcmToken.rawValue: FieldValue.delete()])
        
        let memberRef = membersReference()
        memberRef
            .whereField(MemberObject.CodingKeys.userId.rawValue, isEqualTo: UserDefaultManager.shared.userUid!)
            .getDocuments { (snapshots, err) in
                if err == nil {
                    guard let snapshots = snapshots else { return }
                    let memberId = snapshots.documents[0].documentID
                    memberRef.document(memberId)
                        .updateData([UserObject.CodingKeys.fcmToken.rawValue: FieldValue.delete()])
                    UserDefaultManager.shared.groupId = nil
                    UserDefaultManager.shared.userUid = nil
                    UserDefaultManager.shared.userName = nil
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        updateFirestorePushTokenIfNeeded()
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
        
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let tabBarVc = UIStoryboard.main.instantiateInitialViewController()!
        
        delegate.window?.rootViewController = tabBarVc
        
        print(response)
        
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("willPresent", notification.request.content)
        
        completionHandler([.alert])
    }
    
}

extension PushNotificationManager {
    
    private func membersReference() -> CollectionReference {
        
        return Firestore.firestore()
            .collection(FIRCollectionReference.groups.rawValue)
            .document(UserDefaultManager.shared.groupId!)
            .collection(FIRCollectionReference.members.rawValue)
    }
    
    private func usersReference() -> DocumentReference {
        
        return Firestore.firestore()
            .collection(FIRCollectionReference.users.rawValue)
            .document(UserDefaultManager.shared.userUid!)
    }
    
}
