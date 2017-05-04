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
	
	let meetingID: ObjectID
	
	var meeting: Meeting {
		get {
			if let meeting = Cache.get(objectType: .meeting, objectWithID: meetingID) {
				return meeting as! Meeting
			}
		}
	}
	
    init(ID: ObjectID, title: String, meetingID: ObjectID) {
		self.ID = ID
		self.title = title
        self.meetingID = meetingID
	}
}
