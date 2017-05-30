//
//  CommentsTableViewController.swift
//  mOpt Storyboards
//
//  Created by Filipe Marques on 05/05/17.
//  Copyright © 2017 Filipe Marques. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController {
    
    @IBOutlet var commentView: UIView!
    
    
    var currentTopic:Topic!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 150
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
        self.navigationItem.title = currentTopic.title
        //self.commentsTableView.reloadData()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        return self.commentView
    }
    
    func hideKeyboard() {
        tableView.endEditing(true)
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


extension CommentsTableViewController: UITableViewDataSource {
    
    // MARK: - Table view data source
    
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as! DescriptionTableViewCell
            
            cell.topicDescription.text = currentTopic.info ?? ""
            
            let dateFormatter = DateFormatter()
            let timeFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM"
            timeFormatter.dateFormat = "HH:mm"
            
            let topicDateCreation = dateFormatter.string(from:currentTopic.date)
            let topicTimeCreation = timeFormatter.string(from:currentTopic.date)
            
            cell.topicInformation.text = "[ Created by \(currentTopic.creator.name) - \(topicDateCreation) \(topicTimeCreation) ]"
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
            cell.commentText.text = currentTopic.comments[indexPath.row].text
            return cell
        }
    }
    
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        } else {
            return currentTopic.comments.count
        }
    }
}



extension CommentsTableViewController: UITableViewDelegate {
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
