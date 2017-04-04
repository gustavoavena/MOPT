//
//  CloudKitHandler.swift
//  MOPT
//
//  Created by Gustavo Avena on 03/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import CloudKit

public class CloudKitHandler: NSObject {
    
    let myContainer: CKContainer
    
    let publicDB: CKDatabase
    
    override init() {
        myContainer = CKContainer.default()
        publicDB = myContainer.publicCloudDatabase
    }
    
    func fetchByID(recordID: String, handleUserObject: @escaping (CKRecord?, Error?) -> Void) {
        
        let recordIDObject = CKRecordID(recordName: recordID)
        
        
        publicDB.fetch(withRecordID: recordIDObject){
            (record, error) in
            
            guard error == nil else {
                print("Error performing query for meeting")
                return
            }
            
            print("record:", record as Any, terminator: "\n\n")
            
            if let record = record {
                handleUserObject(record, error)
                
            } else {
                handleUserObject(nil, CKHandlerError.NoRecordFound)
            }
        
        }
    }
}
