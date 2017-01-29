//
//  OAuthViewController.swift
//  TGWeibo
//
//  Created by Theodore Guo on 27/1/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController {
    let WB_App_Key = "3158814375"
    let WB_App_Secret = "94c518bb5f86110b9aa25c0e672dd21c"
    let WB_redirect_uri = "http://www.ntu.edu.sg"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Initialize navigation bar
        navigationItem.title = "TGWeibo"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(close))
        
        // 2. Get unauthorized request token
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_redirect_uri)&language=en"
        let url = NSURL(string: urlStr)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
    
    /**
     Close login interface
     */
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func loadView() {
         view = webView
    }
    
    // MARK: - Lazy loading
    /// Web view
    private lazy var webView: UIWebView = {
        let wv = UIWebView()
        return wv
    }()
}
