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
    private var comments = [CKRecord]()
    private let topicServices = TopicServices()
    private let subtopicServices = SubtopicServices()

    @IBOutlet weak var currentUserPicture: UIImageView!
    @IBOutlet weak var commentTextField: UITextView!
    @IBAction func sendCommentButton(_ sender: UIButton) {
        subtopicServices.addComment(subtopicRecordID: (currentSubtopic?.recordID)!, commentText: commentTextField.text, creatorRecordID: CurrentUser.shared().userRecordID!)
        loadSubtopicComments(subtopicID: (currentSubtopic?.recordID)!)
        commentTextField.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
        loadSubtopicComments(subtopicID: (currentSubtopic?.recordID)!)
    }
    
    func loadSubtopicComments(subtopicID:CKRecordID) {
        subtopicServices.getSubtopicComments(subtopicRecordID: (currentSubtopic?.recordID)!) {
            (commentRecords, error) in
            guard error == nil else {
                print("Error fetching comments")
                return
            }
            self.comments = commentRecords
            OperationQueue.main.addOperation({
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = currentSubtopic?["title"] as? String
        
        
        if let imageFile = TableViewHelper.getImageFromDirectory(userRecordName: CurrentUser.shared().userRecordID?.recordName){
            self.currentUserPicture.image = imageFile
        } else {
            print("Couldn't load user picture to display by the comment textbox.")
            self.currentUserPicture.image = UIImage(named:"example")
        }


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
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentsTableViewCell
        //print("printing comment = \(self.comments[indexPath.row]["text"])")
        cell.commentText.text = self.comments[indexPath.row]["text"] as? String
        
		cell.commentCreatorPicture.image = UIImage(named:"example")
		
		let creatorReference = self.comments[indexPath.row]["creator"] as! CKReference
		
		return TableViewHelper.loadCellProfilePicture(userRecordID: creatorReference.recordID, cell: cell)

	}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addConclusion",
            let segueDestination = segue.destination as? AddConclusionViewController {
            segueDestination.currentTopic = currentSubtopic
        }
    }

    
    func handleRefresh(refreshControl: UIRefreshControl) {
        loadSubtopicComments(subtopicID: (currentSubtopic?.recordID)!)
        
    }
}
