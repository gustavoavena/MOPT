//
//  topicInformationTableViewController.swift
//  MOPT
//
//  Created by Filipe Marques on 03/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class topicInformationTableViewController: UITableViewController {
    
    let testUser = User(name: "Farol", fbUsername: "filipemarques.568", email: "fi.marques33@gmail.com", profilePicture: #imageLiteral(resourceName: "example"))
    
    public var currentTopic:Topic?
    private var topicDescription:String?
    private var subtopics = [Topic]()
    private var comments = [Comment]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        if self.currentTopic?.subtopics != nil {
            subtopics = (self.currentTopic?.subtopics)!
        }
        if self.currentTopic?.subtopics != nil {
           comments = (self.currentTopic?.comments)!
        }
        
        subtopics.append(Topic(title:"Câmera", text: "", creator: testUser, subtopics: nil, comments: nil, isSubtopic: true, meeting: (currentTopic?.meeting)!  ))
        
        comments.append(Comment(text: "Deveríamos colocar uma câmerablablablablablablaba asdsfkladnfl asdnfklasdflk ihasd,jfbasdlk flksdhfklasdhkfjg dsj faldshflasdhfadslfhalsd gfjads fjhasdjgdjkg afghliae wriaweh flia sdfy sdalfhasdf asdo ifhlewfh aksd f idshfjlsda hgf ldksag lhadg dsahfjagdfjkasd fjhdsjfasdhukfhasd lfhjkehfuah fjdabfjasd gfjkgdsjkg dsag gfkjasd gfjkasdhfkjd sfdsajfgkjdsf kesgd fkadgfkjgdkjgdkjgakjdgfkjgsdk jfgdkjgfkadsgf kjdg kdsg fkjdgfkjagd jkfgaksdjfgjkadsgfkjadsg fjadgsfkdsgfuiewgf sdugfukdsagfkwaegfukeg fkusdgfkjadsgf kjdsag faejsgd fkuewgkjfadsgfkajdg fkjae gsfukegkjfekfjaehkfhaewku fg ekfjhaejf zskuf gsdkjfakj fkgakug fkuag kf agkuefg ukadsfahef iaye gfkeuhf is faoiefoasfhla fkuae gfuakdgfku aefgkafjbsd kufaewg fkuag fkusda fgakuwf gakwu fdku fakuf gakeu gfukae fgkuasdf", createdAt: Date(), creator: testUser))
        
        topicDescription = self.currentTopic?.text

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

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
            cell.topicDescription.text = self.topicDescription
            return cell
            
        }
            
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "subtopicCell", for: indexPath) as! subtopicsTableViewCell
            cell.subtopicTitle.text = self.subtopics[indexPath.row].title
            cell.subtopicCreatorPicture.image = self.subtopics[indexPath.row].creator.profilePicture
            return cell
            
        }
            
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! commentsTableViewCell
            cell.commentText.text = self.comments[indexPath.row].text
            cell.commentCreatorPicture.image = self.comments[indexPath.row].creator.profilePicture
            return cell
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
