//
//  MeetingCKHandler.swift
//  MOPT
//
//  Created by Gustavo Avena on 204//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import CloudKit

class MeetingCKHandler: CloudKitHandler {
//	let possibleTypes = [NSString.self, NSDate, CKRecordValue]
	
	func getType(_ attribute: String) -> Any {
		
		switch(attribute) {
		case "title", "conclusion", "text":
			return NSString.self
			break
		case "endTime", "startTime", "date":
			return NSDate.self
			break
		default:
			print("Couldn't find attribute \(attribute)'s type.")
			return CKRecordValue.self
			break
		}
		
	}
	
	func update(attribute:String, value: Any, meeting: Meeting) {
		let meetingRecordID = CKRecordID(recordName: meeting.ID) // Fetch CKRecord
		
		fetchRecordByID(recordID: meetingRecordID) {
			(record, error) in
			
			guard error == nil else {
				print("Error when trying to update meeting \(meeting)'s title.")
				return
			}
			
			if let record = record {
				record[attribute] = (value as? CKRecordValue) ?? "NONE" as NSString
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
	
	
	func update(title: String, meeting: Meeting) {
		update(attribute: "title", value: title, meeting: meeting)
	}
	
	func update(newParticipant: User, meeting: Meeting) {
		let userRecordID = CKRecordID(recordName: newParticipant.ID)
		let userReference = CKReference(recordID: userRecordID, action: .none)
		let meetingRecordID = CKRecordID(recordName: meeting.ID)
		
		fetchRecordByID(recordID: meetingRecordID) {
			(record, error) in
			
			guard error == nil else {
				print("Error when trying to update meeting \(meeting)'s participants.")
				return
			}
			
			if let record = record {
				if var participants = (record["participants"] as? [CKReference]) {
					participants.append(userReference)
					record["participants"] = participants as CKRecordValue
				} else {
					let participants = [userReference]
					record["participants"] = participants as CKRecordValue
				}
				
				self.saveRecord(record: record)
				
			} else {
				print("No meeting record found.")
				// TODO: alert caller or create new record?
			}
		}
		
	}
	
	// TODO: update startTime
	
	

		
	

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
