//
//  MeetingCKHandler.swift
//  MOPT
//
//  Created by Gustavo Avena on 204//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import CloudKit


enum MoptObject {
	case meeting
	case topic
	case user
	case comment
	case subtopic
}

// Define possible UpdateOperations for Meeting objects
enum UpdateOperation {
	case title
	case startTime
	case endTime
	case date
	case addParticipant
	case expectedDuration
	case currentTopic
	case addTopic
	case removeTopic
	case removeParticipant
	
	// TODO: assign callbacks to the enum values?
}

/*

Basic workflow for update operations:
1) Someone calls the update with the proper signature for each record attribute.
2) this update method calls the "big" one that is common to everyone.
3) The switch statement inside this "big" update method will call the proper assign method to update the record and save it.

*/

class MeetingCKHandler: CloudKitHandler {
	
	private static let publicDB: CKDatabase = CKContainer.default().publicCloudDatabase
	private static let privateDB: CKDatabase = CKContainer.default().privateCloudDatabase
	
	
	
	private static func saveRecord(_ record: CKRecord) {
		
		print("Attempting to save record \(record.recordID.recordName).")
		
		self.publicDB.save(record) {
			(record, error) in
			if let error = error {
				// TODO: define error
				print("Error when saving the record \(String(describing: record?.recordID.recordName)).")
				print(error.localizedDescription)
				return
			} else {
				print("Record \(String(describing: record?.recordID.recordName)) saved successfully.")
			}
			
		}
		
	}

	
	// Directly assign attributes to the record that follow the protocol CKRecordValue
	private static func assign(attribute: String, value: CKRecordValue, record: CKRecord) {
		record[attribute] = value
		saveRecord(record)
	}
	
	

	// Adds a new topic or user to the meeting
	private static func add(attribute: String, value: CKRecordValue, record: CKRecord) {
		let reference = value as! CKReference
		
		if var array = (record[attribute] as? [CKReference]) {
			array.append(reference)
			record[attribute] = array as CKRecordValue
		} else {
			let array = [reference]
			record[attribute] = array as CKRecordValue
		}
		
		saveRecord(record)
	}
	
	private static func remove(attribute: String, value: CKRecordValue, record: CKRecord) {
		let reference = value as! CKReference
		
		if var array = (record[attribute] as? [CKReference]) {
			if let index = array.index(of: reference) {
				array.remove(at: index)
				record[attribute] = array as CKRecordValue
			} else {
				print("Couldn't find \(attribute) in the array.")
			}
			
		} else {
			print("Couldn't find the \(attribute) in the array (array is empty).")
		}
		
		saveRecord(record)
	}
	

	
	

	/**
		This is the update method that gets called from all the others.
	*/
	private static func update(operation: UpdateOperation, attribute:String, value: CKRecordValue, meeting: Meeting) {
		let meetingRecordID = CKRecordID(recordName: meeting.ID) // Fetch CKRecord
		
		MeetingCKHandler.publicDB.fetch(withRecordID: meetingRecordID) {
			(record, error) in
			
			guard error == nil else {
				print("Error when trying to update meeting \(meeting)'s attribute. UpdateOperation = [Insert operation here]")
				return
			}
			
			if let record = record {
				
				switch operation {
				case .title, .startTime, .endTime, .date, .expectedDuration, .currentTopic:
					self.assign(attribute: attribute, value: value, record: record)
				case .addParticipant, .addTopic:
					self.add(attribute: attribute, value: value, record: record)
				case .removeTopic, .removeParticipant:
					self.remove(attribute: attribute, value: value, record: record)
				default:
					print("Update operation not found.") // TODO: define error
				}
				
				
			} else {
				print("No record with ID \(meetingRecordID) found.")
				// TODO: alert caller or create new record?
			}
		}
		// If not found, call the method to create one and save it.
		// else, modify the attribute and save the record.
		// TODO: error handling, in case the remote update is not successfull
	}
	
	
	static func update(title: String, meeting: Meeting) {
		update(operation: UpdateOperation.title, attribute: "title", value: title as CKRecordValue, meeting: meeting)
	}
	
	static func update(startTime: Date, meeting: Meeting) {
		update(operation: UpdateOperation.startTime, attribute: "startTime", value: startTime as CKRecordValue, meeting: meeting)
	}
	
	static func update(endTime: Date, meeting: Meeting) {
		update(operation: UpdateOperation.endTime, attribute: "endTime", value: endTime as CKRecordValue, meeting: meeting)
	}
	
	static func update(date: Date, meeting: Meeting) {
		update(operation: UpdateOperation.date, attribute: "date", value: date as CKRecordValue, meeting: meeting)
	}
	
	static func update(expectedDuration: Double, meeting: Meeting) {
		update(operation: UpdateOperation.expectedDuration, attribute: "expectedDuration", value: expectedDuration as CKRecordValue, meeting: meeting)
	}
	
	static func update(currentTopic: Topic, meeting: Meeting) {
		let topicRecordID = CKRecordID(recordName: currentTopic.ID)
		let topicReference = CKReference(recordID: topicRecordID, action: .none)
		
		update(operation: UpdateOperation.currentTopic, attribute: "currentTopic", value: topicReference as CKRecordValue, meeting: meeting)
	}
	
	static func update(addParticipant: User, meeting: Meeting) {
		let userRecordID = CKRecordID(recordName: addParticipant.ID)
		let userReference = CKReference(recordID: userRecordID, action: .none)
		
		update(operation: .addParticipant, attribute: "participants", value: userReference, meeting: meeting)
	}
	
	static func update(removeParticipant: Topic, meeting: Meeting) {
		let userRecordID = CKRecordID(recordName: removeParticipant.ID)
		let userReference = CKReference(recordID: userRecordID, action: .none)
		
		update(operation: UpdateOperation.removeParticipant, attribute: "participants", value: userReference as CKRecordValue, meeting: meeting)
	}
	
	static func update(addTopic: Topic, meeting: Meeting) {
		let topicRecordID = CKRecordID(recordName: addTopic.ID)
		let topicReference = CKReference(recordID: topicRecordID, action: .none)
		
		update(operation: UpdateOperation.addTopic, attribute: "topics", value: topicReference as CKRecordValue, meeting: meeting)
	}
	
	static func update(removeTopic: Topic, meeting: Meeting) {
		let topicRecordID = CKRecordID(recordName: removeTopic.ID)
		let topicReference = CKReference(recordID: topicRecordID, action: .none)
		
		update(operation: UpdateOperation.removeTopic, attribute: "topics", value: topicReference as CKRecordValue, meeting: meeting)
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
