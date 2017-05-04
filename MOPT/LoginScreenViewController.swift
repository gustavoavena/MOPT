//
//  ViewController.swift
//  login_test
//
//  Created by Rodrigo Hilkner on 3/29/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import CloudKit
import Dispatch

class LoginScreenViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    fileprivate var userDelegate: UserServices
    fileprivate let ckHandler: CloudKitHandler
    
    //creating facebook login button instance
    let loginButtonObject: FBSDKLoginButton! = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["public_profile", "email"]
        return button
    }()
    
    @IBOutlet weak var startupButton: UIButton!

    
    required  init?(coder aDecoder: NSCoder) {
        self.ckHandler = CloudKitHandler()
        
        self.userDelegate = UserServices()
        super.init(coder: aDecoder)
    }
    
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startupButton.isUserInteractionEnabled = false
        //checking if user is already logged in
        if (FBSDKAccessToken.current() != nil) {
            print("Usuario logado no Facebook.")
            
            //TODO chamar funcao que trava tudo
            self.userDelegate.fetchFacebookUserInfo() {
                (response, error) in
                //TODO atuala
                guard error == nil else {
                    print("Error fetching user's facebook info.")
                    return
                }
                
                if let userInfo = response {
                    
                    print("Fetched user's Facebook info.")
					
					var user = Cache.get(objectType: .user, objectWithID: userInfo["id"] as! ObjectID) as? User
					
					if user == nil {
						let urlString = "http://graph.facebook.com/\(userInfo["id"] as! String)/picture?type=large"
						user = User.create(ID: userInfo["id"] as! ObjectID, name: userInfo["name"] as! String, email: userInfo["email"] as! String, profilePictureURL: urlString)
					}
					
					let currentUser = CurrentUser.shared()
					currentUser.userID = user!.ID // FIXME: make sure currentUser is never nil
					// Logged user in
					self.startupButton.isUserInteractionEnabled = true
					
					
					
//                    let userName = userInfo["name"] as! String
//                    let userEmail = userInfo["email"] as! String
//                    let userID = userInfo["id"] as! String
//                    let userPictureURL = URL(string: "http://graph.facebook.com/\(userID)/picture?type=large")!
//                    
//                    let userRecordID = CKRecordID(recordName: userID)
//                    self.ckHandler.fetchByRecordID(recordID: userRecordID) {
//                        (response, error) in
//                        
//                        if let userRecord = response {
//                            let currentUser = CurrentUser.shared()
//                            currentUser.userRecordID = userRecord.recordID // Logged user in
//							let userServices = UserServices()
//							userServices.downloadImage(imageURL: userPictureURL, userRecordID: userRecord.recordID)
//							
//                        } else {
//                            self.userDelegate.createUser(fbID: userID, name: userName, email: userEmail, profilePictureURL: userPictureURL)
//                        }
//						  self.startupButton.isUserInteractionEnabled = true
//                    }
                }
            }
            
        }
        
        self.view.addSubview(loginButtonObject)
        loginButtonObject.center = self.view.center
        
        //delegating loginButton to LoginScreenViewController
        self.loginButtonObject.delegate = self
    }
    
    
    //loginButton: called when user logs in
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if ((error) != nil) {
            print("Error: \(error.localizedDescription)")
        }
        else if result.isCancelled {
            print("Login cancelled")
        }
        else {
            //getting user's facebook informations (id, name, email)
            self.userDelegate.fetchFacebookUserInfo(completionHandler:  {
                (response, error) in
                
                guard error == nil else {
                    print("Error fetching user's facebook info.")
                    return
                }
                
                if let userInfo = response {
                    let userName = userInfo["name"] as! String
                    let userEmail = userInfo["email"] as! String
                    let userID = userInfo["id"] as! String
                    let userPictureURL = URL(string: "http://graph.facebook.com/\(userID)/picture?type=large")!
                    
                    let userRecordID = CKRecordID(recordName: userID)
//                    self.ckHandler.fetchByRecordID(recordID: userRecordID) {
//                        (response, error) in
//                        
//                        
//                        if let userRecord = response {
//                            let currentUser = CurrentUser.shared()
//                            currentUser.userRecordID = userRecord.recordID // Logged user in
//                        } else {
//                            self.userDelegate.createUser(fbID: userID, name: userName, email: userEmail, profilePictureURL: userPictureURL)
//                        }
//                        self.startupButton.isUserInteractionEnabled = true
//                    }
                }
            })
        }
    }
	
    
    //loginButtonDidLogOut: called when user logs out
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("tchauzinho")
    }
    
}

