//
//  NotificaiotnFile.swift
//  Pheli FM
//
//  Created by Jigar Khatri on 7/02/24.
//

import UIKit
import Foundation
import FirebaseCore
import FirebaseMessaging
import SwiftyJSON


extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func setFireBase_Notificaiton(application: UIApplication){
        //FIREBASE CONFIGURE
#if ENGCOBO
print("test")
#else
print("now")
#endif
        FirebaseApp.configure()

        main_thread {
            //Push Notification Register
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                if let error = error {
                    debugPrint("[AppDelegate] requestAuthorization error: \(error.localizedDescription)")
                    return
                }
                UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { settings in
                    if settings.authorizationStatus != .authorized {
                        return
                    }
                    DispatchQueue.main.async(execute: {
                        UIApplication.shared.registerForRemoteNotifications()
                    })
                })
                //Parse errors and track state
            }
            application.registerForRemoteNotifications()
        }
    }
}



//MARK: - GET DEVICE TOKEN AND MOVE SCREEN
extension AppDelegate : MessagingDelegate{
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
        Messaging.messaging().delegate = self
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        self.deviceToken = fcmToken ?? ""
        print("FCM TOKEN -> \(self.deviceToken)")
        
        //CEHCK TOKEN IS VALIDE
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("Remote FCM registration token: \(token)")
          }
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(error)
        //UIPasteboard.general.string = error.localizedDescription
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

    
      // Print full message.
        print(userInfo)
        dicNotificationData = userInfo as NSDictionary

      completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.badge])

    }
        
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //  let rootViewController = self.window!.rootViewController as! UINavigationController
        dicNotificationData = response.notification.request.content.userInfo as NSDictionary
        print(dicNotificationData)
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Select")
            if (CurrentUser.shared.user) != nil{
                if isHomeScreen{
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        self.moveToNotificaitonScreen(dicData: dicNotificationData)
                    }
                }

            }

        default:
            print("default")
        }
        completionHandler()
    }
    
    
    
    func moveToNotificaitonScreen(dicData  : NSDictionary){
        if dicData.count == 0{
            return
        }
        
        dicNotificationData = [:]
//        let jsonUserInfo = JSON(dicData)
//        print("JSON didReceive", dicData)
//        
//        showAlertMessage(strMessage: "\(dicData)")
//
//        
//        let payload = jsonUserInfo["payload"]
//        let data = payload["data"]
//        
//        let pushType = data["push_type"].intValue
//        let object_id = data["object_id"].stringValue
//        
//        appDelegate.titleText = data["push_title"].stringValue
//        appDelegate.descText = data["push_message"].stringValue
//        
        
        let pushType = "\(dicData["push_type"] ?? 0)"
        let object_id = "\(dicData["object_id"] ?? 0)"
        if pushType == "1" {
            self.setMessageRoot(customID: object_id)
            
        } else if pushType == "2" {
            self.setReminderRoot()
            
        } else if pushType == "5" {
            self.setBookingRoot(id: object_id)
            
        } else if pushType == "6" {
            self.setNotiRoot(customID: object_id)
        }
    }
}
