//
//  OAuthViewController.swift
//  TGWeibo
//
//  Created by Theodore Guo on 27/1/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit
import SVProgressHUD

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
        wv.delegate = self
        return wv
    }()
}

extension OAuthViewController: UIWebViewDelegate {
    /**
     Returning true means loading succeeded, or it means loading failed
     */
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // 1. Judge to continue if it isn't authorization callback page
        let urlStr = request.URL!.absoluteString
        if !urlStr.hasPrefix(WB_redirect_uri) {
            return true
        }
        
        // 2. Judge authorization succeeded or not
        let codeStr = "code="
        if request.URL!.query!.hasPrefix(codeStr) { // Authorization succeeded
            // Get authorized request token
            let code = request.URL?.query?.substringFromIndex(codeStr.endIndex)
            // Get access token using authorized request token
            loadAccessToken(code!)
        } else { // Cancel authorization
            // Close login interface
            close()
        }
        
        return false
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        // Show loading reminder
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
        SVProgressHUD.showInfoWithStatus("Loading")
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        // Dismiss loading reminder
        SVProgressHUD.dismiss()
    }
    
    /**
     Get access token
     
     - parameter code: authorized request token
     */
    private func loadAccessToken(code: String) {
        // 1. Define path
        let path = "oauth2/access_token"
        
        // 2. Set parameters
        let params = ["client_id": WB_App_Key, "client_secret": WB_App_Secret, "grant_type": "authorization_code", "code": code, "redirect_uri": WB_redirect_uri]
        
        // 3. Post request
        NetworkTools.shareNetworkTools().POST(path, parameters: params, progress: nil, success: { (_, JSON) in
            // 1. Convert dictionary to model
            let account = UserAccount(dict: JSON as! [String : AnyObject])
            
            // 2. Get user info
            account.loadUserInfo({ (account, error) in
                // Save user info
                if account != nil {
                    account?.saveAccount()
                } else {
                    // Show poor network reminder
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
                    SVProgressHUD.showInfoWithStatus("Poor network")
                }
            })
            }) { (_, error) in
                print(error)
        }
    }
}
