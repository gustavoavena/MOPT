//
//  MeetingCKHandler.swift
//  MOPT
//
//  Created by Gustavo Avena on 204//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import CloudKit


// Define possible UpdateOperations for Meeting objects
enum UpdateOperation {
	case title
	case startTime
	case endTime
	case date
	case newParticipant
	
	// TODO: assign callbacks to the enum values?
}

class MeetingCKHandler: CloudKitHandler {
	
	/*
	
	Basic workflow for update operations:
	1) Someone calls the update with the proper signature for each record attribute.
	2) this update method calls the "big" one that is common to everyone.
	3) The switch statement inside this "big" update method will call the proper assign method to update the record and save it.
	
	*/
	
	
	// Directly assign attributes to the record that follow the protocol CKRecordValue
	func assign(attribute: String, value: CKRecordValue, record: CKRecord) {
		record[attribute] = value
		self.saveRecord(record: record)
	}
	
	
	// Append a new participant to the meeting.
	func assign(newParticipant: CKRecordValue, record: CKRecord) {
		let userReference = newParticipant as! CKReference // Force downcasting because I guarantee it will be a CKReference.
		
		if var participants = (record["participants"] as? [CKReference]) {
			participants.append(userReference)
			record["participants"] = participants as CKRecordValue
		} else {
			let participants = [userReference]
			record["participants"] = participants as CKRecordValue
		}
		
		self.saveRecord(record: record)

	}
	
	/**
		This is the update method that gets called from all the others.
	*/
	func update(operation: UpdateOperation, attribute:String, value: CKRecordValue, meeting: Meeting) {
		let meetingRecordID = CKRecordID(recordName: meeting.ID) // Fetch CKRecord
		
		fetchRecordByID(recordID: meetingRecordID) {
			(record, error) in
			
			guard error == nil else {
				print("Error when trying to update meeting \(meeting)'s attribute. UpdateOperation = [Insert operation here]")
				return
			}
			
			if let record = record {
				
				switch operation {
				case .title, .startTime, .endTime, .date:
					self.assign(attribute: attribute, value: value, record: record)
				case .newParticipant:
					self.assign(newParticipant: value, record: record)
				default:
					print("Update operation not found.") // TODO: define error
				}
				
				
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
		update(operation: UpdateOperation.title, attribute: "title", value: title as CKRecordValue, meeting: meeting)
	}
	
	func update(newParticipant: User, meeting: Meeting) {
		let userRecordID = CKRecordID(recordName: newParticipant.ID)
		let userReference = CKReference(recordID: userRecordID, action: .none)
		
		update(operation: .newParticipant, attribute: "", value: userReference, meeting: meeting)
	}
	
	
	

		
	

}




/*

	The CKHandlers will be responsible for fetching records and returning objects, updating the records after updating the objects, fetching the new/updated records and updating the objects.

	It needs to implement an update() method that will have multiple signatures, one for each record attribute.
	They will all update the modified property and call the method responsible for saving the whole record after the modifications.

	IMPORTANT methods that all CKHandelers must implement:
	func fetchByID(recordID: CKRecordID, handleUserObject: @escaping (CKRecord?, Error?) -> Void)
	func saveRecord(record: CKRecord)

	Maybe create abstract class???

	They will probably all inherit from CloudKitHandler...

	Notes: We need to decide which will by synchronous and which will be asynchronous, to avoid delaying the main thread and UI operations.
	For example, *save* methods can by async, because they will not affect the UI (the object will be locally modified and willbe correctly displayed, while on the background the record is updated remotely).



*/
