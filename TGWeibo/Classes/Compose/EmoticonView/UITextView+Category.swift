//
//  UITextView+Category.swift
//  TGWeibo
//
//  Created by Theodore Guo on 5/2/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

extension UITextView {
    func insertEmoticon(emoticon: Emoticon) {
        // 1. Handle remove button
        if emoticon.isRemoveButton {
            deleteBackward()
        }
        
        // 2. Judge whether current clicked emoticon is emoji
        if emoticon.emojiStr != nil {
            self.replaceRange(self.selectedTextRange!, withText: emoticon.emojiStr!)
        }
        
        // 3. Judge whether current clicked emoticon is picture
        if emoticon.png != nil {
//            print("font = \(font)")
            // 3.1 Create emoticon string
            let imageText = EmoticonTextAttachment.imageText(emoticon, font: font ?? UIFont.systemFontOfSize(17))
            
            // 3.2 Get current content
            let strM = NSMutableAttributedString(attributedString: self.attributedText)
            
            // 3.3 Insert emoticon to the positon of cursor
            let range = self.selectedRange
            strM.replaceCharactersInRange(range, withAttributedString: imageText)
            // Property string has its default size
            strM.addAttribute(NSFontAttributeName, value: font! , range: NSMakeRange(range.location, 1))
            
            // 3.4 Assign replaced string to UITextView
            self.attributedText = strM
            // Resume cursor's postion
            // The first parameter is to designate cursor's postion and the second one is the character count selected
            self.selectedRange = NSMakeRange(range.location + 1, 0)
            
            // 3.5 Tigger textViewDidChange() itself
            delegate?.textViewDidChange!(self)
        }
    }
    
    /**
     Get the string to be posted to the server
    */
    func emoticonAttributedText() -> String {
        var strM = String()
        // Get the data to be posted to the server
        attributedText.enumerateAttributesInRange( NSMakeRange(0, attributedText.length), options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (objc, range, _) -> Void in
            if objc["NSAttachment"] != nil {
                // Picture
                let attachment =  objc["NSAttachment"] as! EmoticonTextAttachment
                strM += attachment.chs!
            } else {
                // Text
                strM += (self.text as NSString).substringWithRange(range)
            }
        }
        return strM
    }
}