//
//  RestaurantDetailTableViewCell.swift
//  GourmetApp
//
//  Created by 岩瀬　駿 on 2015/07/13.
//  Copyright (c) 2015年 岩瀬　駿. All rights reserved.
//

import UIKit
import SDWebImage

class RestaurantDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var photoHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
