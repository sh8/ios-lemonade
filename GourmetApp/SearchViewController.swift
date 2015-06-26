//
//  ViewController.swift
//  GourmetApp
//
//  Created by 岩瀬　駿 on 2015/06/23.
//  Copyright (c) 2015年 岩瀬　駿. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SearchViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var searchField: UITextField!
    var restaurants: [Restaurant] = [Restaurant]()
    let nsnc = NSNotificationCenter.defaultCenter()
    var observers = [NSObjectProtocol]()
    let ls = LocationService()
    internal var here: (lat: Double, lon: Double)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ls.startUpdatingLocation()
        self.setObserver()
        
        // 飲食店の位置を地図に表示. APIの読み込み終了時に実行される.
        nsnc.addObserverForName(API.APILoadCompleteNotification,
            object: nil,
            queue: nil,
            usingBlock: {
                (notification) in
                // 現在地を取得し、現在地を中心として飲食店を表示する.
                if let lat = self.here?.lat{
                    if let lon = self.here?.lon{
                        // 表示範囲を最も距離の遠い飲食店に合わせる
                        if let dist_lat = self.restaurants.last?.lat{
                            if let dist_lon = self.restaurants.last?.lon{
                                let diff = (
                                    lat: abs(dist_lat - lat),
                                    lon: abs(dist_lon - lon)
                                )
                                let cllc = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                                // 表示範囲を設定する
                                let mkcs = MKCoordinateSpanMake(diff.lat * 2.4, diff.lon * 2.4)
                                let mkcr = MKCoordinateRegionMake(cllc, mkcs)
                                self.map.setRegion(mkcr, animated: false)
                            }
                        }
                    }
                }
                
                // ピンを設定
                for (index, restaurant) in enumerate(self.restaurants) {
                    if let lat = restaurant.lat {
                        if let lon = restaurant.lon {
                            var pin = MKPointAnnotation()
                            let cllc = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                            pin.coordinate = cllc
                            pin.title = restaurant.name
                            self.map.addAnnotation(pin)
                        }
                    }
                }
            }
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapped(sender: UITapGestureRecognizer) {
        searchField.resignFirstResponder()
    }
    
    // MARK: - アプリケーションロジック
    func searchRestaurant(#lat: Double, lon: Double){
        API.request(.GET, url: "restaurants/search", params: ["lat": lat, "lon": lon],
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
                            self.map.showsUserLocation = true
                            self.here = (lat: clloc.coordinate.latitude, lon: clloc.coordinate.longitude)
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
}

