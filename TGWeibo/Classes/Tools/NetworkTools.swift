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
    
    /**
     Post Weibo
     
     :param: text            text to be posted
     :param: image           pictures to be posted
     :param: successCallback callback when it succeeds
     :param: errorCallback   callback when it fails
     */
    func sendStatus(text: String, image: UIImage?, successCallback: (status: Status) -> (), errorCallback: (error: NSError) -> ()) {
        var path = "2/statuses/"
        let params = ["access_token":UserAccount.loadAccount()!.access_token! , "status": text]
        if image != nil { // Send Weibo with pictures
            path += "upload.json"
            POST(path, parameters: params, constructingBodyWithBlock: { (formData) -> Void in
                // 1. Convert data to binary type
                let data = UIImagePNGRepresentation(image!)!
                
                // 2. Upload data
                // data: binary data to be uploaded
                // name: corresponding field at server
                // fileName: file name (not important)
                // mimeType: data type (if not sure, use general types: application/octet-stream)
                formData.appendPartWithFileData(data
                    , name:"pic", fileName:"abc.png", mimeType:"application/octet-stream")
                }, progress: nil, success: { (_, JSON) -> Void in
                    successCallback(status: Status(dict: JSON as! [String : AnyObject]))
                }, failure: { (_, error) -> Void in
                    errorCallback(error: error)
            })
        } else { // Send text Weibo
            path += "update.json"
            POST(path, parameters: params, progress: nil, success: { (_, JSON) -> Void in
                successCallback(status: Status(dict: JSON as! [String : AnyObject]))
            }) { (_, error) -> Void in
                errorCallback(error: error)
            }
        }        
    }
}
