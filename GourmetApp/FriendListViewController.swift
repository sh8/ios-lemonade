//
//  FriendListViewController.swift
//  GourmetApp
//
//  Created by 岩瀬　駿 on 2015/07/19.
//  Copyright (c) 2015年 岩瀬　駿. All rights reserved.
//

import UIKit

class FriendListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    
    var users = [User]()
    let nsnc = NSNotificationCenter.defaultCenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchField.delegate = self
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.users = []
        let query = self.searchField.text
        self.searchUser(query)
        searchField.resignFirstResponder()
        nsnc.addObserverForName(API.APILoadCompleteNotification, object: nil, queue: nil, usingBlock: {
            (notification) in
            self.tableView.reloadData()
            self.searchField.resignFirstResponder()
        })
        return true
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("PushToFriendMyPage", sender: self.users[indexPath.row])
    }
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.users.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row < self.users.count {
                let cell = tableView.dequeueReusableCellWithIdentifier("FriendList") as! FriendListTableViewCell
                cell.user = self.users[indexPath.row]
                return cell
            }
        }
     return UITableViewCell()
    }
    
    // アプリケーションロジック
    func searchUser(query: String) {
        API.request(.GET, url: "users/search", params: ["query": query],
            completion: {
                (request, response, json, error) -> Void in
                // TODO: 下記にjson取得終了時に行いたい処理を書く
                for (key, value) in json {
                    var user = User()
                    user.id = value["id"].int
                    user.name = value["name"].string
                    user.screenoName = value["screen_name"].string
                    user.profilePhoto = value["profile_photo"]["url"].string
                    self.users.append(user)
                }
        })
    }

    // MARK: - IBActions
    @IBAction func backButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PushToFriendMyPage" {
            if let nc = segue.destinationViewController as? MypageViewController {
                nc.user = sender as! User
            }
        }
    }

}
