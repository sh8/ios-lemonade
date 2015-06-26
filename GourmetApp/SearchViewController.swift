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

class SearchViewController: UIViewController, UIGestureRecognizerDelegate, MKMapViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    var restaurants: [Restaurant] = [Restaurant]()
    let nsnc = NSNotificationCenter.defaultCenter()
    var observers = [NSObjectProtocol]()
    var cllc: CLLocationCoordinate2D? = nil
    var isFirstView = true
    let ls = LocationService()

    override func viewDidLoad() {
        super.viewDidLoad()
        ls.startUpdatingLocation()
        panGesture.delegate = self
        map.delegate = self
        searchField.delegate = self
        self.setObserver()
        
        // 飲食店の位置を地図に表示. APIの読み込み終了時に実行される.
        nsnc.addObserverForName(API.APILoadCompleteNotification,
            object: nil,
            queue: nil,
            usingBlock: {
                (notification) in
                // 現在地を取得し、現在地を中心として飲食店を表示する.
                // 最初のみこの作業を行う.
                if self.isFirstView {
                    if let lat = self.cllc?.latitude{
                        if let lon = self.cllc?.longitude{
                            // 表示範囲を最も距離の遠い飲食店に合わせる
                            if let dist_lat = self.restaurants.last?.lat{
                                if let dist_lon = self.restaurants.last?.lon{
                                    let diff = (
                                        lat: abs(dist_lat - lat),
                                        lon: abs(dist_lon - lon)
                                    )
                                    // 表示範囲を設定する
                                    let mkcs = MKCoordinateSpanMake(diff.lat * 2.4, diff.lon * 2.4)
                                    let mkcr = MKCoordinateRegionMake(self.cllc!, mkcs)
                                    self.map.setRegion(mkcr, animated: false)
                                }
                            }
                        }
                    }
                }
                
                
                // ピンを設定
                for restaurant in self.restaurants {
                    let ann = self.map.annotations as! [MKAnnotation]
                    let same = ann.filter({$0.title == restaurant.name})
                    if !same.isEmpty {
                        continue
                    }
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
    
    // MARK: - IBAction
    @IBAction func onTapped(sender: UITapGestureRecognizer) {
        searchField.resignFirstResponder()
    }
    
    @IBAction func handlePan(sender: UIPanGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Ended {
            cllc?.latitude = map.centerCoordinate.latitude
            cllc?.longitude = map.centerCoordinate.longitude
            isFirstView = false
            self.searchRestaurant(lat: map.centerCoordinate.latitude, lon: map.centerCoordinate.longitude)
        }
    }
    
    // MARK: - TextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchField.text.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        request.region = map.region
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler({
            (response:MKLocalSearchResponse!, error:NSError!) in
            let item = response.mapItems.last as! MKMapItem
            self.cllc?.latitude = item.placemark.coordinate.latitude
            self.cllc?.longitude = item.placemark.coordinate.longitude
            let mkcr = MKCoordinateRegionMakeWithDistance(self.cllc!, 500, 500)
            self.map.setRegion(mkcr, animated: false)
            self.searchRestaurant(lat: self.cllc!.latitude, lon: self.cllc!.longitude)
            self.searchField.resignFirstResponder()
        })
        return true
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!) {
        for view in views as! [MKAnnotationView]{
            var endFrame: CGRect = view.frame
            view.frame = CGRectOffset(endFrame, 0, -500)
            UIView.animateWithDuration(0.5, animations: {
                view.frame = endFrame
            })
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: - アプリケーションロジック
    func searchRestaurant(#lat: Double, lon: Double){
        API.request(.GET, url: "restaurants/search", params: ["lat": lat, "lon": lon],
            completion: {
                (request, response, json, error) -> Void in
                // TODO: 下記にjson取得終了時に行いたい処理を書く
                self.restaurants = []
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
                            self.cllc = CLLocationCoordinate2D(latitude: clloc.coordinate.latitude, longitude: clloc.coordinate.longitude)
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

