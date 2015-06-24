//
//  PostViewController.swift
//  GourmetApp
//
//  Created by 岩瀬　駿 on 2015/06/24.
//  Copyright (c) 2015年 岩瀬　駿. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var placeHolder: UILabel!
    @IBOutlet weak var selectRestaurantButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        caption.delegate = self
        partsLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - IBAction
    @IBAction func selectRestaurantButtonTapped(sender: UIButton) {
        performSegueWithIdentifier("modalSelectRestaurant", sender: nil)
    }
    
    // MARK: - UITextViewDelegate
    //textviewがフォーカスされたら、Labelを非表示
    func textViewShouldBeginEditing(textView: UITextView) -> Bool
    {
        placeHolder.hidden = true
        return true
    }
    
    //textviewからフォーカスが外れて、TextViewが空だったらLabelを再び表示
    func textViewDidEndEditing(textView: UITextView) {
        if(caption.text.isEmpty){
            placeHolder.hidden = false
        }
    }
    
    // MARK: - UIPartsLayout
    func partsLayout(){
        caption.layer.borderWidth = 1
        caption.layer.borderColor = UIColor.blackColor().CGColor
        selectRestaurantButton.layer.borderWidth = 1
        selectRestaurantButton.layer.borderColor = UIColor.blackColor().CGColor
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
