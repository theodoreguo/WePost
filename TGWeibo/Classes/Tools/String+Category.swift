//
//  String+Category.swift
//  TGWeibo
//
//  Created by Theodore Guo on 30/1/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

extension String {
    /**
     Append current string to cache directory
     */
    func cacheDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! as NSString
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
    }
    
    /**
     Append current string to document directory
     */
    func docDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! as NSString
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
    }
    
    /**
     Append current string to tmp directory
     */
    func tmpDir() -> String {
        let path = NSTemporaryDirectory() as NSString
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
    }
}
