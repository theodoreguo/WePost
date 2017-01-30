//
//  UserAccount.swift
//  TGWeibo
//
//  Created by Theodore Guo on 29/1/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {
    /// API authorized access token
    var access_token: String?
    /// access token's lifecycle
    var expires_in: NSNumber?
    /// Current authorized user's ID
    var uid: String?
    
    init(dict: [String: AnyObject]) {
        access_token = dict["access_token"] as? String
        expires_in = dict["expires_in"] as? NSNumber
        uid = dict["uid"] as? String
    }
    
    /// Override CustomStringConvertible protocol's description to print object
    override var description: String {
        // 1. Define properities array
        let properties = ["access_token", "expires_in", "uid"]
        
        // 2. Convert to dictionary based on properities array
        let dict = self.dictionaryWithValuesForKeys(properties)
        
        // 3. Convert dictionary to string
        return "\(dict)"
    }
    
    // MARK: - Save and read
    /**
     Save authorization model
     */
    func saveAccount() {
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
        let filePath = (path as NSString).stringByAppendingPathComponent("account.plist")
        print("filePath:\(filePath)")
        NSKeyedArchiver.archiveRootObject(self, toFile: filePath)
    }
    
    /**
     Load account model
     */
    class func loadAccount() -> UserAccount? {
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
        let filePath = (path as NSString).stringByAppendingPathComponent("account.plist")
        print("filePath:\(filePath)")
        
        let account = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? UserAccount
        return account
    }
    
    // MARK: - NSCoding
    /**
     Write object to file
     */
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
    }
    
    /**
     Read object from file
     */
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeObjectForKey("expires_in") as? NSNumber
        uid = aDecoder.decodeObjectForKey("uid") as? String
    }
}
