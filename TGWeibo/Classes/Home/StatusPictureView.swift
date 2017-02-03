//
//  StatusPictureView.swift
//  TGWeibo
//
//  Created by Theodore Guo on 3/2/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit
import SDWebImage

class StatusPictureView: UICollectionView {
    var status: Statuses? {
        didSet {
            // Refresh data
            reloadData()
        }
    }
    
    /// Illustration layout
    private var pictureLayout: UICollectionViewFlowLayout =  UICollectionViewFlowLayout()
    
    init() {
        super.init(frame: CGRectZero, collectionViewLayout: pictureLayout)
        
        // Initialize illustrations
        // 1. Register cell
        registerClass(PictureViewCell.self, forCellWithReuseIdentifier: TGPictureViewCellReuseIdentifier)
        
        // 2. Set data source
        dataSource = self
        
        // 3. Set space between cells
        pictureLayout.minimumInteritemSpacing = 10
        pictureLayout.minimumLineSpacing = 10
        
        // 4. Set background color
        backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Calculate illustrations' size
     */
    func calculateImageSize() -> CGSize {
        // 1. Get illustration count
        let count = status?.storedPicURLS?.count
        
        // 2. Return zero if no illustration
        if count == 0 || count == nil {
            return CGSizeZero
        }
        
        // 3. Return real size if only one illustration
        if count == 1 {
            // 3.1 Get buffered illustrations
            let key = status?.storedPicURLS!.first?.absoluteString
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key!)
            pictureLayout.itemSize = image.size
            // 3.2 Return buffered illustrations' size
            return image.size
        }
        
        // 4. Calculate four block box size if there are 4 illustrations
        let width = 90
        let margin = 10
        pictureLayout.itemSize = CGSize(width: width, height: width)
        if count == 4 {
            let viewWidth = width * 2 + margin
            return CGSize(width: viewWidth, height: viewWidth)
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
        return CGSize(width: viewWidth, height: viewHeight)
    }
}

extension StatusPictureView: UICollectionViewDataSource {
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

private class PictureViewCell: UICollectionViewCell {
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
