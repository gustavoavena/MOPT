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
			if let meeting = Meeting.meetings[ID] {
				return meeting
			} else {
				print("Couldn't find Subject's meeting.")
				// TODO: fetch record and create object
				return Meeting.meetings[ID]! // TODO: remove this
			}
		}

	}
	
	var creator: User {
		get {
			if let creator = User.users[ID] {
				return creator
			} else {
				print("Couldn't find Subject's creator.")
				// TODO: fetch record and create object
				return User.users[ID]! // TODO: remove this
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
