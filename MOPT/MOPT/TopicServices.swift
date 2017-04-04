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
    

    
      
    
    
//    
//    func addComment(comment: Comment) {
//        if var comments = self.comments {
//            comments.append(comment)
//        } else {
//            self.comments = [comment]
//        }
//    }
//    
//    func removeComment(comment: Comment) {
//        guard (self.comments != nil) else {
//            // TODO: Throw error, because comments is nil!!
//            print("Comments is empty!")
//            return
//        }
//        
//        if(self.comments?.contains(comment))! {
//            if let index = self.comments!.index(of: comment) {
//                self.comments?.remove(at: index)
//            } else {
//                // TODO: throw error?
//                print("Could not remove comment")
//            }
//        }
//    }
//    
//    func addConclusion(conclusion: String) {
//        // TODO: check if topic is being discussed or has already ended. Only then can you insert a conclusion.
//        self.conclusion = conclusion
//    }
//    
//    func startTopic() throws {
//        // TODO: Check if the startTime is nil. If not, throw error. If it is, start the meeting at the current time.
//        // Remember to call the self.meeting.changeCurrentTopic()
//        
//        guard ( self.timeController.startTime == nil &&
//            self.timeController.endTime == nil &&
//            self.meeting.currentTopic == nil)
//            else {
//                print("Can't start topic.")
//                throw TimeError.StartError
//        }
//        
//        self.timeController.startTime = Date()
//        
//        self.meeting.changeCurrentTopic(currentTopic: self)
//        
//    }
//    
//    func endTopic() throws {
//        // TODO: Check if startTime is NOT nil and endTime IS nil.
//        
//        guard ( self.timeController.endTime == nil &&
//            self.timeController.startTime != nil &&
//            self.meeting.currentTopic == self) else {
//                print("Can't end topic.")
//                throw TimeError.EndError
//        }
//        
//        self.timeController.endTime = Date()
//        self.meeting.changeCurrentTopic(currentTopic: nil)
//    }
//    



}
