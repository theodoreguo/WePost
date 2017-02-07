//
//  EmoticonPackage.swift
//  TGWeibo
//
//  Created by Theodore Guo on 5/2/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

/**
 Structure:
 1. Load emoticons.plist to get each group's emoticon path
    emoticons.plist (dictionary, stored all emoticon groups' data)
    |----packages (dictionary array)
            |----id (stored the file folder of corresponding emoticon group)

 2. Load corresponding emoticon group's info.plist based on the acquired file path
    info.plist (dictionary)
    |----id (the file folder of current emoticon group)
    |----group_name_cn (group name)
    |----emoticons (dictionary array, stored all emoticon data)
            |----chs (words corresponding to each emoticon)
            |----png (picture corresponding to each emoticon)
            |----code (hexadecimal string corresponding to each emoji)
 */
class EmoticonPackage: NSObject {
    /// The file folder of current emoticon group
    var id: String?
    /// Group name
    var group_name_cn : String?
    /// All emoticon objects of current group
    var emoticons: [Emoticon]?
        
    static let packageList:[EmoticonPackage] = EmoticonPackage.loadPackages()
    
    /// Return property string based the string passed into
    class func emoticonString(str: String) -> NSAttributedString? {
        // Generate property string
        let strM = NSMutableAttributedString(string: str)
        do {
            // 1. Create pattern
            let pattern = "\\[.*?\\]"
            
            // 2. Created the object of regular expression
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
            // 3. Start matching
            let res = regex.matchesInString(str, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, str.characters.count))
            // 4. Get result
            var count = res.count
            while count > 0 {
                // 4.1 Start matching from the end
                count -= 1
                let checkingRes = res[count]
                // 4.2 Get the matched emoticon string
                let tempStr = (str as NSString).substringWithRange(checkingRes.range)
                // 4.3 Find target emoticon model based on emoticon string
                if let emoticon = emoticonWithStr(tempStr) {
//                    print(emoticon.chs)
                    // 4.4 Generate property string based the emoticon model
                    let attrStr = EmoticonTextAttachment.imageText(emoticon, font: UIFont.systemFontOfSize(15))
                    // 4.5 Add property string
                    strM.replaceCharactersInRange(checkingRes.range, withAttributedString: attrStr)
                }
            }            
            // Get replaced property string
            return strM
        } catch {
            print(error)
            return nil
        }
    }

    /**
     Find the emoticon model based on corresponding text
     
     - parameter str: emoticon text
     
     - returns: emoticon model
     */
    class func emoticonWithStr(str: String) -> Emoticon? {
        var emoticon: Emoticon?
        for package in EmoticonPackage.packageList {
            emoticon = package.emoticons?.filter({ (e) -> Bool in
                return e.chs == str
            }).last
            
            if emoticon != nil{
                break
            }
        }
        return emoticon
    }
    
    /// Get all groups' emoticon array
    private class func loadPackages() -> [EmoticonPackage] {
        var packages = [EmoticonPackage]()
        // 1. Create the group of "Recent"
        let pk = EmoticonPackage(id: "")
        pk.group_name_cn = "Recent"
        pk.emoticons = [Emoticon]()
        pk.appendEmptyEmoticons()
        packages.append(pk)
        
        let path = NSBundle.mainBundle().pathForResource("emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        // 2. Load emoticons.plist
        let dict = NSDictionary(contentsOfFile: path)!
        // 3. Get packages in emoticons
        let dictArray = dict["packages"] as! [[String:AnyObject]]
        // 4. Traverse packages array
        for d in dictArray {
            // 5. Get ID and create corresponding group
            let package = EmoticonPackage(id: d["id"]! as! String)
            packages.append(package)
            package.loadEmoticons()
            package.appendEmptyEmoticons()
        }
        return packages
    }
    
    /// Load all emoticons of each group
    func loadEmoticons() {
        let emoticonDict = NSDictionary(contentsOfFile: infoPath("info.plist"))!
        group_name_cn = emoticonDict["group_name_cn"] as? String
        let dictArray = emoticonDict["emoticons"] as! [[String: String]]
        emoticons = [Emoticon]()
        var index = 0
        for dict in dictArray {
            if index == 20 {
                emoticons?.append(Emoticon(isRemoveButton: true))
                index = 0
            }
            emoticons?.append(Emoticon(dict: dict, id: id!))
            index += 1
        }
    }
    
    /**
     Append blank buttons (append some blank buttons if there are less than 21 buttons in one page)
     */
    func appendEmptyEmoticons() {
//        print(emoticons?.count)
        let count = emoticons!.count % 21
        
        for _ in count..<20 {
            // Append blank buttons
            emoticons?.append(Emoticon(isRemoveButton: false))
        }
        // Append remove button
        emoticons?.append(Emoticon(isRemoveButton: true))
    }
    
    /**
     Add recent emoticons
    */
    
    func appendEmoticons(emoticon: Emoticon)
    {
        // 1. Judge whether it's remove button
        if emoticon.isRemoveButton {
            return
        }
        // 2. Judge whether current clicked emoticon has been added to Recent
        let contains = emoticons!.contains(emoticon)
        if !contains {
            // Delete the romove button
            emoticons?.removeLast()
            emoticons?.append(emoticon)
        }
        
        // 3. Sort the array
        var result = emoticons?.sort({ (e1, e2) -> Bool in
            return e1.times > e2.times
        })
        
        // 4. Delete repeated emoticon
        if !contains {
            result?.removeLast()
            // Add a romove button
            result?.append(Emoticon(isRemoveButton: true))
        }
        emoticons = result
//        print(emoticons?.count)
    }
    
    /**
     Get designated file's full path
     
     - parameter fileName: file name
     
     - returns: full path
     */
    func infoPath(fileName: String) -> String {
        return (EmoticonPackage.emoticonPath().stringByAppendingPathComponent(id!) as NSString).stringByAppendingPathComponent(fileName)
    }
    
    /**
     Get emoticon's path
     */
    class func emoticonPath() -> NSString {
        return (NSBundle.mainBundle().bundlePath as NSString).stringByAppendingPathComponent("Emoticons.bundle")
    }
    
    init(id: String) {
        self.id = id
    }
}

class Emoticon: NSObject {
    /// Words corresponding to each emoticon
    var chs: String?
    /// Picture corresponding to each emoticon
    var png: String?
        {
        didSet{
            imagePath = (EmoticonPackage.emoticonPath().stringByAppendingPathComponent(id!) as NSString).stringByAppendingPathComponent(png!)
        }
    }
    /// Hexadecimal string corresponding to each emoji
    var code: String? {
        didSet {
            // 1. Get string from hexadecimal number
            // Create a scanner to extract the data from string
            let scanner = NSScanner(string: code!)
            
            // 2. Convert hexadecimal number to string
            var result:UInt32 = 0
            scanner.scanHexInt(&result)
            
            // 3. Convert hexadecimal number to emoji string
            emojiStr = "\(Character(UnicodeScalar(result)))"
        }
    }
    /// String corresponding to emoji
    var emojiStr: String?
    /// The file folder of current emoticon group
    var id: String?
    /// Full path of emoticon pictures表情图片的全路径
    var imagePath: String?
    /// Flag of whether it's remove button
    var isRemoveButton: Bool = false
    /// Stored the used times of current emoticon
    var times: Int = 0
    
    init(isRemoveButton: Bool) {
        super.init()
        self.isRemoveButton = isRemoveButton
    }
    
    init(dict: [String: String], id: String) {
        super.init()
        self.id = id
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
