//
//  WelcomeViewController.swift
//  TGWeibo
//
//  Created by Theodore Guo on 1/2/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {
    /// Bottom constraints
    var bottomCons: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Add subviews
        view.addSubview(bgIV)
        view.addSubview(iconView)
        view.addSubview(messageLabel)
        
        // 2. Lay out subviews
        bgIV.tg_Fill(view)
        
        let cons = iconView.tg_AlignInner(type: TG_AlignType.BottomCenter, referView: view, size: CGSize(width: 100, height: 100), offset: CGPoint(x: 0, y: -150))
        // Get profile's bottom constraints
        bottomCons = iconView.tg_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
        
        messageLabel.tg_AlignVertical(type: TG_AlignType.BottomCenter, referView: iconView, size: nil, offset: CGPoint(x: 0, y: 20))
        
        // 3. Set user avatar
        if let iconUrl = UserAccount.loadAccount()?.avatar_large
        {
            let url = NSURL(string: iconUrl)!
            iconView.sd_setImageWithURL(url)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        bottomCons?.constant = -UIScreen.mainScreen().bounds.height -  bottomCons!.constant // -667.0 - (-150) = -517.0
        print(-UIScreen.mainScreen().bounds.height) // -667.0
        print(bottomCons!.constant) // -517.0
        print(-UIScreen.mainScreen().bounds.height -  bottomCons!.constant) // -150.0
        
        // 3. Excute animation
        UIView.animateWithDuration(2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            // Profile's animation
            self.iconView.layoutIfNeeded()
        }) { (_) -> Void in
            // Text's animation
            UIView.animateWithDuration( 2.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                self.messageLabel.alpha = 1.0
                }, completion: { (_) -> Void in
                    print("OK")
            })
        }
    }
    
    // MARK: - Lazy loading
    private lazy var bgIV: UIImageView = UIImageView(image: UIImage(named: "ad_background"))
    
    private lazy var iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        iv.layer.cornerRadius = 50
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome Back"
        label.sizeToFit()
        label.alpha = 0.0
        return label
    }()
}
