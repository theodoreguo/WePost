//
//  StatusOriginalTableViewCell.swift
//  TGWeibo
//
//  Created by Theodore Guo on 3/2/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

class StatusOriginalTableViewCell: StatusTableViewCell {
    override func setUpUI() {
        super.setUpUI()
        
        let cons = pictureView.tg_AlignVertical(type: TG_AlignType.BottomLeft, referView: contentLabel, size: CGSizeZero, offset: CGPoint(x: 0, y: 10))
        pictureWidthCons = pictureView.tg_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureHeightCons =  pictureView.tg_Constraint(cons, attribute: NSLayoutAttribute.Height)
    }
}
