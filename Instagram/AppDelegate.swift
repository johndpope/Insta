//
//  AppDelegate.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/09.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        /*
        let realmDataSet = RealmDataSet()
        realmDataSet.userId = 1
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(realmDataSet)
        }*/
        let realmDataSet = RealmDataSet()
        realmDataSet.userId = 5
        
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        try! realm.write {
            realm.add(realmDataSet)
        }
        print(realm.objects(RealmDataSet.self))
        
        // Adobeの管理画面で登録したアプリのClientIDとSecretの文字列を設定する
        AdobeUXAuthManager.shared().setAuthenticationParametersWithClientID("c89af0c8863b4b3daf84be903dd5b5c7", withClientSecret: "a594828d-54c6-4b0d-8350-e22fb62c795b")

        window = UIWindow(frame: UIScreen.main.bounds)
        //let storyboard = UIStoryboard(name: "InstagramTabViewController", bundle: nil)
        //let vc = storyboard.instantiateInitialViewController() as! InstagramTabViewController
        let storyboard = UIStoryboard(name: "TimeLineStoryPageViewController", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! UIPageViewController
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        
        return true
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

