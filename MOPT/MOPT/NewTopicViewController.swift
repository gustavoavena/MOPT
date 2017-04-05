//
//  NewTopicViewController.swift
//  MOPT
//
//  Created by Filipe Marques on 04/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import CloudKit

class NewTopicViewController: UIViewController {
    
    var currentMeeting:CKRecord?
    private let topicServices = TopicServices()
    
    @IBOutlet weak var newTopicName: UITextField!

    @IBOutlet weak var newTopicDescription: UITextView!
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        topicServices.createTopic(title: newTopicName, description: newTopicDescription, meetingRecordID: currentMeeting?.recordID, creatorRecordID: CKRecordID)
        //Code to create a new topic and segue the program to the topic created
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
