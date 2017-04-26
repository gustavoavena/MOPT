//
//  Topic.swift
//  MOPT
//
//  Created by Gustavo Avena on 204//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class Topic: NSObject, MoptObject {
	let ID: ObjectID
	let meetingID: ObjectID // TODO: fix inheritance problem.
	let creatorID: ObjectID
	var title: String
	var commentIDs: [ObjectID] = [ObjectID]()
	var comments: [Comment] // Computed property
	var conclusion: String?
	var info: String?
	var endTime: Date?
	var startTime: Date?
	var expectedDuration: TimeInterval?
	
	public static var topics: [String: Topic] = [String: Topic]()
	
	init(ID: String, title: String, creatorID: ObjectID, meetingID: ObjectID) {
		self.ID = ID
		self.title = title
		self.creatorID = creatorID
		self.meetingID = meetingID
	}
	
	convenience init(ID: String, title: String, creatorID: ObjectID, meetingID: ObjectID,  expectedDuration: TimeInterval) {
		self.init(ID: ID, title: title, creatorID: creatorID, meetingID: meetingID)
		self.expectedDuration = expectedDuration
	}
	
	convenience init(ID: String, title: String, creatorID: ObjectID, meetingID: ObjectID, info: String) {
		self.init(ID: ID, title: title, creatorID: creatorID, meetingID: meetingID)
		self.info = info
	}
	
	convenience init(ID: String, title: String, creatorID: ObjectID, meetingID: ObjectID, info: String, expectedDuration: TimeInterval) {
		self.init(ID: ID, title: title, creatorID: creatorID, meetingID: meetingID)
		self.info = info
		self.expectedDuration = expectedDuration
	}
	
	

}
