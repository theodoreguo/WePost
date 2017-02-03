//
//  StatusTableViewBottomView.swift
//  TGWeibo
//
//  Created by Theodore Guo on 3/2/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

class StatusTableViewBottomView: UIView {
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
        // 1. Set background color
        backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        
        // 2. Add subviews
        addSubview(repostBtn)
        addSubview(commentsBtn)
        addSubview(likesBtn)
        
        // 3. Lay out subviews
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
