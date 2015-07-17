//
//  Favorite.swift
//  GourmetApp
//
//  Created by 岩瀬　駿 on 2015/07/18.
//  Copyright (c) 2015年 岩瀬　駿. All rights reserved.
//

import Foundation

public class Favorite: Printable {
    
    public var id: Int? = nil
    public var user_id: Int? = nil
    public var post_id: Int? = nil
    public var user: User = User()
    public var post: Post = Post()
    
    public var description: String {
        get {
            var str: String = "\(user_id)\n"
            str += "\(post_id)\n"
            return str
        }
    }
    
}