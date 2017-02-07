//
//  StatusRepostTableViewCell.swift
//  TGWeibo
//
//  Created by Theodore Guo on 3/2/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit
import KILabel

class StatusRepostTableViewCell: StatusTableViewCell {
    /// Override superclass status property to dispose reposted Weibo's nickname and content text (subclass overrides superclass didSet() won't affect superclass's operation)
    override var status: Status? {
        didSet {
            let name = status?.retweeted_status?.user?.name ?? ""
            let text = status?.retweeted_status?.text ?? ""
//            repostLabel.text = name + ": " + text
            repostLabel.attributedText = EmoticonPackage.emoticonString("@" + name + ": " + text)
        }
    }
    
    /**
     Override UI initialization method
     */
    override func setUpUI() {
        super.setUpUI()
        
        // 1. Add subviews
        contentView.insertSubview(repostBgBtn, belowSubview: pictureView)
        contentView.insertSubview(repostLabel, aboveSubview: repostBgBtn)
        
        // 2. Lay out subviews
        // 2.1 Lay out repost background
        repostBgBtn.tg_AlignVertical(type: TG_AlignType.BottomLeft, referView: contentLabel, size: nil, offset: CGPoint(x: -10, y: 10))
        repostBgBtn.tg_AlignVertical(type: TG_AlignType.TopRight, referView: footerView, size: nil)
        // 2.2 Lay out repost content text
        repostLabel.tg_AlignInner(type: TG_AlignType.TopLeft, referView: repostBgBtn, size: nil, offset: CGPoint(x: 10, y: 10))
        // 2.3 Modify illustrations' positions
        let cons = pictureView.tg_AlignVertical(type: TG_AlignType.BottomLeft, referView: repostLabel, size: CGSizeZero, offset: CGPoint(x: 0, y: 10))
        pictureWidthCons = pictureView.tg_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureHeightCons =  pictureView.tg_Constraint(cons, attribute: NSLayoutAttribute.Height)
        pictureTopCons = pictureView.tg_Constraint(cons, attribute: NSLayoutAttribute.Top)
    }
    
    // MARK: Lazy loading
    /// Repost content text
    private lazy var repostLabel: KILabel = {
        let label = KILabel()
        label.textColor = UIColor.darkGrayColor()
        label.font = UIFont.systemFontOfSize(15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        
        // Monitor URL click
        label.urlLinkTapHandler = {(label, string, range) in
            print(string)
        }
        
        return label
    }()
    /// Repost background button
    private lazy var repostBgBtn: UIButton = {
       let btn = UIButton()
        btn.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        return btn
    }()
}
