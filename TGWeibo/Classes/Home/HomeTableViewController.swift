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
    var statuses: [Status]? {
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTableViewController.showPhotoBrowser), name: TGStatusPictureViewSelected, object: nil)
        
        // 4. Register and set cell
        tableView.registerClass(StatusOriginalTableViewCell.self, forCellReuseIdentifier: StatusTableViewCellIdentifier.OriginalCell.rawValue)
        tableView.registerClass(StatusRepostTableViewCell.self, forCellReuseIdentifier: StatusTableViewCellIdentifier.RepostCell.rawValue)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
//        tableView.estimatedRowHeight = 200
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.rowHeight = 300
        
        // 5. Add refresh widget
        refreshControl = HomeRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadData), forControlEvents: UIControlEvents.ValueChanged)
        
        newStatusLabel.hidden = false
        
        // 6. Load Weibo data
        loadData()
    }
    
    deinit {
        // Remove notificatons
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     Show photo browser
     */
    func showPhotoBrowser(notification: NSNotification) {
//        print(notification.userInfo)
        guard let indexPath = notification.userInfo![TGStatusPictureViewIndexKey] as? NSIndexPath else {
            return
        }
        guard let urls = notification.userInfo![TGStatusPictureViewURLKey] as? [NSURL] else {
            return
        }
        // Create photo browser
        let vc = PhotoBrowserController(index: indexPath.item, urls: urls)
        // Show photo browser
        presentViewController(vc, animated: true, completion: nil)
    }
    
    /**
     Get Weibo data
     */
    /// Store the state which is pull-down or pull-up refresh currently
    var pullUpRefreshFlag = false
    @objc private func loadData() {
        // 1. It's pull-down refresh by default
        var since_id = statuses?.first?.id ?? 0
        
        // 2. Judge it's pull-up refresh or not
        var max_id = 0
        if pullUpRefreshFlag {
            since_id = 0
            max_id = statuses?.last?.id ?? 0
        }
        
        Status.loadStatuses(since_id, max_id: max_id) { (models, error) in
            // Stop refreshing
            self.refreshControl?.endRefreshing()
            
            if error != nil {
                return
            }
            
            // Pull-down refresh
            if since_id > 0 {
                // If pull-down refresh is triggered, joint new data to the front of old data
                self.statuses = models! + self.statuses!
                
                // Show refresh reminder widget
                self.showNewStatusCount(models?.count ?? 0)
            } else if max_id > 0 {
                // If pull-up refresh is triggered, joint new data to the end of old data
                self.statuses = self.statuses! + models!
            } else {
                self.statuses = models
            }
        }
    }
    
    /**
     Show the quantity of updated Weibo statuses
     */
    private func showNewStatusCount(count: Int) {
        newStatusLabel.hidden = false
        newStatusLabel.text = (count == 0) ? "No more update" : "Update \(count) Weibo"
        
        let rect = newStatusLabel.frame
        UIView.animateWithDuration(1.5, animations: {
            UIView.setAnimationRepeatAutoreverses(true)
            self.newStatusLabel.frame = CGRectOffset(rect, 0, 3 * rect.height)
            }) { (_) in
               self.newStatusLabel.frame = rect
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
    /// Refresh reminder widget
    private lazy var newStatusLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.orangeColor()
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(14)
        label.textColor = UIColor.whiteColor()
        let height: CGFloat = 44
        label.frame = CGRect(x: 0, y: -2 * height, width: UIScreen.mainScreen().bounds.width, height: height)
        
        self.navigationController?.navigationBar.insertSubview(label, atIndex: 0)
        
        label.hidden = true
        
        return label
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
        let status = statuses![indexPath.row]
        
        // 1. Get cell
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusTableViewCellIdentifier.cellID(status), forIndexPath: indexPath) as! StatusTableViewCell
        
        // 2. Set data
        cell.status = status
        
        // 3. Judge if the last cell has been reached
        let count = statuses?.count ?? 0
        if indexPath.row == (count - 1) {
            pullUpRefreshFlag = true
            loadData()
        }
        
        // 4. Return cell
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
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusTableViewCellIdentifier.cellID(status)) as! StatusTableViewCell
        
        // 4. Get row height
        let rowHeight = cell.rowHeight(status)
        
        // 5. Buffer row height
        rowCache[status.id] = rowHeight
        
        // 6. Return row height
        return rowHeight
    }
}