//
//  ViewController.swift
//  login_test
//
//  Created by Rodrigo Hilkner on 3/29/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginScreenViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    fileprivate var userDelegate: UserDelegate
    
    //creating facebook login button instance
    let loginButton: FBSDKLoginButton! = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["public_profile", "email"]
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let meetingServices = MeetingServices()
        
        meetingServices.addParticipant(meetingID: "Slackers:gugaavena:04042017", username: "gugaavena")

        
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
            userDelegate.fetchUserInfo(completionHandler: { (userInfo) in
                let userName = userInfo["name"] as! String
                let userEmail = userInfo["email"] as! String
                let userID = Int(userInfo["id"] as! String)!
                let userPictureURL = URL(string: "http://graph.facebook.com/\(userID)/picture?type=large")!
                
                //[code] procura user no banco de dados
                //[code] if user == nil, cria novo usuario
                userDelegate.createUser(id: userID, name: userName, email: userEmail, profilePictureURL: userPictureURL)
                //[code] pula para proxima viewcontroller enviando user encontrado/criado como parametro
            })
        }
    }
    
    //loginButtonDidLogOut: called when user logs out
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("tchauzinho")
    }
}

