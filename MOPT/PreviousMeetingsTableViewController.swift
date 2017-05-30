//
//  MeetingsTableViewController.swift
//  MOPT
//
//  Created by Filipe Marques on 03/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//


import UIKit

class PreviousMeetingsTableViewController: MeetingsTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.meetings = loadMeetings(fromUser: CurrentUser.shared().userID!, false)
        print("Loaded previous meetings view controller.")
    }
        
}
