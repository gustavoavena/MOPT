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
	
	var topic: Topic
	var creator: User
	
	public static var comments: [String: Comment] = [String: Comment]()
	
	init(ID: String, creatorID: ObjectID, text: String, topicID: ObjectID) {
		self.ID = ID
		self.creatorID = creatorID
		self.text = text
		self.topicID = topicID
		
	}
	

}
