//
//  TestingFile.swift
//  MOPT
//
//  Created by Gustavo Avena on 05/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import CloudKit

public class TestingFile {
    
    public static func test() {
        
        
        let meetingServices = MeetingServices()
        let topicServices = TopicServices()
        
        let meetingRecordID = CKRecordID(recordName: "Slackers:gugaavena:04042017")
        let userRecordID = CKRecordID(recordName: "gugaavena")
        //        meetingServices.addParticipant(meetingRecordID: meetingRecordID, userEmail: "ggavena@gmail.com")
        
        
        topicServices.getMeetingTopics(meetingRecordID: meetingRecordID) {
            (topics, error) in

            print("printing topics from meeting \(meetingRecordID.recordName)")
            for topic in topics {
                print(topic)
            }
        }

        
    }

}


//topicServices.createTopic(title: "First Topic", description: "First topic, for testing", meetingRecordID: meetingRecordID, creatorRecordID: userRecordID)
//
//topicServices.createTopic(title: "Second Topic", description: "Second topic, for testing, again.", meetingRecordID: meetingRecordID, creatorRecordID: userRecordID)
