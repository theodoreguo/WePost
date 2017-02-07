//
//  EmoticonTextAttachment.swift
//  TGWeibo
//
//  Created by Theodore Guo on 5/2/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

class EmoticonTextAttachment: NSTextAttachment {
    // Store corresponding emoticon text
    var chs: String?
    
    /// Create emoticon string based on corresponding emoticon model
    class func imageText(emoticon: Emoticon, font: UIFont) -> NSAttributedString {
        // 1. Create attachment
        let attachment = EmoticonTextAttachment()
        attachment.chs = emoticon.chs
        attachment.image = UIImage(contentsOfFile: emoticon.imagePath!)
        // Set attachment size
        let s = font.lineHeight
        attachment.bounds = CGRectMake(0, -4, s, s)
        
        // 2. Create property string based on corresponding attachment
        return NSAttributedString(attachment: attachment)
    }
}
