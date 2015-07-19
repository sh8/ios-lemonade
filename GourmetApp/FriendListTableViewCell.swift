//
//  FriendListTableViewCell.swift
//  GourmetApp
//
//  Created by 岩瀬　駿 on 2015/07/19.
//  Copyright (c) 2015年 岩瀬　駿. All rights reserved.
//

import UIKit

class FriendListTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var screenName: UILabel!
    
    var user: User = User() {
        didSet {
            name.text = user.name
            screenName.text = user.screenoName
            if let profilePhoto = user.profilePhoto {
                self.profilePhoto.sd_setImageWithURL(NSURL(string: profilePhoto))
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
