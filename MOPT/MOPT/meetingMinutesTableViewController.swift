//
//  meetingMinutesTableViewController.swift
//  MOPT
//
//  Created by Filipe Marques on 04/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import CloudKit

class meetingMinutesTableViewController: UITableViewController {
    
    var currentMeeting:CKRecord?
    var topics = [CKRecord]()
    let topicServices = TopicServices()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = currentMeeting?["title"] as? String
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return topics.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        for i in 0 ..< section {
            let subtopics = [CKRecord]()
            topicServices.getSubtopics(userRecordID: topics[i].recordID) {
                (subtopicRecords, error) in
                guard error == nil && subtopicRecords != nil else {
                    print("Error fetching subtopics")
                    return
                }
                self.subtopics = subtopicRecords!
            }
            if subtopics.count != 0 {
                return subtopics.count
            } else {
                return 1
            }
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let subtopics = [CKRecord]()
        topicServices.getSubtopics(userRecordID: topics[indexPath.row].recordID) {
            (subtopicRecords, error) in
            guard error == nil && subtopicRecords != nil else {
                print("Error fetching subtopics")
                return
            }
            self.subtopics = subtopicRecords!
        }
        if subtopics.count != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "subtopicConclusionCell", for: indexPath) as! SubtopicsConclusionTableViewCell
            cell.subtopicTitle.text = subtopics[indexPath.row]["title"] as? String
            cell.subtopicMinute.text = subtopics[indexPath.row]["concluion"] as? String
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "topicConclusionCell", for: indexPath) as! TopicConclusionTableViewCell
            cell.topicMinute.text = topics[indexPath.row]["conclusion"] as? String
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return topics[section]["title"] as? String
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
