//
//  Topic.swift
//  MOPT
//
//  Created by Gustavo Avena on 204//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class Topic: NSObject {
	let ID: String
	var title: String
	var meeting: Meeting
	var creator: User
	var comments: [Comment] = [Comment]()
	var conclusion: String?
	var info: String?
	var endTime: Date?
	var startTime: Date?
	var expectedDuration: TimeInterval?
	
	
	init(ID: String, title: String, creator: User, meeting: Meeting, info: String?, expectedDuration: TimeInterval?) {
		self.ID = ID
		self.title = title
		self.creator = creator
		self.meeting = meeting
		self.info = info
		
		self.expectedDuration = expectedDuration
	}
	
	

}
