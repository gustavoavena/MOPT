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
    func getUserMeetings(userRecordID: CKRecordID, _ nextMeetings: Bool, completionHandler: @escaping ([CKRecord], Error?) -> Void) // DONE
    func createMeeting(title: String, date: NSDate, moderatorRecordID: CKRecordID) // DONE
    func addParticipant(meetingRecordID: CKRecordID, userEmail: String) // DONE
    func startMeeting(meetingID: CKRecordID) // DONE
    func endMeeting(meetingID: CKRecordID) // DONE
    func changeCurrentTopic(meetingRecordID: CKRecordID, topicRecordID: CKRecordID?) // Test
    func removeParticipant(meetingRecordID: CKRecordID, participantRecordID: CKRecordID) // TEST
    
    
}


protocol TopicDelegate {
    func createTopic(title: String, description: String, meetingRecordID: CKRecordID, creatorRecordID: CKRecordID) // DONE
    func removeTopic(meetingRecordID: CKRecordID, topicRecordID: CKRecordID) //TEST
    func getMeetingTopics(meetingRecordID:CKRecordID, completionHandler: @escaping ([CKRecord], Error?)->Void) // DONE
    func getSubtopics(topicRecordID: CKRecordID, completionHandler: @escaping ([CKRecord], Error?)-> Void) // DONE
    func getTopicComments(topicRecordID: CKRecordID, completionHandler: @escaping ([CKRecord], Error?) -> Void) // Remove optional
    func addComment(topicRecordID: CKRecordID, commentText: String, creatorRecordID: CKRecordID) // DONE
    func addTopicConclusion(topicRecordID: CKRecordID, conclusion: String) // DONE
//    func startTopic(topicID: CKRecordID) // For later
//    func endTopic(topicID: CKRecordID) // For later
}

protocol SubtopicDelegate {
    func createSubtopic(subtopicTitle: String, topicRecordID: CKRecordID, creatorRecordID: CKRecordID) // DONE
    func getSubtopicComments(subtopicRecordID: CKRecordID, completionHandler: @escaping ([CKRecord], Error?) -> Void) // DONE    func addComment(subtopicRecordID: CKRecordID, commentText: String, creatorRecordID: CKRecordID) // DONE
    func addSubtopicConclusion(subtopicRecordID: CKRecordID, conclusion: String) // DONE
//    func startSubtopic(subtopicID: CKRecordID)
//    func endSubtopic(subtopicID: CKRecordID)
}




protocol UserDelegate {
    func createUser(fbID: String, name: String, email: String, profilePictureURL: URL) // DONE
    func getUserProfilePictureURL(userReference: CKReference, completionHandler: @escaping (URL?, Error?) -> Void)
//    func getCurrentUserRecordID(completionHandler: @escaping (CKRecordID?, Error?) -> Void)
    func getUserRecordFromEmail(email: String, completionHandler: @escaping (CKRecord?, Error?) -> Void) // DONE
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
