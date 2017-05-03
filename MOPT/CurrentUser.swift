//
//  class CurrentUser.swift
//  MOPT
//
//  Created by Gustavo Avena on 06/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import CloudKit


class CurrentUser: NSObject {
    
    public var userID: ObjectID? {
        didSet {
            print("Changing currentUserRecordID from \(String(describing: oldValue)) to \(String(describing: userID))")
        }
    }
    
    private static var sharedCurrentUser: CurrentUser = {
        let currentUser = CurrentUser(userID: nil)
        
        return currentUser
    }()
    
    
    private init(userID: ObjectID? = nil) {
        self.userID = userID
    }
    
    class func shared() -> CurrentUser {
        return sharedCurrentUser
    }
    
}
