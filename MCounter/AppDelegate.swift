//
//  AppDelegate.swift
//  MCounter
//
//  Created by Muhammad Ahmad on 22/03/2019.
//  Copyright © 2019 WeOverOne. All rights reserved.
//

import UIKit
import UserNotifications
//import Firebase
import Bugsnag
import CoreData
import CoreLocation


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
        
        ThemeSettings.sharedInstance.font17
        AppStateStore.shared.autoDayNightOn = false 
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.window?.rootViewController = secondVC
        UIApplication.shared.isIdleTimerDisabled = true
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
        })
        UserDefaults.standard.register(defaults: [
            DefaultsVariables.soundOn.rawValue : true,
            DefaultsVariables.vibrationOn.rawValue: true,
            DefaultsVariables.autoDayNight.rawValue: false,
            DefaultsVariables.warmupIntervel.rawValue : 20,
            DefaultsVariables.proUser.rawValue: true,
            DefaultsVariables.streakDays.rawValue: 0,
            DefaultsVariables.warmupTimer.rawValue: true ,
            DefaultsVariables.themeNumber.rawValue: 0
            ])
//        FirebaseApp.configure()
        Bugsnag.start(withApiKey: "e37598b804ee00ada48400339a129ed4")
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        AppStateStore.shared.resetTimer = true
        print(notification.request.content.userInfo)
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
        AppStateStore.shared.resetTimer = true
        print(response.notification.request.content.userInfo)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        for window in application.windows {
            window.rootViewController?.beginAppearanceTransition(true, animated: false)
            window.rootViewController?.endAppearanceTransition()
        }
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        PrestianceStorage.saveContext()
    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        for window in application.windows {
            window.rootViewController?.beginAppearanceTransition(false, animated: false)
            window.rootViewController?.endAppearanceTransition()
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
}

