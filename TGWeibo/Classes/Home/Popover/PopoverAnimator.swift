//
//  PopoverAnimator.swift
//  TGWeibo
//
//  Created by Theodore Guo on 26/1/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

/// Difine constants to store notifications' names
let TGPopoverAnimatorWillShow = "TGPopoverAnimatorWillShow"
let TGPopoverAnimatorWillDismiss = "TGPopoverAnimatorWillDismiss"

class PopoverAnimator: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    /// Record popover view's status, false by default
    var isPresent: Bool = false
    
    /// Define a variable to store popover view's size
    var presentFrame = CGRectZero
    
    /**
     Implement delegate methods to designate transition executor
     */
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let pc = PopoverPresentationController(presentedViewController: presented, presentingViewController: presenting)
        // Set popover's size
        pc.presentFrame = presentFrame
        return pc
    }
    
    // MARK: - Default animation will be invalid if below methods are implemented, customized operations are required then.
    /**
     To appoint executor of Modal presentation animation
     */
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        // Post notification to inform controller that view will show
        NSNotificationCenter.defaultCenter().postNotificationName(TGPopoverAnimatorWillShow, object: self)
        return self
    }
    
    /**
     To appoint executor of Modal dismission animation
     */
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        // Post notification to inform controller that view will dismiss
        NSNotificationCenter.defaultCenter().postNotificationName(TGPopoverAnimatorWillDismiss, object: self)
        return self
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    /**
     Return animation duration
     */
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    /**
     Notify system how to implement animation
     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if isPresent { // Popover needs to be presented
            // 1. Get presenting view
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            toView.transform = CGAffineTransformMakeScale(1.0, 0.0)
            // Note that the view is required to be added to the container
            transitionContext.containerView()?.addSubview(toView)
            // Set anchor point
            toView.layer.anchorPoint = CGPointMake(0.5, 0)
            
            // 2. Execute animation
            UIView.animateWithDuration(0.5, animations: {
                // 2.1 Clear transform
                toView.transform = CGAffineTransformIdentity
            }) { (_) in
                // 2.2 Inform system once animation is completed to avoid potential unknown errors
                transitionContext.completeTransition(true)
            }
        } else { // Popover needs to be dismissed
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            
            UIView.animateWithDuration(0.2, animations: {
                fromView?.transform = CGAffineTransformMakeScale(1.0, 0.000001) // y: 0.0 doesn't work since CGFloat is not precise enough, modified to 0.000001 instead
                }, completion: { (_) in
                    transitionContext.completeTransition(true)
            })
        }
    }
}