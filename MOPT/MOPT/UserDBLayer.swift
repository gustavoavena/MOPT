//
//  UserDBLayer.swift
//  MOPT
//
//  Created by Gustavo Avena on 31/03/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import CloudKit

class UserDBLayer: NSObject {
    
    // TODO: Query for existing user by fbUsername. Check is such user exists. If yes, return his object, if it doesn't, return nil
    
    static func queryUserByFBUsername(fbUsername: String) throws -> User? {
        let queryPredicate = NSPredicate(format: "fbUsername == %@", fbUsername)
        let queryObject = CKQuery(recordType: "User", predicate: queryPredicate)
        
        
        let myContainer = CKContainer.default()
        
        let publicDatabase = myContainer.publicCloudDatabase
        var queryError: Error? = nil
        var queryResult: [CKRecord]? = nil
        
        
        publicDatabase.perform(queryObject, inZoneWith: nil, completionHandler:  {
            (records, error) in
            if error != nil {
                print("Error performing query for user")
                queryError = error
            }
            
            queryResult = records
            
        })
        
        guard queryError == nil else {
            throw QueryError.UserError
        }
        
        if let user = queryResult?[0] {
            return user
        } else {
            return nil
        }
        

    }

}
