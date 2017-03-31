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
    
    
    
    // Declaring it as private to be sure that it is only called from withing this class. This ensure separation between layers.
    private func createUserFromRecord(record: CKRecord) -> User {
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
        
        
        let myContainer = CKContainer.default()
        
        let privateDB = myContainer.privateCloudDatabase
        
        print("Performing query by fbUsername...")
        
        
        privateDB.perform(queryObject, inZoneWith: nil)  {
            (records, error) in
            if error != nil {
                print("Error performing query for user")
            }
            
            print("records:", records!)
         
            
            if let userRecord = records?[0] {
//                print("userRecord:", userRecord)
                let user = self.createUserFromRecord(record: userRecord)
                handleUserObject(user, error)
            } else {
                handleUserObject(nil, error)
            }
        }
        
        
        
    }
    
    
}
