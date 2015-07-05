//
//  MypageViewController.swift
//  GourmetApp
//
//  Created by 岩瀬　駿 on 2015/06/25.
//  Copyright (c) 2015年 岩瀬　駿. All rights reserved.
//

import UIKit

class MypageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var posts: [Post] = [Post]()
    var user: User = User()
    
    let nsnc = NSNotificationCenter.defaultCenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        getImage()
        
        nsnc.addObserverForName(API.APILoadCompleteNotification, object: nil, queue: nil,
            usingBlock: {
                (notification) in
                self.collectionView.reloadData()
            }
        )

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - アプリケーションロジック
    func getImage() {
        API.request(.GET, url: "posts", params: ["user_id": "0"],
            completion:{
                (request, response, json, error) -> Void in
                self.user.screenoName = json["user"]["screen_name"].string
                self.user.name = json["user"]["name"].string
                self.user.email = json["user"]["email"].string
                for (key, value) in json["posts"] {
                    var post = Post()
                    post.photoName = value["photo"]["url"].string
                    post.restaurantId = value["restaurant_id"].int
                    self.posts.append(post)
                }
            }
        )
    }
    
    // MARK: - UICollectionViewFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = self.view.frame.size.width / 3
        return CGSize(width: size, height: size)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
   
    // MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.posts.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        // ユーザ情報ヘッダの場合のみ処理する
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "UserInfoHeader", forIndexPath: indexPath) as! MypageCollectionReusableView
            header.screenName.text = self.user.screenoName
            return header
        }
        return UICollectionReusableView()
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if indexPath.row <= posts.count {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MypageCollectionViewCell", forIndexPath: indexPath) as! MypageCollectionViewCell
                let photo_url = self.posts[indexPath.row].photoName!
                cell.photo.sd_setImageWithURL(NSURL(string: photo_url))
                return cell
            }
        }
        return UICollectionViewCell()
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
