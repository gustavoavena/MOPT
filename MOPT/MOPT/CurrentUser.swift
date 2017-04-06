//
//  class CurrentUser.swift
//  MOPT
//
//  Created by Gustavo Avena on 06/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import CloudKit


class CurrentUser: NSObject {
    
    static private var currentUserRecordID: CKRecordID
    
    
    override init() {
        
        fetchFacebookUserInfo {
            (userInfo, error) in
            
            guard error == nil && userInfo != nil else {
                print("error getting current user CK Record ID")
                return
            }
            
            self.currentUserRecordID = CKRecordID(recordName: userInfo?["id"] as! String)
        }
    }
    
    static public func userRecordID() -> CKRecordID {
        return currentUserRecordID
    }

}
