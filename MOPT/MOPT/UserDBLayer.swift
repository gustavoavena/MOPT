//
//  UserDBLayer.swift
//  MOPT
//
//  Created by Gustavo Avena on 31/03/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import CloudKit

class UserDBLayer: NSObject {
    
    // TODO: Query for existing user by fbUsername. Check is such user exists. If yes, return his object, if it doesn't, return nil
    
    static func queryUserByFBUsername(fbUsername: String) throws -> User? {
        let queryPredicate = NSPredicate(format: "fbUsername == %@", fbUsername)
        let queryObject = CKQuery(recordType: "User", predicate: queryPredicate)
        
        
        let myContainer = CKContainer.default()
        
        let privateDB = myContainer.privateCloudDatabase
        var queryError: Error?
        var queryResult: [CKRecord]?
        
        print("Performing query by fbUsername...")
        
        
        privateDB.perform(queryObject, inZoneWith: nil)  {
            (records, error) in
            if error != nil {
                print("Error performing query for user")
                queryError = error
            }
            
            print("records:", records!)
            // queryResult = records // Doesn't work! Because it's a reference, when the code leaves the closure, records is deleted, so queryResult becomes nil!
            queryResult = [CKRecord](records!)
            
        }
        
        guard queryError == nil else {
            throw QueryError.UserError
        }
        
        print("queryResult:", queryResult as Any)
        
        if let userRecord = queryResult?[0] {
            print("userRecord:", userRecord)
            return nil
        } else {
            return nil
        }
    }
    
//    static func createUserFromRecord()

}
