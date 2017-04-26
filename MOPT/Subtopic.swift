//
//  Subtopic.swift
//  MOPT
//
//  Created by Gustavo Avena on 204//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class Subtopic: Topic {
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
	
	public static var subtopics: [String: Subtopic] = [String: Subtopic]()
	
	init(ID: String, title: String, creatorID: ObjectID, parentTopicID: ObjectID) {
		super.init(ID: ID, title: title, creatorID: creatorID, meetingID: "")
		self.parentTopicID = parentTopicID
	}
	
}
