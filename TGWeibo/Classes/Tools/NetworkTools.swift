//
//  NetworkTools.swift
//  TGWeibo
//
//  Created by Theodore Guo on 29/1/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit
import AFNetworking

class NetworkTools: AFHTTPSessionManager {
    static let tools: NetworkTools = {
        let url = NSURL(string: "https://api.weibo.com/")
        let t = NetworkTools(baseURL: url)
        t.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as? Set<String>
        return t
    }()
    
    /**
     Get singleton
     */
    class func shareNetworkTools() -> NetworkTools {
        return tools
    }
}
