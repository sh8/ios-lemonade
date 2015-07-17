//
//  FavoriteViewController.swift
//  GourmetApp
//
//  Created by 岩瀬　駿 on 2015/07/17.
//  Copyright (c) 2015年 岩瀬　駿. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var favorites = [Favorite]()
    let nsnc = NSNotificationCenter.defaultCenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Favorites"
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        getImage()
        
        nsnc.addObserverForName(API.APILoadCompleteNotification, object: nil, queue: nil,
            usingBlock: {
                (notification) in
                self.collectionView.reloadData()
            }
        )
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.favorites.count
        }
        return 0
    }
    
    // MARK: - UICollectionViewFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = self.view.frame.size.width / 3
        return CGSize(width: size, height: size)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if indexPath.row <= favorites.count {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FavoriteCollectionViewCell", forIndexPath: indexPath) as! FavoriteCollectionViewCell
                let photo_url = self.favorites[indexPath.row].post.photoName!
                cell.photo.sd_setImageWithURL(NSURL(string: photo_url))
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    // MARK: - アプリケーションロジック
    // MARK: - アプリケーションロジック
    func getImage() {
        API.request(.GET, url: "favorites", params: nil,
            completion:{
                (request, response, json, error) -> Void in
                for (key, value) in json["favorites"] {
                    var favorite = Favorite()
                    favorite.post.photoName = value["post"]["photo"]["url"].string
                    favorite.post.restaurant.id = value["post"]["restaurant_id"].int
                    self.favorites.append(favorite)
                }
            }
        )
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
