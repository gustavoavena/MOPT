//
//  TopicsTableViewController.swift
//  MOPT
//
//  Created by Filipe Marques on 03/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import CloudKit


class TopicsTableViewController: UITableViewController {
    
    var currentMeeting:CKRecord?
    private var topics = [CKRecord]()
    private let topicServices = TopicServices()
    private let meetingServices = MeetingServices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
        loadTopics(meetingID: (currentMeeting?.recordID)!)

    }
    
    func loadTopics (meetingID: CKRecordID) {
        topicServices.getMeetingTopics(meetingRecordID: meetingID) {
            (topicRecords, error) in
            guard error == nil else {
                print("Error fetching topics")
                return
            }
            self.topics = topicRecords
            OperationQueue.main.addOperation({
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        self.navigationItem.title = currentMeeting?["title"] as? String
    }
    
    @IBAction func startMeetingButton(_ sender: UIBarButtonItem) {
        print("Starting Meeting = \(String(describing:currentMeeting))")
        meetingServices.startMeeting(meetingID: (currentMeeting?.recordID)!)
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var subtopics = [CKRecord]()
        let cell = tableView.dequeueReusableCell(withIdentifier: "topicCell", for: indexPath) as!TopicsTableViewCell
        cell.topicName.text = self.topics[indexPath.row]["title"] as? String
        topicServices.getSubtopics(topicRecordID:self.topics[indexPath.row].recordID){
            (subtopicRecords, error) in
            guard error == nil else {
                print("Error fetching subtopics")
                return
            }
            subtopics = subtopicRecords
        }
        cell.numberOfSubtopics.text = String(describing: subtopics.count) + (" subtopics")
        cell.topicCreatorPicture.image = UIImage(named:"example")
		
		let creatorReference = self.topics[indexPath.row]["creator"] as! CKReference
		
		return TableViewHelper.loadCellProfilePicture(fromUserID: creatorReference.recordID.recordName, cell: cell)
		
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToTopicInformation",
            let segueDestination = segue.destination as? TopicInformationTableViewController,
            let indexPath = self.tableView.indexPathForSelectedRow {
            let selectedTopic = topics[indexPath.row]
            segueDestination.currentTopic = selectedTopic
        }
        if segue.identifier == "newTopic",
            let segueDestination = segue.destination as? NewTopicViewController {
            segueDestination.currentMeeting = currentMeeting
        }
        if segue.identifier == "addParticipant",
            let segueDestination = segue.destination as? AddParticipantsViewController{
            segueDestination.currentMeeting = currentMeeting
        }
        if segue.identifier == "startMeeting",
            let segueDestination = segue.destination as? CurrentMeetingTableViewController {
            print("Sending CurrentMeeting = \(String(describing:currentMeeting))")
            segueDestination.currentMeeting = currentMeeting
        }
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        loadTopics(meetingID: (currentMeeting?.recordID)!)
        
    }
}
