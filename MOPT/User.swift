//
//  User.swift
//  MOPT
//
//  Created by Gustavo Avena on 204//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class User: NSObject, MoptObject {
	
	
	let ID: ObjectID
	let name: String
	let email: String
	let profilePictureURL: URL // Store a string instead of an URL?
	var meetingsIDs: [ObjectID] = [ObjectID]()
	
	var meetings: [Meeting] {
		get {
			var _meetings = [Meeting]()
			
			for id in meetingsIDs {
				if let m = Cache.get(objectType: .meeting, objectWithID: id) as? Meeting {
					_meetings.append(m)
				}
			}
			return _meetings
		}
	}
	
	
	
	init(ID: ObjectID, name: String, email: String, profilePictureURL: URL) {
		self.ID = ID
		self.name = name
		self.email = email
		self.profilePictureURL = profilePictureURL
	}
	
	

}


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
    
    
    func getUser(withEmail: String) -> User? {
        // TODO: fazer query e pegar objeto. Implementar o query no CloudKitMapper. Vai dar trabalho.
        return nil
    }
    
    
}

