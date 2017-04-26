//
//  Subtopic.swift
//  MOPT
//
//  Created by Gustavo Avena on 204//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class Subtopic: Topic {
	public static var subtopics: [String: Subtopic] = [String: Subtopic]()
	
	let parentTopicID: ObjectID
	var parentTopic: Topic {
		get {
			if let parentTopic = Topic.topics[self.parentTopicID] {
				return parentTopic
			} else {
				// call method that will fetch the record and create the object
				print("ParentTopic not found! Error") // TODO: define error and find out what to do here...
				return Topic.topics[self.parentTopicID]!
			}
		}
		
	}
	
	
	init(ID: String, title: String, creatorID: ObjectID, parentTopicID: ObjectID) {
		self.parentTopicID = parentTopicID
		super.init(ID: ID, title: title, creatorID: creatorID, meetingID: "")
	}
	
}
