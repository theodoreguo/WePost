//
//  VisitorView.swift
//  TGWeibo
//
//  Created by Theodore Guo on 17/1/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

protocol VisitorViewDelegate : NSObjectProtocol {
    // Login call-back
    func loginBtnDidClick()
    // Register call-back
    func registerBtnDidClick()
}

class VisitorView: UIView {
    // Difine an attribute to store the delegate object ('weak' is compulsory to avoid circular references)
    weak var delegate: VisitorViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add child widgets
        addSubview(iconView)
        addSubview(backgroundMaskView)
        addSubview(centerImageView)
        addSubview(messageLabel)
        addSubview(loginBtn)
        addSubview(registerBtn)
        
        // Set child widgets' layout
        iconView.tg_AlignInner(type: TG_AlignType.Center, referView: self, size: nil)
        
        centerImageView.tg_AlignInner(type: TG_AlignType.Center, referView: self, size: nil)
        
        messageLabel.tg_AlignVertical(type: TG_AlignType.BottomCenter, referView: iconView, size: nil)
        let widthCons = NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 224)
        addConstraint(widthCons)
        
        registerBtn.tg_AlignVertical(type: TG_AlignType.BottomLeft, referView: messageLabel, size: CGSize(width: 100, height: 30), offset: CGPoint(x: 0, y: 20))
        
        loginBtn.tg_AlignVertical(type: TG_AlignType.BottomRight, referView: messageLabel, size: CGSize(width: 100, height: 30), offset: CGPoint(x: 0, y: 20))
        
        backgroundMaskView.tg_Fill(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Set up visitor view
     
     - parameter isHome:    judge it's home tab or view
     - parameter imageName: the name of image which needs to be displayed
     - parameter message:   text which needs to be displayed
     */
    func setUpVisitorViewInfo(isHome: Bool, imageName: String, message: String) {
        // Hide icons circle if it's not home tab
        iconView.hidden = !isHome
        // Reset center image
        centerImageView.image = UIImage(named: imageName)
        // Modify text
        messageLabel.text = message
        // Judge to execute animation
        if isHome {
            startAnimation()
        }
    }
    
    /**
     Actions once register button is clicked
     */
    func registerBtnClick() {
//        print(#function)
        delegate?.registerBtnDidClick()
    }
    
    /**
     Actions once login button is clicked
     */
    func loginBtnClick() {
//        print(#function)
        delegate?.loginBtnDidClick()
    }
    
    // MARK: - Internal control functions
    /**
     Rotation animation
     */
    private func startAnimation() {
        // Create animation
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        // Set animation attributes
        anim.toValue = 2 * M_PI
        anim.duration = 20
        anim.repeatCount = MAXFLOAT
        anim.removedOnCompletion = false
        // Add animation to layer
        iconView.layer.addAnimation(anim, forKey: nil)
    }
    
    // MARK: - Lazy loading
    /// Icons circle
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView(image:UIImage(named: "visitordiscover_feed_image_smallicon"))
        return imageView
    }()
    
    /// Center image
    private lazy var centerImageView: UIImageView = {
        let imageView = UIImageView(image:UIImage(named: "visitordiscover_feed_image_house"))
        return imageView
    }()
    
    /// Label
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.lightGrayColor()
        label.text = ""
        return label
    }()
    
    /// Register button
    private lazy var registerBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        btn.setTitle("Register", forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        
        btn.addTarget(self, action: #selector(VisitorView.loginBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
    }()
    
    /// Login button
    private lazy var loginBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        btn.setTitle("Login", forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        
        btn.addTarget(self, action: #selector(VisitorView.registerBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
    }()
    
    /// Mask view
    private lazy var backgroundMaskView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        return imageView
    }()
}
