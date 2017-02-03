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
            
            // Set illustrations
            // 1.1 Calculate illustration size
            let size = calculateImageSize()
            // 1.2 Set illustration size
            pictureWidthCons?.constant = size.viewSize.width
            pictureHeightCons?.constant = size.viewSize.height
            // 1.3 Set cell size
            pictureLayout.itemSize = size.itemSize
            // 1.4 Refresh data
            pictureView.reloadData()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Initialize UI
        setUpUI()
        
        // Initialize illustrations
        setUpPictureView()
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
        contentView.addSubview(pictureView)
        
        // 2. Lay out subviews
        iconView.tg_AlignInner(type: TG_AlignType.TopLeft, referView: contentView, size: CGSize(width: 50, height: 50), offset: CGPoint(x: 10, y: 10))
        verifiedView.tg_AlignInner(type: TG_AlignType.BottomRight, referView: iconView, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 5, y: 5))
        nameLabel.tg_AlignHorizontal(type: TG_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 10))
        memberView.tg_AlignHorizontal(type: TG_AlignType.TopRight, referView: nameLabel, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 10, y: 0))
        timeLabel.tg_AlignHorizontal(type: TG_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        sourceLabel.tg_AlignHorizontal(type: TG_AlignType.BottomRight, referView: timeLabel, size: nil, offset: CGPoint(x: 5, y: 0))
        contentLabel.tg_AlignVertical(type: TG_AlignType.BottomLeft, referView: iconView, size: nil, offset: CGPoint(x: 0, y: 10))
        
        let cons = pictureView.tg_AlignVertical(type: TG_AlignType.BottomLeft, referView: contentLabel, size: CGSizeZero, offset: CGPoint(x: 0, y: 10))
        pictureWidthCons = pictureView.tg_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureHeightCons =  pictureView.tg_Constraint(cons, attribute: NSLayoutAttribute.Height)
        
        let width = UIScreen.mainScreen().bounds.width
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
    
    /**
     Calculate illustrations' size
     */
    private func calculateImageSize() -> (viewSize: CGSize, itemSize: CGSize) {
        // 1. Get illustration count
        let count = status?.storedPicURLS?.count
        
        // 2. Return zero if no illustration
        if count == 0 || count == nil {
            return (CGSizeZero, CGSizeZero)
        }
        
        // 3. Return real size if only one illustration
        if count == 1 {
            // 3.1 Get buffered illustrations
            let key = status?.storedPicURLS!.first?.absoluteString
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key!)
//            pictureLayout.itemSize = image.size
            // 3.2 Return buffered illustrations' size
            return (image.size, image.size)
        }
        
        // 4. Calculate four block box size if there are 4 illustrations
        let width = 90
        let margin = 10
//        pictureLayout.itemSize = CGSize(width: width, height: width)
        if count == 4 {
            let viewWidth = width * 2 + margin
            return (CGSize(width: viewWidth, height: viewWidth), CGSize(width: width, height: width))
        }
        
        // 5. Calculate nine block box size if there are 2/3/5/6/7/8/9 illustrations
        // 5.1 Set column number
        let colNumber = 3
        // 5.2 Calculate row number
        let rowNumber = (count! - 1) / 3 + 1
        // view width = cols * picture width + (cols - 1) * margin
        let viewWidth = colNumber * width + (colNumber - 1) * margin
        // view height = rows * picture height + (rows - 1) * margin
        let viewHeight = rowNumber * width + (rowNumber - 1) * margin
        return (CGSize(width: viewWidth, height: viewHeight), CGSize(width: width, height: width))
    }
    
    /**
     Initialize illustrations
     */
    private func setUpPictureView() {
        // 1. Register cell
        pictureView.registerClass(PictureViewCell.self, forCellWithReuseIdentifier: TGPictureViewCellReuseIdentifier)
        
        // 2. Set data source
        pictureView.dataSource = self
        
        // 3. Set space between cells
        pictureLayout.minimumInteritemSpacing = 10
        pictureLayout.minimumLineSpacing = 10
        
        // 4. Set background color
        pictureView.backgroundColor = UIColor.clearColor()
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
    /// Illustration layout
    private lazy var pictureLayout: UICollectionViewFlowLayout =  UICollectionViewFlowLayout()
    /// Illustration
    private lazy var pictureView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.pictureLayout)
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

extension StatusTableViewCell: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.storedPicURLS?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 1. Get cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TGPictureViewCellReuseIdentifier, forIndexPath: indexPath) as! PictureViewCell
        // 2. Set data
        cell.imageURL = status?.storedPicURLS![indexPath.item]
        
        return cell
    }
}

class PictureViewCell: UICollectionViewCell {
    /// Define property to receive transmitted data
    var imageURL: NSURL? {
        didSet {
            iconImageView.sd_setImageWithURL(imageURL!)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        contentView.addSubview(iconImageView)
        // 2. Lay out subviews
        iconImageView.tg_Fill(contentView)
    }
    
    // MARK: - Lazy loading
    private lazy var iconImageView:UIImageView = UIImageView()
}
