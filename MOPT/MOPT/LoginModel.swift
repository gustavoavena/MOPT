//
//  Model.swift
//  login_test
//
//  Created by Rodrigo Hilkner on 01/04/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import FBSDKLoginKit

class LoginModel {
    
    //fetching user's facebook information
    func fetchUserInfo(completionHandler:@escaping ([String:Any])->Void) {
        
        var userData: [String:Any]!
        
        //getting id, name and email informations from user's facebook
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil) {
                userData = (result as! [String:Any])
                completionHandler(userData)
            }
        })
        
    }
    
    func createUser(id: Int, name: String, email: String, profilePictureURL: URL) {
        //criar usuario
    }
}
