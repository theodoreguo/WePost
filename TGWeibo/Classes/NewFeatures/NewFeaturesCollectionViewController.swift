//
//  NewFeaturesCollectionViewController.swift
//  TGWeibo
//
//  Created by Theodore Guo on 1/2/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

/// Page count
private let pageCount = 4
/// Reuse identifier
private let reuseIdentifier = "reuseIdentifier"

class NewFeaturesCollectionViewController: UICollectionViewController {
    /// Layout object
    private var layout: UICollectionViewFlowLayout = NewFeaturesLayout()
    
    init() {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.registerClass(NewFeaturesCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - UICollectionViewDataSource
    /**
     Return cells' quantity
     */
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCount
    }
    
    /**
     Return cell corresponding to each index path
     */
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 1. Get cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewFeaturesCell
        
        // 2. Set cell data
        cell.imageIndex = indexPath.item
        
        return cell
    }
    
    /**
     Called once the last cell is displayed
     */
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        // Get current displayed cell's index path
        let path = collectionView.indexPathsForVisibleItems().last!
        
        if path.item == (pageCount - 1) {
            // Get the cell corresponding to current index path
            let cell = collectionView.cellForItemAtIndexPath(path) as! NewFeaturesCell
            // Execute animation
            cell.startBtnAnimation()
        }
    }
}

class NewFeaturesCell: UICollectionViewCell {
    var imageIndex: Int? {
        didSet {
            iconView.image = UIImage(named: "new_feature_\(imageIndex! + 1)")
        }
    }
    
    /**
     Set start button's animation
     */
    func startBtnAnimation() {
        startBtn.hidden = false
        
        // Execute animation
        startBtn.transform = CGAffineTransformMakeScale(0.0, 0.0)
        startBtn.userInteractionEnabled = false
        
        UIView.animateWithDuration(2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
            // Clear transformation
            self.startBtn.transform = CGAffineTransformIdentity
            }) { (_) in
                self.startBtn.userInteractionEnabled = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Monitor start button click
     */
    func startBtnClick() {
        NSNotificationCenter.defaultCenter().postNotificationName(TGSwitchRootViewControllerKey, object: true)
    }
    
    private func setUpUI() {
        // Add subviews to content view
        contentView.addSubview(iconView)
        contentView.addSubview(startBtn)
        
        // Set subviews' positions
        iconView.tg_Fill(contentView)
        startBtn.tg_AlignInner(type: TG_AlignType.BottomCenter, referView: contentView, size: nil, offset: CGPoint(x: 0, y: -160))
    }
    
    // MARK: - Lazy loading
    private lazy var iconView = UIImageView()
    private lazy var startBtn: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "new_feature_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "new_feature_button_highlighted"), forState: UIControlState.Highlighted)
        btn.hidden = true
        btn.addTarget(self, action: #selector(startBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
}

private class NewFeaturesLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        // Set layout
        itemSize = UIScreen.mainScreen().bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // Set collection view's properities
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
        collectionView?.pagingEnabled = true
    }
}
