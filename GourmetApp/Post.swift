//
//  Post2.swift
//  GourmetApp
//
//  Created by 岩瀬　駿 on 2015/06/25.
//  Copyright (c) 2015年 岩瀬　駿. All rights reserved.
//

import Foundation

public class Post: Printable {

    public var id: Int? = nil
    public var photoName: String? = nil
    public var isFavorite: Bool? = nil
    public var user: User = User()
    public var restaurant: Restaurant  = Restaurant()
    
    public var description: String {
        get {
            var str: String = "\(user)\n"
            return str
        }
    }
    
}