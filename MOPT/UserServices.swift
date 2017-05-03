//
//  UserServices.swift
//  MOPT
//
//  Created by Gustavo Avena on 31/03/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
//import CloudKit
import FBSDKLoginKit


/*
class UserServices: NSObject, UserDelegate {
    
    let ckHandler: CloudKitHandler
    
    override init() {
        ckHandler = CloudKitHandler()
    }
    
    func createUser(fbID: String, name: String, email: String, profilePictureURL: URL) {
        let recordID = CKRecordID(recordName: String(fbID))
        let userRecord = CKRecord(recordType: "User", recordID: recordID)
        
        print("Creating user \(name) with fbID = \(String(describing: String(fbID)))")
        
        userRecord["name"] = name as NSString
        userRecord["email"] = email as NSString
        userRecord["fbID"] = fbID as NSString
        userRecord["profilePictureURL"] = profilePictureURL.absoluteString as NSString
        
        // Logs user in:
        let currentUser = CurrentUser.shared()
        currentUser.userRecordID = userRecord.recordID // logged in
        
        self.ckHandler.saveRecord(record: userRecord)
        
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
                return
            }
            
            let userID = CKRecordID(recordName: userInfo?["id"] as! String)
            completionHandler(userID, error)
        }
    }
    
    
	func downloadImage(imageURL: URL, userRecordID: CKRecordID) {
        print("Download of \(imageURL) started")
        
        var urlStr = imageURL.absoluteString
        urlStr = urlStr.replacingOccurrences(of: "http", with: "https")
		
		let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
		let fileName = documentsDirectory.appendingPathComponent(String(format: "%@ProfilePicture.jpg", userRecordID.recordName))
		
		
        
        let request = URLRequest(url: URL(string: urlStr)!)

        
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            guard let data = data, error == nil else {
                print("Error downloading user profile picture -> \(String(describing: error?.localizedDescription))")
//                completionHandler(nil, error)
                return
            }
            
            DispatchQueue.main.async {
				
				do {
					try data.write(to: fileName)
					print("User \(userRecordID.recordName)'s profile picture saved successfully")
				}
				catch {
					print("Error when trying to save profile picture")
					return
				}
//                completionHandler(UIImage(data: data), nil)
            }
            
            print("Download of \(imageURL) finished")
            }.resume()
    }
} */



extension User: UserDelegate {
	static func create(ID: ObjectID, name: String, email: String, profilePictureURL: String) -> User {
		
		guard let url = URL(string: profilePictureURL) else {
			print("Couldn't create profile picture URL") // TODO: deal with this!
			
			return User(ID: ID, name: name, email: email, profilePictureURL: URL(fileURLWithPath: ""))
		}
		
		let user = User(ID: ID, name: name, email: email, profilePictureURL: url)
		Cache.set(inCache: .user, withID: ID, object: user)
		
		CloudKitMapper.createRecord(fromUser: user) // Saves it to the DB
		
		return user
	}
	
	
	func getUser(fromEmail: String) -> User? {
		// TODO: fazer query e pegar objeto. Implementar o query no CloudKitMapper. Vai dar trabalho.
		return nil
	}
}
