//
//  AuthenticateViewController.swift
//  GourmetApp
//
//  Created by 岩瀬　駿 on 2015/06/28.
//  Copyright (c) 2015年 岩瀬　駿. All rights reserved.
//

import UIKit
import Accounts
import TSMessages

class AuthenticateViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var screenNameField: UITextField!
    var accountStore: ACAccountStore = ACAccountStore()
    var account: ACAccount!
    let defaults = NSUserDefaults.standardUserDefaults()
    let TWITTER = 1
    let FACEBOOK = 2
    let nsnc = NSNotificationCenter.defaultCenter()
    let LOGIN_COMPLETED = "LOGIN_COMPLETED"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordField.delegate = self
        self.emailField.delegate = self
        self.screenNameField.delegate = self
        nsnc.addObserverForName(self.LOGIN_COMPLETED, object: nil, queue: nil, usingBlock: {
            (notification) in
            self.performSegueWithIdentifier("PushToTabMenu", sender: nil)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // アカウントがないときの処理を加える
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
                    let access_token: String? = facebookAccount?.credential.oauthToken
                    self.account = facebookAccount
                    self.signUp(sns_type: self.FACEBOOK)
                }
            }
        })
    }
   
    // アカウントが無いときの処理を加える
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
    func signUp(sns_type: Int? = nil) {
        var params = [String: AnyObject]()
        if let sns = sns_type {
            switch sns {
            case self.TWITTER:
                let name: String = self.account.username
                let email: String = ""
                let uid = self.account?.valueForKey("properties")?.objectForKey("user_id") as! String
                params = ["user": ["name": name, "screen_name": name, "email": email, "uid": uid, "sns_type": sns]]
            case self.FACEBOOK:
                let name = self.account.username
                let email: String = self.account?.valueForKey("properties")?.objectForKey("ACUIDisplayUsername") as! String
                let uid = self.account?.valueForKey("properties")?.objectForKey("uid") as! Int
                params = ["user": ["name": name, "screen_name": name, "email": email, "uid": uid, "sns_type": sns]]
            default:
                break
            }
        } else {
            let name = screenNameField.text
            let email = emailField.text
            let password = passwordField.text
            params = ["user": ["screen_name": name, "email": email, "password": password]]
        }
        API.request(.POST, url: "users/sign_up", params: params, completion: {
            (request, response, json, error) -> Void in
            for (key, value) in json {
                self.defaults.setObject(json["access_token"].string, forKey: "ACCESS_TOKEN")
                self.defaults.synchronize()
                self.nsnc.postNotificationName(self.LOGIN_COMPLETED, object: nil)
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
                    self.account = account
                    self.signUp(sns_type: self.TWITTER)
            }))
        }
        
        // キャンセルボタン
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        // 表示する
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func validationAlertByTile(title: String) {
        TSMessage.showNotificationInViewController(self, title: title, subtitle: nil, type: TSMessageNotificationType.Error)
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let email = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return email.evaluateWithObject(self.emailField.text)
    }
    
    func isValidScreenName() -> Bool {
        let screenNameRegEx = "^[a-zA-Z0-9]+$"
        // TODO: - 同じユーザ名がいた時の処理を加える
        let screenName = NSPredicate(format:"SELF MATCHES %@", screenNameRegEx)
        return screenName.evaluateWithObject(self.screenNameField.text)
    }
    
    func isValidPassword() -> Bool {
        let passwordRegEx = "^[a-zA-Z0-9]+$"

        let password = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return password.evaluateWithObject(self.passwordField.text)
    }
    
    func isValidPasswordNumber() -> Bool {
        let minumumNum = 6
        let maximumNum = 16
        let size = count(self.passwordField.text)       
        return size > minumumNum && size < maximumNum
    }
    
    // MARK: - UITextFieldDelegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField === emailField {
            screenNameField.becomeFirstResponder()
            if !isValidEmail() {
                validationAlertByTile("メールアドレスが不正です")
            }
        } else if textField === screenNameField {
            passwordField.becomeFirstResponder()
            if !isValidScreenName() {
                validationAlertByTile("アカウント名は英数字で入力してください")
            }
        } else {
            if !isValidPassword() {
                validationAlertByTile("パスワードは英数字で入力してください")
            }
            
            if !isValidPasswordNumber() {
                validationAlertByTile("パスワードは8文字以上16文字以内です")
            }
            
            if isValidEmail() && isValidScreenName() && isValidPassword() && isValidPasswordNumber() {
                signUp()
            }
        }
        
        return true
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
