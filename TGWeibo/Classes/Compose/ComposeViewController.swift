//
//  ComposeViewController.swift
//  TGWeibo
//
//  Created by Theodore Guo on 4/2/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {
    /// Toolbar bottom constraints
    var toolbarBottonCons: NSLayoutConstraint?
    /// Photo selector height constraints
    var photoViewHeightCons: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        // Register a notification to monitor the popup and disappearance of the keyboard
        NSNotificationCenter.defaultCenter().addObserver(self , selector: #selector(ComposeViewController.keyboardChange(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        // Add emoticon keyboard controller and photo selector controller as current controller's child view controllers
        addChildViewController(emoticonVC)
        addChildViewController(photoSelectorVC)
        
        // Initialize navigation bar
        setUpNavi()
        
        // Initialize input view
        setUpInpuView()
        
        // Initialize photo selector view
        setUpPhotoView()
        
        // Initialize tool bar
        setUpToolbar()
    }
    
    /**
     Actions when the keyboard is changed
     */
    func keyboardChange(notification: NSNotification) {
//        print(notification)
        // 1. Get the keyboard's final rect
        let value = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let rect = value.CGRectValue()
        
        // 2. Modify toolbar's contraints
        // Popup: y = 409, height = 258
        // Close: y = 667, height = 258
        // 667 - 409 = 258
        // 667 - 667 = 0
        let height = UIScreen.mainScreen().bounds.height
        toolbarBottonCons?.constant = -(height - rect.origin.y)
        
        // 3. Refresh the interface
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        // 3.1 Get keyboard's animation curve
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber        
        UIView.animateWithDuration(duration.doubleValue) { () -> Void in
            // 3.2 Set animation curve
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve.integerValue)!)
            
            self.view.layoutIfNeeded()
        }        
