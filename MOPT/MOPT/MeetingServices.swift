//
//  MeetingServices.swift
//  MOPT
//
//  Created by Gustavo Avena on 31/03/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import CloudKit

class MeetingServices: NSObject, MeetingDelegate {
    
    let ckHandler: CloudKitHandler
    let userServices: UserServices
    
    
    override init() {
        ckHandler = CloudKitHandler()
        userServices = UserServices()
    }
    
    
    func getUserMeetings(userRecordID: CKRecordID, _ nextMeetings: Bool, completionHandler: @escaping ([CKRecord]?, Error?) -> Void) {
        let userReference = CKReference(recordID: userRecordID, action: .none)
        let predicate = NSPredicate(format: "user = %@ in participants", userReference) //ATENTION!
        let query = CKQuery(recordType: "Meeting", predicate: predicate)
        
        self.ckHandler.publicDB.perform(query, inZoneWith: nil) {
            (responseData, error) in
            
            guard error == nil && responseData != nil else {
                print("problem getting user meetings")
                return
            }
            
            let records = responseData!
            
            completionHandler(records, error)

        }
    }
    
    
    func createMeeting(title: String, date: NSDate, moderatorRecordID: CKRecordID) {
        //qual o recordID de uma meeting?
        let recordID = CKRecordID(recordName: String(title))
        let userRecord = CKRecord(recordType: "Meeting", recordID: recordID)
        
        print("Creating meeting \(title)")
        
        userRecord["title"] = title as NSString
        userRecord["date"] = date as NSDate
        userRecord["moderator"] = String(fbID) as NSString
        
        
        ckHandler.saveRecord(record: userRecord)
    }
    
    
    // DONE: obeys protocol!
    func addParticipant(meetingRecordID: CKRecordID, userEmail: String)  {
        
        print("Adding participant \(userEmail) to meeting \(meetingRecordID.recordName)")
        
        ckHandler.fetchByRecordID(recordID: meetingRecordID) {
            (recordResponse, error) in
            
            guard error == nil && recordResponse != nil else {
                print("Error fetching meeting")
                return
            }
            
            let record = recordResponse!
            
            self.userServices.getUserRecordFromEmail(email: userEmail) {
                (user, error) in
                
                guard error == nil && user != nil else {
                    print("Error fetching user by email")
                    return
                }
                
                let userReference = CKReference(record: user!, action: .none)
                
                var participants: NSArray = record["participants"] as? NSArray ?? NSArray()
                
                participants =  participants.adding(userReference) as NSArray
                record["participants"] = participants as CKRecordValue
                
                print("participant added to reference list.")
                
                
                self.ckHandler.saveRecord(record: record)
            }
            
        }
        
        
    }
    
    
    func startMeeting(meetingID: CKRecordID)  {
        
        ckHandler.fetchByRecordID(recordID: meetingID) {
            (recordResponse, error) in
            
            guard error == nil && recordResponse != nil else {
                print("Error fetching meeting")
                return
            }
            
            let record = recordResponse!
            
            let startTime = record["startTime"] as! NSDate?
            let endTime = record["endTime"] as! NSDate?
            
            guard (startTime == nil && endTime == nil) else {
                print("can't start meeting that is already running or ended.")
                return
            }
            
            record["startTime"] = Date() as NSDate
            
            self.ckHandler.publicDB.save(record) {
                (newRecord, error) in
                guard error == nil else {
                    print("Error saving record to DB.")
                    return
                }
            }
        }
      
        
    }
    
    func endMeeting(meetingID: CKRecordID)  {
        
        ckHandler.fetchByRecordID(recordID: meetingID) {
            (recordResponse, error) in
            
            guard error == nil && recordResponse != nil else {
                print("Error fetching meeting")
                return
            }
            
            let record = recordResponse!
            
            let startTime = record["startTime"] as! NSDate?
            let endTime = record["endTime"] as! NSDate?
            
            guard (endTime == nil && startTime != nil) else {
                print("can't end meeting that isn't running or ended.")
                return
            }
            
            record["endTime"] = Date() as NSDate
            
            self.ckHandler.publicDB.save(record) {
                (newRecord, error) in
                guard error == nil else {
                    print("Error saving record to DB.")
                    return
                }
            }
        }
        
        
    }
    
    /**Call this method when starting/ending a topic.*/
    func changeCurrentTopic(meetingRecordID: CKRecordID, topicRecordID: CKRecordID?) throws {
        
        ckHandler.fetchByRecordID(recordID: meetingRecordID) {
            (recordResponse, error) in
            
            guard error == nil && recordResponse != nil else {
                print("Error fetching meeting")
                return
            }
            
            let record = recordResponse!
            
            var topicReference: CKReference?
            
            if topicRecordID != nil {
                topicReference = CKReference(recordID: topicRecordID!, action: .none)
            } else {
                topicReference = nil
            }
           
            
            
            
            record["currentTopic"] = topicReference
            
                      
            self.ckHandler.publicDB.save(record) {
                (newRecord, error) in
                guard error == nil else {
                    print("Error saving record to DB.")
                    return
                }
            }
        }
        
        
    }
    
    
    
    
 
    
    // TODO: removeParticipant.
    
    
    
        
    // TODO: removeTopic.


}













