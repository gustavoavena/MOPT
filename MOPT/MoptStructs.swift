//
//  MoptStructs.swift
//  mOpt Storyboards
//
//  Created by Filipe Marques on 29/04/17.
//  Copyright © 2017 Filipe Marques. All rights reserved.
//

import UIKit

struct Meeting {
    var meetingName:String
    var meetingDate:Date
    var subjects:[Subject]
    var topics:[Topic]
}

struct Subject {
    var subjectName:String!
    var topics:[Topic]!
    var collapsed:Bool!
}

struct Topic {
    var topicName:String
    var topicDescription:String
    var topicCreator:User
    var createdIn:Date
    var comments:[Comment]

}

struct Comment {
    var commentDate:Date
    var commentText:String
}

struct User {
    var userName:String
    var email:String
}
