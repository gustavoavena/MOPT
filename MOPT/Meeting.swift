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
	let creatorID: ObjectID
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
	var currentTopicID: ObjectID?
	var currentTopic: Topic? {
		get {
			if let ct = currentTopicID, let topic = Cache.get(objectType: .topic, objectWithID: ct) {
				return (topic as! Topic)
			} else {
				return nil
			}
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
				if let topic = Cache.get(objectType: .topic, objectWithID: id) {
					_topics.append(topic as! Topic)
				}
			}
			return _topics
		}
	}
	
	var participants: [User]  {
		get {
			var _participants = [User]()
			for id in participantIDs {
				if let p = Cache.get(objectType: .user, objectWithID: id) {
					_participants.append(p as! User)
				}
			}
			return _participants
		}
	}
	
	
	
	
	init(ID: String, title: String, date: Date, creatorID: ObjectID) {
		self.ID = ID
		self.title = title
		self.creatorID = creatorID
		self.date = date

		self.participantIDs = [creatorID]
	}
	
	convenience init(ID: String, title: String, date: Date, creatorID: ObjectID, expectedDuration: TimeInterval?) {
		self.init(ID: ID, title: title, date: date, creatorID: creatorID)
		self.expectedDuration = expectedDuration
	}
	
	// TODO: user setters instead of observers??
	
	
		

	
}
