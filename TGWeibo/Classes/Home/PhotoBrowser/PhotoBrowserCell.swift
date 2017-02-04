//
//  PhotoBrowserCell.swift
//  TGWeibo
//
//  Created by Theodore Guo on 4/2/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoBrowserCellDelegate: NSObjectProtocol {
    func photoBrowserCellDidClose(cell: PhotoBrowserCell)
}

class PhotoBrowserCell: UICollectionViewCell {
    /// Photo browser cell delegate
    weak var photoBrowserCellDelegate: PhotoBrowserCellDelegate?
    /// Picture URL
    var imageURL: NSURL? {
        didSet {
            // Reset properties
            reset()
            
            // 2. Set picture
            iconView.sd_setImageWithURL(imageURL) { (image, _, _, _) -> Void in
                // 3. Set picture display position
                self.setImageViewPostion()
            }
        }
    }
    
    /**
     Modify picture display position
     */
    private func setImageViewPostion() {
        // 1. Get the picture's size tuned based on aspect ratio
        let size = self.displaySize(iconView.image!)
        
        // 2. Judge the height of the picture exceeds the screen's height or not
        if size.height < UIScreen.mainScreen().bounds.height {
            // 2.1 < screen's height -> set padding to be displayed in center
            iconView.frame = CGRect(origin: CGPointZero, size: size)
            // Set picture displayed in center
            let y = (UIScreen.mainScreen().bounds.height - size.height) * 0.5
            self.scrollView.contentInset = UIEdgeInsets(top: y, left: 0, bottom: y, right: 0)
        } else {
            // 2.2 > screen's height -> y = 0, set scroll range as the picture's size
            iconView.frame = CGRect(origin: CGPointZero, size: size)
            scrollView.contentSize = size
        }
    }
    
    /**
     Set picture display size
     */
    private func displaySize(image: UIImage?) -> CGSize {
        if image == nil {
            return CGSizeZero
        }
        
        // 1. Get picture's aspect ratio
        let scale = image!.size.height / image!.size.width
        
        // 2. Calculate picture height based on its aspect ratio
        let width = UIScreen.mainScreen().bounds.width
        let height =  width * scale
        
        return CGSize(width: width, height: height)
    }
    
    /**
     Reset the properties of scroll view and image view
     */
    private func reset() {
        // Reset scroll view
        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.contentOffset = CGPointZero
        scrollView.contentSize = CGSizeZero
        
        // Reset image view
        iconView.transform = CGAffineTransformIdentity
    }
    
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
        // 1. Add subviews
        contentView.addSubview(scrollView)
        scrollView.addSubview(iconView)
        
        // 2. Lay out subviews
        scrollView.frame = UIScreen.mainScreen().bounds
        
        // 3. Handle zooming
        scrollView.delegate = self
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 0.5
        
        // 4. Monitor picture's click event
        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
        iconView.addGestureRecognizer(tap)
        iconView.userInteractionEnabled = true
    }
    
    /**
     Close photo browser
     */
    func close() {
        photoBrowserCellDelegate?.photoBrowserCellDidClose(self)
    }
    
    // MARK: - Lazy loading
    /// Scroll view
    private lazy var scrollView: UIScrollView = UIScrollView()
    /// Icon view
    lazy var iconView: UIImageView = UIImageView()
}

extension PhotoBrowserCell: UIScrollViewDelegate {
    // Inform system the view to be zoomed
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return iconView
    }
    
    // Modify picture's positon
    // view: zoomed view
    // Note: Zooming is to modify transform and will only affect frame instead of bounds
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
//        print("scrollViewDidEndZooming")
        
//        print(view?.bounds)
//        print(view?.frame)
        
        var offsetX = (UIScreen.mainScreen().bounds.width - view!.frame.width) * 0.5
        var offsetY = (UIScreen.mainScreen().bounds.height - view!.frame.height) * 0.5
//        print("offsetX = \(offsetX), offsetY = \(offsetY)")
        offsetX = offsetX < 0 ? 0 : offsetX
        offsetY = offsetY < 0 ? 0 : offsetY
        
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
    }
}
