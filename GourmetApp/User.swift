//
//  User.swift
//  GourmetApp
//
//  Created by 岩瀬　駿 on 2015/07/05.
//  Copyright (c) 2015年 岩瀬　駿. All rights reserved.
//

import Foundation

public class User: Printable {
    
    public var name: String? = nil
    public var screenoName: String? = nil
    public var email: String? = nil
    public var sex: Int? = nil
    public var birthday: Int? = nil
    
    public var description: String {
        get {
            var str: String = "\(name)\n"
            str += "\(screenoName)\n"
            str += "\(email)\n"
            str += "\(sex)\n"
            str += "\(birthday)\n"
            return str
        }
    }
    
}