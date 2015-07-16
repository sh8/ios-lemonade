//
//  TimeLineTableViewCell.swift
//  GourmetApp
//
//  Created by 岩瀬　駿 on 2015/07/06.
//  Copyright (c) 2015年 岩瀬　駿. All rights reserved.
//

import UIKit
import SDWebImage

class TimeLineTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var screenName: UIButton!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var post = Post()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
