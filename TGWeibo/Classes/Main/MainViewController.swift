//
//  MainViewController.swift
//  TGWeibo
//
//  Created by Theodore Guo on 16/1/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set current controller's tab bar color
        tabBar.tintColor = UIColor.orangeColor()
        
        // Add child view controllers
        addChildViewController("HomeTableViewController", title: "Home", imageName: "tabbar_home")
        addChildViewController("MessageTableViewController", title: "Message", imageName: "tabbar_message_center")
        addChildViewController("DiscoverTableViewController", title: "Discover", imageName: "tabbar_discover")
        addChildViewController("MeTableViewController", title: "Me", imageName: "tabbar_profile")
    }
    
    /**
     Initialize child view controller
     
     - parameter childControllerName: child controller that needs initalization
     - parameter title:               child controller's title
     - parameter imageName:           child controller's image
     */
    private func addChildViewController(childControllerName: String, title: String, imageName: String) {
        // Acquire namespace dynamicly (Namespace is included in the class name when creating an object using stipulated class name)
        let nameSpace = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
        
        // Convert string to class
        // Namespace is project's name by default, but it can be modified
        let className:AnyClass? = NSClassFromString(nameSpace + "." + childControllerName)
        // Create the object according to the corresponding class
        // Convert AnyClass to specified type
        let viewControllerClass = className as! UIViewController.Type
        // Create the object
        let viewController = viewControllerClass.init()
        
        // 1. Set data for tab bar
        viewController.tabBarItem.image = UIImage(named: imageName)
        viewController.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        viewController.title = title
        
        // 2. Add navigation controller
        let nav = UINavigationController()
        nav.addChildViewController(viewController)
        
        // 3. Add navigation controller to current controller
        addChildViewController(nav)
    }
}
