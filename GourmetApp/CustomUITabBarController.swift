//
//  CustomUITabBarController.swift
//  GourmetApp
//
//  Created by 岩瀬　駿 on 2015/07/05.
//  Copyright (c) 2015年 岩瀬　駿. All rights reserved.
//

import UIKit

class CustomUITabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.appendCenterButton()
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.11, green: 0.39, blue: 0.53, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().alpha = 1.0
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        UITabBar.appearance().barTintColor = UIColor(red: 0.09, green: 0.09, blue: 0.09, alpha: 1.0)
        UITabBar.appearance().tintColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func appendCenterButton() {
        let button: UIButton! = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        let image: UIImage? = UIImage(named:"tabbar-photo2")
        
        button.setImage(image, forState: UIControlState.Normal)
        button.frame = CGRectMake(0, 0, 80, 60)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15)
        button.addTarget(self, action: "onClick:", forControlEvents:.TouchUpInside)
        button.layer.position = CGPoint(x: self.view.frame.width / 2, y: UIScreen.mainScreen().bounds.size.height - button.frame.height + 35)
        button.layer.borderWidth = 0
        
        self.view.addSubview(button)
    }
    
    @IBAction func onClick(sender: AnyObject) {
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var mainViewController: UIViewController
        
        mainViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PostViewController") as! PostViewController
        // タブバーを非表示にする
        mainViewController.hidesBottomBarWhenPushed = true;
        self.presentViewController(mainViewController, animated: true, completion: nil)
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
