//
//  TopicInformationTableViewController.swift
//  MOPT
//
//  Created by Filipe Marques on 03/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import CloudKit

class TopicInformationTableViewController: UITableViewController {
    
    public var currentTopic:CKRecord?
    private var subtopics = [CKRecord]()
    private var comments = [CKRecord]()
    private let topicServices = TopicServices()
    
    @IBOutlet weak var currentUserPicture: UIImageView!
    
    @IBOutlet weak var commentTextField: UITextView!
    
    @IBAction func sendCommentButton(_ sender: UIButton) {
        topicServices.addComment(topicRecordID: (currentTopic?.recordID)!, commentText: commentTextField.text, creatorRecordID: CurrentUser.shared().userRecordID!)
        loadTopicInformation(topicID: (currentTopic?.recordID)!)
        commentTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentUserPicture.image = UIImage(named:"example")
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
		
		
		
        loadTopicInformation(topicID: (currentTopic?.recordID)!)
		
        
    }
    
    func loadTopicInformation(topicID:CKRecordID) {
        topicServices.getSubtopics(topicRecordID: topicID) {
            (subtopicRecords, error) in
            guard error == nil else {
                print("Error fetching subtopics")
                return
            }
            self.subtopics = subtopicRecords
            OperationQueue.main.addOperation({
                self.tableView.reloadData()
            })
        }
        topicServices.getTopicComments(topicRecordID: topicID) {
            (commentRecords, error) in
            guard error == nil else {
                print("Error fetching comments")
                return
            }
            self.comments = commentRecords
            OperationQueue.main.addOperation({
                self.tableView.reloadData()
            })
        }
        self.refreshControl?.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        self.navigationItem.title = currentTopic?["title"] as? String
        
        if let imageFile = TableViewHelper.getImageFromDirectory(userRecordName: CurrentUser.shared().userRecordID?.recordName){
            self.currentUserPicture.image = imageFile
        } else {
            print("Couldn't load user picture to display by the comment textbox.")
            self.currentUserPicture.image = UIImage(named:"example")
        }

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
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as! DescriptionTableViewCell
            cell.topicDescription.text = self.currentTopic?["description"] as? String
            return cell
            
        }
            
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "subtopicCell", for: indexPath) as! SubtopicsTableViewCell
            cell.subtopicTitle.text = self.subtopics[indexPath.row]["title"] as? String
            cell.subtopicCreatorPicture.image = UIImage(named:"example")
			
			let creatorReference = self.subtopics[indexPath.row]["creator"] as! CKReference
			
			return TableViewHelper.loadCellProfilePicture(userRecordID: creatorReference.recordID, cell: cell)

			
        }
            
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentsTableViewCell
            cell.commentText.text = self.comments[indexPath.row]["text"] as? String
            cell.commentCreatorPicture.image = UIImage(named:"example")
			
			
			let creatorReference = self.comments[indexPath.row]["creator"] as! CKReference
			
			return TableViewHelper.loadCellProfilePicture(userRecordID: creatorReference.recordID, cell: cell)
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
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        loadTopicInformation(topicID: (currentTopic?.recordID)!)
    }
}
