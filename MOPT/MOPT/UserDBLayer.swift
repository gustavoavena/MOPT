////
////  UserDBLayer.swift
////  MOPT
////
////  Created by Gustavo Avena on 31/03/17.
////  Copyright © 2017 Gustavo Avena. All rights reserved.
////
//
//import CloudKit
//import UIKit
//
//class UserDBLayer: NSObject {
//    
//    let myContainer: CKContainer
//    
//    let publicDB: CKDatabase
//    
//    override init() {
//        myContainer = CKContainer.default()
//        publicDB = myContainer.publicCloudDatabase
//    }
//    
//    
//    
//    
//    func createUserFromRecord(record: CKRecord) -> User {
//        // TODO: get profilePicture from URL
//        let profilePicture = record["profilePicture"]
//        let user = User(name: record["name"] as! String,
//                        fbUsername: record["fbUsername"] as! String,
//                        email: record["email"] as! String,
//                        meetings: record["meetings"] as? [Meeting],
//                        profilePicture: profilePicture as? UIImage
//        )
//        return user
//    }
//    
//    
//    // TODO: Query for existing user by fbUsername. Check is such user exists. If yes, return his object, if it doesn't, return nil
//    
//    func queryUserByFBUsername(fbUsername: String, handleUserObject: @escaping (User?, Error?) -> Void) throws {
//        
//        let recordID = CKRecordID(recordName: fbUsername)
//        print("Performing query by fbUsername...")
//        
//        
//        publicDB.fetch(withRecordID: recordID){
//            (record, error) in
//            if error != nil {
//                print("Error performing query for user")
//            }
//            
//            print("record:", record, terminator: "\n\n")
//            
//            
//            
//            if let userRecord = record {
//                let user = self.createUserFromRecord(record: userRecord)
//                handleUserObject(user, error)
//                
//            } else {
//                handleUserObject(nil, error)
//            }
//    }
//        
////    func createRecordFromUserObject(user: User) -> CKRecord {
////        let userRecordID = CKRecordID(recordName: user.fbUsername)
////        let userRecord = CKRecord(recordType: "User", recordID: userRecordID)
////        
////        userRecord["name"] = user.name as NSString
////        userRecord["email"] = user.email as NSString
////        userRecord["fbUsername"] = user.fbUsername as NSString
////
////        
////        
////        
////        
////        
////        for meeting in user.meetings {
////            let recordID = CKRecordID(recordName: String(format: "%@:%@", meeting.title, meeting.moderator.fbUsername))
////            userRecord["meetings"].append(CKReference(recordID: recordID))
////        }
////        
////        
////        
////        return userRecord
////        
////    }
//        
//    // TODO: Implement error handling with a completionHandler.
////    func storeUserObject(user: User) {
////        let userRecord = createRecordFromUserObject(user: user)
////        
////        publicDB.save(userRecord) {
////            (record, error) in
////            if let error = error {
////                // Insert error handling
////                print("Error when saving the user.")
////                print(error.localizedDescription)
////                return
////            }
////            // Insert successfully saved record code
////            print("User saved successfully.")
////        }
////    }
////    
//        
//        
//    }
//    
//    
//}
