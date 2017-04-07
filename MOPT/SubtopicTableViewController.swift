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
        //print("printing comment = \(self.comments[indexPath.row]["text"])")
        cell.commentText.text = self.comments[indexPath.row]["text"] as? String
        
        cell.commentCreatorPicture.image = UIImage(named:"\((self.comments[indexPath.row]["creator"] as! CKRecord).recordID.recordName)ProfilePicture.jpg")
        
        let userServices = UserServices()
        userServices.downloadImage(imageURL: self.comments[indexPath.row]["profilePictureURL"]) {
            (data, error) in
            
            guard error == nil else {
                print("Error setting profile picture.")
                return
            }
            
            if let image = data {
                 cell.commentCreatorPicture.image = image
            } else {
                cell.commentCreatorPicture.image = UIImage(named:"example")
            }
           
        }
        
        //print(self.comments[indexPath.row]["creator"].recordID.recordName)
        //cell.commentCreatorPicture.image = self.comments[indexPath.row].creator.profilePicture
        //cell.commentCreatorPicture.image = self.comments[indexPath.row]["profilePicture"] as? UIImage
        //cell.commentCreatorPicture.image = UIImage(named:"example")
        return cell
    }
    
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        loadSubtopicComments(subtopicID: (currentSubtopic?.recordID)!)
        
    }
}
