//
//  UIButton+Category.swift
//  TGWeibo
//
//  Created by Theodore Guo on 2/2/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

extension UIButton {
    class func createButton(imageName: String, title: String) -> UIButton {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setTitle(title, forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(14)
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return btn
    }
}
