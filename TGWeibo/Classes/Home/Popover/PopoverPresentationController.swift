//
//  PopoverPresentationController.swift
//  TGWeibo
//
//  Created by Theodore Guo on 26/1/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

class PopoverPresentationController: UIPresentationController {
    /// Define a variable to store popover view's size
    var presentFrame = CGRectZero
    
    /**
     Initialization method, to create transition executor
     
     - parameter presentedViewController:  presented view's controller
     - parameter presentingViewController: presenting view's controller (Xcode 6 is nil and Xcode 7 is wild pointer)
     
     - returns: transition executor
     */
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        
        print(presentedViewController)
    }
    
    /**
     Invoked when container view will lay out subviews
     */
    override func containerViewWillLayoutSubviews() {
        // 1. Modify popover's size
        if presentFrame == CGRectZero {
            presentedView()?.frame = CGRect(x: 100, y: 56, width: 200, height: 200)
        } else {
            presentedView()?.frame = presentFrame
        }
        
        // 2. Insert a misk view underneath presenting view in container view
        containerView?.insertSubview(maskView, atIndex: 0)
    }
    
    // MARK: - Lazy loading
    /// Mask view
    private lazy var maskView: UIView = {
        // 1. Create view
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        view.frame = UIScreen.mainScreen().bounds
        
        // 2. Add monitor
        let tap = UITapGestureRecognizer(target: self, action: #selector(PopoverPresentationController.close))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    /**
     Acquire current popover view controller
     */
    func close() {
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
