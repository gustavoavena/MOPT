//
//  TopicsTableViewController.swift
//  mOpt Storyboards
//
//  Created by Filipe Marques on 29/04/17.
//  Copyright © 2017 Filipe Marques. All rights reserved.
//

import UIKit

class TopicsTableViewController: UITableViewController {
    
    var currentMeeting:Meeting!
    
    override func viewDidLoad() {
        guard let _ = currentMeeting else {
            print("meeting not loaded")
            return
        }
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        self.navigationItem.title = currentMeeting.title
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return currentMeeting.topics.count + currentMeeting.subjects.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section < currentMeeting.topics.count {
            return 1
        }
        return (currentMeeting.subjects[section-currentMeeting.topics.count].topics.count+1)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
		// TODO: delete this and make sure that view doesn't load without a current meeting.
		guard let meeting = currentMeeting else {
            print("meeting not loaded")
            return TopicTableViewCell()
        }
        
        let section = indexPath.section
        let row = indexPath.row
        let subjects = meeting.subjects
        
        if section < currentMeeting.topics.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell") as! TopicTableViewCell
            cell.title.text = meeting.topics[section].title
            return cell
        } else {
            if row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectCell") as! SubjectTableViewCell
                cell.title.text = subjects[section-currentMeeting.topics.count].title
//                cell.toggleButton.image = UIImage(named:(subjects[section-currentMeeting.topics.count].collapsed == true ? "Down Chevron" : "Up Chevron"))
                cell.toggleButton.image = UIImage(named: cell.collapsed == true ? "Down Chevron" : "Up Chevron")
                
//                cell.toggleButton.addTarget(self, action: #selector(self.toggleCollapse(sender:self, cell: cell)), forControlEvents: .TouchUpInside)
                
                cell.tag = section

                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell") as! TopicTableViewCell
                cell.title.text = subjects[section-currentMeeting.topics.count].topics[row-1].title
                return cell
            }
        }

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        // Header has fixed height
        if section < currentMeeting.topics.count {
            return 48
        } else {
            if row == 0 {
                return 52.0
            }
            
            return ((tableView.cellForRow(at: indexPath) as! SubjectTableViewCell).collapsed) ? 0 : 48.0
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToComments",
            let segueDestination = segue.destination as? CommentsTableViewController,
            let indexPath = self.tableView.indexPathForSelectedRow {
            if indexPath.section >= currentMeeting.topics.count {
                let selectedTopic = currentMeeting.subjects[indexPath.section-currentMeeting.topics.count].topics[indexPath.row-1]
                segueDestination.currentTopic = selectedTopic
            } else {
                let selectedTopic = currentMeeting.topics[indexPath.section]
                segueDestination.currentTopic = selectedTopic
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) is SubjectTableViewCell {
            if (indexPath.row == 0) {
                toggleCollapse(at: indexPath, cell: (tableView.cellForRow(at: indexPath) as! SubjectTableViewCell))
            }
        }
    }
    
    func toggleCollapse(at indexPath: IndexPath, cell: SubjectTableViewCell) {
        
        cell.collapsed = !(cell.collapsed)
        
        // Toggle collapse
//        currentMeeting?.subjects[indexPath.section-currentMeeting.topics.count].collapsed = cell.collapsed
        
        // FIXME: fix the logic.
//        
//        let start = 0
//        let end = start + (currentMeeting?.subjects[indexPath.section-currentMeeting.topics.count].topics.count)! + 1
//        
//        tableView.beginUpdates()
//            for _ in start ..< end + 1 {
//            tableView.reloadRows(at: [indexPath], with: .automatic)
//        }
//        tableView.endUpdates()
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
