//
//  SubtopicTableViewController.swift
//  MOPT
//
//  Created by Filipe Marques on 03/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import CloudKit

class SubtopicTableViewController: UITableViewController {
    
    var currentSubtopic:CKRecord?
    public private (set) var comments = [CKRecord]()
    private let topicServices = TopicServices()
    private let subtopicServices = SubtopicServices()

    @IBOutlet weak var currentUserPicture: UIImageView!
    @IBOutlet weak var commentTextField: UITextView!
    @IBAction func sendCommentButton(_ sender: UIButton) {
        subtopicServices.addComment(subtopicRecordID: currentSubtopic?.recordID, commentText: commentTextField, creatorRecordID: CKRecordID)
        self.tableView.reloadData()
        commentTextField.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        topicServices.getSubtopicComments(topicRecordID: currentSubtopic?.recordID) {
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
        self.navigationItem.title = currentSubtopic?["title"] as? String
        
        self.currentUserPicture.image = UIImage(named:"example")
        //self.currentUserPicture.image = UIImage(named:"example")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! commentsTableViewCell
        cell.commentText.text = self.comments[indexPath.row]["text"] as! String
        
        cell.commentCreatorPicture.image = UIImage(named:"example")
        //cell.commentCreatorPicture.image = self.comments[indexPath.row].creator.profilePicture
        return cell
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
