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
    var restaurants: [Restaurant] = [Restaurant]()
    let nsnc = NSNotificationCenter.defaultCenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // search_restaurantメソッドは現在位置情報取得のオブザーバーを受け取った後に実行する
        // 例: LSDidUpdateLocationNotificationを受信
        self.search_restaurant(lat: 1.11, lon: 1.11)
        
        // 飲食店の位置を地図に表示. APIの読み込み終了時に実行される.
        nsnc.addObserverForName(API.APILoadCompleteNotification,
            object: nil,
            queue: nil,
            usingBlock: {
            (notification) in
                // self.restaurant.first?.latではなく
                // ユーザの現在地を渡すようにする.
                if let lat = self.restaurants.first?.lat {
                    if let lon = self.restaurants.first?.lon{
                        let dist_lat = self.restaurants.last?.lat
                        let dist_lon = self.restaurants.last?.lon
                        // 表示範囲を最も距離の遠い飲食店に合わせる
                        let diff = (
                            lat: abs(dist_lat! - lat),
                            lon: abs(dist_lon! - lon)
                        )
                        let cllc = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                        // 表示範囲を設定する
                        let mkcs = MKCoordinateSpanMake(diff.lat * 2.4, diff.lon * 2.4)
                        let mkcr = MKCoordinateRegionMake(cllc, mkcs)
                        self.map.setRegion(mkcr, animated: false)
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
    
    // MARK: - アプリケーションロジック
    func search_restaurant(#lat: Double, lon: Double){
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
}

