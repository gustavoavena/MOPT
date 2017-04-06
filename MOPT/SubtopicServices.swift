//
//  SubtopicServices.swift
//  MOPT
//
//  Created by Gustavo Avena on 31/03/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import CloudKit

class SubtopicServices: NSObject, SubtopicDelegate {
    
    let ckHandler: CloudKitHandler
    
    
    
    override init() {
        ckHandler = CloudKitHandler()
    }
    
    

    func createSubtopic(subtopicTitle: String, topicRecordID: CKRecordID, creatorRecordID: CKRecordID) {
        // Default SubtopicID string is: "[title]:[parentTopicID]:[creatorID]"
        let recordID = CKRecordID(recordName: String(format: "%@:%@:%@", subtopicTitle, topicRecordID.recordName, creatorRecordID.recordName))
        
        let subtopicRecord = CKRecord(recordType: "Subtopic", recordID: recordID)
        
        print("Creating Subtopic \(subtopicTitle) for topic = \(topicRecordID.recordName)")
        
        let parentTopicReference = CKReference(recordID: topicRecordID, action: .deleteSelf)
        let creatorReference = CKReference(recordID: creatorRecordID, action: .deleteSelf)
        
        subtopicRecord["title"] = subtopicTitle as NSString
        subtopicRecord["parentTopic"] = parentTopicReference
        subtopicRecord["creator"] = creatorReference
        
        
        ckHandler.saveRecord(record: subtopicRecord)
    }
    


    func getSubtopicComments(subtopicRecordID: CKRecordID, completionHandler: @escaping ([CKRecord]?, Error?) -> Void) {
        let subtopicReference = CKReference(recordID: subtopicRecordID, action: .deleteSelf)
        let predicate = NSPredicate(format: "subtopic = %@", subtopicReference)
        let query = CKQuery(recordType: "Comment", predicate: predicate)
        
        
        self.ckHandler.publicDB.perform(query, inZoneWith: nil) {
            (responseData, error) in
            guard error == nil && responseData != nil else {
                print("problem getting subtopics from meeting")
                completionHandler([CKRecord](), error)
                return
            }
            
            if let records = responseData {
                completionHandler(records, nil)
            } else {
                completionHandler([CKRecord](), nil)
            }
            
            
        }
        
        
    }
    
    

    func addComment(subtopicRecordID: CKRecordID, commentText: String, creatorRecordID: CKRecordID) {
        let subtopicReference = CKReference(recordID: subtopicRecordID, action: .deleteSelf)
        let creatorReference = CKReference(recordID: creatorRecordID, action: .deleteSelf)
        let createdAt = NSDate()
        let commentIDString = String(format: "%@:%@:%@", subtopicRecordID.recordName, createdAt.description, creatorRecordID.recordName)
        let commentRecordID = CKRecordID(recordName: commentIDString)
        let record = CKRecord(recordType: "Comment", recordID: commentRecordID)
        
        record["createdAt"] = createdAt
        record["text"] = commentText as NSString
        record["subtopic"] = subtopicReference
        record["creator"] = creatorReference
        
        self.ckHandler.saveRecord(record: record)
    }
    
    

    func addSubtopicConclusion(subtopicRecordID: CKRecordID, conclusion: String) {
        
        ckHandler.fetchByRecordID(recordID: subtopicRecordID) {
            (response, error) in
            
            guard error == nil else {
                print("error fetching subtopic to add conclusion.")
                return
            }
            
            if let subtopic = response {
                subtopic["conclusion"] = conclusion as NSString
                self.ckHandler.saveRecord(record: subtopic)
            } else {
                print("Couldn't save the conclusion.")
            }
        }
        
    }
    
    
    
    
    
}