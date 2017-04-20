//
//  Comment.swift
//  MOPT
//
//  Created by Gustavo Avena on 204//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class Comment: NSObject {
	let ID: String
	var createdAt: Date = Date()
	var creator: User
	var text: String
	var topic: Topic
	
	init(ID: String, creator: User, text: String, topic: Topic) {
		self.ID = ID
		self.creator = creator
		self.text = text
		self.topic = topic
		
	}
	

}
