//
//  Status.swift
//  TGWeibo
//
//  Created by Theodore Guo on 1/2/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit
import SDWebImage

class Status: NSObject {
    /// Weibo posted time
    var created_at: String? {
        didSet {
            // created_at = "Sun Sep 12 14:50:57 +0800 2014"
            // 1. Convert string to date
            let createdDate = NSDate.dateWithStr(created_at!)
            // 2. Get formatted date string
            created_at = createdDate.descDate
        }
    }
    /// Weibo ID
    var id: Int = 0
    /// Weibo text content
    var text: String?
    /// Weibo source
    var source: String? {
        didSet {
            // 1. Get substring
            if let str = source {
                if str == ""
                {
                    return
                }
                
                // 1.1 Get substring beginning location
                let startLocation = (str as NSString).rangeOfString(">").location + 1
                // 1.2 Get substring length
                let length = (str as NSString).rangeOfString("<", options: NSStringCompareOptions.BackwardsSearch).location - startLocation
                // 1.3 Get substring
                source = "from " + (str as NSString).substringWithRange(NSMakeRange(startLocation, length))
            }
        }
    }
    /// Weibo illustrations array
    var pic_urls: [[String: AnyObject]]? {
        didSet {
            // 1. Initialize array
            storedPicURLS = [NSURL]()
            storedLargePicURLS = [NSURL]()
            // 2. Traverse to get all illustrations' path string
            for dict in pic_urls! {
                if let urlStr = dict["thumbnail_pic"] as? String {
                    // 1. Convert string to URL and save to array
                    storedPicURLS?.append(NSURL(string: urlStr)!)
                    
                    // 2. Handle large illustrations
                    let largeURLStr = urlStr.stringByReplacingOccurrencesOfString("thumbnail", withString: "large")
                    storedLargePicURLS?.append(NSURL(string: largeURLStr)!)
                }
            }
        }
    }
    /// Store Weibo illustrations' URLs
    var storedPicURLS: [NSURL]?
    /// Store Weibo large illustrations' URLs
    var storedLargePicURLS: [NSURL]?
    /// User info
    var user: User?
    /// Reposted Weibo
    var retweeted_status: Status?
    /// Return original or reposted Weibo illustrations' URL array (when reposting Weibo, original Weibo has no illustrations)
    var pictureURLS: [NSURL]? {
        return retweeted_status != nil ? retweeted_status?.storedPicURLS : storedPicURLS
    }
    /// Return original or reposted Weibo large illustrations' URL array
    var largePictureURLS: [NSURL]? {
        return retweeted_status != nil ? retweeted_status?.storedLargePicURLS : storedLargePicURLS
    }
    
    // Convert dictionary to model
    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    // setValuesForKeysWithDictionary() will call below method internally
    override func setValue(value: AnyObject?, forKey key: String) {
        // 1. Judge whether user dictionary belonging to Weibo dictionary is being assigned data currently
        if "user" == key {
            // Create a model based on the dictionary corresponding to current user key 
            user = User(dict: value as! [String: AnyObject])
            return
        }
        
        // 2. Judge whether reposted Weibo is being assigned data currently
        if "retweeted_status" == key {
            // Convert to model based on the dictionary corresponding to current retweeted_status key
            retweeted_status = Status(dict: value as! [String: AnyObject])
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    /// Print current model data
    var properties = ["created_at", "id", "text", "source", "pic_urls"]
    override var description: String {
        let dict = dictionaryWithValuesForKeys(properties)
        return "\(dict)"
    }
    
    /**
     Load Weibo data
     */
    class func loadStatuses(since_id: Int, max_id: Int, finished: (models: [Status]?, error: NSError?) -> ()) {
        let path = "2/statuses/home_timeline.json"
        var params = ["access_token": UserAccount.loadAccount()!.access_token!]
        
        // Pull-down refresh
        if since_id > 0 {
            params["since_id"] = "\(since_id)"
        }
        
        // Pull-up refresh
        if max_id > 0 {
            params["max_id"] = "\(max_id - 1)"
        }
        
        // 1. Get the array storing dictionary corresponding to statuses key
        NetworkTools.shareNetworkTools().GET(path, parameters: params, progress: nil, success: { (_, JSON) in
            // 2. Traverse array and convert dictionary to model
            let models = dictToModel(JSON!["statuses"] as! [[String: AnyObject]])
            
            // 3. Buffer illustrations
            bufferStatusImages(models, finished: finished)
            }) { (_, error) in
                print(error)
                finished(models: nil, error: error)
        }
    }
    
    /**
     Buffer illustrations
     */
    class func bufferStatusImages(list: [Status], finished: (models:[Status]?, error:NSError?) -> ()) {
        if list.count == 0 {
            finished(models: list, error: nil)
            return
        }
        
        // 1. Create an array
        let group = dispatch_group_create()

        // 2. Buffer illustrations
        for status in list {
            guard status.pictureURLS != nil else {
                continue
            }
            for url in status.pictureURLS! {
                // Add download opration to the group
                dispatch_group_enter(group)
                
                // Download images
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (_, _, _, _, _) -> Void in
                    // Leave current group
                    dispatch_group_leave(group)
                })
            }
        }
        
        // 3. Transmit data to caller using closure when all illustrations are downloaded
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            // Coming here means all illustrations have been downloaded
            finished(models: list, error: nil)
        }
    }
    
    /**
     Convert dictionary array to model array
     */
    class func dictToModel(list: [[String: AnyObject]]) -> [Status] {
        var models = [Status]()
        for dict in list {
            models.append(Status(dict: dict))
        }
        return models
    }
}
