//
//  CurrentMeetingTableViewController.swift
//  MOPT
//
//  Created by Adann Sérgio Simões on 05/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import CloudKit

class CurrentMeetingTableViewController: UITableViewController {
    
    var currentMeeting:CKRecord?
    var topics = [CKRecord]()
    private let meetingServices = MeetingServices()
    private let topicServices = TopicServices()
    private let subtopicServices = SubtopicServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print ("Getting CurrentMeeting = \(String(describing: currentMeeting))")
        topicServices.getMeetingTopics(meetingRecordID: (currentMeeting?.recordID)!) {
            (topicRecords, error) in
            guard error == nil else {
                print("Error fetching topics")
                return
            }
            self.topics = topicRecords
            OperationQueue.main.addOperation({
                self.tableView.reloadData()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = currentMeeting?["title"] as? String
    }
    
    @IBAction func endMeetingButton(_ sender: UIBarButtonItem) {
        meetingServices.endMeeting(meetingID: (currentMeeting?.recordID)!)
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return topics.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var subtopics = [CKRecord]()
        for i in 0 ..< section {
            topicServices.getSubtopics(topicRecordID: topics[i].recordID) {
                (subtopicRecords, error) in
                guard error == nil else {
                    print("Error fetching subtopics")
                    return
                }
                subtopics = subtopicRecords
            }
            if subtopics.count != 0 {
                return subtopics.count
            } else {
                return 1
            }
        }
        
        print("subtopiccount = \(subtopics.count)")
        if subtopics.count != 0 {
            return subtopics.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var subtopics = [CKRecord]()

        topicServices.getSubtopics(topicRecordID: topics[indexPath.section].recordID) {
            (subtopicRecords, error) in
            guard error == nil else {
                print("Error fetching subtopics")
                return
            }
            subtopics = subtopicRecords
        }
        
        sleep(2) // TODO: REMOVE IT
        if subtopics.count != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "subtopicAddConclusionCell", for: indexPath) as! subtopicsTableViewCell
            cell.subtopicTitle.text = subtopics[indexPath.row]["title"] as? String
            //cell.subtopicCreatorPicture.image = subtopics[indexPath.row]["profilePicture"] as? UIImage
            cell.subtopicCreatorPicture.image = UIImage(named:"example")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "topicAddConclusionCell", for: indexPath) as! topicsTableViewCell
            cell.topicName.text = self.topics[indexPath.row]["title"] as? String
            //cell.numberOfSubtopics.text = ""
            //cell.topicCreatorPicture.image = self.topics[indexPath.row]["profilePicture"] as? UIImage
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return topics[section]["title"] as? String
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.backgroundView?.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if segue.identifier == "addTopicConclusion",
            let segueDestination = segue.destination as? AddTopicConclusionViewController,
            let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedTopic = topics[indexPath.row]
                segueDestination.currentTopic = selectedTopic
        }
        
        
    }
   
}
