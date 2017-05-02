//
//  ControllerProtocols.swift
//  MOPT
//
//  Created by Gustavo Avena on 04/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import CloudKit

protocol MeetingDelegate {
    func getUserMeetings(userRecordID: CKRecordID, _ nextMeetings: Bool, completionHandler: @escaping ([CKRecord], Error?) -> Void) 
    func createMeeting(title: String, date: NSDate, moderatorRecordID: CKRecordID) 
    func addParticipant(meetingRecordID: CKRecordID, userEmail: String) 
    func startMeeting(meetingID: CKRecordID) 
    func endMeeting(meetingID: CKRecordID) 
    func changeCurrentTopic(meetingRecordID: CKRecordID, topicRecordID: CKRecordID?) 
    func removeParticipant(meetingRecordID: CKRecordID, participantRecordID: CKRecordID) 
}

protocol NewMeetingDelegate {
	static func create(title: String, date: Date, creator: ObjectID) -> Meeting
	func add(participant ID: ObjectID)
	func remove(participant ID: ObjectID)
	func add(topic ID: ObjectID)
	func remove(topic ID: ObjectID)
//	func add(subject ID: ObjectID)
//	func remove(subject ID: ObjectID)
	
}


protocol TopicDelegate {
    func createTopic(title: String, description: String, meetingRecordID: CKRecordID, creatorRecordID: CKRecordID) 
    func removeTopic(meetingRecordID: CKRecordID, topicRecordID: CKRecordID) //TEST
    func getMeetingTopics(meetingRecordID:CKRecordID, completionHandler: @escaping ([CKRecord], Error?)->Void) 
    func getSubtopics(topicRecordID: CKRecordID, completionHandler: @escaping ([CKRecord], Error?)-> Void) 
    func getTopicComments(topicRecordID: CKRecordID, completionHandler: @escaping ([CKRecord], Error?) -> Void) // Remove optional
    func addComment(topicRecordID: CKRecordID, commentText: String, creatorRecordID: CKRecordID) 
    func addTopicConclusion(topicRecordID: CKRecordID, conclusion: String) 
//    func startTopic(topicID: CKRecordID) // For later
//    func endTopic(topicID: CKRecordID) // For later
}

protocol NewTopicDelegate {
	static func create(title: String, meeting meetingID: ObjectID, creator creatorID: ObjectID, subject subjectID: ObjectID?, info: String?) -> Topic
	// LATER: startTime, endTime and expectedDuration
	func add(comment ID: ObjectID)
}

protocol CommentDelegate {
	func create(creator creatorID: ObjectID, topic topicID: ObjectID) -> Comment
}




protocol UserDelegate {
    func createUser(fbID: String, name: String, email: String, profilePictureURL: URL) 
    func getUserProfilePictureURL(userReference: CKReference, completionHandler: @escaping (URL?, Error?) -> Void)
//    func getCurrentUserRecordID(completionHandler: @escaping (CKRecordID?, Error?) -> Void)
    func getUserRecordFromEmail(email: String, completionHandler: @escaping (CKRecord?, Error?) -> Void) 
    func fetchFacebookUserInfo(completionHandler:@escaping ([String:Any]?, Error?) -> Void)
}

protocol NewUserDelegate {
	func create(ID: ObjectID, name: String, email: String, profilePictureURL: URL) -> User
	//    func getCurrentUserRecordID(completionHandler: @escaping (CKRecordID?, Error?) -> Void)
	func getUser(fromEmail: String) -> User?
	func fetchFacebookUserInfo(completionHandler:@escaping ([String:Any]?, Error?) -> Void)
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
