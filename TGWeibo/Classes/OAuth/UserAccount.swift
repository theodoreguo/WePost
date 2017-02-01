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
    /// User authorization expires date
    var expiresDate: NSDate? {
        didSet {
            // Convert to date based on expires seconds
            expiresDate = NSDate(timeIntervalSinceNow: expires_in!.doubleValue)
        }
    }
    /// Profile
    var avatar_large: String?
    /// Nickname
    var screen_name: String?
    
    override init() {
        
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        print(key)
    }
    
    /// Override CustomStringConvertible protocol's description to print object
    override var description: String {
        // 1. Define properities array
        let properties = ["access_token", "expires_in", "uid", "expiresDate", "avatar_large", "screen_name"]
        
        // 2. Convert to dictionary based on properities array
        let dict = self.dictionaryWithValuesForKeys(properties)
        
        // 3. Convert dictionary to string
        return "\(dict)"
    }
    
    /**
     Load user info
     */
    func loadUserInfo(finished: (account: UserAccount?, error: NSError?) -> ()) {
        assert(access_token != nil, "No authorization")
        
        let path = "2/users/show.json"
        let params = ["access_token": access_token!, "uid": uid!]
        NetworkTools.shareNetworkTools().GET(path, parameters: params, progress: nil, success: { (_, JSON) in
            if let dict = JSON as? [String: AnyObject] {
                self.avatar_large = dict["avatar_large"] as? String
                self.screen_name = dict["screen_name"] as? String
                finished(account: self, error: nil)
                print(JSON)
                return
            }
            
            finished(account: nil, error: nil)
            }) { (_, error) in
                print(error)
                
                finished(account: nil, error: error)
        }
    }
    
    /**
     Get user login status
     */
    class func userLogin() -> Bool {
        return UserAccount.loadAccount() != nil
    }
    
    // MARK: - Save and read
    /**
     Save authorization model
     */
    static let filePath = "account.plist".cacheDir()
    func saveAccount() {
        NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.filePath)
    }
    
    /**
     Load account model
     */
    static var account: UserAccount?
    class func loadAccount() -> UserAccount? {
        // 1. Judge whether account info has been loaded
        if account != nil {
            return account
        }
        
        // 2. Load authorizatino model
        account = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? UserAccount
        
        // 3. Judge authorization info expires or not
        if account?.expiresDate?.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            // Expired
            return nil
        }
        
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
        aCoder.encodeObject(expiresDate, forKey: "expiresDate")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
    }
    
    /**
     Read object from file
     */
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeObjectForKey("expires_in") as? NSNumber
        uid = aDecoder.decodeObjectForKey("uid") as? String
        expiresDate = aDecoder.decodeObjectForKey("expiresDate") as? NSDate
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
    }
}
