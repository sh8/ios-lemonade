//
//  AuthenticateViewController.swift
//  GourmetApp
//
//  Created by 岩瀬　駿 on 2015/06/28.
//  Copyright (c) 2015年 岩瀬　駿. All rights reserved.
//

import UIKit
import Accounts

class AuthenticateViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var screenNameField: UITextField!
    var accountStore: ACAccountStore = ACAccountStore()
    var twitterAccount: ACAccount?
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(sender: UIButton) {
        signUp()
        performSegueWithIdentifier("PushToTabMenu", sender: nil)
    }

    @IBAction func facebookButtonTapped(sender: UIButton) {
        var facebookAccountType: ACAccountType = self.accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierFacebook)
        let env = NSProcessInfo.processInfo().environment
        let options = [ACFacebookAppIdKey: env["FacebookAppID"] as! String, ACFacebookPermissionsKey: ["email"], ACFacebookAudienceKey: ACFacebookAudienceOnlyMe]
        self.accountStore.requestAccessToAccountsWithType(facebookAccountType, options: options as [NSObject : AnyObject], completion:{
            (granted: Bool, error: NSError?) -> Void in
            if error != nil {
                println("error! \(error)")
                return
            }
           
            if granted {
                let facebookAccounts: [ACAccount] = (self.accountStore.accountsWithAccountType(facebookAccountType) as? [ACAccount])!
                if facebookAccounts.count > 0 {
                    let facebookAccount: ACAccount? = facebookAccounts.last
                    let email: String = facebookAccount?.valueForKey("properties")?.objectForKey("ACUIDisplayUsername") as! String
                    println(facebookAccount?.valueForKey("properties"))
                    let access_token: String? = facebookAccount?.credential.oauthToken
                    
                }
            }
            
        })
    }
    
    @IBAction func twitterButtonTapped(sender: UIButton) {
        let twitterAccountType: ACAccountType = self.accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        self.accountStore.requestAccessToAccountsWithType(twitterAccountType, options: nil, completion:{
            (granted: Bool, error: NSError?) -> Void in
            if error != nil {
                println("error! \(error)")
                return
            }
            
            if granted {
                let twitterAccounts: [ACAccount] = (self.accountStore.accountsWithAccountType(twitterAccountType) as? [ACAccount])!
                if twitterAccounts.count > 0 {
                    self.showAccountSelectSheet(twitterAccounts)
                    let twitterAccount: ACAccount? = twitterAccounts.last
                }
            }
            
        })
    }
    
    @IBAction func onTapped(sender: UITapGestureRecognizer) {
        screenNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
   
    // アプリケーションロジック
    func signUp() {
        let name = screenNameField.text
        let email = emailField.text
        let password = passwordField.text
        API.request(.POST, url: "users/sign_up", params: ["user": ["screen_name": name, "email": email, "password": password]], completion: {
            (request, response, json, error) -> Void in
            for (key, value) in json {
                self.defaults.setObject(json["access_token"].string, forKey: "ACCESS_TOKEN")
                self.defaults.synchronize()
                println(self.defaults.objectForKey("ACCESS_TOKEN"))
            }
        })
    }
    
    private func showAccountSelectSheet(accounts: [ACAccount]) {
        
        let alert = UIAlertController(title: "Twitter",
            message: "アカウントを選択してください",
            preferredStyle: .ActionSheet)
        
        // アカウント選択のActionSheetを表示するボタン
        for account in accounts {
            alert.addAction(UIAlertAction(title: account.username,
                style: .Default,
                handler: { (action) -> Void in
                    println("your select account is \(account)")
                    self.twitterAccount = account
            }))
        }
        
        // キャンセルボタン
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        // 表示する
        self.presentViewController(alert, animated: true, completion: nil)
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
