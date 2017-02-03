//
//  StatusTableViewTopView.swift
//  TGWeibo
//
//  Created by Theodore Guo on 3/2/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

class StatusTableViewTopView: UIView {
    var status: Status? {
        didSet {
            // Set nickname
            nameLabel.text = status?.user?.name
            
            // Set user profile
            if let url = status?.user?.imageURL {
                iconView.sd_setImageWithURL(url)
            }
            
            // Set user verification logo
            verifiedView.image = status?.user?.verifiedImage
            
            // Set membership logo
            memberView.image = status?.user?.mbrankImage
            
            // Set source
            sourceLabel.text = status?.source
            
            // Set posted time
            timeLabel.text = status?.created_at
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Intialize UI
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Intialize UI
     */
    private func setUpUI() {
        // 1. Add subviews
        addSubview(iconView)
        addSubview(verifiedView)
        addSubview(nameLabel)
        addSubview(memberView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        
        // 2. Lay out subviews
        iconView.tg_AlignInner(type: TG_AlignType.TopLeft, referView: self, size: CGSize(width: 50, height: 50), offset: CGPoint(x: 10, y: 10))
        verifiedView.tg_AlignInner(type: TG_AlignType.BottomRight, referView: iconView, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 5, y: 5))
        nameLabel.tg_AlignHorizontal(type: TG_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 10))
        memberView.tg_AlignHorizontal(type: TG_AlignType.TopRight, referView: nameLabel, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 10, y: 0))
        timeLabel.tg_AlignHorizontal(type: TG_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        sourceLabel.tg_AlignHorizontal(type: TG_AlignType.BottomRight, referView: timeLabel, size: nil, offset: CGPoint(x: 5, y: 0))
    }
    
    // MARK: Lazy loading
    /// Profile
    private lazy var iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        return iv
    }()
    /// Verification logo
    private lazy var verifiedView: UIImageView = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
    /// Nickname
    private lazy var nameLabel: UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 14)
    /// Membership logo
    private lazy var memberView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))
    /// Post time
    private lazy var timeLabel: UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 14)
    /// Source
    private lazy var sourceLabel: UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 14)
}
