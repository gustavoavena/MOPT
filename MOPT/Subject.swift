//
//  Subject.swift
//  MOPT
//
//  Created by Gustavo Avena on 204//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import Foundation

class Subject: NSObject, MoptObject {
	
	
	let ID: ObjectID
	let meetingID: ObjectID
	let creatorID: ObjectID
	var title: String
	
	var topicIDs: [ObjectID] = [ObjectID]()
	
	var topics: [Topic] = [Topic]() // TODO: implement computed property
	
	var meeting: Meeting {
		get {
			if let meeting = Cache.get(objectType: .meeting, objectWithID: ID) {
				return meeting as! Meeting
			}
		}
	}
	
	var creator: User {
		get {
			if let creator = Cache.get(objectType: .user, objectWithID: ID) {
				return creator as! User
			}
		}
	}
	
	init(ID: String, title: String, creatorID: ObjectID, meetingID: ObjectID) {
		self.ID = ID
		self.title = title
		self.creatorID = creatorID
		self.meetingID = meetingID
	}
	

}
