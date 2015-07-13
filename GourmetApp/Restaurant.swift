//
//  Restaurant.swift
//  GourmetApp
//
//  Created by 岩瀬　駿 on 2015/06/23.
//  Copyright (c) 2015年 岩瀬　駿. All rights reserved.
//

import Foundation

public class Restaurant: Printable {
    public var id: Int? = nil
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
    public var posts = [Post]()

    public var description: String {
        get {
            var string = "\nName: \(name)\n"
            string += "Lat: \(lat)\n"
            string += "Lon: \(lon)\n"
            string += "address: \(address)\n"
            return string
        }
    }
}
