//
//  User.swift
//  MOPT
//
//  Created by Gustavo Avena on 29/03/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import CloudKit



class User: NSObject {
    let name: String
    let email: String
    var meetings: [Meeting]
    let profilePicture: UIImage?
    
    
    init(name: String, email: String, meetings: [Meeting]?, profilePicture: UIImage?) {
        self.name = name
        self.email = email
        self.meetings = meetings ?? [Meeting]()
        self.profilePicture = profilePicture
    }
    
    public static func test() {
        
        let userRecordID = CKRecordID(recordName: "First User")
        
        let userRecord = CKRecord(recordType: "User", recordID: userRecordID)
        
        userRecord["email"] = "fakeemail@gmail.com" as NSString
        userRecord["name"] = "First User" as NSString
        
        let myContainer = CKContainer.default()
        
        let publicDatabase = myContainer.publicCloudDatabase
        
        
        publicDatabase.save(userRecord) {
            (record, error) in
            if let error = error {
                // Insert error handling
                print("Error when saving the user")
                print(error.localizedDescription)
                return
            }
            // Insert successfully saved record code
            print("User saved successfully")
        }
        
        
    }
    

}

