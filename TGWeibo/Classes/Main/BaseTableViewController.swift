//
//  BaseTableViewController.swift
//  TGWeibo
//
//  Created by Theodore Guo on 16/1/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController, VisitorViewDelegate {
    // Define a variable to judge current user has logged in or not
    var userLogin = UserAccount.userLogin()
    
    // Difine an attribute to save visitor view
    var visitorView: VisitorView?
    
    override func loadView() {
        userLogin ? super.loadView() : setUpVisitorView()
    }
    
    // MARK: - Internal control functions
    /**
     Set up visitor view
     */
    private func setUpVisitorView() {
        // Initialize visitor view
        let customView = VisitorView()
        customView.delegate = self
        view = customView
        visitorView = customView
        
        // Set navigation bar button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BaseTableViewController.registerBtnDidClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BaseTableViewController.loginBtnDidClick))
    }
    
    // MARK: - VisitorViewDelegate
    func registerBtnDidClick() {
        print(UserAccount.loadAccount())
    }
    
    func loginBtnDidClick() {
        // Present login interface
        let oauthVC = OAuthViewController()
        let navi = UINavigationController(rootViewController: oauthVC)
        presentViewController(navi, animated: true, completion: nil)
    }
}
