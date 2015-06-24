//
//  SelectRestaurantTableViewCell.swift
//  GourmetApp
//
//  Created by 岩瀬　駿 on 2015/06/24.
//  Copyright (c) 2015年 岩瀬　駿. All rights reserved.
//

import UIKit

class SelectRestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var restaurantName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var restaurant: Restaurant = Restaurant() {
        didSet {
            // 店舗名を表示
            restaurantName.text = restaurant.name
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
