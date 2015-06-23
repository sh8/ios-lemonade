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
        self.search_restaurant(lat: 1.11, lon: 1.11)
        // 飲食店の位置を地図に表示
        
        nsnc.addObserverForName(API.APILoadCompleteNotification,
            object: nil,
            queue: nil,
            usingBlock: {
            (notification) in
                
                if let lat = self.restaurants[0].lat {
                    if let lon = self.restaurants[0].lon{
                        let cllc = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                        let mkcr = MKCoordinateRegionMakeWithDistance(cllc, 500, 500)
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
                    println(restaurant)
                    self.restaurants.append(restaurant)
                }
        })
    }
}

