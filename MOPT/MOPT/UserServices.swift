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
        let recordID = CKRecordID(recordName: String(fbID))
        let userRecord = CKRecord(recordType: "User", recordID: recordID)
        
        print("Creating user \(name) with fbID = \(String(fbID))")
        
        userRecord["name"] = name as NSString
        userRecord["email"] = email as NSString
        userRecord["fbID"] = String(fbID) as NSString
        userRecord["profilePictureURL"] = profilePictureURL.absoluteString as NSString
        
        
        ckHandler.saveRecord(record: userRecord)
        
    }
    
    //fetching user's facebook information
    func fetchFacebookUserInfo(completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
        
        //getting id, name and email informations from user's facebook
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start {
            (connection, result, error) in
            
            guard error == nil && result != nil else {
                print("error fetching user's facebook information")
                return
            }
            
            let userInfo = (result as? [String:Any])
            completionHandler(userInfo, error)
        }
    }
    
    // DONE: obeys protocol.
    public func getUserRecordFromEmail(email: String, completionHandler: @escaping (CKRecord?, Error?) -> Void) {
        let predicate = NSPredicate(format: "email == %@", email)
        let query = CKQuery(recordType: "User", predicate: predicate)
        
        self.ckHandler.publicDB.perform(query, inZoneWith: nil) {
            (results, error) in
            
            guard error == nil && results != nil else {
                print("error getting user record by email.")
                return
            }
            
            let records = results!
            
            if records.count > 0 {
                completionHandler(records[0], nil)
            } else {
                completionHandler(nil, QueryError.UserByEmail)
            }
            
        }
        
        
    }
    
    
    func getUserProfilePictureURL(userReference: CKReference, completionHandler: @escaping (URL?, Error?) -> Void) {
        fetchFacebookUserInfo {
            (userInfo, error) in
            
            guard error == nil && userInfo != nil else {
                print("error getting user's facebook profile picture URL")
                return
            }
            
            let userID = CKRecordID(recordName: userInfo?["id"] as! String)
            let userPictureURL = URL(string: "http://graph.facebook.com/\(userID)/picture?type=large")!
            completionHandler(userPictureURL, error)
        }
    }
    
    
    func getCurrentUserRecordID(completionHandler: @escaping (CKRecordID?, Error?) -> Void) {
        fetchFacebookUserInfo {
            (userInfo, error) in
            
            guard error == nil && userInfo != nil else {
                print("error getting current user CK Record ID")
            }
            
            let userID = CKRecordID(recordName: userInfo?["id"] as! String)
            completionHandler(userID, error)
        }
    }

}
