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
    
    
}


protocol TopicDelegate {
    func createTopic(title: String, description: String, meetingRecordID: CKRecordID, creatorRecordID: CKRecordID)
    func getMeetingTopics(meetingRecordID:CKRecordID, completionHandler: ([CKRecord]?, Error?)->Void)
    func getSubtopics(topicRecordID: CKRecordID, completionHandler: ([CKRecord]?, Error?)-> Void)
    func getTopicComments(commentsReferenceList: NSArray, completionHandler: ([CKRecord]?, Error?) -> Void)
    func addComment(topicRecordID: CKRecordID, commentText: String, creatorRecordID: CKRecordID)
    func addTopicConclusion(topicRecordID: CKRecordID, conclusion: String)
}

protocol SubtopicDelegate {
    func createSubtopic(topicRecordID: CKRecordID, subtopicTitle: String, creatorRecordID: CKRecordID)
    func getSubtopicComments(commentsReferenceList: NSArray, completionHandler: ([CKRecord]?, Error?) -> Void)
    func addComment(subtopicRecordID: CKRecordID, commentText: String, creatorRecordID: CKRecordID)
    func addSubtopicConclusion(subtopicRecordID: CKRecordID, conclusion: String)
}




protocol UserDelegate {
    func createUser(fbID: Int, name: String, email: String, profilePictureURL: URL) // DONE
    func getUserProfilePictureURL(userReference: CKReference, completionHandler: (URL?, Error?) -> Void)
    func getCurrentUserRecordID() -> CKRecordID // TODO: Write global function to get current user's CKRecordID from his Facebook ID.
    func getUserRecordFromEmail(email: String, completionHandler: (CKRecord?, Error?)->Void) // DONE
    
    
}

