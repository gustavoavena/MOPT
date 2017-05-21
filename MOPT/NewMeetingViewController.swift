//
//  NewMeetingViewController.swift
//  MOPT
//
//  Created by Filipe Marques on 04/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class NewMeetingViewController: UIViewController {
    
//    let meetingServices = MeetingServices()

    @IBOutlet weak var newMeetingName: UITextField!
    
    @IBOutlet weak var newMeetingDate: UIDatePicker!
    
    @IBAction func newMeetingNameKeyboardAction(_ sender: UITextField) {
        hideKeyboard(textField: newMeetingName)
    }
    
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
//        meetingServices.createMeeting(title: self.newMeetingName.text!, date: self.newMeetingDate.date as NSDate, moderatorRecordID: CurrentUser.shared().userRecordID!)
		Meeting.create(title: self.newMeetingName.text!, date: self.newMeetingDate.date as Date, creator: CurrentUser.shared().userID!)
        //Code to create a new meeting and segue the program to the meeting created
        self.navigationController?.popViewController(animated: true)
    }
    
    func hideKeyboard(textField: UITextField) {
        self.newMeetingName.resignFirstResponder()
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
