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
    
    var currentMeeting:Meeting!
//    private let topicServices = TopicServices()
	
    @IBOutlet weak var newTopicName: UITextField!

    @IBOutlet weak var newTopicDescription: UITextView!
    
    @IBAction func newTopicNameKeyboardAction(_ sender: UITextField) {
        hideKeyboard(textField: newTopicName)
    }
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
//        topicServices.createTopic(title: self.newTopicName.text!, description: self.newTopicDescription.text, meetingRecordID: (currentMeeting?.recordID)!, creatorRecordID: CurrentUser.shared().userRecordID!)
		Topic.create(title: self.newTopicName.text!, meeting: currentMeeting.ID, creator: CurrentUser.shared().userID!, subject: nil, info: self.newTopicDescription.text!)
        //Code to create a new topic and segue the program to the topic created
        self.navigationController?.popViewController(animated: true)
    }
    
    func hideKeyboard(textField: UITextField) {
        self.newTopicName.resignFirstResponder()
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
