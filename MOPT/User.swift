//
//  User.swift
//  MOPT
//
//  Created by Gustavo Avena on 204//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class User: NSObject, MoptObject {
	let ID: ObjectID = ""
	var meetingsIDs: [ObjectID]
	var meetings: [Meeting] {
		get {
			var _meetings = [Meeting]()
			
			for id in meetingsIDs {
				if let m = Meeting.meetings[id] {
					_meetings.append(m)
				}
			}
			return _meetings
		}
	}
	
	public static var users: [String: User] = [String: User]()

}
