//
//  User.swift
//  TGWeibo
//
//  Created by Theodore Guo on 2/2/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

class User: NSObject {
    /// User ID
    var id: Int = 0
    /// Username
    var name: String?
    /// Profile
    var profile_image_url: String?
    /// Weibo verification
    var verified: Bool = false
    /// Verification type (-1: unverified; 0: veirfied user; 2, 3, 5: verified enterprise; 220: expert)
    var verified_type: Int = -1
    
    // Convert dictionary to model
    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    /// Print current model data
    var properties = ["id", "name", "profile_image_url", "verified", "verified_type"]
    override var description: String {
        let dict = dictionaryWithValuesForKeys(properties)
        return "\(dict)"
    }
}
