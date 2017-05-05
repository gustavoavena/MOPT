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
//	case removeCurrentTopic
	case addComment
	case conclusion
	case info
	case text
}



/*

Basic workflow for update operations:
1) Someone calls the update/add/remove with the proper signature for each record attribute.
2) this update method calls the "main" update method.
3) The switch statement inside this "main" update method will call the proper assign/add/remove method to update the record and save it.

*/

class CloudKitMapper {
	
	private static let publicDB: CKDatabase = CKContainer.default().publicCloudDatabase
	private static let privateDB: CKDatabase = CKContainer.default().privateCloudDatabase
	
	
	/**
         Saves a record to CloudKit's public database
     
        - parameter record: record to be saved on public database
     */
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
	

	
	/**
        Sets a value in a record's attribute.
        Example: updated a meeting's title.
        
        - parameter attribute: the name of the attribute to be updated (e.g. title, date).
        - parameter value: the value to assign to the attribute described above.
        - parameter record: the record to be modified.
	*/
	private static func assign(attribute: String, value: CKRecordValue, record: CKRecord) {
		record[attribute] = value
		save(record: record)
	}
	
	private static func unset(attribute: String, record: CKRecord) {
		record[attribute] = nil
		save(record: record)
	}
	
	

	/**
		Adds a reference/value to a list attribute inside the record.
		Example: adds a topic to the topics list in a meeting record.
	
		- parameter attribute: the name of the list to be updated (e.g. participants, topics).
		- parameter value: the object/value to be added to the list described above.
		- parameter record: the record to be modified.
	*/
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
	
	/**
		Removes a reference (or a value) from a list attribute in the record.
		Example: removes a user from the participants list in a Meeting record.
		
		- parameter attribute: the name of the list to be updated (e.g. participants, topics).
		- parameter value: the object/value to be removed from the list described above.
		- parameter record: the record to be modified.
	*/
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
		This update method is responsible for fetching the record associated with the MoptObject that was modified. It also.
		- parameter operation: the opertation type (e.g. addParticipant, removeTopic).
		- parameter attribute: the key (string) to the attribute that will be updated in the CloudKit record.
		- parameter value: the new value of this attribute.
		- parameter object: the MoptObject that was updated. The corresponding CloudKit record will be fetched and updated.
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
	
	
	// TODO: document everything with comments

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


	static func update(text: String, object: MoptObject) {
		update(operation: UpdateOperation.text, attribute: "text", value: text as CKRecordValue, object: object)
	}
	
