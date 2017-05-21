//
//  MeetingTableViewCell.swift
//  mOpt Storyboards
//
//  Created by Filipe Marques on 29/04/17.
//  Copyright © 2017 Filipe Marques. All rights reserved.
//

import UIKit

class MeetingTableViewCell: UITableViewCell {

    @IBOutlet weak var meetingName: UILabel!
    @IBOutlet weak var meetingDate: UILabel!
    @IBOutlet weak var meetingTime: UILabel!
	
	// TODO: declare creatorImage outlet.
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
