//
//  UserDBLayer.swift
//  MOPT
//
//  Created by Gustavo Avena on 31/03/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import CloudKit
import UIKit

class UserDBLayer: NSObject {
    
    let myContainer: CKContainer
    
    let publicDB: CKDatabase
    
    override init() {
        myContainer = CKContainer.default()
        publicDB = myContainer.publicCloudDatabase
    }
    
    
    
    
    func createUserFromRecord(record: CKRecord) -> User {
        // TODO: get profilePicture from URL
        let profilePicture = record["profilePicture"]
        let user = User(name: record["name"] as! String,
                        fbUsername: record["fbUsername"] as! String,
                        email: record["email"] as! String,
                        meetings: record["meetings"] as? [Meeting],
                        profilePicture: profilePicture as? UIImage
        )
        return user
    }
    
    
    // TODO: Query for existing user by fbUsername. Check is such user exists. If yes, return his object, if it doesn't, return nil
    
    func queryUserByFBUsername(fbUsername: String, handleUserObject: @escaping (User?, Error?) -> Void) throws {
        let queryPredicate = NSPredicate(format: "fbUsername == %@", fbUsername)
        let queryObject = CKQuery(recordType: "User", predicate: queryPredicate)
        
        
       
        
        print("Performing query by fbUsername...")
        
        
        publicDB.perform(queryObject, inZoneWith: nil)  {
            (records, error) in
            if error != nil {
                print("Error performing query for user")
            }
            
            print("records:", records!, terminator: "\n\n")
            
            
            
            if let records = records {
                
                guard records.count >= 1 else {
                    print("No records found.")
                    handleUserObject(nil, QueryError.UserError)
                    return
                }
                
                let userRecord =  records[0]
                let user = self.createUserFromRecord(record: userRecord)
                handleUserObject(user, error)
                
            } else {
                handleUserObject(nil, error)
            }
        }
        
        func createRecordFromUserObject(user: User) -> CKRecord {
            let userRecordID = CKRecordID(recordName: user.fbUsername)
            let userRecord = CKRecord(recordType: "User", recordID: userRecordID)
            
            userRecord["name"] = user.name as NSString
            userRecord["email"] = user.email as NSString
            userRecord["fbUsername"] = user.fbUsername as NSString
            
            let meetingDBLayer = MeetingDBLayer()
            userRecord["meetings"] = meetingDBLayer.createRecordFromMeetingObject(user.meetings)
            
            
            return userRecord
            
        }
        
        
        // TODO: Implement error handling with a completionHandler.
        func storeUserObject(user: User) {
            let userRecord = createRecordFromUserObject(user: user)
            
            publicDB.save(userRecord) {
                (record, error) in
                if let error = error {
                    // Insert error handling
                    print("Error when saving the user.")
                    print(error.localizedDescription)
                    return
                }
                // Insert successfully saved record code
                print("User saved successfully.")
            }
        }
        
        
        
    }
    
    
}
