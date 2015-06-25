//
//  SelectRestaurantViewController.swift
//  GourmetApp
//
//  Created by 岩瀬　駿 on 2015/06/24.
//  Copyright (c) 2015年 岩瀬　駿. All rights reserved.
//

import UIKit
import CoreLocation

class SelectRestaurantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var restaurants: [Restaurant] = [Restaurant]()
    let nsnc = NSNotificationCenter.defaultCenter()
    var observers = [NSObjectProtocol]()
    let ls = LocationService()
    weak var delegate: PostViewController?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        ls.startUpdatingLocation()
        self.setObserver()
        
        // 飲食店の位置を地図に表示. APIの読み込み終了時に実行される.
        nsnc.addObserverForName(API.APILoadCompleteNotification,
            object: nil,
            queue: nil,
            usingBlock: {
                (notification) in
                    self.tableView.reloadData()
            }
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.dismissViewControllerAnimated(true, completion: {
            self.delegate?.restaurant = self.restaurants[indexPath.row]
            self.delegate?.restaurantName.text = self.restaurants[indexPath.row].name
        })
    }
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return restaurants.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row < restaurants.count {
                let cell = tableView.dequeueReusableCellWithIdentifier("SelectRestaurant") as! SelectRestaurantTableViewCell
                cell.restaurant = restaurants[indexPath.row]
                return cell
            }
        }
        return UITableViewCell()
    }
    
    // MARK: - アプリケーションロジック
    func searchRestaurant(#lat: Double, lon: Double){
        API.request(.GET, url: "restaurants/near", params: ["lat": lat, "lon": lon, "limit": 20, "start": restaurants.count],
            completion: {
                (request, response, json, error) -> Void in
                // TODO: 下記にjson取得終了時に行いたい処理を書く
                for (key, value) in json {
                    var restaurant = Restaurant()
                    restaurant.name = value["name"].string
                    restaurant.tel = value["tel"].string
                    restaurant.lat = value["lat"].doubleValue
                    restaurant.lon = value["lon"].doubleValue
                    restaurant.address = value["address"].string
                    self.restaurants.append(restaurant)
                }
        })
    }
    
    // MARK: - setObserver
    func setObserver(){
        // 位置情報取得を禁止している場合
        observers.append(
            nsnc.addObserverForName(
                ls.LSAuthDeniedNotification,
                object: nil,
                queue: nil,
                usingBlock: {
                    notification in
                    //位置情報がONになっていないダイアログ表示
                    self.presentViewController(self.ls.locationServiceDisabledAlert, animated: true, completion: nil)
                }
            )
        )
        
        // 位置情報取得を制限している場合
        observers.append(
            nsnc.addObserverForName(
                ls.LSAuthDeniedNotification,
                object: nil,
                queue: nil,
                usingBlock: {
                    notification in
                    //位置情報が制限されているダイアログ表示
                    self.presentViewController(self.ls.locationServiceRestrictedAlert, animated: true, completion: nil)
                }
            )
        )
        
        // 位置情報取得に失敗した場合
        observers.append(
            nsnc.addObserverForName(
                ls.LSAuthDeniedNotification,
                object: nil,
                queue: nil,
                usingBlock: {
                    notification in
                    //位置情報取得に失敗したダイアログ
                    self.presentViewController(self.ls.locationServiceDidFailAlert, animated: true, completion: nil)
                }
            )
        )
        
        // 位置情報を取得した場合
        observers.append(
            nsnc.addObserverForName(
                ls.LSDidUpdateLocationNotification,
                object: nil,
                queue: nil,
                usingBlock: {
                    notification in
                    if let userInfo = notification.userInfo as? [String: CLLocation] {
                        if let clloc = userInfo["location"] {
                            self.searchRestaurant(lat: clloc.coordinate.latitude , lon: clloc.coordinate.longitude)
                        }
                    }
                }
            )
        )
        
        // 位置情報が利用可能になったとき
        observers.append(
            nsnc.addObserverForName(
                ls.LSAuthorizedNotification,
                object: nil,
                queue: nil,
                usingBlock: {
                    notification in
                    // TODO: - 位置情報が利用可能になった時の処理を書く
                }
            )
        )
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
