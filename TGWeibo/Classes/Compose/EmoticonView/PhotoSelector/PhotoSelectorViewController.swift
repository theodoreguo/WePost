//
//  PhotoSelectorViewController.swift
//  TGWeibo
//
//  Created by Theodore Guo on 6/2/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

private let TGPhotoSelectorCellReuseIdentifier = "TGPhotoSelectorCellReuseIdentifier"

class PhotoSelectorViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize UI
        setUpUI()
    }
    
    /**
     Initialize UI
     */
    private func setUpUI() {
        // 1. Add subviews
        view.addSubview(collcetionView)
        
        // 2. Lay out subviews
        collcetionView.translatesAutoresizingMaskIntoConstraints = false
        var cons = [NSLayoutConstraint]()
        
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collcetionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collcetionView": collcetionView])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collcetionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collcetionView": collcetionView])
        view.addConstraints(cons)
        
    }
    
    // MARK: - Lazy laoding
    /// Collection view
    private lazy var collcetionView: UICollectionView = {
       let clv = UICollectionView(frame: CGRectZero, collectionViewLayout: PhotoSelectorViewLayout())
        clv.registerClass(PhotoSelectorCell.self, forCellWithReuseIdentifier: TGPhotoSelectorCellReuseIdentifier)
        clv.backgroundColor = UIColor.lightGrayColor()
        clv.dataSource = self
        return clv
    }()
    /// Store pictures in photo selector
    lazy var pictureImages = [UIImage]()

}

extension PhotoSelectorViewController: UICollectionViewDataSource, PhotoSelectorCellDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureImages.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collcetionView.dequeueReusableCellWithReuseIdentifier(TGPhotoSelectorCellReuseIdentifier, forIndexPath: indexPath) as! PhotoSelectorCell
        
        cell.PhotoCellDelegate = self
        cell.backgroundColor = UIColor.orangeColor()

        cell.image = (pictureImages.count == indexPath.item) ? nil : pictureImages[indexPath.item] // 0  1
//        print(pictureImages.count)
//        print(indexPath.item)
        
        return cell
    }
    
    func photoDidAddSelector(cell: PhotoSelectorCell) {
        // 1. Judge whether it's able to access the photo library
        // case PhotoLibrary
        // case SavedPhotosAlbum
        // case Camera
        if !UIImagePickerController.isSourceTypeAvailable( UIImagePickerControllerSourceType.PhotoLibrary) {
            return
        }
        
        // 2. Create photo selector
        let vc = UIImagePickerController()
        vc.delegate = self
        presentViewController(vc, animated: true, completion: nil)
    }
    
    /**
     Actions when a photo is selected
     
     - parameter picker:      controller triggering the event
     - parameter image:       current selected photo
     - parameter editingInfo: editing info
     */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
//        print(image)
//        print(editingInfo)

        let newImage = image.imageWithScale(300)
//        let data2 = UIImageJPEGRepresentation(newImage, 1.0)
//        data2?.writeToFile("/Users/xiaomage/Desktop/2.jpg", atomically: true)
        
        // Add current selected photo to array
        pictureImages.append(newImage)
        collcetionView.reloadData()
        
        // Note: dismiss photo selector if below method is implemented
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func photoDidRemoveSelector(cell: PhotoSelectorCell) {
        // 1. Remove current clicked photo from the array
        let indexPath = collcetionView.indexPathForCell(cell)
        pictureImages.removeAtIndex(indexPath!.item)
        // 2. Refresh data
        collcetionView.reloadData()
    }
}

@objc protocol PhotoSelectorCellDelegate : NSObjectProtocol {
    optional func photoDidAddSelector(cell: PhotoSelectorCell)
    optional func photoDidRemoveSelector(cell: PhotoSelectorCell)
}

class PhotoSelectorCell: UICollectionViewCell {
    weak var PhotoCellDelegate: PhotoSelectorCellDelegate?
    var image: UIImage? {
        didSet {
            if image != nil {
                removeButton.hidden = false
                addButton.setBackgroundImage(image!, forState: UIControlState.Normal)
                addButton.userInteractionEnabled = false
            } else {
                removeButton.hidden = true
                addButton.userInteractionEnabled = true
                addButton.setBackgroundImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
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
        // 1. Add subviews
        contentView.addSubview(addButton)
        contentView.addSubview(removeButton)
        
        // 2. Lay out subviews
        addButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        var cons = [NSLayoutConstraint]()
         cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[addButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["addButton": addButton])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[addButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["addButton": addButton])
        
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:[removeButton]-2-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["removeButton": removeButton])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-2-[removeButton]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["removeButton": removeButton])
        
        contentView.addConstraints(cons)
    }
    
    // MARK: - Lazy loading
    /// Remove button
    private lazy var removeButton: UIButton = {
        let btn = UIButton()
        btn.hidden = true
        btn.setBackgroundImage(UIImage(named: "compose_photo_close"), forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(PhotoSelectorCell.removeBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    /// Add button
    private lazy  var addButton: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        btn.setBackgroundImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(PhotoSelectorCell.addBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    func addBtnClick() {
        PhotoCellDelegate?.photoDidAddSelector!(self)
    }
    
    func removeBtnClick() {
        PhotoCellDelegate?.photoDidRemoveSelector!(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PhotoSelectorViewLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        
        itemSize = CGSize(width: 80, height: 80)
        minimumInteritemSpacing  = 10
        minimumLineSpacing = 10
        sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
    }
}
