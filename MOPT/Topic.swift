//
//  Topic.swift
//  MOPT
//
//  Created by Gustavo Avena on 204//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import Foundation

class Topic: NSObject, MoptObject {
	public static var topics: [String: Topic] = [String: Topic]()
	static var fetching: [ObjectID: DBStatus] = [ObjectID:DBStatus]() // TODO: set default to false
	
	let ID: ObjectID
	let meetingID: ObjectID // TODO: fix inheritance problem.
	let creatorID: ObjectID
	let subjectID: ObjectID?
	
	var title: String
	var conclusion: String?
	var info: String?
	var endTime: Date?
	var startTime: Date?
	var expectedDuration: TimeInterval?
	var commentIDs: [ObjectID] = [ObjectID]()
	
	var comments: [Comment] {
		get {
			var _comments = [Comment]()
			
			for id in commentIDs {
				if let comment = Comment.comments[id] {
					_comments.append(comment)
				}
			}
			return _comments
		}
	}
	
	var meeting: Meeting {
		get {
			if let meeting = Meeting.get(meetingWithID: meetingID) {
				return meeting
			}
		}
	}
	var creator: User {
		get {
			if let creator = User.users[ID] {
				return creator
			} else {
				print("Couldn't find Topic's creator.")
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
	
	public static func get(topicWithID ID: ObjectID) -> Topic? {
		
		if let m = Topic.topics[ID] {
			return m
		} else if (fetching[ID] ?? .empty) == DBStatus.empty { // Default value to empty
			fetching[ID] = DBStatus.fetching
			
			CloudKitMapper.create(objectType: .meeting, fromID: ID) { (object) in
				
				guard let meeting = object as? Topic else {
					fetching[ID] = .notFound
					return
				}
				Topic.topics[ID] = meeting
				fetching[ID] = .found
			}
			
			return get(topicWithID: ID)
		} else {
			while(fetching[ID] == DBStatus.fetching) {} // Wait until operation finishes.
			
			if fetching[ID] == .found {
				fetching[ID] = .empty
				return get(topicWithID:ID)
			} else { // Not found
				fetching[ID] = .empty
				return nil
			}
		}
		
	}

}