	/**
		This method will fetch a record by ID and create its object (MoptObject).
		- parameter object: The object type (an instance of the MoptObjectType enumeration).
		- parameter withID: the ID of the object to be fetched from the DB and instantiated.
		- parameter completionHandler: a closure that receives the newly created MoptObject as an argument.
	*/
	public static func create(object objectType: MoptObjectType, withID ID: ObjectID, completionHandler: @escaping (MoptObject?) -> Void) {
		// fetch record and call the method to create object from record.

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
	
	
	/**
		Creates a Meeting object from a CKRecord object.
	
		- parameter fromRecord: the CKRecord to be mapped to a Meeting.
		- returns: the matching Meeting object.
	*/
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
    
    /**
         Creates a Subject object from a CKRecord object.
         
         - parameter fromRecord: the CKRecord to be mapped to a Subject.
         - returns: the matching Subject object.
     */
    public static func createSubject(fromRecord record: CKRecord) -> Subject? {
        var subject: Subject
        let ID = record.recordID.recordName
        var meetingID: ObjectID
        
        if let meetingReference =  record["meeting"] as? CKReference {
            meetingID = meetingReference.recordID.recordName
        } else {
            print("Couldn't initialize subject's meeting.")
            return nil
        }
        
        guard let title = record["title"] as? String else {
            print("Couldn't create subject object: title = nil")
            return nil
        }
        
        subject = Subject(ID: ID, title: title, meetingID: meetingID)
        
        if let topicIDs = record["topicIDs"] as? [ObjectID] {
            for id in topicIDs {
                subject.topicIDs.append(id)
            }
        }
        
        return subject
    }
	
	/**
		Creates a Topic object from a CKRecord object.
		
		- parameter fromRecord: the CKRecord to be mapped to a Topic.
		- returns: the matching Topic object.
	*/
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
	
	/**
		Creates a User object from a CKRecord object.
		
		- parameter fromRecord: the CKRecord to be mapped to a User.
		- returns: the matching User object.
	*/
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
	
	/**
		Creates a CKRecord object object from a Meeting object.
		
		- parameter fromMeeting: the Meeting object to be mapped to a CKRecord object.
		- returns: the matching CKRecord object.
	*/
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

	
	
	// Creates CKRecord given User
	func createRecord(fromUser user: User) -> CKRecord {
		let recordID = CKRecordID(recordName: user.ID)
		let record = CKRecord(recordType: "User", recordID: recordID)
		
		record["name"] = user.name as NSString
		record["email"] = user.email as NSString
		record["profilePictureURL"] = user.profilePictureURL as? CKRecordValue
		
		var meetings = [CKReference]()
		for m in user.meetingsIDs {
			let mRecordID = CKRecordID(recordName: m)
			let mReference = CKReference(recordID: mRecordID, action: .none)
			
			meetings.append(mReference)
		}
		
		record["meetings"] = meetings as CKRecordValue
		
		return record
	}
	
	
	
	// Creates CKRecord given Subject
	public static func createRecord(fromSubject subject: Subject) -> CKRecord {
		let recordID = CKRecordID(recordName: subject.ID)
		let record = CKRecord(recordType: "Subject", recordID: recordID)
		
		record["title"] = subject.title as NSString
		
		let meetingRecordID = CKRecordID(recordName: subject.meetingID)
		let meetingReference = CKReference(recordID: meetingRecordID, action: .deleteSelf)
		
		record["meeting"] = meetingReference
		
		var topics = [CKReference]()
		for t in subject.topics {
			let tRecordID = CKRecordID(recordName: t.ID)
			let tReference = CKReference(recordID: tRecordID, action: .none)
			
			topics.append(tReference)
		}
		
		record["topics"] = topics as CKRecordValue
		
		return record
	}
	
	
	// Creates CKRecord given Topic
	public static func createRecord(fromTopic topic: Topic) -> CKRecord {
		let recordID = CKRecordID(recordName: topic.ID)
		let record = CKRecord(recordType: "Topic", recordID: recordID)
		
		record["title"] = topic.title as NSString
		
		let meetingRecordID = CKRecordID(recordName: topic.meetingID)
		let meetingReference = CKReference(recordID: meetingRecordID, action: .deleteSelf)
		
		record["meeting"] = meetingReference
		
		let creatorRecordID = CKRecordID(recordName: topic.creatorID)
		let creatorReference = CKReference(recordID: creatorRecordID, action: .deleteSelf)
		
		record["creator"] = creatorReference
		
		if let conclusion = topic.conclusion {
			record["conclusion"] = conclusion as NSString
		}
		
		if let info = topic.info {
			record["info"] = info as NSString
		}
		
		if let startTime = topic.startTime {
			record["startTime"] = startTime as NSDate
		}
		
		if let endTime = topic.endTime {
			record["endTime"] = endTime as NSDate
		}
		
		if let expectedDuration = topic.expectedDuration {
			record["expectedDuration"] = expectedDuration as CKRecordValue
		}
		
		var comments = [CKReference]()
		for c in topic.commentIDs {
			let cRecordID = CKRecordID(recordName: c)
			let cReference = CKReference(recordID: cRecordID, action: .none)
			
			comments.append(cReference)
		}
		
		record["comments"] = comments as CKRecordValue
		
		return record
	}
	
	// Creates CKRecord given Comment
	func createRecord(fromComment comment: Comment) -> CKRecord {
		let recordID = CKRecordID(recordName: comment.ID)
		let record = CKRecord(recordType: "Comment", recordID: recordID)
		
		let topicRecordID = CKRecordID(recordName: comment.topicID)
		let topicReference = CKReference(recordID: topicRecordID, action: .deleteSelf)
		
		record["topic"] = topicReference
		
		let creatorRecordID = CKRecordID(recordName: comment.creatorID)
		let creatorReference = CKReference(recordID: creatorRecordID, action: .deleteSelf)
		
		record["creator"] = creatorReference
		record["createdAt"] = comment.createdAt as NSDate
		record["text"] = comment.text as NSString
		
		return record
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





	CloudKit Record Attributes:

	- Comment: createdAt, creatorID, text, topicID.
	- Meeting: creatorID, currentTopicID, date, endTime, expectedDuration, participantIDs, startTime, title, topicIDs.
	- Topic: comments, conclusion, creatorID, description, endTime, expectedDuration, meetingID, startTime, title.
	- User: email, meetingIDs, name, profilePictureURL.
	- Subject (needs to be created)



*/
