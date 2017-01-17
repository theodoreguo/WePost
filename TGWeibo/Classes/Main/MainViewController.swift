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
//        tabBar.tintColor = UIColor.orangeColor()
        
        // Add child controllers
        addChildViewControllers()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add compose button
        setUpComposeBtn()
    }
    
    /**
     Actions once compose button is clicked
     */
    func composeBtnClick() {
        print(#function)
    }
    
    // MARK: - Internal control functions
    /**
     Add compose button
     */
    private func setUpComposeBtn() {
        // Add compose button
        tabBar.addSubview(composeBtn)
        
        // Adjust button's position
        let buttonW = UIScreen.mainScreen().bounds.size.width / CGFloat(viewControllers!.count)
        let rect = CGRect(x: 0, y: 0, width: buttonW, height: 49)
        composeBtn.frame = CGRectOffset(rect, 2 * buttonW, 0)
    }
    
    /**
     Add child controllers
     */
    private func addChildViewControllers() {
        // Get JSON file's directory (simulate setting up child controllers based on server requests)
        let path = NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil)
        
        // Create NSData through file path
        if let jsonPath = path {
            let jsonData = NSData(contentsOfFile: jsonPath)
            
            do {
                // Sirialize JSON data, i.e. converting to array
                let dictArr = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers)
                
                // Traverse array to create view controller and set data dynamically
                for dict in dictArr as! [[String: String]] {
                    addChildViewController(dict["vcName"]!, title: dict["title"]!, imageName: dict["imageName"]!)
                }
            } catch {
                // Code to be run once errer occurs
                print(error)
                
                // Create child controllers locally
                // Add child view controllers
                addChildViewController("HomeTableViewController", title: "Home", imageName: "tabbar_home")
                addChildViewController("MessageTableViewController", title: "Message", imageName: "tabbar_message_center")
                addChildViewController("NullViewController", title: "", imageName: "")
                addChildViewController("DiscoverTableViewController", title: "Discover", imageName: "tabbar_discover")
                addChildViewController("MeTableViewController", title: "Me", imageName: "tabbar_profile")
            }
        }
    }
    
    /**
     Initialize child view controller
     
     - parameter childControllerName: child controller that needs initalization
     - parameter title:               child controller's title
     - parameter imageName:           child controller's image
     */
    private func addChildViewController(childControllerName: String, title: String, imageName: String) {
        // 1. Acquire namespace dynamicly (Namespace is included in the class name when creating an object using stipulated class name)
        let nameSpace = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
        
        // 2. Convert string to class
        // 2.1 Namespace is project's name by default, but it can be modified
        let className:AnyClass? = NSClassFromString(nameSpace + "." + childControllerName)
        
        // 2.2 Create the object according to the corresponding class
        // 2.2.1 Convert AnyClass to specified type
        let viewControllerClass = className as! UIViewController.Type
        // 2.2.2 Create the object
        let viewController = viewControllerClass.init()
        
        // 3. Set data for tab bar
        viewController.tabBarItem.image = UIImage(named: imageName)
        viewController.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        viewController.title = title
        
        // 4. Add navigation controller
        let nav = UINavigationController()
        nav.addChildViewController(viewController)
        
        // 5. Add navigation controller to current controller
        addChildViewController(nav)
    }
    
    // MARK: - Lazy loading
    /// Compose button
    private lazy var composeBtn: UIButton = {
        // Create a button
        let btn = UIButton()
        
        // Set foreground image
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        
        // Set background image
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        
        // Monitor button click event
        btn.addTarget(self, action: #selector(MainViewController.composeBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
    }()
}
