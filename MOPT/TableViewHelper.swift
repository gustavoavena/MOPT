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
	
	
	public static func loadCellProfilePicture(userRecordID: CKRecordID, cell: UITableViewCell) -> UITableViewCell {
		let ckHandler = CloudKitHandler()
		let semaphore = DispatchSemaphore(value: 0)
		
		
		ckHandler.fetchByRecordID(recordID: userRecordID) {
			(response, error) in
			
			guard error == nil else {
				print("Error finding meeting creator record.")
				return
			}
			
			if let creatorRecord = response {
				
				let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
				let fileName = documentsDirectory.appendingPathComponent(String(format: "%@ProfilePicture.jpg", creatorRecord.recordID.recordName))
				
				if let imageFile = UIImage(contentsOfFile: fileName.path) {
					if cell is meetingsTableViewCell {
						(cell as! meetingsTableViewCell).moderatorPicture.image = imageFile
					} else if cell is topicsTableViewCell {
						(cell as! topicsTableViewCell).topicCreatorPicture.image = imageFile
					}
					
					print("Loaded profile picture from file.")
				}
				semaphore.signal()
				
			} else {
				print("Couldn't find meeting creator record.")
				return
			}
			
		}
		
		semaphore.wait()
		return cell

	}

}
