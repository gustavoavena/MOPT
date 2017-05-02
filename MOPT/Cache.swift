//
//  Cache.swift
//  MOPT
//
//  Created by Gustavo Avena on 25//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import Dispatch



class Cache: NSObject {
	private static var meetings: [String: Meeting] = [String: Meeting]()
	private static var topics: [String: Topic] = [String: Topic]()
	private static var users: [String: User] = [String: User]()
	private static var comments: [String: Comment] = [String: Comment]()
	private static var subjects: [String: Subject] = [String: Subject]()
	
	
	
	
	public static func get(meetingWithID ID: ObjectID) -> Meeting? { // TODO: Abstract to MoptObject class??
		let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
		
		if let m = meetings[ID] {
			return m
		} else  {
			CloudKitMapper.create(objectType: .meeting, fromID: ID) { (object) in
				
				guard let meeting = object as? Meeting else {
					semaphore.signal()
					return
				}
				meetings[ID] = meeting
				semaphore.signal()
			}
		}
		
		semaphore.wait()
		return meetings[ID] ?? nil
	}
	
	private static func get(fromCache: MoptObjectType, withID ID: ObjectID) -> MoptObject? {
		switch fromCache {
		case .meeting:
			return meetings[ID]
		case .topic:
			return topics[ID]
		case .comment:
			return comments[ID]
		case .user:
			return users[ID]
		case .subject:
			return subjects[ID]
		default:
			print("Object cache not found")
			return nil
		}
	}
	

	public static func get(objectType: MoptObjectType, objectWithID ID: ObjectID) -> MoptObject? { 
		let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
		
		if let object = get(fromCache: objectType, withID: ID) {
			return object
		} else  {
			CloudKitMapper.create(objectType: objectType, fromID: ID) { (object) in
				
				guard let object = object else {
					semaphore.signal()
					return
				}

				switch objectType {
				case .meeting:
					meetings[ID] = (object as! Meeting)
				case .topic:
					topics[ID] = (object as! Topic)
				case .comment:
					comments[ID] = (object as! Comment)
				case .user:
					users[ID] = (object as! User)
				case .subject:
					subjects[ID] = (object as! Subject)
				default:
					print("Object cache not found")
				}
				
				semaphore.signal()
			}
		}
		
		semaphore.wait()
		return get(fromCache: objectType, withID: ID)
	}
	
	
}
