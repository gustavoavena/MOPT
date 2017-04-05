//
//  TopicServices.swift
//  MOPT
//
//  Created by Gustavo Avena on 31/03/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import CloudKit

class TopicServices: NSObject {
    
    let ckHandler: CloudKitHandler
    
    var topics: [CKRecord]
    
    
    override init() {
        ckHandler = CloudKitHandler()
        topics = [CKRecord]()
    }
    
    // DONE: obeys protocol.
    func createTopic(title: String, description: String, meetingRecordID: CKRecordID, creatorRecordID:CKRecordID) {
        // Default topicID string is: "[title]:[meetingID]"
        let recordID = CKRecordID(recordName: String(format: "%@:%@", title, meetingRecordID.recordName))
        
        let topicRecord = CKRecord(recordType: "Topic", recordID: recordID)
        
        print("Creating topic \(title) in meeting = \(meetingRecordID.recordName)")
        
        let meetingReference = CKReference(recordID: meetingRecordID, action: .deleteSelf)
        let creatorReference = CKReference(recordID: creatorRecordID, action: .deleteSelf)
        
        topicRecord["title"] = title as NSString
        topicRecord["description"] = description as NSString
        topicRecord["meeting"] = meetingReference
        topicRecord["creator"] = creatorReference
        
        
        ckHandler.saveRecord(record: topicRecord)
    }
    
    // DONE: obeys protocol.
    func getMeetingTopics(meetingRecordID:CKRecordID, completionHandler: @escaping ([CKRecord], Error?)->Void) {
        let meetingReference = CKReference(recordID: meetingRecordID, action: .deleteSelf)
        let predicate = NSPredicate(format: "meeting = %@", meetingReference)
        let query = CKQuery(recordType: "Topic", predicate: predicate)
        
        self.ckHandler.publicDB.perform(query, inZoneWith: nil) {
            (responseData, error) in
            
            guard error == nil && responseData != nil else {
                print("problem getting topics from meeting")
                return
            }
            
            let records = responseData!
            
            completionHandler(records, error)
            
        }
    }
    
    // TODO: test it after creating subtopics.
    func getSubtopics(topicRecordID: CKRecordID, completionHandler: @escaping ([CKRecord]?, Error?)-> Void) {
        let topicReference = CKReference(recordID: topicRecordID, action: .deleteSelf)
        let predicate = NSPredicate(format: "topic = %@", topicReference)
        let query = CKQuery(recordType: "Subtopic", predicate: predicate)
        
        self.ckHandler.publicDB.perform(query, inZoneWith: nil) {
            (responseData, error) in
            
            guard error == nil && responseData != nil else {
                print("problem getting topics from meeting")
                return
            }
            
            let records = responseData!
            
            completionHandler(records, error)
            
        }

    }

    
      
    



}
