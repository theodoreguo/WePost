//
//  UIImage+Category.swift
//  TGWeibo
//
//  Created by Theodore Guo on 6/2/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

extension UIImage {
    /**
     Generate a picture based on the width of the picture passed into (compress the picture based on its original aspect ratio)
     
     - parameter width: designated width
     
     - returns: compressed picture
     */
    func imageWithScale(width: CGFloat) -> UIImage {
        // 1. Calculate height based transmitted picture's original height
        let height = width *  size.height / size.width
        
        // 2. Draw a new picture based on aspect ratio
        let currentSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContext(currentSize)
        drawInRect(CGRect(origin: CGPointZero, size: currentSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}