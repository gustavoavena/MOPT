//
//  TopicDBLayer.swift
//  MOPT
//
//  Created by Gustavo Avena on 30/03/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import CloudKit

class TopicDBLayer: NSObject {
    
//    let myContainer: CKContainer
//    
//    let publicDB: CKDatabase
//    
//    override init() {
//        myContainer = CKContainer.default()
//        publicDB = myContainer.publicCloudDatabase
//    }
//    
//    func fetchByID(topicID: String, handleUserObject: @escaping (CKRecord?, Error?) -> Void) {
//        
//        let recordID = CKRecordID(recordName: topicID)
//        
//        
//        publicDB.fetch(withRecordID: recordID){
//            (record, error) in
//            if error != nil {
//                print("Error performing query for topic")
//            }
//            
//            print("record:", record, terminator: "\n\n")
//            
//            
//            
//            if let record = record {
//                handleUserObject(record, error)
//                
//            } else {
//                handleUserObject(nil, error)
//            }
//        }
//
//    }

}
