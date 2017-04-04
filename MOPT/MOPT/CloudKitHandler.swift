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
    
    func fetchByRecordID(recordID: CKRecordID, handleUserObject: @escaping (CKRecord?, Error?) -> Void) {
        
        publicDB.fetch(withRecordID: recordID){
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
    
    public func saveRecord(record: CKRecord) {
        
        print("Attempting to save record \(record.recordID.recordName)")
        
        self.publicDB.save(record) {
            (record, error) in
            if let error = error {
                // Insert error handling
                print("Error when saving the record \(record?.recordID.recordName).")
                print(error.localizedDescription)
                return
            }
            // Insert successfully saved record code
            print("Record \(record?.recordID.recordName) saved successfully.")
        }
        
    }
}
