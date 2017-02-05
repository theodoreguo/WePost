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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        // Initialize navigation bar
        setUpNavi()
        
        // Initialize input view
        setupInpuView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Display keyboard
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Hide keyboard
        textView.resignFirstResponder()
    }
    
    /**
     Initialize input view
     */
    private func setupInpuView() {
        // 1. Add subviews
        view.addSubview(textView)
        textView.addSubview(placeholderLabel)
        
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
        let path = "2/statuses/update.json"
        let params = ["access_token":UserAccount.loadAccount()?.access_token! , "status": textView.text]
        NetworkTools.shareNetworkTools().POST(path, parameters: params, progress: nil, success: { (_, JSON) -> Void in
            // 1. Show post succeeded reminder
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
            SVProgressHUD.showInfoWithStatus("Post Succeeded")
            
            // 2. Close new Weibo interface
            self.close()
        }) { (_, error) -> Void in
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
        tv.delegate = self
        return tv
    }()
    /// Placeholder label
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(13)
        label.textColor = UIColor.lightGrayColor()
        label.text = "What's on your mind?"
        return label
    }()
}

extension ComposeViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        placeholderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
}
