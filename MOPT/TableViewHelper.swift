//
//  TableViewHelper.swift
//  MOPT
//
//  Created by Gustavo Avena on 114//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import CloudKit
import Dispatch

// Definitely a faulty implementation, due to the use of semaphores. But it does what we need it to do for now...
class TableViewHelper: NSObject {
	
	static let userServices = UserServices()
	
	
	static func assignImageByClass(cell: UITableViewCell, imageFile: UIImage) {
		if cell is MeetingsTableViewCell {
			(cell as! MeetingsTableViewCell).moderatorPicture.image = imageFile
		}
//		else if cell is TopicsTableViewCell {
//			(cell as! TopicsTableViewCell).topicCreatorPicture.image = imageFile
//		} else if cell is SubtopicsTableViewCell {
//			(cell as! SubtopicsTableViewCell).subtopicCreatorPicture.image = imageFile
//		} else if cell is CommentsTableViewCell {
//			(cell as! CommentsTableViewCell).commentCreatorPicture.image = imageFile
//		} else if cell is PreviousMeetingsTableViewCell {
//			(cell as! PreviousMeetingsTableViewCell).moderatorPicture.image = imageFile
//		}
	}
	
	public static func loadCellProfilePicture(fromUser userID: ObjectID, cell: UITableViewCell) -> UITableViewCell {
		let semaphore = DispatchSemaphore(value: 0)
		
		
		let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
		let fileName = documentsDirectory.appendingPathComponent(String(format: "%@ProfilePicture.jpg", userID))
		
		if let imageFile = UIImage(contentsOfFile: fileName.path) {
			self.assignImageByClass(cell: cell, imageFile: imageFile)
			semaphore.signal()

			
//			print("Loaded profile picture from file.")
		} else {
			
			let user = Cache.get(objectType: .user, objectWithID: userID) as! User
			
			self.userServices.downloadImage(imageURL: user.profilePictureURL, userID: userID)
			if let imageFile = UIImage(contentsOfFile: fileName.path) {
				self.assignImageByClass(cell: cell, imageFile: imageFile)
			} else {
				print("Error loading picture after downlaoding it.")
			}
			semaphore.signal()
			

			
		}
		
		
		semaphore.wait()
		return cell

	}
    
    public static func getImageFromDirectory(userRecordName: String?) -> UIImage? {
        guard userRecordName != nil else {
            return nil
        }
        
        let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileName = documentsDirectory.appendingPathComponent(String(format: "%@ProfilePicture.jpg", userRecordName!)) // Force unwrap because you can't get here without being logged in.
        
        if let imageFile = UIImage(contentsOfFile: fileName.path){
            return imageFile
        } else {
            print("Couldn't load user picture to display by the comment textbox.")
            return nil
        }
    }

}
