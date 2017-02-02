//
//  StatusTableViewCell.swift
//  TGWeibo
//
//  Created by Theodore Guo on 2/2/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit
import SDWebImage

class StatusTableViewCell: UITableViewCell {
    var status: Statuses? {
        didSet {
            nameLabel.text = status?.user?.name
            timeLabel.text = "just now"
            contentLabel.text = status?.text
            
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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        // 1. Add subviews
        contentView.addSubview(iconView)
        contentView.addSubview(verifiedView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(memberView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(sourceLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(footerView)
        
        footerView.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        
        // 2. Lay out subviews
        iconView.tg_AlignInner(type: TG_AlignType.TopLeft, referView: contentView, size: CGSize(width: 50, height: 50), offset: CGPoint(x: 10, y: 10))
        verifiedView.tg_AlignInner(type: TG_AlignType.BottomRight, referView: iconView, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 5, y: 5))
        nameLabel.tg_AlignHorizontal(type: TG_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 10))
        memberView.tg_AlignHorizontal(type: TG_AlignType.TopRight, referView: nameLabel, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 10, y: 0))
        timeLabel.tg_AlignHorizontal(type: TG_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        sourceLabel.tg_AlignHorizontal(type: TG_AlignType.BottomRight, referView: timeLabel, size: nil, offset: CGPoint(x: 5, y: 0))
        contentLabel.tg_AlignVertical(type: TG_AlignType.BottomLeft, referView: iconView, size: nil, offset: CGPoint(x: 0, y: 10))
        
        let width = UIScreen.mainScreen().bounds.width
        footerView.tg_AlignVertical(type: TG_AlignType.BottomLeft, referView: contentLabel, size: CGSize(width: width, height: 44), offset: CGPoint(x: -10, y: 10))
        
        // Add bottom constraint
        // TODO: temporary setting
        footerView.tg_AlignInner(type: TG_AlignType.BottomRight, referView: contentView, size: nil, offset: CGPoint(x: -10, y: -10))
    }
    
    // MARK: - Lazy loading
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
    /// Content
    private lazy var contentLabel: UILabel = {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        return label
    }()
    /// Bottom tool bar
    private lazy var footerView: StatusFooterView = StatusFooterView()
}

class StatusFooterView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        addSubview(repostBtn)
        addSubview(commentsBtn)
        addSubview(likesBtn)
        
        // 2. Lay out subviews
        tg_HorizontalTile([repostBtn, commentsBtn, likesBtn], insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    // MARK: Lazy loading
    /// Repost button
    private lazy var repostBtn: UIButton = UIButton.createButton("timeline_icon_retweet", title: "Repost")
    /// Comments button
    private lazy var commentsBtn: UIButton = UIButton.createButton("timeline_icon_comment", title: "Comments")
    /// Likes button
    private lazy var likesBtn: UIButton = UIButton.createButton("timeline_icon_unlike", title: "Likes")
}
