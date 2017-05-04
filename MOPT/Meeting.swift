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
	static var fetching: [ObjectID: DBStatus] = [ObjectID:DBStatus]() // TODO: set default to false
	
	
	let ID: ObjectID
	let creatorID: ObjectID
	
	var creator: User {
		get {
			return Cache.get(objectType: .user, objectWithID: creatorID) as! User // FIXME: make sure this is never nil!
		}
	}
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
	
	var currentTopicID: ObjectID? // TODO: observer didSet that allows nil

	var currentTopic: Topic? {
		get {
			if let ct = currentTopicID, let topic = Cache.get(objectType: .topic, objectWithID: ct) as? Topic {
				return topic
			} else {
				return nil
			}
		}
		set(currentTopic) {
			if let currentTopic = currentTopic {
				currentTopicID = currentTopic.ID
			} else {
				currentTopicID = nil
			}
		}
	}
	var endTime: Date? // TODO: observer didSet that allows nil
	var startTime: Date? // TODO: observer didSet that allows nil
	var expectedDuration: TimeInterval? // TODO: observer didSet that allows nil
	var participantIDs: [ObjectID]
	var topicIDs: [ObjectID] = [ObjectID]()
	var subjectIDs: [ObjectID] = [ObjectID]()
	
	var topics: [Topic]  {
		get {
			var _topics = [Topic]()
			for id in topicIDs {
				if let topic = Cache.get(objectType: .topic, objectWithID: id) as? Topic {
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
				if let p = Cache.get(objectType: .user, objectWithID: id) as? User {
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
	
	// MARK: use setters instead of observers??

	
	
	public static func get(meetingWithID ID: ObjectID) -> Meeting? { // TODO: Abstract to MoptObject class??
		
		
		if let m = Meeting.meetings[ID] {
				return m
		} else if (fetching[ID] ?? .empty) == DBStatus.empty {
			fetching[ID] = DBStatus.fetching
			
			CloudKitMapper.create(objectType: .meeting, fromID: ID) { (object) in
				
				guard let meeting = object as? Meeting else {
					fetching[ID] = .notFound
					return
				}
				Meeting.meetings[ID] = meeting
				fetching[ID] = .found
			}
			
			return get(meetingWithID: ID)
            
		} else {
			while(fetching[ID] == DBStatus.fetching) {} // Wait until operation finishes.
			
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
