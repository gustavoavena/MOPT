//
//  MeetingServices.swift
//  MOPT
//
//  Created by Gustavo Avena on 31/03/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import CloudKit

class MeetingServices: NSObject {
    
    let ckHandler: CloudKitHandler
    
    override init() {
        ckHandler = CloudKitHandler()
    }
    
    
    func startMeeting(meetingID: String) throws {
        
        
        ckHandler.fetchByID(recordID: meetingID) {
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
    
    func endMeeting(meetingID: String) throws {
        
        ckHandler.fetchByID(recordID: meetingID) {
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
    func changeCurrentTopic(meetingID: String, topicID: String?) throws {
        
        ckHandler.fetchByID(recordID: meetingID) {
            (recordResponse, error) in
            
            guard error == nil && recordResponse != nil else {
                print("Error fetching meeting")
                return
            }
            
            let record = recordResponse!
            
            var topicRecordID: CKRecordID?
            
            if let id = topicID {
                 topicRecordID = CKRecordID(recordName: id)
            } else {
                topicRecordID =  nil
            }
            
           
            let topicReference = CKReference(recordID: topicRecordID!, action: .none)
            
            
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
    
    func addParticipant(meetingID: String, username: String)  {
        
        print("Adding participant \(username) to meeting \(meetingID)")
        
        ckHandler.fetchByID(recordID: meetingID) {
            (recordResponse, error) in
            
            guard error == nil && recordResponse != nil else {
                print("Error fetching meeting")
                return
            }
            
            let record = recordResponse!
            
            let userRecordID = CKRecordID(recordName: username)
            
            let userReference = CKReference(recordID: userRecordID, action: .none)
            
            var participants: NSArray = record["participants"] as? NSArray ?? NSArray()
            
            participants =  participants.adding(userReference) as NSArray
            record["participants"] = participants as CKRecordValue
            
            print("participant added to reference list.")
            
            
            
            self.ckHandler.publicDB.save(record) {
                (newRecord, error) in
                guard error == nil else {
                    print("Error saving record to DB.")
                    return
                }
                print("Meeting record saved successfully.")
            }
        }
        
        
    }
    
 
    
    // TODO: removeParticipant.
    
    
    
        
    // TODO: removeTopic.


}
