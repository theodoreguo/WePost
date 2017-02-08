//
//  WebExplorerController.swift
//  TGWeibo
//
//  Created by Theodore Guo on 8/2/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

class WebExplorerController: UIViewController, UIWebViewDelegate {
    /// Store URL transmitted
    var url: NSURL?
    // Web view
    @IBOutlet weak var webView: UIWebView!
    // Back item
    @IBOutlet weak var backItem: UIBarButtonItem!
    // Forward item
    @IBOutlet weak var forwardItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegate
        webView.delegate = self
        
        // Load URL request
        webView.loadRequest(NSURLRequest(URL: url!))
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: "WebExplorerController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Go back
     */
    @IBAction func back(sender: AnyObject) {
        webView.goBack()
    }
    
    /**
     Go forward
     */
    @IBAction func forward(sender: AnyObject) {
        webView.goForward()
    }
    
    /**
     Refresh web view
     */
    @IBAction func refresh(sender: AnyObject) {
        webView.reload()
    }
    
    // MARK: - UIWebViewDelegate
    func webViewDidFinishLoad(webView: UIWebView) {
        backItem.enabled = webView.canGoBack
        forwardItem.enabled = webView.canGoForward
    }
}
