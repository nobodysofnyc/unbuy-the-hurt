//
//  AppDelegate.swift
//  Unbuy the Hurt
//
//  Created by Mike Kavouras on 10/26/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        setupFabric()
        setupGA()
        
        return true
    }
    
    func setupFabric() {
        Fabric.with([Crashlytics()])
    }
    
    func setupGA() {
        GAI.sharedInstance().trackUncaughtExceptions = true
        GAI.sharedInstance().dispatchInterval = 10;
        GAI.sharedInstance().trackerWithTrackingId("UA-55460587-2")
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }


}

