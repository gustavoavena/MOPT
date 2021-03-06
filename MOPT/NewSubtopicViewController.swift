//
//  NewSubtopicViewController.swift
//  MOPT
//
//  Created by Filipe Marques on 04/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import CloudKit

class NewSubtopicViewController: UIViewController {
    
    var currentTopic:CKRecord?
    private let subtopicServices = SubtopicServices()
    
    @IBOutlet weak var newSubtopicName: UITextField!
    
    @IBAction func newSubtopicNameKeyboardAction(_ sender: UITextField) {
        hideKeyboard(textField: newSubtopicName)
    }
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        subtopicServices.createSubtopic(subtopicTitle: self.newSubtopicName.text!, topicRecordID: (currentTopic?.recordID)!, creatorRecordID: CurrentUser.shared().userRecordID!)
        //Code to create a new subtopic and segue the program to the subtopic created
        self.navigationController?.popViewController(animated: true)
    }

    func hideKeyboard(textField: UITextField) {
        self.newSubtopicName.resignFirstResponder()
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
