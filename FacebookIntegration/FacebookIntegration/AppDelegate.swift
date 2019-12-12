//
//  AppDelegate.swift
//  FacebookIntegration
//
//  Created by Macbook on 12/12/2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit
import UIKit

import FacebookCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        return true
    }


    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      return ApplicationDelegate.shared.application(
        application,
        open: url,
        sourceApplication: sourceApplication,
        annotation: annotation
      )
    }

    @available(iOS 9.0, *)
    func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
      return ApplicationDelegate.shared.application(application, open: url, options: options)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
      AppEvents.activateApp()
    }

    
}

