//
//  PostViewController.swift
//  GourmetApp
//
//  Created by 岩瀬　駿 on 2015/06/24.
//  Copyright (c) 2015年 岩瀬　駿. All rights reserved.
//

import UIKit
import TSMessages

class PostViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var selectRestaurantButton: UIButton!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var restaurant: Restaurant? = Restaurant()
    var image: UIImage? = nil
    let ipc = UIImagePickerController()
    let kAnimator = Animator()
    let nsnc = NSNotificationCenter.defaultCenter()
    let CompleteSendingImage = "CompleteSendingImage"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ipc.delegate = self
        ipc.allowsEditing = true
        self.transitioningDelegate = self
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
    
    @IBAction func addPhotoTapped(sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            alert.addAction(
                UIAlertAction(
                    title: "写真を撮る",
                    style: .Default,
                    handler: {
                        action in
                        self.ipc.sourceType = .Camera
                        self.presentViewController(self.ipc, animated: true, completion: nil)
                    }
                )
            )
        }
        
        // 「写真を選択」ボタンはいつでも使える
        alert.addAction(
            UIAlertAction(
                title: "写真を選択",
                style: .Default,
                handler: {
                    action in
                    self.ipc.sourceType = .PhotoLibrary
                    self.presentViewController(self.ipc, animated: true, completion: nil)
                }
            )
        )
        
        alert.addAction(
            UIAlertAction(
                title: "キャンセル",
                style: .Cancel,
                handler: {
                    action in
                }
            )
        )
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func submitButtonTapped(sender: UIButton) {
        backButton.enabled = false
        submitButton.enabled = false
        self.uploadImage()
    }

    @IBAction func backButtonTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // アプリケーションロジック
    func uploadImage() {
        let imageData = UIImagePNGRepresentation(image)
        API.upload("posts/create", params: ["restaurant_id": "\(restaurant!.id!)", "user_id": "0", "name": "shun"], data: imageData, completion: {
            (request, response, json, error) -> Void in
            // TODO: - エラー処理を書く
            let alertController = self.presentingViewController
            TSMessage.showNotificationInViewController(alertController, title: "投稿が完了しました", subtitle: nil, type: TSMessageNotificationType.Success)
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        ipc.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            // TODO: ここに画像を受け取った時の処理を書く.
            self.addPhotoButton.setBackgroundImage(image, forState: UIControlState.Normal)
            self.image = image
        }
        ipc.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - UIPartsLayout
    func partsLayout(){
        submitButton.backgroundColor = UIColor(red: 0.09, green: 0.09, blue: 0.09, alpha: 1.0)
        submitButton.alpha = 0.9
        submitButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        kAnimator.presenting = true
        return kAnimator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        kAnimator.presenting = false
        return kAnimator
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "modalSelectRestaurant" {
            if let nc = segue.destinationViewController as? SelectRestaurantViewController {
                nc.delegate = self
            }
        }
    }

}
