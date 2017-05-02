//
//  Comment.swift
//  MOPT
//
//  Created by Gustavo Avena on 204//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class Comment: NSObject, MoptObject {
	let ID: ObjectID
	let createdAt: Date = Date()
	let creatorID: ObjectID
	let topicID: ObjectID
	var text: String
	
	var topic: Topic {
		get {
			if let topic = Topic.topics[ID] {
				return topic
			} else {
				print("Couldn't find Comment's topic.")
				// TODO: fetch record and create object
				return Topic.topics[ID]! // TODO: remove this
			}
		}
	}
	var creator: User {
		get {
			if let creator = User.users[ID] {
				return creator
			} else {
				print("Couldn't find Comment's user.")
				// TODO: fetch record and create object
				return User.users[ID]! // TODO: remove this
			}
		}
	}
	
	
	
	init(ID: String, creatorID: ObjectID, text: String, topicID: ObjectID) {
		self.ID = ID
		self.creatorID = creatorID
		self.text = text
		self.topicID = topicID
		
	}
	

}
