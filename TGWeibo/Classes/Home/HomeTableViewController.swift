//
//  HomeTableViewController.swift
//  TGWeibo
//
//  Created by Theodore Guo on 16/1/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set visitor view info, if the user hasn't logged in
        if !userLogin {
            visitorView?.setUpVisitorViewInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
            
            return
        }
        
        // Set up navigation bar
        setUpNavi()
    }
    
    /**
     Set up navigation bar
     */
    private func setUpNavi() {
        // Set up left / right navigation bar button
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
        button.selected = !button.selected
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
        print(#function)
    }

}
