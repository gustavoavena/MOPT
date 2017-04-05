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
    // TODO: Default value for getUserNextMeetings
    func getUserMeetings(userRecordID: CKRecordID, _ nextMeetings: Bool, completionHandler: ([CKRecord]?, Error?) -> Void)
    func createMeeting(title: String, date: NSDate, moderatorRecordID: CKRecordID)
    func addParticipant(meetingRecordID: CKRecordID, userEmail: String) // DONE
    func startMeeting(meetingID: CKRecordID)
    func endMeeting(meetingID: CKRecordID)
    
    
}


protocol TopicDelegate {
    func createTopic(title: String, description: String, meetingRecordID: CKRecordID, creatorRecordID: CKRecordID) // DONE
    func getMeetingTopics(meetingRecordID:CKRecordID, completionHandler: ([CKRecord], Error?)->Void) // DONE
    func getSubtopics(topicRecordID: CKRecordID, completionHandler: ([CKRecord]?, Error?)-> Void) // TODO: Test it.
    func getTopicComments(topicRecordID: CKRecordID, completionHandler: ([CKRecord]?, Error?) -> Void) // DONE
    func addComment(topicRecordID: CKRecordID, commentText: String, creatorRecordID: CKRecordID) // DONE
    func addTopicConclusion(topicRecordID: CKRecordID, conclusion: String) // DONE
    func startTopic(topicID: CKRecordID)
    func endTopic(topicID: CKRecordID)
}

protocol SubtopicDelegate {
    func createSubtopic(topicRecordID: CKRecordID, subtopicTitle: String, creatorRecordID: CKRecordID)
    func getSubtopicComments(subtopicRecordID: CKRecordID, completionHandler: ([CKRecord]?, Error?) -> Void)
    func addComment(subtopicRecordID: CKRecordID, commentText: String, creatorRecordID: CKRecordID)
    func addSubtopicConclusion(subtopicRecordID: CKRecordID, conclusion: String)
    func startSubtopic(subtopicID: CKRecordID)
    func endSubtopic(subtopicID: CKRecordID)
}




protocol UserDelegate {
    func createUser(fbID: Int, name: String, email: String, profilePictureURL: URL) // DONE
    func getUserProfilePictureURL(userReference: CKReference, completionHandler: (URL?, Error?) -> Void)
    func getCurrentUserRecordID() -> CKRecordID // TODO: Write global function to get current user's CKRecordID from his Facebook ID.
    func getUserRecordFromEmail(email: String, completionHandler: (CKRecord?, Error?)->Void) // DONE
    
    
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
