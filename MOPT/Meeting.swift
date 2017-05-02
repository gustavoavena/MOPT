//
//  Meeting.swift
//  MOPT
//
//  Created by Gustavo Avena on 204//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import Foundation

enum DBStatus {
	case found
	case notFound
	case fetching
	case empty
}


class Meeting: NSObject, MoptObject {
	private static var meetings: [String: Meeting] = [String: Meeting]() // TODO: use internal??
	static var fetching: [ObjectID: DBStatus] = [ObjectID:DBStatus]() // TODO: set default to false
	
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
			if let ct = currentTopicID, let topic = Topic.get(topicWithID: ct) {
				return topic
			}
			return nil
			
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
				if let topic = Topic.get(topicWithID: id) {
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
		self.creatorID = creatorID
		self.date = date

		self.participantIDs = [creatorID]
	}
	
	convenience init(ID: String, title: String, date: Date, creatorID: ObjectID, expectedDuration: TimeInterval?) {
		self.init(ID: ID, title: title, date: date, creatorID: creatorID)
		self.expectedDuration = expectedDuration
	}
	
	// TODO: user setters instead of observers??
	
	
	public static func get(meetingWithID ID: ObjectID) -> Meeting? {
		
		
		if let m = Meeting.meetings[ID] {
				return m
		} else if fetching[ID] == DBStatus.empty {
			fetching[ID] = DBStatus.fetching
			CloudKitMapper.create(objectType: .meeting, fromID: ID) { (object, error) in
				guard let meeting = object as? Meeting else {
					fetching[ID] = .notFound
					return
				}
				Meeting.meetings[ID] = meeting
				fetching[ID] = .found
			}
			return get(meetingWithID: ID)
		} else {
			while(fetching[ID] == DBStatus.fetching) {}
			
			if fetching[ID] == .found {
				fetching[ID] = .empty
				return get(meetingWithID:ID)
			} else { // Not found
				fetching[ID] = .empty
				return nil
			}
		}
		
	}
	

	
}
