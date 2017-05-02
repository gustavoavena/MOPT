//
//  ControllerProtocols.swift
//  MOPT
//
//  Created by Gustavo Avena on 04/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import Foundation

protocol MeetingDelegate {
	static func create(title: String, date: Date, creator: ObjectID) -> Meeting
	func add(participant ID: ObjectID)
	func remove(participant ID: ObjectID)
	func add(topic ID: ObjectID)
	func remove(topic ID: ObjectID)
//	func add(subject ID: ObjectID)
//	func remove(subject ID: ObjectID)
	
}


protocol TopicDelegate {
	static func create(title: String, meeting meetingID: ObjectID, creator creatorID: ObjectID, subject subjectID: ObjectID?, info: String?) -> Topic
	func add(comment ID: ObjectID)
	// LATER: startTime, endTime and expectedDuration
}

protocol CommentDelegate {
	func create(creator creatorID: ObjectID, topic topicID: ObjectID) -> Comment
}

// TODO: SubjectDelegate


protocol UserDelegate {
	func create(ID: ObjectID, name: String, email: String, profilePictureURL: String) -> User
	func getUser(fromEmail: String) -> User?
	func fetchFacebookUserInfo(completionHandler:@escaping ([String:Any]?, Error?) -> Void)
	//    func getCurrentUserRecordID(completionHandler: @escaping (CKRecordID?, Error?) -> Void)
}





/*

 Naming patterns:
 
 When we create a record, we need to define a recordName to its recordID object. Listed below are the rules for creating those recordNames while maintaining a strict pattern:
 
 
 User: string of its facebookID, provided by Facebook's API.
 Meeting: "[meeting title]:[creator's record ID]:[created at (use the description attribute from NSDate]
 Topic: "[title]:[meeting record ID]:[creator's ID]"
 Comment: "[topic record ID]:[createdAt string]:[creator's record ID]"
 Subtopic: "[subtopic title]:[parent topic record ID]:[creator's record ID]"
 
 
 **Note: When I say record ID, I'm refering to the recordID object's recordName attribute (the string that we're defining here).
 
 
 */

/*
 
 
 
 
 */
