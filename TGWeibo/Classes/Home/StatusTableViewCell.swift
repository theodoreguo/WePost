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

class StatusTableViewCell: UITableViewCell {
    /// Store illustration width constraint
    var pictureWidthCons: NSLayoutConstraint?
    /// Store illustration height constraint
    var pictureHeightCons: NSLayoutConstraint?
    /// Store Statuses model
    var status: Statuses? {
        didSet {
            // 1. Set top view
            topView.status = status
            
            // 2. Set content text
            contentLabel.text = status?.text
            
            // 3. Set illustrations
            // 3.1 Assign data (model data should be assigned first as model data are necessary for calculating size)
            pictureView.status = status
            // 3.2 Calculate illustration size
            let size = pictureView.calculateImageSize()
            // 3.3 Set illustration size
            pictureWidthCons?.constant = size.width
            pictureHeightCons?.constant = size.height
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
    
    private func setUpUI() {
        // 1. Add subviews
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(footerView)
        
        // 2. Lay out subviews
        let width = UIScreen.mainScreen().bounds.width
        topView.tg_AlignInner(type: TG_AlignType.TopLeft, referView: contentView, size: CGSize(width: width, height: 60))
        
        contentLabel.tg_AlignVertical(type: TG_AlignType.BottomLeft, referView: topView, size: nil, offset: CGPoint(x: 10, y: 10))
        
        let cons = pictureView.tg_AlignVertical(type: TG_AlignType.BottomLeft, referView: contentLabel, size: CGSizeZero, offset: CGPoint(x: 0, y: 10))
        pictureWidthCons = pictureView.tg_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureHeightCons =  pictureView.tg_Constraint(cons, attribute: NSLayoutAttribute.Height)
        
        footerView.tg_AlignVertical(type: TG_AlignType.BottomLeft, referView: pictureView, size: CGSize(width: width, height: 44), offset: CGPoint(x: -10, y: 10))
        
        // Add bottom constraint
        // TODO: temporary setting
//        footerView.tg_AlignInner(type: TG_AlignType.BottomRight, referView: contentView, size: nil, offset: CGPoint(x: -10, y: -10))
    }
    
    /**
     Acquire row height
     */
    func rowHeight(status: Statuses) -> CGFloat {
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
    private lazy var contentLabel: UILabel = {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        return label
    }()
    /// Illustration
    private lazy var pictureView: StatusPictureView = StatusPictureView()
    /// Bottom tool bar
    private lazy var footerView: StatusTableViewBottomView = StatusTableViewBottomView()
}
