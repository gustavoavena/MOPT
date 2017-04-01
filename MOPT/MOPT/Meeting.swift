//
//  Meeting.swift
//  MOPT
//
//  Created by Gustavo Avena on 30/03/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit



class Meeting: NSObject {
    let moderator: User
    let date: Date
    var topics: [Topic]
    var participants: [User]
    let timeController: TimeControl
    var currentTopic: Topic?
    let title: String
    
    init(title: String, moderator: User, date: Date, timeController: TimeControl = TimeControl()) {
        self.title = title
        self.moderator = moderator
        self.date = date
        self.topics = [Topic]()
        self.participants = [moderator]
        self.timeController = timeController
        self.currentTopic = nil
    }
    
    func startMeeting() throws {
        
        guard (self.timeController.startTime == nil && self.timeController.endTime == nil) else {
            print("can't start meeting that is already running or ended.")
            throw TimeError.StartError
        }
        
        self.timeController.startTime = Date()
    }
    
    func endMeeting() throws {
        
        guard (self.timeController.endTime == nil && self.timeController.startTime != nil) else {
            print("can't end meeting that hasn't started yet or already ended.")
            throw TimeError.EndError
        }
        
        self.timeController.endTime = Date()

    }
    
    /**Call this method when starting/ending a topic.*/
    func changeCurrentTopic(currentTopic: Topic?) {
        self.currentTopic = currentTopic
    }
    
    func addParticipant(participant: User) {
        self.participants.append(participant)
    }
    
    // TODO: removeParticipant.
    
    func addTopic(topic: Topic) {
        self.topics.append(topic)
    }
    
    // TODO: removeTopic.

    

}

