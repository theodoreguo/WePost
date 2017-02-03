//
//  HomeTableViewController.swift
//  TGWeibo
//
//  Created by Theodore Guo on 16/1/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

let TGHomeReuseIdentifier = "TGHomeReuseIdentifier"

class HomeTableViewController: BaseTableViewController {
    /// Store Weibo array
    var statuses: [Statuses]? {
        didSet{
            // Refresh table view when data are set
            tableView.reloadData()
        }
    }
    
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
        
        // 4. Register and set cell
        tableView.registerClass(StatusTableViewCell.self, forCellReuseIdentifier: TGHomeReuseIdentifier)
        
//        tableView.estimatedRowHeight = 200
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.rowHeight = 300
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // 5. Load Weibo data
        loadData()
    }
    
    deinit {
        // Remove notificatons
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     Get Weibo data
     */
    private func loadData() {
        Statuses.loadStatuses { (models, error) in
            if error != nil {
                return
            }
            self.statuses = models
        }
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
    
    /// Row height buffer (using dictionary to store ID as key and row height as value)
    var rowCache: [Int: CGFloat] = [Int: CGFloat]()
    
    /**
     Handle memory warning
     */
    override func didReceiveMemoryWarning() {
        // Clear buffer
        rowCache.removeAll()
    }
}

extension HomeTableViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Get cell
        let cell = tableView.dequeueReusableCellWithIdentifier(TGHomeReuseIdentifier, forIndexPath: indexPath) as! StatusTableViewCell
        
        // Set data
        let status = statuses![indexPath.row]
//        cell.textLabel?.text = status.text
        cell.status = status
        
        return cell
    }
    
    /**
     Return row height
     */
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // 1. Get the model corresponding to that row
        let status = statuses![indexPath.row]
        
        // 2. Acquire the row height if it exists in buffer
        if let height = rowCache[status.id] {
            return height
        }
        
        // 3. Get cell
        let cell = tableView.dequeueReusableCellWithIdentifier(TGHomeReuseIdentifier) as! StatusTableViewCell
        
        // 4. Get row height
        let rowHeight = cell.rowHeight(status)
        
        // 5. Buffer row height
        rowCache[status.id] = rowHeight
        
        // 6. Return row height
        return rowHeight
    }
}