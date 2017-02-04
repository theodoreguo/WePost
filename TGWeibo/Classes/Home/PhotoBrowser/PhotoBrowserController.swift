//
//  PhotoBrowserController.swift
//  TGWeibo
//
//  Created by Theodore Guo on 4/2/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit
import SVProgressHUD

private let photoBrowserCellReuseIdentifier = "pictureCell"

class PhotoBrowserController: UIViewController {
    /// Current illustration's index
    var currentIndex: Int = 0
    /// Illustrations' URL array
    var pictureURLs: [NSURL]?
    
    init(index: Int, urls: [NSURL]) {
        super.init(nibName: nil, bundle: nil)
        
        currentIndex = index
        pictureURLs = urls
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set controller view background color as it's transparent by default
        view.backgroundColor = UIColor.whiteColor()
        
        // Initialize UI
        setUpUI()
    }
    
    /**
     Initialize UI
     */
    private func setUpUI() {
        // 1. Add subviews
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        // 2. Lay out subviews
        closeBtn.tg_AlignInner(type: TG_AlignType.BottomLeft, referView: view, size: CGSize(width: 80, height: 35), offset: CGPoint(x: 20, y: -20))
        saveBtn.tg_AlignInner(type: TG_AlignType.BottomRight, referView: view, size: CGSize(width: 80, height: 35), offset: CGPoint(x: -20, y: -20))
        collectionView.frame = UIScreen.mainScreen().bounds
        
        // 3. Register cell
        collectionView.registerClass(PhotoBrowserCell.self, forCellWithReuseIdentifier: photoBrowserCellReuseIdentifier)
        
        // 4. Set data source
        collectionView.dataSource = self
    }
    
    /**
     Close photo browser
     */
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     Save a photo to the album
     */
    func save() {
        // 1. Get displayed cell
        let index = collectionView.indexPathsForVisibleItems().last!
        let cell = collectionView.cellForItemAtIndexPath(index) as! PhotoBrowserCell
        
        // 2. Save picture
        let image = cell.iconView.image
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(completionSelector), nil)
    }
    
    /**
     The optional completionSelector of adding a photo to the saved photos album
     */
    func completionSelector(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error != nil {
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
            SVProgressHUD.showInfoWithStatus("Save Failed")
        } else {
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
            SVProgressHUD.showInfoWithStatus("Save Succeeded")
        }
    }
    
    // MARK: - Lazy loading
    /// Close button
    private lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Close", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn.backgroundColor = UIColor(white: 0.3, alpha: 0.5)
        btn.addTarget(self, action: #selector(close), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    /// Save button
    private lazy var saveBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Save", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn.backgroundColor = UIColor(white: 0.3, alpha: 0.5)
        btn.addTarget(self, action: #selector(save), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    /// Collection view
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: PhotoBrowserLayout())
}

extension PhotoBrowserController: UICollectionViewDataSource, PhotoBrowserCellDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureURLs?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoBrowserCellReuseIdentifier, forIndexPath: indexPath) as! PhotoBrowserCell
//        cell.backgroundColor = UIColor.randomColor()
        cell.imageURL = pictureURLs![indexPath.item]
        cell.photoBrowserCellDelegate = self
        
        return cell
    }
    
    func photoBrowserCellDidClose(cell: PhotoBrowserCell) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

class PhotoBrowserLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        itemSize = UIScreen.mainScreen().bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
    }
}
