//
//  Post2.swift
//  GourmetApp
//
//  Created by 岩瀬　駿 on 2015/06/25.
//  Copyright (c) 2015年 岩瀬　駿. All rights reserved.
//

import Foundation

public class Post: Printable {

    public var photoName: String? = nil
    public var restaurantId: Int? = nil
    
    public var description: String {
        get {
            var str: String = "\(restaurantId)"
            return str
        }
    }
    
}