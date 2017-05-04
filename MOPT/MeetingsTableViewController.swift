//
//  MeetingsTableViewController.swift
//  MOPT
//
//  Created by Filipe Marques on 03/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//



import UIKit
import CloudKit

class MeetingsTableViewController: UITableViewController {
    
    public private(set) var meetings = [Meeting]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
		self.meetings = loadMeetings(fromUser: CurrentUser.shared().userID!, true)
        print("Loaded meetings view")
    
    }

    func loadMeetings(fromUser userId: ObjectID, _ next: Bool) -> [Meeting] {
		
		if let user = Cache.get(objectType: .user, objectWithID: userId) as? User {
			return user.meetings
		} else {
			print("user not found.")
			return [Meeting]()
		}
		
	}
	
	
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetings.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "meetingCell", for: indexPath) as! MeetingsTableViewCell
		
		let meeting: Meeting = self.meetings[indexPath.row]
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        timeFormatter.dateFormat = "HH:mm"
        
        cell.meetingName.text = meeting.title
        cell.meetingTime.text = "\(timeFormatter.string(from:meeting.date))"
        cell.meetingDate.text = "\(dateFormatter.string(from:meeting.date))"
        cell.moderatorPicture.image = UIImage(named:"example") // Setting profile picture as default, in case query doesn't work.
		
		
        return TableViewHelper.loadCellProfilePicture(fromUser: meeting.creator.ID, cell: cell)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "segueToTopics",
//            let segueDestination = segue.destination as? TopicsTableViewController,
//            let indexPath = self.tableView.indexPathForSelectedRow {
//            let selectedMeeting = meetings[indexPath.row]
//            segueDestination.currentMeeting = selectedMeeting
//        }
//    }
	
    func handleRefresh(refreshControl: UIRefreshControl) {
		self.meetings = loadMeetings(fromUser: CurrentUser.shared().userID!, true)
    }

    
}
