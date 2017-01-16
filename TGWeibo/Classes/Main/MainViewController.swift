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
        
        /*
        // 1. Create home view controller
        let home = HomeTableViewController()
        // 1.1 Set data for home tab bar
        home.tabBarItem.image = UIImage(named: "tabbar_home")
        home.tabBarItem.selectedImage = UIImage(named: "tabbar_home_highlighted")
        home.tabBarItem.title = "Home"
        // 1.2 Set data for navigation bar
        home.navigationItem.title = "Home" // Or use home.title = "Home" instead of the above twe lines
        
        // 2. Add navigation controller
        let nav = UINavigationController()
        nav.addChildViewController(home)
        
        // 3. Add navigation controller to current controller
        addChildViewController(nav)
        */
        
        addChildViewController(HomeTableViewController(), title: "Home", imageName: "tabbar_home")
        addChildViewController(MessageTableViewController(), title: "Message", imageName: "tabbar_message_center")
        addChildViewController(DiscoverTableViewController(), title: "Discover", imageName: "tabbar_discover")
        addChildViewController(MeTableViewController(), title: "Me", imageName: "tabbar_profile")
    }
    
    /**
     Initialize child view controller
     
     - parameter childController: child controller that needs initalization
     - parameter title:           child controller's title
     - parameter imageName:       child controller's image
     */
    private func addChildViewController(childController: UIViewController, title: String, imageName: String) {
        // 1. Set data for home tab bar
        childController.tabBarItem.image = UIImage(named: imageName)
        childController.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        childController.title = title
        
        // 2. Add navigation controller
        let nav = UINavigationController()
        nav.addChildViewController(childController)
        
        // 3. Add navigation controller to current controller
        addChildViewController(nav)
    }
}
