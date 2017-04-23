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
	let privateDB: CKDatabase
    
    override init() {
        self.myContainer = CKContainer.default()
        self.publicDB = myContainer.publicCloudDatabase
		self.privateDB = myContainer.privateCloudDatabase
    }
    
    func fetchRecordByID(recordID: CKRecordID, handleUserObject: @escaping (CKRecord?, Error?) -> Void) {
        
        self.publicDB.fetch(withRecordID: recordID){
            (record, error) in
            
            guard error == nil else {
                print("Error fetching record by ID.")
                handleUserObject(nil, error)
                return
            }
            
//            print("record:", record as Any, terminator: "\n\n")
			
            if let record = record {
                handleUserObject(record, error)
            } else {
                print("Record not found - CloudKitHandler.fetchByRecordID.")
                handleUserObject(nil, CKHandlerError.NoRecordFound)
            }
            
        }
    }
    
    func saveRecord(record: CKRecord) {
        
        print("Attempting to save record \(record.recordID.recordName)")
        
        self.publicDB.save(record) {
            (record, error) in
            if let error = error {
                // Insert error handling
                print("Error when saving the record \(String(describing: record?.recordID.recordName)).")
                print(error.localizedDescription)
                return
            }
            // Insert successfully saved record code
            print("Record \(String(describing: record?.recordID.recordName)) saved successfully.")
        }
        
    }
}
