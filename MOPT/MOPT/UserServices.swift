//
//  UserServices.swift
//  MOPT
//
//  Created by Gustavo Avena on 31/03/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import CloudKit
import FBSDKLoginKit


class UserServices: UserDelegate {
    func createUser(fbID: Int, name: String, email: String, profilePictureURL: URL) {
        
        
    }
    
    //fetching user's facebook information
    func fetchFacebookUserInfo(completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
        
        //getting id, name and email informations from user's facebook
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start {
            (connection, result, error) -> Void in
            
            let userInfo = (result as? [String:Any])
            completionHandler(userInfo, error)
        }
    }
    
    
    func getUserProfilePictureURL(userReference: CKReference, completionHandler: @escaping (URL?, Error?) -> Void) {
        fetchFacebookUserInfo {
            (userInfo, error) in
            let userID = CKRecordID(recordName: userInfo?["id"] as! String)
            let userPictureURL = URL(string: "http://graph.facebook.com/\(userID)/picture?type=large")!
            
            completionHandler(userPictureURL, error)
        }
    }
    
    
    func getCurrentUserRecordID(completionHandler: @escaping (CKRecordID?, Error?) -> Void) {
        fetchFacebookUserInfo {
            (userInfo, error) in
            let userID = CKRecordID(recordName: userInfo?["id"] as! String)
            
            completionHandler(userID, error)
        }
    }
}
