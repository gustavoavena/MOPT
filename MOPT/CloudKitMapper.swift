//
//  CloudKitMapper.swift
//  MOPT
//
//  Created by Gustavo Avena on 204//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import CloudKit
import Dispatch



enum MoptObjectType {
	case meeting
	case topic
	case user
	case comment
	case subject
}

// TODO: split by object type?
// Defines possible UpdateOperations for objects
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

	// Meeting
//	case removeCurrentTopic
	
	
	
	// Topic
	case addComment
	case conclusion
	case info
	
	// Comment
	case text
}


// TODO: Use sets instead of arrays for IDs

/*

Basic workflow for update operations:
1) Someone calls the update/add/remove with the proper signature for each record attribute.
2) this update method calls the "main" update method.
3) The switch statement inside this "main" update method will call the proper assign/add/remove method to update the record and save it.

*/

class CloudKitMapper {
	
	private static let publicDB: CKDatabase = CKContainer.default().publicCloudDatabase
//	private static let privateDB: CKDatabase = CKContainer.default().privateCloudDatabase
	
	
	
	private static func save(record: CKRecord) {
		
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
		save(record: record)
	}
	
	private static func unset(attribute: String, record: CKRecord) {
		record[attribute] = nil
		save(record: record)
	}
	
	

	// Adds a new topic or user to the object
	private static func add(attribute: String, value: CKRecordValue, record: CKRecord) {
		let reference = value as! CKReference
		
		if var array = (record[attribute] as? [CKReference]) {
			array.append(reference)
			record[attribute] = array as CKRecordValue
		} else {
			let array = [reference]
			record[attribute] = array as CKRecordValue
		}
		
		save(record: record)
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
		
		save(record: record)
	}
	

	
	

	/**
		This is the update method that gets called from all the others.
	*/
	private static func update(operation: UpdateOperation, attribute:String, value: CKRecordValue, object: MoptObject) {
		let objectRecordID = CKRecordID(recordName: object.ID) // Fetch CKRecord
		
		CloudKitMapper.publicDB.fetch(withRecordID: objectRecordID) {
			(record, error) in
			
			guard error == nil else {
				print("Error when trying to update object \(object)'s attribute. UpdateOperation = [Insert operation here]")
				return
			}
			
			if let record = record {
				
				switch operation {
				case .title, .startTime, .endTime, .date, .expectedDuration, .currentTopic, .conclusion, .info, .text:
					self.assign(attribute: attribute, value: value, record: record)
				case .addParticipant, .addTopic, .addComment:
					self.add(attribute: attribute, value: value, record: record)
				case .removeTopic, .removeParticipant:
					self.remove(attribute: attribute, value: value, record: record)
				}
				
			} else {
				print("No record with ID \(objectRecordID) found.")
				// TODO: alert caller or create new record?
			}
		}
		// TODO: error handling, in case the remote update is not successfull
	}
	
	
	static func update(title: String, object: MoptObject) {
		update(operation: UpdateOperation.title, attribute: "title", value: title as CKRecordValue, object: object)
	}
	
	static func update(startTime: Date, object: MoptObject) {
		update(operation: UpdateOperation.startTime, attribute: "startTime", value: startTime as CKRecordValue, object: object)
	}
	
	static func update(endTime: Date, object: MoptObject) {
		update(operation: UpdateOperation.endTime, attribute: "endTime", value: endTime as CKRecordValue, object: object)
	}
	
	static func update(date: Date, object: Meeting) {
		update(operation: UpdateOperation.date, attribute: "date", value: date as CKRecordValue, object: object)
	}
	
	static func update(expectedDuration: Double, object: MoptObject) {
		update(operation: UpdateOperation.expectedDuration, attribute: "expectedDuration", value: expectedDuration as CKRecordValue, object: object)
	}
	
	

	// TODO: implement authorization (permissions)
	// TODO: set currentTopic to nil.
	public static func update(currentTopic topic: ObjectID, object: Meeting) {
		let topicRecordID = CKRecordID(recordName: topic)
		let topicReference = CKReference(recordID: topicRecordID, action: .none)
		
		update(operation: UpdateOperation.currentTopic, attribute: "currentTopic", value: topicReference as CKRecordValue, object: object)
	}
	
	
	public static func add(participant: ObjectID, object: Meeting) {
		let userRecordID = CKRecordID(recordName: participant)
		let userReference = CKReference(recordID: userRecordID, action: .none)
		
		update(operation: .addParticipant, attribute: "participants", value: userReference, object: object)
	}
	
	public static func remove(participant: ObjectID, object: Meeting) {
		let userRecordID = CKRecordID(recordName: participant)
		let userReference = CKReference(recordID: userRecordID, action: .none)
		
		update(operation: UpdateOperation.removeParticipant, attribute: "participants", value: userReference as CKRecordValue, object: object)
	}
	
