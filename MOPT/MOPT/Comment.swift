//
//  Comment.swift
//  MOPT
//
//  Created by Gustavo Avena on 30/03/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class Comment: NSObject {
    let text: String
    let createdAt: Date
    let creator: User
    
    init(text: String, createdAt: Date, creator: User) {
        self.text = text
        self.createdAt = createdAt
        self.creator = creator
    }

}
