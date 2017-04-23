//
//  User.swift
//  MOPT
//
//  Created by Gustavo Avena on 204//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class User: NSObject {
	let ID: String = ""
	var meetingsIDs: [String]
	var meetings: [Meeting] {
		get {
			// get all meeting objects with a query
		}
		// there is no set! it's read-only!
	}
//	var meetings: [Meeting] {
//		get {
//			return getMeetings(fromUser: self)
//		}
//	}

}
