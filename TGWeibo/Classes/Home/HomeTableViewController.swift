//
//  HomeTableViewController.swift
//  TGWeibo
//
//  Created by Theodore Guo on 16/1/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

class HomeTableViewController: BasicTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Set visitor view info, if the user hasn't logged in
        if !userLogin {
            visitorView?.setUpVisitorViewInfo(true, imageName: "visitordiscover_feed_image_house", message: "Follow someone, then you will get some surprises")
            
            return
        }
        
        // 2. Set up navigation bar
        setUpNavi()
        
        // 3. Register notification to monitor popover's actions
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTableViewController.change), name: TGPopoverAnimatorWillShow, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTableViewController.change), name: TGPopoverAnimatorWillDismiss, object: nil)
    }
    
    deinit {
        // Remove notificatons
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     Change arrow's up-down direction of title button
     */
    func change() {
        // Change title button's state
        let titleBtn = navigationItem.titleView as! TitleButton
        titleBtn.selected = !titleBtn.selected
    }
    
    /**
     Set up navigation bar
     */
    private func setUpNavi() {
        // Set up left/right navigation bar button
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_friendattention", target: self, action: #selector(leftItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_pop", target: self, action: #selector(rightItemClick))
        
        // Set up title button
        let titleBtn = TitleButton()
        titleBtn.setTitle("Theodore_Guo ", forState: UIControlState.Normal)
        titleBtn.addTarget(self, action: #selector(titleBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = titleBtn
    }
    
    /**
     Switch button's selection state
     
     - parameter button: button clicked
     */
    func titleBtnClick(button: TitleButton) {
        // Set up popover list
        let sb = UIStoryboard(name: "PopoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        // Set transition delegate
        vc?.transitioningDelegate = popoverAnimator
        // Set presention style
        vc?.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        presentViewController(vc!, animated: true, completion: nil)
    }
    
    /**
     Actions once friend attention button is clicked
     */
    func leftItemClick() {
        print(#function)
    }
    
    /**
     Actions once pop button is clicked
     */
    func rightItemClick() {
        let sb = UIStoryboard(name: "QRCodeViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        presentViewController(vc!, animated: true, completion: nil)
    }
    
    // MARK: - Lazy loading
    /// It's necessary to define an attribute to store transitioning object, or exceptions will appear
    private lazy var popoverAnimator:PopoverAnimator = {
        let pa = PopoverAnimator()
        pa.presentFrame = CGRect(x: 100, y: 56, width: 200, height: 350)
        return pa
    }()
}