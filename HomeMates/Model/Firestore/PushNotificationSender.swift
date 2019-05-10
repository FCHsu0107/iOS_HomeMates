//
//  PushNotificationSender.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/5/5.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class PushNotificationSender {
    
    static let shared = PushNotificationSender()
    
    func sendPushNotification(to token: String, title: String, body: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String: Any] = ["to": token,
                                           "notification": ["title": title, "body": body],
                                           "data": ["user": "test_id"]]
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: paramString,
                                                       options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request
        .setValue(
            "key=AAAAG9D4lGs:APA91bGtf_eUY_70sMMLNY1GpYkAAT9t5nOfYu3l9zezM9dGYGmbwI_Fw4i35YCi_Bs1VtLOhmpfhypl2JQubo9W7eu9Y1p_U0cuqXtv2jUEGP9Bzkr73BihjVrfyxqdpdiqO0uE29Qi",
            forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(
                        with: jsonData,
                        options: JSONSerialization
                            .ReadingOptions
                            .allowFragments)
                        as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
