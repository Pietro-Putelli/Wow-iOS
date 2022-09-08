//
//  AppDelegate.swift
//  eventsProject
//
//  Created by Pietro Putelli on 13/06/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit
import MapKit
import UserNotifications
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var isAlrealdyRegistered: Bool!
    var languages = Language.languageFromBundle()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window?.layer.cornerRadius = window!.frame.width / 64
        window?.clipsToBounds = true
        
        isAlrealdyRegistered = UserDefaults.standard.bool(forKey: USER_KEYS.ALREADY_REGISTERED)

        if isAlrealdyRegistered {
            let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TAB_BAR")
            window?.rootViewController = homeViewController
            window?.makeKeyAndVisible()
            if let languageIndex = UserDefaults.standard.value(forKey: USER_KEYS.LANGUAGE_INDEX) as? Int {
                User.language_index = languageIndex
            }            
        } else {
            User.language_index = 0
        }
        
        User.language = languages[User.language_index]
        
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {(granted, error) in}
        UIApplication.shared.registerForRemoteNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
        UserDefaults.standard.setValue(false, forKey:"_UIConstraintBasedLayoutLogUnsatisfiable")
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map {String(format: "%02.2hhx", $0)}.joined()
        UserDefaults.standard.set(token, forKey: USER_KEYS.TOKEN)
        print(token)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let data = userInfo["data"] as? [String:Any] {
            if let notification_type = data["type"] as? Int {
                if let json_string = data["user_data"] as? String {
                    if let json = json_string.toJSON() as? [String:AnyObject] {
                        switch notification_type {
                        case 1: self.followNotification(json: json)
                        case 2,4: self.goingEventNotification(json: json)
//                        case 3: self.answerNotification(json: json)
                        default: break
                        }
                    }
                }
            }
        }
    }
    
    func followNotification(json: [String:AnyObject]) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = mainStoryboard.instantiateViewController(withIdentifier: "TAB_BAR") as! UITabBarController
        tabBarController.selectedIndex = 3
        
        window?.rootViewController = tabBarController
        tabBarController.selectedIndex = 3
        window?.makeKeyAndVisible()
        
        let profileNC = tabBarController.viewControllers![2] as! UINavigationController
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileVC = profileStoryboard.instantiateViewController(withIdentifier: "myProfileID") as! MyProfileTVC
        profileVC.selectedFriend = JSON.parseFriend(json: json)
        profileVC.hidesBottomBarWhenPushed = true
        
        profileNC.pushViewController(profileVC, animated: true)
    }
    
    func goingEventNotification(json: [String:AnyObject]) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = mainStoryboard.instantiateViewController(withIdentifier: "TAB_BAR") as! UITabBarController
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        let eventNC = tabBarController.viewControllers![0] as! UINavigationController
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let eventVC = homeStoryboard.instantiateViewController(withIdentifier: "eventTVCID") as! EventsTVC
        eventVC.selectedEvent = JSON.parseSingleEvent(json: json)
        eventVC.hidesBottomBarWhenPushed = true
        
        eventNC.pushViewController(eventVC, animated: true)
    }
    
    func answerNotification(json: [String:AnyObject]) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = mainStoryboard.instantiateViewController(withIdentifier: "TAB_BAR") as! UITabBarController
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        let eventNC = tabBarController.viewControllers![0] as! UINavigationController
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let discussionReplyVC = homeStoryboard.instantiateViewController(withIdentifier: "REPLY_VC") as! DiscussionReplyesVC
        discussionReplyVC.selectedDiscussion = JSON.parseSingleDiscussion(json: json)
        
        eventNC.pushViewController(discussionReplyVC, animated: true)
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
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
