//
//  Meeting.swift
//  MOPT
//
//  Created by Gustavo Avena on 204//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import Foundation

class Meeting: NSObject {
	var ID: String
	var title: String
	var currentTopic: Topic?
	var date: Date
	var endTime: Date?
	var startTime: Date?
	var expectedDuration: TimeInterval?
	var creator: User
	var participants: [User]
	var topics: [Topic]
	
	
	
	init(ID: String, title: String, date: Date, creator: User, expectedDuration: TimeInterval?) {
		self.ID = ID
		self.title = title
		self.creator = creator
		self.date = date

		self.expectedDuration = expectedDuration
		self.participants = [creator]
		self.topics = [Topic]()
		
		
	}
	

	
}
