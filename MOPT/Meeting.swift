//
//  Meeting.swift
//  MOPT
//
//  Created by Gustavo Avena on 204//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import Foundation

class Meeting: NSObject, MoptObject {
	let ID: ObjectID
	let creator: ObjectID
	var title: String {
		get {
			return title
		}
		set(newValue) {
			CKHandler.update(title: newValue, object: self)
		}
	}
	var date: Date
	var currentTopic: ObjectID?
	var endTime: Date?
	var startTime: Date?
	var expectedDuration: TimeInterval?
	var participantIDs: [ObjectID]
	var participants: [User] // computed property
	var topicIDs: [ObjectID] = [ObjectID]()
	var topics: [Topic] // computed property
	public static var meetings: [String: Meeting] = [String: Meeting]() // TODO: use internal??
	
	
	
	init(ID: String, title: String, date: Date, creatorID: ObjectID) {
		self.ID = ID
		self.title = title
		self.creator = creatorID
		self.date = date

		self.participantIDs = [creatorID]
	}
	
	convenience init(ID: String, title: String, date: Date, creatorID: ObjectID, expectedDuration: TimeInterval?) {
		self.init(ID: ID, title: title, date: date, creatorID: creatorID)
		self.expectedDuration = expectedDuration
	}
	
	
	
	

	
}
