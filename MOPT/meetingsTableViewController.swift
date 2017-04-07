//
//  meetingsTableViewController.swift
//  MOPT
//
//  Created by Filipe Marques on 03/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//



import UIKit
import CloudKit

class meetingsTableViewController: UITableViewController {
    
    public private(set) var meetings = [CKRecord]()
    private let meetingServices = MeetingServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
        loadMeetings(CurrentUser.shared().userRecordID!, true)
    
    }

    func loadMeetings(_ userId: CKRecordID, _ next: Bool){
        
        meetingServices.getUserMeetings(userRecordID: userId, next) {
            (meetingRecords, error) in
            guard error == nil else {
                print("Error fetching meeting")
                return
            }
            self.meetings = meetingRecords
            OperationQueue.main.addOperation({
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            })
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "meetingCell", for: indexPath) as! meetingsTableViewCell
        
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        timeFormatter.dateFormat = "HH:mm"
        
        cell.meetingName.text = self.meetings[indexPath.row]["title"] as? String
        cell.meetingTime.text = "\(timeFormatter.string(from:self.meetings[indexPath.row]["date"] as! Date))"
        cell.meetingDate.text = "\(dateFormatter.string(from:self.meetings[indexPath.row]["date"] as! Date))"
        cell.moderatorPicture.image = UIImage(named:"example")
        //cell.moderatorPicture.image = self.meetings[indexPath.row]["profilePicture"] as? UIImage
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToTopics",
            let segueDestination = segue.destination as? TopicsTableViewController,
            let indexPath = self.tableView.indexPathForSelectedRow {
            let selectedMeeting = meetings[indexPath.row]
            print("selectedMeeting = \(selectedMeeting)") // TODO: Remove it
            segueDestination.currentMeeting = selectedMeeting
        }
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        loadMeetings(CurrentUser.shared().userRecordID!, false)
       
    }

    
}
