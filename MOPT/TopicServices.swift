//
//  TopicServices.swift
//  MOPT
//
//  Created by Gustavo Avena on 31/03/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import CloudKit

class TopicServices: NSObject, TopicDelegate {
    
    let ckHandler: CloudKitHandler
    
    
    
    override init() {
        ckHandler = CloudKitHandler()
    }
    
    func createTopic(title: String, description: String, meetingRecordID: CKRecordID, creatorRecordID:CKRecordID) {
        // Default topicID string is: "[title]:[meetingID]"
        let recordID = CKRecordID(recordName: String(format: "%@:%@:%@", title, meetingRecordID.recordName, creatorRecordID.recordName))
        
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
    
    
    //TODO: test, insert in protocol
    func removeTopic(meetingRecordID: CKRecordID, topicRecordID: CKRecordID) {
        
        ckHandler.fetchByRecordID(recordID: meetingRecordID) {
            (recordResponse, error) in
            
            guard error == nil && recordResponse != nil else {
                print("Error fetching meeting")
                return
            }
            
            let record = recordResponse!
            var topics: [CKReference] = record["topic"] as! [CKReference]
            let topicReference = CKReference(recordID: topicRecordID, action: .none)
            
            //remover CKReference (participantReference) da NSArray (participants)
            let index = topics.index(of: topicReference)
            //index! (force unwrap): posso garantir que index nao sera nil, pois para um topico ser removido ele deve existir na tela do usuario (nao existe possibilidade de tentar remover um topico que nao existe) -- TODO: comentar em ingles
            topics.remove(at: index!)
            
            record["participants"] = topics as NSArray
            
            print("topic \(topicRecordID.recordName) removed from meeting \(meetingRecordID.recordName).")
            
            self.ckHandler.saveRecord(record: record)
        }
    }
    
    
    func getMeetingTopics(meetingRecordID: CKRecordID, completionHandler: @escaping ([CKRecord], Error?)->Void) {
        let meetingReference = CKReference(recordID: meetingRecordID, action: .deleteSelf)
        let predicate = NSPredicate(format: "meeting = %@", meetingReference)
        let query = CKQuery(recordType: "Topic", predicate: predicate)
        
        self.ckHandler.publicDB.perform(query, inZoneWith: nil) {
            (responseData, error) in
            
            guard error == nil && responseData != nil else {
                print("problem getting topics from meeting")
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
    
   
    func getSubtopics(topicRecordID: CKRecordID, completionHandler: @escaping ([CKRecord]?, Error?)-> Void) {
        let topicReference = CKReference(recordID: topicRecordID, action: .deleteSelf)
        let predicate = NSPredicate(format: "parentTopic = %@", topicReference)
        let query = CKQuery(recordType: "Subtopic", predicate: predicate)
        
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
    
    
    func getTopicComments(topicRecordID: CKRecordID, completionHandler: @escaping ([CKRecord]?, Error?) -> Void) {
        let topicReference = CKReference(recordID: topicRecordID, action: .deleteSelf)
        let predicate = NSPredicate(format: "topic = %@", topicReference)
        let query = CKQuery(recordType: "Comment", predicate: predicate)
        
        
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

    
    func addComment(topicRecordID: CKRecordID, commentText: String, creatorRecordID: CKRecordID) {
        let topicReference = CKReference(recordID: topicRecordID, action: .deleteSelf)
        let creatorReference = CKReference(recordID: creatorRecordID, action: .deleteSelf)
        let createdAt = NSDate()
        let commentIDString = String(format: "%@:%@:%@", topicRecordID.recordName, createdAt.description, creatorRecordID.recordName)
        let commentRecordID = CKRecordID(recordName: commentIDString)
        let record = CKRecord(recordType: "Comment", recordID: commentRecordID)
        
        record["createdAt"] = createdAt
        record["text"] = commentText as NSString
        record["topic"] = topicReference
        record["creator"] = creatorReference
        
        self.ckHandler.saveRecord(record: record)
    }
    
    
    func addTopicConclusion(topicRecordID: CKRecordID, conclusion: String) {
        
        ckHandler.fetchByRecordID(recordID: topicRecordID) {
            (response, error) in
            
            guard error == nil else {
                print("error fetching topic to add conclusion.")
                return
            }
            
            if let topic = response {
                topic["conclusion"] = conclusion as NSString
                self.ckHandler.saveRecord(record: topic)
            } else {
                print("Couldn't save the conclusion.")
            }
        }

    }
    
    



}
