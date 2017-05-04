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
	var title: String
	
	var topicIDs: [ObjectID] = [ObjectID]()
	
	var topics: [Topic] {
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
	
	// Does the subject need a reference to the creator and/or meeting
	
//	let meetingID: ObjectID
//	let creatorID: ObjectID
//	
//	var meeting: Meeting {
//		get {
//			if let meeting = Cache.get(objectType: .meeting, objectWithID: ID) {
//				return meeting as! Meeting
//			}
//		}
//	}
//	
//	var creator: User {
//		get {
//			if let creator = Cache.get(objectType: .user, objectWithID: ID) {
//				return creator as! User
//			}
//		}
//	}
	
	init(ID: ObjectID, title: String) {
		self.ID = ID
		self.title = title
	}
	
//	init(ID: String, title: String, creatorID: ObjectID, meetingID: ObjectID) {
//		self.ID = ID
//		self.title = title
//		self.creatorID = creatorID
//		self.meetingID = meetingID
//	}
	

}
