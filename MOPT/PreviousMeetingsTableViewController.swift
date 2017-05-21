//
//  MeetingsTableViewController.swift
//  MOPT
//
//  Created by Filipe Marques on 03/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//


import UIKit
import CloudKit

class PreviousMeetingsTableViewController: UITableViewController {
    
    public private(set) var meetings = [Meeting]()
//    private let meetingServices = MeetingServices()
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
		self.meetings = loadMeetings(fromUser: CurrentUser.shared().userID!, false)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "previousMeetingCell", for: indexPath) as! PreviousMeetingsTableViewCell
        
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        timeFormatter.dateFormat = "HH:mm"
        
        cell.meetingName.text = self.meetings[indexPath.row].title
        cell.meetingTime.text = "\(timeFormatter.string(from:self.meetings[indexPath.row].date))"
        cell.meetingDate.text = "\(dateFormatter.string(from:self.meetings[indexPath.row].date))"

		cell.moderatorPicture.image = UIImage(named:"example")
		
		let creatorID =  self.meetings[indexPath.row].creatorID
		
		return TableViewHelper.loadCellProfilePicture(fromUser: creatorID, cell: cell)
		
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToMinute",
            let segueDestination = segue.destination as? TopicsTableViewController,
            let indexPath = self.tableView.indexPathForSelectedRow {
            let selectedMeeting = meetings[indexPath.row]
            segueDestination.currentMeeting = selectedMeeting
        }
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
		loadMeetings(fromUser: CurrentUser.shared().userID!, false)
        
    }
    
        
}
