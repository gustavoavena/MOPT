//
//  class CurrentUser.swift
//  MOPT
//
//  Created by Gustavo Avena on 06/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import CloudKit


class CurrentUser: NSObject {
    
    public var userRecordID: CKRecordID? {
        didSet {
            print("Changing currentUserRecordID from \(String(describing: oldValue)) to \(String(describing: userRecordID))")
        }
    }
    
    private static var sharedCurrentUser: CurrentUser = {
        let currentUser = CurrentUser(userRecordID: nil)
        
        return currentUser
    }()
    
    
    private init(userRecordID: CKRecordID? = nil) {
        self.userRecordID = userRecordID
    }
    
    class func shared() -> CurrentUser {
        return sharedCurrentUser
    }
    
}
