//
//  UpcomingMeetingsTableViewController.swift
//  mOpt Storyboards
//
//  Created by Filipe Marques on 28/04/17.
//  Copyright © 2017 Filipe Marques. All rights reserved.
//

import UIKit

class UpcomingMeetingsTableViewController: MeetingsTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.meetings = loadMeetings(fromUser: CurrentUser.shared().userID!, true)
        print("Loaded upcoming meetings view controller.")
    }
	
    
}