	public static func add(topic: ObjectID, object: Meeting) {
		let topicRecordID = CKRecordID(recordName: topic)
		let topicReference = CKReference(recordID: topicRecordID, action: .none)
		
		update(operation: UpdateOperation.addTopic, attribute: "topics", value: topicReference as CKRecordValue, object: object)
	}
	
	public static func remove(topic: ObjectID, object: Meeting) {
		let topicRecordID = CKRecordID(recordName: topic)
		let topicReference = CKReference(recordID: topicRecordID, action: .none)
		
		update(operation: UpdateOperation.removeTopic, attribute: "topics", value: topicReference as CKRecordValue, object: object)
	}
	
	
	// Topic update operations
	public static func add(comment: ObjectID, object: Topic) {
		let commentRecordID = CKRecordID(recordName: comment)
		let commentReference = CKReference(recordID: commentRecordID, action: .none)

		
		update(operation: UpdateOperation.addComment, attribute: "comments", value: commentReference as CKRecordValue, object: object)
	}
	
	public static func update(conclusion: String, object: MoptObject) {
		update(operation: UpdateOperation.conclusion, attribute: "conclusion", value: conclusion as CKRecordValue, object: object)
	}
	
	public static func update(info: String, object: MoptObject) {
		update(operation: UpdateOperation.info, attribute: "info", value: info as CKRecordValue, object: object)
	}


	
	// Comment update operations
	static func update(text: String, object: MoptObject) {
		update(operation: UpdateOperation.text, attribute: "text", value: text as CKRecordValue, object: object)
	}
	
	
	public static func get(object objectType: MoptObjectType, fromID ID: ObjectID, completionHandler: @escaping (MoptObject?) -> Void) {
		// fetch record and call the method to create object from record.
		// will this be synchronous??
		// Does completionHandler need an Error? It will be used in the view... it should be simple.
		let recordID = CKRecordID(recordName: ID)
		
		publicDB.fetch(withRecordID: recordID) {
			(record, error) in
			
			guard error == nil else {
				print("Error fetching record.")
				print(error.debugDescription)
				completionHandler(nil)
				return
			}
			
			guard let record = record else {
				print("No record found on CloudKit.") // TODO: define error.
				completionHandler(nil)
				return
			}
			
			var object: MoptObject?
			
			switch objectType {
			case .meeting:
				object = createMeeting(fromRecord: record)
			case .topic:
				object = createTopic(fromRecord: record)
			case .user:
				object = createUser(fromRecord: record)
				// TODO: create subject
			default:
				print("Couldn't decide which object to create.")
			}
			
			if let object = object {
				completionHandler(object)
			} else {
				completionHandler(nil)
			}
		}
		
	}
	
	

	public static func createMeeting(fromRecord record: CKRecord) -> Meeting? {
		var meeting: Meeting
		let ID = record.recordID.recordName
		var creatorID: ObjectID
		
		if let creatorReference = record["creator"] as? CKReference {
			creatorID = creatorReference.recordID.recordName
		} else {
			print("Couldn't initialize meeting's user.")
			return nil
		}
		guard let title = record["title"] as? String, let date = record["date"]! as? Date else {
			print("Couldnt create meeting object.")
			return nil
		}
		
		meeting = Meeting(ID: ID, title: title, date: date, creatorID: creatorID)
		
		
		if let startTime = record["startTime"] as? Date {
			meeting.startTime = startTime
		}
		
		if let endTime = record["endTime"] as? Date {
			meeting.endTime = endTime
		}
		
		if let expectedDuration = record["expectedDuration"] as? TimeInterval {
			meeting.expectedDuration = expectedDuration
		}
		
		
		return meeting
	}
	
	public static func createTopic(fromRecord record: CKRecord) -> Topic? {
		let ID = record.recordID.recordName
		var topic: Topic
		
		var creatorID: ObjectID
		var meetingID: ObjectID
		

		
		if let creatorReference = record["creator"] as? CKReference, let meetingReference =  record["meeting"] as? CKReference {
			creatorID = creatorReference.recordID.recordName
			meetingID = meetingReference.recordID.recordName
		} else {
			print("Couldn't initialize topic's user and/or meeting.")
			return nil
		}
		
		guard let title = record["title"] as? String else {
			print("Couldnt create meeting object.")
			return nil
		}
		
		topic = Topic(ID: ID, title: title, creatorID: creatorID, meetingID: meetingID)
		
		if let info = record["info"] as? String {
			topic.info = info
		}
		
		if let startTime = record["startTime"] as? Date {
			topic.startTime = startTime
		}
		
		if let endTime = record["endTime"] as? Date {
			topic.endTime = endTime
		}
		
		if let expectedDuration = record["expectedDuration"] as? TimeInterval {
			topic.expectedDuration = expectedDuration
		}
		
		if let conclusion = record["conclusion"] as? String {
			topic.conclusion = conclusion
		}
		
		var commentIDs: [ObjectID] = [ObjectID]()
		
		if let commentReferences = record["comment"] as? [CKReference] {
			for cr in commentReferences {
				commentIDs.append(cr.recordID.recordName)
			}
			topic.commentIDs = commentIDs
		}
		
		return topic
	}
	
	
	// TODO: createSubject(fromRecord record: CKRecord) -> Subject?
	
	
	// XUPITA
	public static func createSubject(fromRecord record: CKRecord) -> Subject? {
		return nil // remove this and write the code.
	}
	
