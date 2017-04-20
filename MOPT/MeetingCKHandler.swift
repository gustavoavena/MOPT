//
//  MeetingCKHandler.swift
//  MOPT
//
//  Created by Gustavo Avena on 204//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import CloudKit

class MeetingCKHandler: CloudKitHandler {
	
	func update(conclusion: String, meeting: Meeting) {
		// Fetch CKRecord
		let recordID = CKRecordID(recordName: meeting.ID)
		fetchByRecordID(recordID: recordID) {
			(record, error) in
			
			guard error == nil else {
				print("Error when trying to update meeting \(meeting)'s conclusion.")
				return
			}
			
			if let record = record {
				record["conclusion"] = conclusion as NSString
				self.saveRecord(record: record)
			} else {
				print("No meeting record found.")
				// TODO: alert caller or create new record?
			}
			
		}
		// If not found, call the method to create one and save it.
		// else, modify the attribute and save the record.
		// TODO: error handling, in case the remote update is not successfull
	}
	
	func update(newParticipant: User, meeting: Meeting) {
		let userRecordID = CKRecordID(recordName: newParticipant.ID)
		let userReference = CKReference(recordID: userRecordID, action: .none)
		
		
		
		
	}
	
	let arr = [1, 2, 3]
	

}




/*

	The CKHandlers will be responsible for fetching records and returning objects, updating the records after updating the objects, fetching the new/updated records and updating the objects.

	It needs to implement an update() method that will have multiple signatures, one for each record attribute.
	They will all update the modified property and call the method responsible for saving the whole record after the modifications.

	IMPORTANT methods that all CKHandelers must implement:
	func fetchByID(recordID: CKRecordID, handleUserObject: @escaping (CKRecord?, Error?) -> Void)
	func saveRecord(record: CKRecord)

	They will probably all inherit from CloudKitHandler...

	Notes: We need to decide which will by synchronous and which will be asynchronous, to avoid delaying the main thread and UI operations.
	For example, *save* methods can by async, because they will not affect the UI (the object will be locally modified and willbe correctly displayed, while on the background the record is updated remotely).


*/
