//
//  Topic.swift
//  MOPT
//
//  Created by Gustavo Avena on 204//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import Foundation

class Topic: NSObject, MoptObject {
	
	
	let ID: ObjectID
	var title: String
	let meetingID: ObjectID
	let creatorID: ObjectID
	var subjectID: ObjectID? = nil
	
	let date: Date
	
	
	
	var conclusion: String? // TODO: observer didSet that allows nil
	var info: String? // TODO: observer didSet that allows nil
	
	var endTime: Date? // TODO: observer didSet that allows nil
	var startTime: Date? // TODO: observer didSet that allows nil
	var expectedDuration: TimeInterval? // TODO: observer didSet that allows nil
	
	
	var commentIDs: [ObjectID] = [ObjectID]()
	
	var comments: [Comment] {
		get {
			var _comments = [Comment]()
			
			for id in commentIDs {
				if let comment = Cache.get(objectType: .comment, objectWithID: id) as? Comment {
					_comments.append(comment)
				}
			}
			return _comments
		}
	}
	
	var meeting: Meeting {
		get {
			return Cache.get(objectType: .meeting, objectWithID: meetingID) as! Meeting // TODO: make sure this is never nil!
		}

	}
	var creator: User {
		get {
			return Cache.get(objectType: .user, objectWithID: creatorID) as! User // TODO: make sure this is never nil!
		}
	}
	
	init(ID: String, title: String, creatorID: ObjectID, meetingID: ObjectID, date: Date) {
		self.ID = ID
		self.title = title
		self.creatorID = creatorID
		self.meetingID = meetingID
		self.date = date
	}
	
	// Use this
	convenience init(ID: String, title: String, creator creatorID: ObjectID, meeting meetingID: ObjectID, subject subjectID: ObjectID?, info: String?, date: Date) {
		self.init(ID: ID, title: title, creatorID: creatorID, meetingID: meetingID, date: date)
		self.subjectID = subjectID
		self.info = info
	}

	
	convenience init(ID: String, title: String, creatorID: ObjectID, meetingID: ObjectID, subjectID: ObjectID, date: Date) {
		self.init(ID: ID, title: title, creatorID: creatorID, meetingID: meetingID, date: date)
		self.subjectID = subjectID
	}
	
	
	
	convenience init(ID: String, title: String, creatorID: ObjectID, meetingID: ObjectID,  expectedDuration: TimeInterval, date: Date) {
		self.init(ID: ID, title: title, creatorID: creatorID, meetingID: meetingID, date: date)
		self.expectedDuration = expectedDuration
	}
	
	convenience init(ID: String, title: String, creatorID: ObjectID, meetingID: ObjectID, info: String, date: Date) {
		self.init(ID: ID, title: title, creatorID: creatorID, meetingID: meetingID, date: date)
		self.info = info
	}
	
	convenience init(ID: String, title: String, creatorID: ObjectID, meetingID: ObjectID, info: String, expectedDuration: TimeInterval, date: Date) {
		self.init(ID: ID, title: title, creatorID: creatorID, meetingID: meetingID, date: date)
		self.info = info
		self.expectedDuration = expectedDuration
	}

}
