//
//  Restaurant.swift
//  GourmetApp
//
//  Created by 岩瀬　駿 on 2015/06/23.
//  Copyright (c) 2015年 岩瀬　駿. All rights reserved.
//

import Foundation

public class Restaurant: Printable {
    public var name: String? = nil
    public var ruby: String? = nil
    public var lat: Double? = nil
    public var lon: Double? = nil
    public var genre: String? = nil
    public var date: NSDate? = nil
    public var address: String? = nil
    public var tel: String? = nil
    public var remarks: String? = nil
    public var country: String? = nil
    public var city: String? = nil
    public var state: String? = nil
    public var cc: String? = nil

    public var description: String {
        get {
            var string = "\nName: \(name)\n"
            return string
        }
    }
    
    public class func search(#lat: Double, lon: Double) -> [Restaurant]{
        var restaurants: [Restaurant] = [Restaurant]()
        API.request(.GET, url: "restaurants/search", params: ["lat": lat, "lon": lon],
            completion: {
                (request, response, json, error) -> Void in
                // TODO: 下記にjson取得終了時に行いたい処理を書く
                println(json)
                
        })
        return [Restaurant]()
    }
}
