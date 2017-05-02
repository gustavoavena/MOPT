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
	
	var text: String // TODO: observer didSet that doesn't allow nil
	
	var topic: Topic {
		get {
			return Cache.get(objectType: .topic, objectWithID: topicID) as! Topic // TODO: make sure this is never nil!
		}
	}
	var creator: User {
		get {
			return Cache.get(objectType: .user, objectWithID: creatorID) as! User // TODO: make sure this is never nil!
		}
	}
	
	
	
	init(ID: String, creatorID: ObjectID, text: String, topicID: ObjectID) {
		self.ID = ID
		self.creatorID = creatorID
		self.text = text
		self.topicID = topicID
		
	}
	

}
