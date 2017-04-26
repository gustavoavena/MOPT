//
//  CloudKitMapper.swift
//  MOPT
//
//  Created by Gustavo Avena on 204//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import CloudKit

typealias ObjectID = String // TODO: replace String with ObjectID where it is proper.


enum MoptObjectType {
	case meeting
	case topic
	case user
	case comment
	case subtopic
}

// Define possible UpdateOperations for objects
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
	// TODO: split by object type?
	
	// Topic
	case addComment
	case conclusion
	case info
	
	// Comment
	case text
}


/*

Basic workflow for update operations:
1) Someone calls the update with the proper signature for each record attribute.
2) this update method calls the "big" one that is common to everyone.
3) The switch statement inside this "big" update method will call the proper assign method to update the record and save it.

*/

class CloudKitMapper: CloudKitHandler {
	
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
				default:
					print("Update operation not found.") // TODO: define error
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
	
	

	
	static func update(currentTopic: Topic, object: Meeting) {
		let topicRecordID = CKRecordID(recordName: currentTopic.ID)
		let topicReference = CKReference(recordID: topicRecordID, action: .none)
		
		update(operation: UpdateOperation.currentTopic, attribute: "currentTopic", value: topicReference as CKRecordValue, object: object)
	}
	
	static func update(addParticipant participant: User, object: Meeting) {
		let userRecordID = CKRecordID(recordName: participant.ID)
		let userReference = CKReference(recordID: userRecordID, action: .none)
		
		update(operation: .addParticipant, attribute: "participants", value: userReference, object: object)
	}
	
	static func update(removeParticipant participant: Topic, object: Meeting) {
		let userRecordID = CKRecordID(recordName: participant.ID)
		let userReference = CKReference(recordID: userRecordID, action: .none)
		
		update(operation: UpdateOperation.removeParticipant, attribute: "participants", value: userReference as CKRecordValue, object: object)
	}
	
	static func update(addTopic topic: Topic, object: Meeting) {
		let topicRecordID = CKRecordID(recordName: topic.ID)
		let topicReference = CKReference(recordID: topicRecordID, action: .none)
		
		update(operation: UpdateOperation.addTopic, attribute: "topics", value: topicReference as CKRecordValue, object: object)
	}
	
	static func update(removeTopic topic: Topic, object: Meeting) {
		let topicRecordID = CKRecordID(recordName: topic.ID)
		let topicReference = CKReference(recordID: topicRecordID, action: .none)
		
		update(operation: UpdateOperation.removeTopic, attribute: "topics", value: topicReference as CKRecordValue, object: object)
	}
	
	
	// Topic update operations
	static func update(addComment comment: Comment, object: Topic) {
		let commentRecordID = CKRecordID(recordName: comment.ID)
		let commentReference = CKReference(recordID: commentRecordID, action: .none)

		
		update(operation: UpdateOperation.addComment, attribute: "comments", value: commentReference as CKRecordValue, object: object)
	}
	
	static func update(conclusion: String, object: MoptObject) {
		update(operation: UpdateOperation.conclusion, attribute: "conclusion", value: conclusion as CKRecordValue, object: object)
	}
	
	static func update(info: String, object: MoptObject) {
		update(operation: UpdateOperation.info, attribute: "info", value: info as CKRecordValue, object: object)
	}


	
	// Comment update operations
	static func update(text: String, object: MoptObject) {
		update(operation: UpdateOperation.text, attribute: "text", value: text as CKRecordValue, object: object)
	}
	public static func createObject(meetingRecordID recordID: CKRecordID) -> Meeting {
		// fetch record and call the method to create object from record.
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
		
		meeting = Meeting(ID: ID, title: title!, date: date!, creatorID: creatorID)
		
		
		if let startTime = record["startTime"] as? Date {
			meeting.startTime = startTime
		}
		
		if let endTime = record["endTime"] as? Date {
			meeting.endTime = endTime
		}
		
		if let expectedDuration = record["expectedDuration"] as? TimeInterval {
			meeting.expectedDuration = expectedDuration
		}
		
		Meeting.meetings[ID] = meeting
		
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
		
		var commentIDs: [ObjectID]
		
		if let commentReferences = record["comment"] as? [CKReference] {
			for cr in commentReferences {
				commentIDs.append(cr.recordID.recordName)
			}
			topic.commentIDs = commentIDs
		}
		
		Topic.topics[ID] = topic
		
		return topic
	}
	
	public static func createSubtopic(fromRecord record: CKRecord) -> Subtopic? {
		let ID = record.recordID.recordName
		var subtopic: Subtopic
		var creatorID: ObjectID
		var topicID: ObjectID
		
		if let creatorReference = record["creator"] as? CKReference, let topicReference =  record["topic"] as? CKReference {
			creatorID = creatorReference.recordID.recordName
			topicID = topicReference.recordID.recordName
		} else {
			print("Couldn't initialize topic's user and/or meeting.")
			return nil
		}
		
		guard let title = record["title"] as? String else {
			print("Couldnt create meeting object.")
			return nil
		}
		
		subtopic = Subtopic(ID: ID, title: title, creatorID: creatorID, parentTopicID: topicID)
		
		if let conclusion = record["conclusion"] as? String {
			subtopic.conclusion = conclusion
		}
		
		var commentIDs: [ObjectID]
		
		if let commentReferences = record["comment"] as? [CKReference] {
			for cr in commentReferences {
				commentIDs.append(cr.recordID.recordName)
			}
			subtopic.commentIDs = commentIDs
		}
		
		Subtopic.subtopics[ID] = subtopic
		
		return subtopic
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
		
		User.users[ID] = user
		
		return user
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