	public static func createUser(fromRecord record: CKRecord) -> User? {
		var user: User
		let ID = record.recordID.recordName

		guard let name = record["name"] as? String, let email = record["email"]! as? String else {
			print("Couldn't create meeting object.")
			return nil
		}
		
		guard let urlString = record["profilePictureURL"] as? String else {
			print("profile picture URL string not found in the record.")
			return nil
		}
		
		guard let url = URL(string: urlString) else {
			print("Couldn't create URL object from string.")
			return nil
		}
		
		
		user = User(ID: ID, name: name, email: email, profilePictureURL: url)
		
		if let meetingIDs = record["meetingIDs"] as? [ObjectID] {
			for id in meetingIDs {
				user.meetingsIDs.append(id)
			}
		}
		
		
		return user
	}
	
	public static func createRecord(fromMeeting meeting: Meeting) {
		let recordID = CKRecordID(recordName: meeting.ID)
		let record = CKRecord(recordType: "Meeting", recordID: recordID)
		
		record["title"] = meeting.title as NSString
		record["date"] = meeting.date as NSDate
		
		let creatorRecordID = CKRecordID(recordName: meeting.creatorID)
		let creatorReference = CKReference(recordID: creatorRecordID, action: .deleteSelf)
		
		record["creator"] = creatorReference
		
		
		if let ct = meeting.currentTopic {
			let ctRecordID = CKRecordID(recordName: ct.ID)
			record["currentTopic"] = CKReference(recordID: ctRecordID, action: .none)
		}
		
		if let startTime = meeting.startTime {
			record["startTime"] = startTime as NSDate
		}
		
		if let endTime = meeting.endTime {
			record["endTime"] = endTime as NSDate
		}
		
		if let expectedDuration = meeting.expectedDuration {
			record["expectedDuration"] = expectedDuration as CKRecordValue
		}
		
		var participants = [CKReference]()
		for p in meeting.participantIDs {
			let pRecordID = CKRecordID(recordName: p)
			let pReference = CKReference(recordID: pRecordID, action: .none)
			
			participants.append(pReference)
			// TODO: append creator twice?
		}
		
		record["participants"] = participants as CKRecordValue
		
		
		var topics = [CKReference]()
		for topicID in meeting.topicIDs {
			let topicRecordID = CKRecordID(recordName: topicID)
			let topicReference = CKReference(recordID: topicRecordID, action: .none)
			
			topics.append(topicReference)
			// TODO: append creator twice?
		}
		
		record["topics"] = topics as CKRecordValue
		
		save(record: record)
	}

	// TODO: createRecord for Topic, Subject, Comment and User
	
	
	// XUPITA
	public static func createRecord(fromTopic topic: Topic) {
		
	}
	
	// XUPITA
	public static func createRecord(fromUser user: User) {
		
	}
	
	// XUPITA
	public static func createRecord(fromSubject subject: Subject) {
		
	}
	
	// XUPITA
	public static func createRecord(fromComment comment: Comment) {
		
	}

		
	

}




/*

	The CloudKitMappers will be responsible for fetching records and returning objects, updating the records after updating the objects, fetching the new/updated records and updating the objects.

	It needs to implement an update() method that will have multiple signatures, one for each record attribute.
	They will all update the modified property and call the method responsible for saving the whole record after the modifications.

	IMPORTANT methods that all CKHandelers must implement:
	func fetchByID(recordID: CKRecordID, handleUserObject: @escaping (CKRecord?, Error?) -> Void)
	func saveRecord(record: CKRecord)

	Maybe create abstract class???

	They will probably all inherit from CloudKitHandler...

	Notes: We need to decide which will by synchronous and which will be asynchronous, to avoid delaying the main thread and UI operations.
	For example, *save* methods can by async, because they will not affect the UI (the object will be locally modified and willbe correctly displayed, while on the background the record is updated remotely).



	IMPORTANT: use a Hash table to store all the records and have instant lookup time. The key will be the ID. Everytime you create and object, put it in the hash table. When you wanna find it, just look for it there. If it's not there, fetch from DB.

*/
