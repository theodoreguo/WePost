//
//  Statuses.swift
//  TGWeibo
//
//  Created by Theodore Guo on 1/2/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

class Statuses: NSObject {
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
    /// Weibo illustrations
    var pic_urls: [[String: AnyObject]]?
    /// User info
    var user: User?
    
    // Convert dictionary to model
    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    // setValuesForKeysWithDictionary() will call below method internally
    override func setValue(value: AnyObject?, forKey key: String) {
        // Judge whether user dictionary belonging to Weibo dictionary is being assigned data currently
        if "user" == key {
            // Create a model based on the dictionary corresponding to current user key 
            user = User(dict: value as! [String: AnyObject])
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
    class func loadStatuses(finished: (models: [Statuses]?, error: NSError?) -> ()) {
        let path = "2/statuses/home_timeline.json"
        let params = ["access_token": UserAccount.loadAccount()!.access_token!]
        
        NetworkTools.shareNetworkTools().GET(path, parameters: params, progress: nil, success: { (_, JSON) in
            let models = dictToModel(JSON!["statuses"] as! [[String: AnyObject]])
            finished(models: models, error: nil)
            }) { (_, error) in
                print(error)
                finished(models: nil, error: error)
        }
    }
    
    /**
     Convert dictionary array to model array
     */
    class func dictToModel(list: [[String: AnyObject]]) -> [Statuses] {
        var models = [Statuses]()
        for dict in list {
            models.append(Statuses(dict: dict))
        }
        return models
    }
}