//        let anim = toolbar.layer.animationForKey("position")
//        print("duration = \(anim?.duration)")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if photoViewHeightCons?.constant == 0 { // Photo selector is not displayed
            // Display keyboard
            textView.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Hide keyboard
        textView.resignFirstResponder()
    }
    
    /**
     Initialize toolbar
     */
    private func setUpToolbar() {
        // 1. Add subviews
        view.addSubview(toolbar)
        view.addSubview(tipLabel)
        
        // 2. Add buttons
        var items = [UIBarButtonItem]()
        let itemSettings = [["imageName": "compose_toolbar_picture", "action": "selectPicture"],
                            
                            ["imageName": "compose_mentionbutton_background"],
                            
                            ["imageName": "compose_trendbutton_background"],
                            
                            ["imageName": "compose_emoticonbutton_background", "action": "inputEmoticon"],
                            
                            ["imageName": "compose_camerabutton_background"]]
        for dict in itemSettings {
            let item = UIBarButtonItem(imageName: dict["imageName"]!, target: self, action: dict["action"])
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolbar.items = items
        
        // 3. Lay out toolbar
        let width = UIScreen.mainScreen().bounds.width
        let cons = toolbar.tg_AlignInner(type: TG_AlignType.BottomLeft, referView: view, size: CGSize(width: width, height: 44))
        toolbarBottonCons = toolbar.tg_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
        
        // 4. Lay out tip label
        tipLabel.tg_AlignVertical(type: TG_AlignType.TopRight, referView: toolbar, size: nil, offset: CGPoint(x: -10, y: -10))
    }
    
    /**
     Select pictures
     */
    func selectPicture() {
        // 1. Close keyboard
        textView.resignFirstResponder()
        
        // 2. Modify photo selector's height
        photoViewHeightCons?.constant = UIScreen.mainScreen().bounds.height * 0.6
    }
    
    /**
     Switch to the emoticon keyboard
     */
    func inputEmoticon() {
        // 1. Close the keyboard
        textView.resignFirstResponder()
        
        // 2. Set input view
        textView.inputView = (textView.inputView == nil) ? emoticonVC.view : nil
        
        // 3. Recall the keyboard
        textView.becomeFirstResponder()
    }
    
    /**
     Initialize photo selector view
     */
    private func setUpPhotoView() {
        // 1. Add photo selector
        view.insertSubview(photoSelectorVC.view, belowSubview: toolbar)
        
        // 2. Lay out photo selector
        let size = UIScreen.mainScreen().bounds.size
        let width = size.width
        let height: CGFloat = 0
        let cons = photoSelectorVC.view.tg_AlignInner(type: TG_AlignType.BottomLeft, referView: view, size: CGSize(width: width, height: height))
        photoViewHeightCons = photoSelectorVC.view.tg_Constraint(cons, attribute: NSLayoutAttribute.Height)
    }
    
    /**
     Initialize input view
     */
    private func setUpInpuView() {
        // 1. Add subviews
        view.addSubview(textView)
        textView.addSubview(placeholderLabel)
        textView.alwaysBounceVertical = true
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        
        // 2. Lay out subviews
        textView.tg_Fill(view)
        placeholderLabel.tg_AlignInner(type: TG_AlignType.TopLeft, referView: textView, size: nil, offset: CGPoint(x: 5, y: 8))
    }
    
    /**
     Initialize navigation bar
     */
    private func setUpNavi() {
        // 1. Add left button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(close))
        // 2. Add right button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(sendStatus))
        navigationItem.rightBarButtonItem?.enabled = false
        
        // 3. Add and lay out center title view
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 32))
        
        let label1 = UILabel()
        label1.text = "New Weibo"
        label1.font = UIFont.boldSystemFontOfSize(17)
        label1.sizeToFit()
        titleView.addSubview(label1)
        
        let label2 = UILabel()
        label2.text = UserAccount.loadAccount()?.screen_name
        label2.font = UIFont.systemFontOfSize(12)
        label2.textColor = UIColor.lightGrayColor()
        label2.sizeToFit()
        titleView.addSubview(label2)
        
        label1.tg_AlignInner(type: TG_AlignType.TopCenter, referView: titleView, size: nil)
        label2.tg_AlignInner(type: TG_AlignType.BottomCenter, referView: titleView, size: nil)
        
        navigationItem.titleView = titleView
    }
    
    /**
     Close view controller
     */
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     Send new Weibo
     */
    func sendStatus() {
//        let path = "2/statuses/update.json"
//        let params = ["access_token":UserAccount.loadAccount()!.access_token! , "status": textView.emoticonAttributedText()]
//        NetworkTools.shareNetworkTools().POST(path, parameters: params, progress: nil, success: { (_, JSON) -> Void in
//            // 1. Show post succeeded reminder
//            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
//            SVProgressHUD.showInfoWithStatus("Post Succeeded")
//            
//            // 2. Close new Weibo interface
//            self.close()
//        }) { (_, error) -> Void in
//            print(error)
//            // 3. Show post failed reminder
//            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
//            SVProgressHUD.showInfoWithStatus("Post Failed")
//        }
        let text = textView.emoticonAttributedText()
        let image = photoSelectorVC.pictureImages.first
        NetworkTools.shareNetworkTools().sendStatus(text , image: image, successCallback: { (status) -> () in
            // 1. Show post succeeded reminder
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
            SVProgressHUD.showInfoWithStatus("Post Succeeded")
            // 2. Close new Weibo interface
            self.close()
        }) { (error) -> () in
            print(error)
            // 3. Show post failed reminder
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
            SVProgressHUD.showInfoWithStatus("Post Failed")
        }
    }
    
    // MARK: - Lazy loading
    /// Text view
    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFontOfSize(17)
        tv.delegate = self
        return tv
    }()
    /// Placeholder label
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(17)
        label.textColor = UIColor.lightGrayColor()
        label.text = "What's on your mind?"
        return label
    }()
    /// Toolbar
    private lazy var toolbar: UIToolbar = UIToolbar()
    /// Emoticon view controller
    private lazy var emoticonVC: EmoticonViewController = EmoticonViewController { [unowned self] (emoticon) -> () in
        self.textView.insertEmoticon(emoticon)
    }
    /// Photo selector view controller
    private lazy var photoSelectorVC: PhotoSelectorViewController = PhotoSelectorViewController()
    /// Word count tip label
    private lazy var tipLabel: UILabel = {
        let label = UILabel()
        return label
    }()
}

private let maxTipLength = 150
extension ComposeViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        // Note: inputing emoticon won't trigger textViewDidChange()
        placeholderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
        
        // Number of words input
        let count =  textView.emoticonAttributedText().characters.count
        let res = maxTipLength - count
        tipLabel.textColor = (res > 0) ? UIColor.darkGrayColor() : UIColor.redColor()
        tipLabel.text = res == maxTipLength ? "" : "\(res)"
    }
}
