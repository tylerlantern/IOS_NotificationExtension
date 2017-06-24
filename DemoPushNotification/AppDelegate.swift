//
//  AppDelegate.swift
//  DemoPushNotification
//
//  Created by Nattapong Unaregul on 6/23/17.
//  Copyright © 2017 Nattapong Unaregul. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder,UIApplicationDelegate ,MessagingDelegate {
    
    var window: UIWindow?
    public func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { (isDone, error) in
            })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        
        NotificationCenter.default.addObserver(self, selector: #selector(tokenRefreshNotification(_:))
            , name: Notification.Name.InstanceIDTokenRefresh , object: nil)
        
        
        
        return true
    }
    func tokenRefreshNotification(_ notification: Notification) {
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("userInfo:\(String(describing: userInfo["aps"]))")
        let fmURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.tyler")
        let urllocalToRead = fmURL!.appendingPathComponent("customAttachmentPic").appendingPathExtension("jpg")
        let data = NSData(contentsOf: urllocalToRead)
        let payloadViewModel = PayloadNotificationViewModel(userData: userInfo, data: data)
        let vc = window?.rootViewController as! ViewController
        vc.payloadNotificationViewModel = payloadViewModel
        completionHandler()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound,.badge])
    }
    
}




