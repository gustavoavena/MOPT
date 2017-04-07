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
    
    func getUserMeetings(userRecordID: CKRecordID, _ nextMeetings: Bool = true, completionHandler: @escaping ([CKRecord], Error?) -> Void) {
        
        print("Getting user meetings")
        var predicate: NSPredicate
        
        let userReference = CKReference(recordID: userRecordID, action: .none)
        if(nextMeetings) {
            predicate = NSPredicate(format: "%@ in participants", userReference) // next meetings (date same day or later as current date).
        } else {
            predicate = NSPredicate(format: "%@ in participants", userReference)
        }
        
        let query = CKQuery(recordType: "Meeting", predicate: predicate)
        
        self.ckHandler.publicDB.perform(query, inZoneWith: nil) {
            (responseData, error) in
            
            guard error == nil else {
                print("problem getting user meetings")
                completionHandler([CKRecord](), error)
                return
            }
            
            
            if let records = responseData {
                completionHandler(records, nil)
            } else {
                print("No meeting records were found.")
                completionHandler([CKRecord](), nil)
            }
            
            

        }
    }
    
    func createMeeting(title: String, date: NSDate, moderatorRecordID: CKRecordID) {
        
        let recordID = CKRecordID(recordName: String(format: "%@:%@:%@", title, moderatorRecordID.recordName, date.description))
        let meetingRecord = CKRecord(recordType: "Meeting", recordID: recordID)
        
        print("Creating meeting \(title)")
        
        let moderatorReference = CKReference(recordID: moderatorRecordID, action: .deleteSelf)
        
        meetingRecord["title"] = title as NSString
        meetingRecord["date"] = date as NSDate
        meetingRecord["moderator"] = moderatorReference
        meetingRecord["participants"] = [moderatorReference] as NSArray
        
        ckHandler.saveRecord(record: meetingRecord)
    }
    
    
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
                
                //OBS: nao eh necessaria a verificaçao de nil, pois toda reuniao tem pelo menos o moderador como participante
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
            
            guard error == nil else {
                print("Error fetching meeting")
                return
            }
            
            if let record = recordResponse {
                let startTime = record["startTime"] as! NSDate?
                let endTime = record["endTime"] as! NSDate?
                
                print("starting meeting \(meetingID.recordName)")
                
                guard (startTime == nil && endTime == nil) else {
                    print("can't start meeting that is already running or ended.")
                    return
                }
                
                record["startTime"] = Date() as NSDate
                
                self.ckHandler.saveRecord(record: record)
            }
            
            
        }
      
        
    }
    
    // TODO: Modify it and make it like startMeeting (using if let)
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
    func changeCurrentTopic(meetingRecordID: CKRecordID, topicRecordID: CKRecordID?) {
        
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
            
                      
            self.ckHandler.saveRecord(record: record)
        }
        
        
    }
    
    
    func removeParticipant(meetingRecordID: CKRecordID, participantRecordID: CKRecordID) {
        
        ckHandler.fetchByRecordID(recordID: meetingRecordID) {
            (recordResponse, error) in
            
            guard error == nil && recordResponse != nil else {
                print("Error fetching meeting")
                return
            }
            
            let record = recordResponse!
            var participants: [CKReference] = record["participants"] as! [CKReference]
            let participantReference = CKReference(recordID: participantRecordID, action: .none)
            
            //remover CKReference (participantReference) da NSArray (participants)
            let index = participants.index(of: participantReference)
            //index! (force unwrap): posso garantir que index nao sera nil, pois para um participante ser removido ele deve existir na tela do usuario (nao existe possibilidade de tentar remover um usuario que nao é participante da reuniao) -- TODO: comentar em ingles
            participants.remove(at: index!)
            
            record["participants"] = participants as NSArray
            
            print("participant \(participantRecordID.recordName) removed from meeting \(meetingRecordID.recordName).")
            
            self.ckHandler.saveRecord(record: record)
        }
    }



}













