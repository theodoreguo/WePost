//
//  EmoticonViewController.swift
//  TGWeibo
//
//  Created by Theodore Guo on 5/2/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//


import UIKit

private let TGEmoticonCellReuseIdentifier = "TGEmoticonCellReuseIdentifier"

class EmoticonViewController: UIViewController {
    /// Closure property ot pass selected emoticon model
    var emoticonDidSelectedCallBack: (emoticon: Emoticon) -> ()
    
    init(callBack: (emoticon: Emoticon)->()) {
        self.emoticonDidSelectedCallBack = callBack
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        // Initialize UI
        setUpUI()
    }
    
    /**
     Initialize UI
    */
    private func setUpUI() {
        // 1. Add subviews
        view.addSubview(collectionVeiw)
        view.addSubview(toolbar)
        
        // 2. Lay out subviews
        collectionVeiw.translatesAutoresizingMaskIntoConstraints = false
        toolbar.translatesAutoresizingMaskIntoConstraints = false

        var cons = [NSLayoutConstraint]()
        let dict = ["collectionVeiw": collectionVeiw, "toolbar": toolbar]
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionVeiw]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[toolbar]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionVeiw]-[toolbar(44)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        
        view.addConstraints(cons)
    }
    
    func itemClick(item: UIBarButtonItem) {
        collectionVeiw.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: item.tag), atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
    }
    
    // MARK: - Lazy loading
    /// Collection view
    private lazy var collectionVeiw: UICollectionView = {
        let clv = UICollectionView(frame: CGRectZero, collectionViewLayout: EmoticonLayout())
        // Register cell
        clv.registerClass(EmoticonCell.self, forCellWithReuseIdentifier: TGEmoticonCellReuseIdentifier)
        clv.backgroundColor = UIColor.whiteColor()
        clv.dataSource = self
        clv.delegate = self
        return clv
    }()
    /// Toolbar
    private lazy var toolbar: UIToolbar = {
       let bar = UIToolbar()
        bar.tintColor = UIColor.darkGrayColor()
        var items = [UIBarButtonItem]()
        
        var index = 0
        for title in ["Recent", "Default", "Emoji", "Huahua"] {
            let item = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EmoticonViewController.itemClick(_:)))
            item.tag = index
            index += 1
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        bar.items = items
        return bar
    }()
    /// Packages
    private lazy var packages: [EmoticonPackage] = EmoticonPackage.packageList
}

extension EmoticonViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // Inform system of the group count
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return packages.count
    }
    // Inform system of the line count of each group
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons?.count ?? 0
    }
    // Inform system of the content of each line
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionVeiw.dequeueReusableCellWithReuseIdentifier(TGEmoticonCellReuseIdentifier, forIndexPath: indexPath) as! EmoticonCell
//        cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor.redColor() : UIColor.greenColor()
        cell.backgroundColor = UIColor.whiteColor()
        
        // 1. Get corresponding group
        let package = packages[indexPath.section]
        // 2. Get corresponding line's model
        let emoticon = package.emoticons![indexPath.item]
        // 3. Assign value to cell
        cell.emoticon = emoticon
        
        return cell
    }
    
    // Actions when a cell is selected
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // 1. Handle recent emoticon: add current clicked emoticon to Recent array
        let emoticon = packages[indexPath.section].emoticons![indexPath.item]
        emoticon.times += 1
        packages[0].appendEmoticons(emoticon)
//        collectionView.reloadSections(NSIndexSet(index: 0))
        
        // 2. Callback to inform which emoticon is being clicked
        emoticonDidSelectedCallBack(emoticon: emoticon)
    }
}

class EmoticonCell: UICollectionViewCell {
    var emoticon: Emoticon? {
        didSet {
            // 1. Judge whether it's emoticon
            if emoticon!.chs != nil {
                iconButton.setImage(UIImage(contentsOfFile: emoticon!.imagePath!), forState: UIControlState.Normal)
            } else {
                // Avoid reuse
                iconButton.setImage(nil, forState: UIControlState.Normal)
            }
            
            // 2. Set emoji
            // Note: add ?? to avoid reuse
            iconButton.setTitle(emoticon!.emojiStr ?? "", forState: UIControlState.Normal)
            
            // 3. Judge whether it's remove button
            if emoticon!.isRemoveButton {
                iconButton.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
                iconButton.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: UIControlState.Highlighted)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Initialize UI
        setUpUI()
    }
    
    /**
     Initialize UI
    */
    private func setUpUI() {
        contentView.addSubview(iconButton)
        iconButton.backgroundColor = UIColor.whiteColor()
        iconButton.frame = CGRectInset(contentView.bounds, 4, 4)
        iconButton.userInteractionEnabled = false
    }

    // MARK: - Lazy loading
    /// Icon button
    private lazy var iconButton: UIButton = {
       let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFontOfSize(32)
        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// Custom layout
class EmoticonLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        // 1. Set cell's properties
        let width = collectionView!.bounds.width / 7
        itemSize = CGSize(width: width, height: width)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        // 2. Set colletion view's properties
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        
        let y = (collectionView!.bounds.height - 3 * width) * 0.45
        collectionView?.contentInset = UIEdgeInsets(top: y, left: 0, bottom: y, right: 0)        
    }
}
