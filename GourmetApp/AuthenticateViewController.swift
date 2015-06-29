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

    var accountStore: ACAccountStore = ACAccountStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(sender: UIButton) {
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
                    let access_token: String? = facebookAccount?.credential.oauthToken
                    println(email)
                    println(access_token)
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
                    let twitterAccount: ACAccount? = twitterAccounts.last
                }
            }
            
        })
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
