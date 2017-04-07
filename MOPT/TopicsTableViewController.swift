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
        let cell = tableView.dequeueReusableCell(withIdentifier: "topicCell", for: indexPath) as!topicsTableViewCell
        cell.topicName.text = self.topics[indexPath.row]["title"] as? String
        topicServices.getSubtopics(topicRecordID:self.topics[indexPath.row].recordID){
            (subtopicRecords, error) in
            guard error == nil && subtopicRecords != nil else {
                print("Error fetching subtopics")
                return
            }
            subtopics = subtopicRecords!
        }
        cell.numberOfSubtopics.text = String(describing: subtopics.count) + (" subtopics")
        //cell.topicCreatorPicture.image = UIImage.self.topics[indexPath.row][""]
        cell.topicCreatorPicture.image = UIImage(named:"example")

        return cell
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToTopicInformation",
            let segueDestination = segue.destination as? topicInformationTableViewController,
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
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
     
     
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
