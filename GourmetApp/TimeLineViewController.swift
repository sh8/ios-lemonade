//
//  TimeLineViewController.swift
//  GourmetApp
//
//  Created by 岩瀬　駿 on 2015/07/05.
//  Copyright (c) 2015年 岩瀬　駿. All rights reserved.
//

import UIKit

class TimeLineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let nsnc = NSNotificationCenter.defaultCenter()
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationItem.title = "Stream"
        nsnc.addObserverForName(API.APILoadCompleteNotification, object: nil, queue: nil, usingBlock: {
            (notification) in
            self.tableView.reloadData()
        })
        
        if self.tableView.respondsToSelector("separatorInset") {
            self.tableView.separatorInset = UIEdgeInsetsZero;
        }
        
        if self.tableView.respondsToSelector("layoutMargins") {
            self.tableView.layoutMargins = UIEdgeInsetsZero;
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        getTimeLine()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 470
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("PushToRestaurantDetail", sender: self.posts[indexPath.row].restaurant)
    }
    
    // MARK: - UITableViewdDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row < posts.count {
                let cell = tableView.dequeueReusableCellWithIdentifier("TimeLine") as! TimeLineTableViewCell
                // TODO: - セルにデータを追加する処理を書く
                cell.screenName.setTitle(self.posts[indexPath.row].user.name!, forState: UIControlState.Normal)
                cell.screenName.addTarget(self, action: "onScreenNameTapped:forEvent:", forControlEvents: UIControlEvents.TouchUpInside)
                cell.restaurantName.text = self.posts[indexPath.row].restaurant.name!
                cell.imageHeight.constant = self.view.frame.width
                cell.profilePhoto.layer.cornerRadius = 5.0
                
                cell.profilePhoto.layer.masksToBounds = true
                cell.photo.contentMode = UIViewContentMode.ScaleAspectFit
                cell.photo.sd_setImageWithURL(NSURL(string: self.posts[indexPath.row].photoName!))
                cell.profilePhoto.sd_setImageWithURL(NSURL(string: self.posts[indexPath.row].user.profilePhoto!))
                
                cell.favoriteButton.addTarget(self, action: "toggleFavorite:forEvent:", forControlEvents: UIControlEvents.TouchUpInside)
                var alphaColor: UIColor? = nil
                if (self.posts[indexPath.row].isFavorite!) {
                    let color = UIColor.redColor()
                    alphaColor = color.colorWithAlphaComponent(0.7)
                } else {
                    let color = UIColor.darkGrayColor()
                    alphaColor = color.colorWithAlphaComponent(0.7)
                }
                cell.favoriteButton.layer.cornerRadius = 5.0
                cell.favoriteButton.backgroundColor = alphaColor
                
                if cell.respondsToSelector("separatorInset") {
                    cell.separatorInset = UIEdgeInsetsZero;
                }
                if cell.respondsToSelector("preservesSuperviewLayoutMargins") {
                    cell.preservesSuperviewLayoutMargins = false;
                }
                if cell.respondsToSelector("layoutMargins") {
                    cell.layoutMargins = UIEdgeInsetsZero;
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    // MARK: - アプリケーションロジック
    func getTimeLine() {
        API.request(.GET, url: "time_lines", params: nil, completion: {
            (request, response, json, error) -> Void in
            for (key, value) in json {
                var post = Post()
                post.id = value["id"].int
                post.photoName = value["photo"]["url"].string
                post.user.id = value["user"]["name"].int
                post.user.profilePhoto = value["user"]["profile_photo"]["url"].string
                post.user.name = value["user"]["name"].string
                post.user.id = value["user_id"].int
                post.isFavorite = value["is_favorite"].bool
                post.restaurant.id = value["restaurant"]["id"].int
                post.restaurant.name = value["restaurant"]["name"].string
                post.restaurant.tel = value["restaurant"]["tel"].string
                post.restaurant.address = value["restaurant"]["address"].string
                post.restaurant.genre = value["restaurant"]["genre"].string
                self.posts.append(post)
            }
        })
    }
    
    func createFavorite(post_id: Int) {
        API.request(.POST, url: "likes/create", params: ["post_id": post_id], completion: {
            (request, response, json, error) -> Void in
        })
    }
    
    func deleteFavorite(post_id: Int) {
        API.request(.DELETE, url: "likes/\(post_id)", params: nil, completion: {
            (request, response, json, error) -> Void in
        })
    }
    
    // MARK: - IBAction

    @IBAction func onScreenNameTapped(sender: UIButton, forEvent event: UIEvent) {
        let touch: UITouch = event.allTouches()?.first as! UITouch
        let point = touch.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        if let row = indexPath?.row {
            let user = self.posts[row].user
            performSegueWithIdentifier("PushToMypage", sender: user)
        }
    }
    
    @IBAction func toggleFavorite(sender: UIButton, forEvent event: UIEvent) {
        let touch: UITouch = event.allTouches()?.first as! UITouch
        let point = touch.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath!) as! TimeLineTableViewCell
        var alphaColor: UIColor? = nil
        if self.posts[indexPath!.row].isFavorite! {
            let color = UIColor.darkGrayColor()
            alphaColor = color.colorWithAlphaComponent(0.7)
            cell.favoriteButton.backgroundColor = alphaColor
            self.posts[indexPath!.row].isFavorite = false
            self.deleteFavorite(self.posts[indexPath!.row].id!)
        } else {
            let color = UIColor.redColor()
            alphaColor = color.colorWithAlphaComponent(0.7)
            cell.favoriteButton.backgroundColor = alphaColor
            self.posts[indexPath!.row].isFavorite = true
            self.createFavorite(self.posts[indexPath!.row].id!)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PushToRestaurantDetail" {
            if let nc = segue.destinationViewController as? RestaurantDetailViewController {
                nc.restaurant = sender as! Restaurant
            }
        } else if segue.identifier == "PushToMypage" {
             if let nc = segue.destinationViewController as? MypageViewController {
                let user = sender as! User
                nc.user = user
            }
        }
    }

}
