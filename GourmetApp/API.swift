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
    static let api_url = "http://160.16.97.128:3000/api/v1/"
    static let APILoadStartNotification = "APILoadStartNotification"
    static let APILoadCompleteNotification = "APILoadCompleteNotification"
    static let APIUploadCompleteNotification = "APIUploadCompleteNotification"
    
    // パラメタなしのイニシャライザ
    private init(){}
    
    // AlamofireをAPIクラスのrequestメソッドでラップした.
    class func request(method: Alamofire.Method, url: String, params: [String: AnyObject], completion: (NSURLRequest, NSHTTPURLResponse?, JSON, NSError?) -> Void) -> Void {
        var request_url = api_url + url
        
        Alamofire.request(method, request_url, parameters: params).responseSwiftyJSON({
            (request, response, json, error) -> Void in
                completion(request, response, json, error)
                NSNotificationCenter.defaultCenter().postNotificationName(self.APILoadCompleteNotification, object: nil)
            }
        )
    }
    
    class func upload(url: String, params: [String: String], data: NSData, completion: (NSURLRequest, NSHTTPURLResponse?, JSON, NSError?) -> Void) -> Void {
        var request_url = api_url + url
        let urlRequest = urlRequestWithComponents(request_url, parameters: params, imageData: data)
        Alamofire.upload(urlRequest.0, urlRequest.1).responseSwiftyJSON({
            (request, response, json, error) -> Void in
            completion(request, response, json, error)
            NSNotificationCenter.defaultCenter().postNotificationName(self.APIUploadCompleteNotification, object: nil)
            }
        )
    }
    
    // this function creates the required URLRequestConvertible and NSData we need to use Alamofire.upload
    class func urlRequestWithComponents(urlString:String, parameters:[String: String], imageData:NSData) -> (URLRequestConvertible, NSData) {
        
        // create url request to send
        var mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        // let boundaryConstant = "myRandomBoundary12345";
        let boundaryConstant = "NET-POST-boundary-\(arc4random())-\(arc4random())"
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        
        
        // create upload data to send
        let uploadData = NSMutableData()
        
        // add image
        uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Disposition: form-data; name=\"file\"; filename=\"file.png\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData(imageData)
        
        // add parameters
        for (key, value) in parameters {
            uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        
        
        // return URLRequestConvertible and NSData
        return (Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
    }
}