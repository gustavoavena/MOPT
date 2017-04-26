//
//  Meeting.swift
//  MOPT
//
//  Created by Gustavo Avena on 204//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import Foundation

class Meeting: NSObject, MoptObject {
	public static var meetings: [String: Meeting] = [String: Meeting]() // TODO: use internal??
	
	let ID: ObjectID
	let creator: ObjectID
	var title: String {
		didSet {
			CloudKitMapper.update(title: title, object: self)
		}
	}
	var date: Date {
		didSet {
			CloudKitMapper.update(date: date, object: self)
		}
	}
	var currentTopic: ObjectID? {
		didSet {
			if let ct = currentTopic {
				CloudKitMapper.update(currentTopicID: ct, object: self)
			}
			// TODO: currentTopic set to nil?
		}
	}
	var endTime: Date?
	var startTime: Date?
	var expectedDuration: TimeInterval?
	var participantIDs: [ObjectID]
	var topicIDs: [ObjectID] = [ObjectID]()
	
	var topics: [Topic]  {
		get {
			var _topics = [Topic]()
			for id in topicIDs {
				if let topic = Topic.topics[id] {
					_topics.append(topic)
				}
			}
			return _topics
		}
	}
	
	var participants: [User]  {
		get {
			var _participants = [User]()
			for id in participantIDs {
				if let p = User.users[id] {
					_participants.append(p)
				}
			}
			return _participants
		}
	}
	
	
	
	
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
	
	// TODO: user setters instead of observers??
	
	
	
	

	
}
