//
//  UIColor+Category.swift
//  TGWeibo
//
//  Created by Theodore Guo on 4/2/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

extension UIColor {
    class func randomColor() -> UIColor {
        return UIColor(red: randomNumber(), green: randomNumber(), blue: randomNumber(), alpha: 1.0)
    }
    
    class func randomNumber() -> CGFloat {
        return CGFloat(arc4random_uniform(256)) / CGFloat(255)
    }
}
