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
        for i in 0 ..< section {
            var subtopics = [CKRecord]()
            topicServices.getSubtopics(topicRecordID: topics[i].recordID) {
                (subtopicRecords, error) in
                guard error == nil && subtopicRecords != nil else {
                    print("Error fetching subtopics")
                    return
                }
                subtopics = subtopicRecords!
            }
            if subtopics.count != 0 {
                return subtopics.count
            } else {
                return 1
            }
        }
        
        return 0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var subtopics = [CKRecord]()

        topicServices.getSubtopics(topicRecordID: topics[indexPath.section].recordID) {
            (subtopicRecords, error) in
            guard error == nil && subtopicRecords != nil else {
                print("Error fetching subtopics")
                return
            }
            subtopics = subtopicRecords!
        }
        if subtopics.count != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "subtopicAddConclusionCell", for: indexPath) as! subtopicsTableViewCell
            cell.subtopicTitle.text = subtopics[indexPath.row]["title"] as? String
            //cell.subtopicCreatorPicture.image =
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "topicAddConclusionCell", for: indexPath) as!topicsTableViewCell
            cell.topicName.text = self.topics[indexPath.row]["title"] as? String
            cell.numberOfSubtopics.text = ""
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return topics[section]["title"] as? String
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if segue.identifier == "addTopicConclusion",
            let segueDestination = segue.destination as? AddTopicConclusionViewController,
            let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedTopic = topics[indexPath.row]
                segueDestination.currentTopic = selectedTopic
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
