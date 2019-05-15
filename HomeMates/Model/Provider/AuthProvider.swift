//
//  LobbyInfoProvider.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/5/11.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation
import UIKit

class AuthProvider {
    // Auth page - sign up and log in
    func createUserDoc(
        email: String, password: String, userName: String, completionHandler: @escaping (Result<Bool>) -> Void) {
        FIRAuthManager.shared.createUser(
            withEmail: email, password: password) {(user, error) in
                if error == nil {
                    guard let user = user else { return }
                    let currentDate = DateProvider.shared.getCurrentDate()
                    let newUser = UserObject(
                        docId: nil, name: userName, email: (user.email)!, picture: nil,
                        creator: false, application: false, finishSignUp: false,
                        mainGroupId: nil, fcmToken: nil, lastLogInDate: currentDate)
                    UserDefaultManager.shared.userUid = user.uid
                    FIRFirestoreSerivce.shared.createUser(uid: user.uid,
                                                          for: newUser,
                                                          in: .users)
                    completionHandler(Result.success(true))
                } else {
                    completionHandler(Result.failure(error!))
                }
        }
    }
    
    //Auth page - log in
    func signInAction(email: String, password: String, completionHandler: @escaping (Result<Bool>) -> Void) {
        FIRAuthManager.shared.signIn(withEmail: email, password: password) { (error) in
            if error == nil {
                FIRFirestoreSerivce.shared.findUser { _, bool, userInfo  in
                    if bool == true && userInfo?.mainGroupId != nil {
                        UserDefaultManager.shared.groupId = userInfo?.mainGroupId
                        
                        completionHandler(Result.success(true))
                    } else {
                        completionHandler(Result.success(false))
                    }
                }
            } else {
                completionHandler(Result.failure(error!))
            }
        }
    }
    
    func createANewGroup(groupName: String, groupId: String,
                         completionHandler: @escaping (Result<Bool>) -> Void) {
        
        FIRFirestoreSerivce.shared.findUser {(user, _, userInfo) in
            
            guard let user = user else { return }
             UserDefaultManager.shared.userUid = user.uid

            guard let userInfo = userInfo else { return }
            let newGroup = GroupObject(docId: nil, creatorId: user.uid,
                                       createrName: userInfo.name, name: groupName, picture: nil,
                                       shortcup: "", groupId: groupId,
                                       logInDate: DateProvider.shared.getCurrentDate())
            
            FIRFirestoreSerivce.shared.createGroup(for: newGroup, in: .groups, completion: { (groupId) in
                guard let groupId = groupId else { return }
                UserDefaultManager.shared.groupId = groupId
                
                let currentDate = DateProvider.shared.getCurrentDate()
                
                let newUser = UserObject(docId: nil, name: userInfo.name,
                                         email: user.email!, picture: nil,
                                         creator: true, application: false,
                                         finishSignUp: true, mainGroupId: groupId,
                                         fcmToken: nil, lastLogInDate: currentDate)
                
                FIRFirestoreSerivce.shared.updateUser(uid: user.uid, for: newUser, in: .users)
                
                let groupInfoInUser = GroupInfoInUser(docId: UserDefaultManager.shared.groupId!,
                                                      isMember: true,
                                                      groupID: UserDefaultManager.shared.groupId!,
                                                      isMainGroup: true, goal: nil)
                
                FirestoreUserManager.shared.createGroupInUser(for: groupInfoInUser, completionHandler: { (result) in
                    switch result {
                    case .success: break
                        
                    case .failure(let err):
                        print(err)
                        
                    }
                })
    
                let groupMemnber = MemberObject(docId: nil, userId: user.uid,
                                                userName: userInfo.name, isCreator: true,
                                                permission: true, userPicture: "profile_48px", goal: nil,
                                                fcmToken: nil)
                
                FIRFirestoreSerivce.shared.createSub(for: groupMemnber, in: .groups,
                                                     inDocument: groupId, inNext: .members)
                completionHandler(Result.success(true))
            })
        }
    }
    
    func searchTheGroup(groupId: String, ownVc: UIViewController) {
        
        FIRFirestoreSerivce.shared.findUser { (user, _, userInfo) in
            guard let user = user else { return }
            guard let userInfo = userInfo else { return }
            var groupResults: [GroupObject] = []
            var groupNames: [String] = []
            
            FIRFirestoreSerivce.shared.findGroup(
            groupId: groupId, returning: GroupObject.self) { [weak self] groups, docIds  in
                if groups.count == 0 {
                    let alert = UIAlertController.sigleActionAlert(
                        title: "群組不存在", message: "請確認群組 ID 或創立新群組", clickTitle: "收到")
                    ownVc.present(alert, animated: false, completion: nil)
                    
                } else {
                    for index in groups {
                        groupResults.append(index)
                        groupNames.append(index.name)
                    }
                    let alertSheet = UIAlertController.showAlertSheet(
                    title: "確認加入群組", message: "確認群組名稱", action: groupNames) { (index) in
                        UserDefaultManager.shared.groupId = groupResults[index].docId
                        
                        let memberInfo = MemberObject(
                            docId: nil, userId: user.uid, userName: userInfo.name, isCreator: false,
                            permission: false, userPicture: "profile_48px", goal: nil, fcmToken: nil)
                        
                        let currentDate = DateProvider.shared.getCurrentDate()
                        
                        let newUser = UserObject(
                            docId: nil, name: userInfo.name, email: user.email!, picture: nil,
                            creator: false, application: false, finishSignUp: true,
                            mainGroupId: docIds[index], fcmToken: nil, lastLogInDate: currentDate)
                        
                        let groupInfoInUser = GroupInfoInUser(
                            docId: nil, isMember: false, groupID: docIds[index], isMainGroup: true, goal: nil)
                        
                        let application = ApplicationObject(
                            docId: nil, applicantId: user.uid, groupCreator: groupResults[index].creatorId,
                            groupId: docIds[index], applicantName: userInfo.name)
                        
                        self?.joinCurrentGroup(userId: user.uid, groupId: docIds[index], memberInfo: memberInfo,
                                               newUser: newUser, groupInfoInUser: groupInfoInUser)
                        self?.applyToGroup(creatorId: groupResults[index].creatorId, application: application)
                        
                        let tabBarVc = UIStoryboard.main.instantiateInitialViewController()!
                            ownVc.present(tabBarVc, animated: true, completion: nil)
                            
                    }
                    ownVc.present(alertSheet, animated: true, completion: nil)
                }
            }
        }
    }
    private func joinCurrentGroup(userId: String, groupId: String, memberInfo: MemberObject,
                                  newUser: UserObject, groupInfoInUser: GroupInfoInUser) {
        FIRFirestoreSerivce.shared.createSub(for: memberInfo, in: .groups, inDocument: groupId, inNext: .members)
        FIRFirestoreSerivce.shared.updateUser(uid: userId, for: newUser, in: .users)
        FirestoreUserManager.shared.createGroupInUser(for: groupInfoInUser) { (result) in
            switch result {
            case .success:
                break
            case .failure(let err):
                print(err)
            }
        }
        
    }
    
    private func applyToGroup(creatorId: String, application: ApplicationObject) {
        FIRFirestoreSerivce.shared.create(for: application, in: .applications)
        FIRFirestoreSerivce.shared.upadeSingleStatus(
            uid: creatorId, in: .users, updateInfo: [UserObject.CodingKeys.application.rawValue: true])
    }
    
}
