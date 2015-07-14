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
        return 500
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
                cell.screenName.text = self.posts[indexPath.row].user.name!
                cell.restaurantName.text = self.posts[indexPath.row].restaurant.name!
                cell.imageHeight.constant = self.view.frame.width
                cell.profilePhoto.layer.cornerRadius = 5.0
                cell.profilePhoto.layer.masksToBounds = true
                cell.photo.contentMode = UIViewContentMode.ScaleAspectFit
                cell.photo.sd_setImageWithURL(NSURL(string: self.posts[indexPath.row].photoName!))
                cell.profilePhoto.sd_setImageWithURL(NSURL(string: self.posts[indexPath.row].user.profilePhoto!))
                
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
                post.photoName = value["photo"]["url"].string
                post.user.id = value["user"]["name"].int
                post.user.profilePhoto = value["user"]["profile_photo"]["url"].string
                post.user.name = value["user"]["name"].string
                post.restaurant.id = value["restaurant"]["id"].int
                post.restaurant.name = value["restaurant"]["name"].string
                post.restaurant.tel = value["restaurant"]["tel"].string
                post.restaurant.address = value["restaurant"]["address"].string
                post.restaurant.genre = value["restaurant"]["genre"].string
                self.posts.append(post)
            }
        })
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PushToRestaurantDetail" {
            if let nc = segue.destinationViewController as? RestaurantDetailViewController {
                nc.restaurant = sender as! Restaurant
            }
        }
    }

}
