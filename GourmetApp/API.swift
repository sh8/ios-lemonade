//
//  API.swift
//  GourmetApp
//
//  Created by 岩瀬　駿 on 2015/06/23.
//  Copyright (c) 2015年 岩瀬　駿. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON

public class API {
    // APIのベースURL.Development限定
    var api_url = "http://160.16.97.128:3000/api/v1/"
    
    public class var sharedInstance: API? {
        struct Static {
            static let instance = API()
        }
        return Static.instance
    }
    
    // パラメタなしのイニシャライザ
    private init(){}
    
    // AlamofireをAPIクラスのrequestメソッドでラップした.
    func request(method: Alamofire.Method, url: String, params: [String: AnyObject], completion: (NSURLRequest, NSHTTPURLResponse?, JSON, NSError?) -> Void) -> Void {
        var request_url = api_url + url
        
        Alamofire.request(method, request_url, parameters: params).responseSwiftyJSON({
            (request, response, json, error) -> Void in
                completion(request, response, json, error)
            }
        )
    }
}