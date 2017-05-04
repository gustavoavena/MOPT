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
	let profilePictureURL: URL
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
