//
//  AppDelegate.swift
//  Spotify 6
//
//  Created by Tommaso on 28/2/15.
//  Copyright (c) 2015 Tommaso. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let kClientID = "40ac927645d64a6da53521bb6287db19"
    let kCallbackURL = "spotifytutorial://returnAfterLogin"
    let kTokenSwapURL = "https://hidden-hollows-1983.herokuapp.com/swap"
    let kTokenRefreshServiceURL = "https://hidden-hollows-1983.herokuapp.com/refresh"

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        if SPTAuth.defaultInstance().canHandleURL(url, withDeclaredRedirectURL: NSURL(string: kCallbackURL)) {
            SPTAuth.defaultInstance().handleAuthCallbackWithTriggeredAuthURL(url, tokenSwapServiceEndpointAtURL: NSURL(string: kTokenSwapURL), callback: { (error: NSError!, session: SPTSession!) -> Void in
                if error != nil {
                    println(error)
                    println("Authentication error")
                    return
                }
                
                println("authentication successful!!")
                
                let userDefaults = NSUserDefaults.standardUserDefaults()
                let sessionData = NSKeyedArchiver.archivedDataWithRootObject(session)
                userDefaults.setObject(sessionData, forKey: "SpotifySession")
                userDefaults.synchronize()
                
                NSNotificationCenter.defaultCenter().postNotificationName("loginSuccessful", object: nil)
            })
        }
        return false
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

