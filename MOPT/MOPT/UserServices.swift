//
//  UserServices.swift
//  MOPT
//
//  Created by Gustavo Avena on 31/03/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import CloudKit


class UserServices: NSObject {
    
    let ckHandler: CloudKitHandler
    
    override init() {
        ckHandler = CloudKitHandler()
    }
    
    // DONE: obeys protocol.
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
    
    // DONE: obeys protocol.
    public func getUserRecordFromEmail(email: String, completionHandler: @escaping (CKRecord?, Error?)->Void) {
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

}
