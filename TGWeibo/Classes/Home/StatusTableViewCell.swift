//
//  StatusTableViewCell.swift
//  TGWeibo
//
//  Created by Theodore Guo on 2/2/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit
import SDWebImage

let TGPictureViewCellReuseIdentifier = "TGPictureViewCellReuseIdentifier"

/**
 Store cell reuse ID
 
 - OriginalCell: Original Weibo reuse ID
 - RepostCell:   Reposted Weibo reuse ID
 */
enum StatusTableViewCellIdentifier: String {
    case OriginalCell = "OriginalCell"
    case RepostCell = "RepostCell"
    
    static func cellID(status: Status) -> String {
        return status.retweeted_status != nil ? RepostCell.rawValue : OriginalCell.rawValue
    }
}

class StatusTableViewCell: UITableViewCell {
    /// Store illustration width constraint
    var pictureWidthCons: NSLayoutConstraint?
    /// Store illustration height constraint
    var pictureHeightCons: NSLayoutConstraint?
    /// Store illustration top constraint
    var pictureTopCons: NSLayoutConstraint?
    /// Store Statuses model
    var status: Status? {
        didSet {
            // 1. Set top view
            topView.status = status
            
            // 2. Set content text
            contentLabel.text = status?.text
            
            // 3. Set illustrations
            // 3.1 Assign data (model data should be assigned first as model data are necessary for calculating size)
            pictureView.status = status?.retweeted_status != nil ? status?.retweeted_status : status
            // 3.2 Calculate illustration size
            let size = pictureView.calculateImageSize()
            // 3.3 Set illustration size
            pictureWidthCons?.constant = size.width
            pictureHeightCons?.constant = size.height
            pictureTopCons?.constant = size.height == 0 ? 0 : 10
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Initialize UI
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        // 1. Add subviews
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(footerView)
        
        // 2. Lay out subviews
        let width = UIScreen.mainScreen().bounds.width
        topView.tg_AlignInner(type: TG_AlignType.TopLeft, referView: contentView, size: CGSize(width: width, height: 60))
        
        contentLabel.tg_AlignVertical(type: TG_AlignType.BottomLeft, referView: topView, size: nil, offset: CGPoint(x: 10, y: 10))
                
        footerView.tg_AlignVertical(type: TG_AlignType.BottomLeft, referView: pictureView, size: CGSize(width: width, height: 44), offset: CGPoint(x: -10, y: 10))
    }
    
    /**
     Acquire row height
     */
    func rowHeight(status: Status) -> CGFloat {
        // 1. Ensure calling didSet to calculate illustration height
        self.status = status
        
        // 2. Refresh interface
        self.layoutIfNeeded()
        
        // 3. Return footer view max y value
        return CGRectGetMaxY(footerView.frame)
    }
    
    // MARK: - Lazy loading
    /// Top view
    private lazy var topView: StatusTableViewTopView = StatusTableViewTopView()
    /// Content
    lazy var contentLabel: UILabel = {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        return label
    }()
    /// Illustration
    lazy var pictureView: StatusPictureView = StatusPictureView()
    /// Bottom tool bar
    lazy var footerView: StatusTableViewBottomView = StatusTableViewBottomView()
}
