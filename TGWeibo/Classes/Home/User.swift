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
    var profile_image_url: String? {
        didSet {
            if let urlStr = profile_image_url {
                imageURL = NSURL(string: urlStr)
            }
        }
    }
    /// Store user profile's URL
    var imageURL: NSURL?
    /// Weibo verification
    var verified: Bool = false
    /// Verification type (-1: unverified; 0: veirfied user; 2, 3, 5: verified enterprise; 220: expert)
    var verified_type: Int = -1 {
        didSet {
            switch verified_type {
            case 0:
                verifiedImage = UIImage(named: "avatar_vip")
            case 2, 3, 5:
                verifiedImage = UIImage(named: "avatar_enterprise_vip")
            case 220:
                verifiedImage = UIImage(named: "avatar_grassroot")
            default:
                verifiedImage = nil
            }
        }
    }
    /// Store user's verification logo
    var verifiedImage: UIImage?
    /// Membership rank
    var mbrank: Int = 0 {
        didSet {
            if mbrank > 0 && mbrank < 7 {
                mbrankImage = UIImage(named: "common_icon_membership_level\(mbrank)")
            }
        }
    }
    /// Store membership rank image
    var mbrankImage: UIImage?
    
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
