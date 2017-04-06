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

class LoginScreenViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    fileprivate var userDelegate: UserDelegate
    fileprivate let ckHandler: CloudKitHandler
    
    //creating facebook login button instance
    let loginButton: FBSDKLoginButton! = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["public_profile", "email"]
        return button
    }()

    

    
    required  init?(coder aDecoder: NSCoder) {
        self.ckHandler = CloudKitHandler()
        
        self.userDelegate = UserServices()
        super.init(coder: aDecoder)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //checking if user is already logged in
        if (FBSDKAccessToken.current() != nil) {
            print("Usuario logado")
            //[code] localiza o objeto do usuario no banco de dados
            //[code] pula para outra view controller enviando user encontrado como parametro
        } else {
            //[code] espera usuario logar
        }
        
        //[duvida] colocar na storyboard?
        self.view.addSubview(loginButton)
        loginButton.center = self.view.center
        
        //delegating loginButton to LoginScreenViewController
        self.loginButton.delegate = self
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
            self.userDelegate.fetchFacebookUserInfo(completionHandler: {
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
                    self.ckHandler.fetchByRecordID(recordID: userRecordID) {
                        (response, error) in
                        

                        if let userRecord = response {
                            let currentUser = CurrentUser.shared()
                            currentUser.userRecordID = userRecord.recordID // Logged user in
                        } else {
                            self.userDelegate.createUser(fbID: userID, name: userName, email: userEmail, profilePictureURL: userPictureURL)
                        }
                        
                        
                    }
                    

                }
               
                
                //[code] procura user no banco de dados
                //[code] if user == nil, cria novo usuario
                
                //[code] pula para proxima viewcontroller enviando user encontrado/criado como parametro
            })
        }
    }
    
    //loginButtonDidLogOut: called when user logs out
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("tchauzinho")
    }
}

