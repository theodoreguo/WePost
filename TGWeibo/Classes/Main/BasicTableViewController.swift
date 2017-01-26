//
//  BasicTableViewController.swift
//  TGWeibo
//
//  Created by Theodore Guo on 16/1/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

class BasicTableViewController: UITableViewController, VisitorViewDelegate {
    // Define a variable to judge current user has logged in or not
    var userLogin = true
    
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
//        navigationController?.navigationBar.tintColor = UIColor.orangeColor()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BasicTableViewController.registerBtnDidClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BasicTableViewController.loginBtnDidClick))
    }
    
    // MARK: - VisitorViewDelegate
    func registerBtnDidClick() {
        print(#function)
    }
    
    func loginBtnDidClick() {
        print(#function)
    }
}
