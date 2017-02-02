//
//  AppDelegate.swift
//  TGWeibo
//
//  Created by Theodore Guo on 16/1/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

/// Switch root view controller notification
let TGSwitchRootViewControllerKey = "TGSwitchRootViewControllerKey"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Register notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.switchRootViewController(_:)), name: TGSwitchRootViewControllerKey, object: nil)
        
        // Set navigation bar and tool bar's appearance
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        // Create window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        
        // Create root view controller
        window?.rootViewController = defaultController()
        window?.makeKeyAndVisible()
        
//        print(isUpdated())
        
        return true
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     Switch root view controller
     */
    func switchRootViewController(notification: NSNotification) {
        if notification.object as! Bool {
            window?.rootViewController = MainViewController()
        } else {
            window?.rootViewController = WelcomeViewController()
        }
    }
    
    /**
     Get default interface controller
     */
    private func defaultController() -> UIViewController {
        if UserAccount.userLogin() {
            return isUpdated() ? NewFeaturesCollectionViewController() : WelcomeViewController()
        }
        return MainViewController()
    }
    
    /**
     Judge app is updated or not
     */
    private func isUpdated() -> Bool {
        // 1. Get current app's version from info.plist
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        
        // 2. Get previous app version from sandbox
        let sandboxVersion = NSUserDefaults.standardUserDefaults().objectForKey("CFBundleShortVersionString") as? String ?? ""
//        print("current = \(currentVersion) sandbox = \(sandboxVersion)")
        
        // 3. Compare app's current version and previous version
        if currentVersion.compare(sandboxVersion) == NSComparisonResult.OrderedDescending { // 3.1 There's new version if current version > previous version
            // 3.1.1 Save latest version
            NSUserDefaults.standardUserDefaults().setObject(currentVersion, forKey: "CFBundleShortVersionString")
            return true
        }
        
        // 3.2 There's no new version if current version < or == previous version
        return false
    }
}

