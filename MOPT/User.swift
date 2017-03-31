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
    let fbUsername: String
    
    
    
    init(name: String, fbUsername: String, email: String, meetings: [Meeting]?, profilePicture: UIImage?) {
        self.name = name
        self.fbUsername = fbUsername
        self.email = email
        self.meetings = meetings ?? [Meeting]()
        self.profilePicture = profilePicture
    }
    
    func joinMeeting(meeting: Meeting) {
        self.meetings.append(meeting)
        meeting.addParticipant(participant: self)
    }
    
    // TODO: implement leaveMeeting.
    
    
    
    
    
    public static func testSave() {
        
        let userRecordID = CKRecordID(recordName: "First User")
        
        let userRecord = CKRecord(recordType: "User", recordID: userRecordID)
        
        userRecord["email"] = "fakeemail@gmail.com" as NSString
        userRecord["name"] = "First User" as NSString
        userRecord["fbUsername"] = "FBUsername" as NSString
        
        
        let myContainer = CKContainer.default()
        
        let privateDB = myContainer.privateCloudDatabase
        
        
        privateDB.save(userRecord) {
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
    
    public static func testQuery() {
        let fbUsername = "FBUsername"
        
        do {
            let userDBLayer = UserDBLayer()
            _ = try userDBLayer.queryUserByFBUsername(fbUsername: fbUsername) {
                (user, error) in
                if user == nil {
                    print("query returned nil!")
                } else {
                    print("user:", user!)
                }
            }
        }
        catch {
            print("User queryUserByFBUsername error!")
        }
        
    }
    

}

