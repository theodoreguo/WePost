//
//  HomeRefreshControl.swift
//  TGWeibo
//
//  Created by Theodore Guo on 3/2/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

class HomeRefreshControl: UIRefreshControl {
    override init() {
        super.init()
        
        // Initialize UI
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Initialize UI
     */
    private func setUpUI() {
        // 1. Add subviews
        addSubview(refreshView)
        
        // 2. Lay out subviews
        refreshView.tg_AlignInner(type: TG_AlignType.Center, referView: self, size: CGSize(width: 140, height: 60))
        
        // 3. Add observer
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    deinit {
        removeObserver(self, forKeyPath: "frame")
    }
    
    /// Flag to store arrow icon rotation state
    private var rotateArrowFlag = false
    /// Flag to store loading view animation state
    private var loadingViewAnimFlag = false
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        // Don't refresh when y value >= 0
        if frame.origin.y >= 0 {
            return
        }
        
        // Judge refresh event has been triggered or not
        if refreshing && !loadingViewAnimFlag {
            loadingViewAnimFlag = true
            // Show the circle and make it execute animation
            refreshView.startLoadingViewAnim()
            return
        }
        
        if frame.origin.y >= -50 && rotateArrowFlag {
            rotateArrowFlag = false
            refreshView.rotateArrowIcon(rotateArrowFlag)
        } else if frame.origin.y < -50 && !rotateArrowFlag {
            rotateArrowFlag = true
            refreshView.rotateArrowIcon(rotateArrowFlag)
        }
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        
        // Stop the circle's animation
        refreshView.stopLoadingViewAnim()
        
        // Reset flag
        loadingViewAnimFlag = false
    }
    
    // MARK: - Lazy loading
    /// Custom refresh view
    private lazy var refreshView: HomeRefreshView = HomeRefreshView.refreshView()
}

class HomeRefreshView: UIView {
    // Loading view
    @IBOutlet weak var loadingView: UIImageView!
    // Pull down view
    @IBOutlet weak var pullDownView: UIView!
    // Arrow icon
    @IBOutlet weak var arrowIcon: UIImageView!
    // Pull down label
    @IBOutlet weak var pullDownLabel: UILabel!
    
    /**
     Turn the arrow icon upside down
     */
    func rotateArrowIcon(flag: Bool) {
        var angle = M_PI
        angle += flag ? -0.01 : 0.01
        UIView.animateWithDuration(0.2) { 
            self.arrowIcon.transform = CGAffineTransformRotate(self.arrowIcon.transform, CGFloat(angle))
        }
        pullDownLabel.text = !flag ? "Pull down" : "Release"
    }
    
    /**
     Start the circle's animation
     */
    func startLoadingViewAnim() {
        pullDownView.hidden = true
        
        // 1. Create animation
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        
        // 2. Set animation properties
        anim.toValue = 2 * M_PI
        anim.duration = 1
        anim.repeatCount = MAXFLOAT
        
        // 3. Remove animation once it's completed
        anim.removedOnCompletion = false
        
        // 4. Add animation to layer
        loadingView.layer.addAnimation(anim, forKey: nil)
    }
    
    /**
     Stop the circle's animation
     */
    func stopLoadingViewAnim() {
        pullDownView.hidden = false
        
        loadingView.layer.removeAllAnimations()
    }
    
    class func refreshView() -> HomeRefreshView {
        return NSBundle.mainBundle().loadNibNamed("HomeRefreshView", owner: nil, options: nil).last as! HomeRefreshView
    }
}