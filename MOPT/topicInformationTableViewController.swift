//
//  topicInformationTableViewController.swift
//  MOPT
//
//  Created by Filipe Marques on 03/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import CloudKit

class topicInformationTableViewController: UITableViewController {
    
    public var currentTopic:CKRecord?
    private var subtopics = [CKRecord]()
    private var comments = [CKRecord]()
    private let topicServices = TopicServices()
    
    @IBOutlet weak var currentUserPicture: UIImageView!
    @IBOutlet weak var commentTextField: UITextView!
    @IBAction func sendCommentButton(_ sender: UIButton) {
        topicServices.addComment(topicRecordID: (currentTopic?.recordID)!, commentText: commentTextField.text, creatorRecordID: CurrentUser.shared().userRecordID!)
        self.tableView.reloadData()
        commentTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentUserPicture.image = UIImage(named:"example")
        //self.currentUserPicture.image = UIImage(named:"example")
        
        topicServices.getSubtopics(topicRecordID: (currentTopic?.recordID)!) {
            (subtopicRecords, error) in
            guard error == nil && subtopicRecords != nil else {
                print("Error fetching subtopics")
                return
            }
            self.subtopics = subtopicRecords!
            OperationQueue.main.addOperation({
                self.tableView.reloadData()
            })
        }
        topicServices.getTopicComments(topicRecordID: (currentTopic?.recordID)!) {
            (commentRecords, error) in
            guard error == nil && commentRecords != nil else {
                print("Error fetching comments")
                return
            }
            self.comments = commentRecords!
            OperationQueue.main.addOperation({
                self.tableView.reloadData()
            })
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        self.navigationItem.title = currentTopic?["title"] as? String
        
        self.currentUserPicture.image = UIImage(named:"example")
        //self.currentUserPicture.image = UIImage(named:"example")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return subtopics.count
        }
        else {
            return comments.count
        }

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as! descriptionTableViewCell
            cell.topicDescription.text = self.currentTopic?["description"] as? String
            return cell
            
        }
            
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "subtopicCell", for: indexPath) as! subtopicsTableViewCell
            cell.subtopicTitle.text = self.subtopics[indexPath.row]["title"] as? String
            //cell.subtopicCreatorPicture.image = self.subtopics[indexPath.row].creator.profilePicture
            cell.subtopicCreatorPicture.image = UIImage(named:"example")
            return cell
            
        }
            
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! commentsTableViewCell
            cell.commentText.text = self.comments[indexPath.row]["text"] as? String
            //cell.commentCreatorPicture.image = self.comments[indexPath.row].creator.profilePicture
            cell.commentCreatorPicture.image = UIImage(named:"example")
            return cell
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSubtopic",
            let segueDestination = segue.destination as? SubtopicTableViewController,
            let indexPath = self.tableView.indexPathForSelectedRow {
            let selectedSubtopic = subtopics[indexPath.row]
            segueDestination.currentSubtopic = selectedSubtopic
        }
        if segue.identifier == "newSubtopic",
            let segueDestination = segue.destination as? NewSubtopicViewController {
            segueDestination.currentTopic = currentTopic
        }
    }
    
    // User commenting space
    

    
    

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

}
