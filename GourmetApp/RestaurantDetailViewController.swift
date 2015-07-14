//  RestaurantDetailViewController.swift
//  GourmetApp
//
//  Created by 岩瀬　駿 on 2015/07/13.
//  Copyright (c) 2015年 岩瀬　駿. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var topLeftPhoto: UIImageView!
    @IBOutlet weak var topRightPhoto: UIImageView!
    @IBOutlet weak var topLeftPhotoConstraint: NSLayoutConstraint!
    @IBOutlet weak var topRightPhotoConstraint: NSLayoutConstraint!
    @IBOutlet weak var topLeftPhotoWidth: NSLayoutConstraint!
    @IBOutlet weak var topRightPhotoWidth: NSLayoutConstraint!
    @IBOutlet weak var restaurantInfo: UIView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    let nsnc = NSNotificationCenter.defaultCenter()
    var firstPhoto: String? = nil
    var secondPhoto: String? = nil
    var restaurant = Restaurant()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.restaurantName.text = self.restaurant.name
        self.genre.text = self.restaurant.genre
        self.address.text = self.restaurant.address
        self.tel.text = self.restaurant.tel
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.getRestaurantDetail()
        self.partsLayout()
        nsnc.addObserverForName(API.APILoadCompleteNotification, object: nil, queue: nil, usingBlock:{
            (notification) in
            if let firstPhoto = self.firstPhoto {
                self.topLeftPhoto.sd_setImageWithURL(NSURL(string: firstPhoto))
            }
            if let secondPhoto = self.secondPhoto{
                self.topRightPhoto.sd_setImageWithURL(NSURL(string: secondPhoto))
            }
            self.tableView.reloadData()
            }
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 500
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurant.posts.count
    }
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row < restaurant.posts.count {
                let cell = tableView.dequeueReusableCellWithIdentifier("RestaurantDetail") as! RestaurantDetailTableViewCell
                cell.profilePhoto.sd_setImageWithURL(NSURL(string: self.restaurant.posts[indexPath.row].user.profilePhoto!))
                cell.photo.sd_setImageWithURL(NSURL(string: self.restaurant.posts[indexPath.row].photoName!))
                cell.screenName.text = self.restaurant.posts[indexPath.row].user.name
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
    // MARK: - アプリケーションロジック
    func getRestaurantDetail() {
        API.request(.GET, url: "restaurants/\(restaurant.id!)", params: nil, completion: {
            (request, response, json, error) -> Void in
            self.firstPhoto = json["firstPhoto"].string
            self.secondPhoto = json["secondPhoto"].string
            for (key, value) in json["posts"] {
                var post = Post()
                post.photoName = value["photo"]["url"].string
                post.user.name = value["user"]["name"].string
                post.user.profilePhoto = value["user"]["profile_photo"]["url"].string
                self.restaurant.posts.append(post)
            }
        })
    }
    
    func partsLayout() {
        self.topLeftPhotoConstraint.constant = self.view.frame.size.width / 2
        self.topRightPhotoConstraint.constant = self.view.frame.size.width / 2
        self.topLeftPhotoWidth.constant = self.view.frame.size.width / 2
        self.topRightPhotoWidth.constant = self.view.frame.size.width / 2
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
