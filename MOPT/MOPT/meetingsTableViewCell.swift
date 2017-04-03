//
//  meetingsTableViewCell.swift
//  MOPT
//
//  Created by Filipe Marques on 03/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class meetingsTableViewCell: UITableViewCell {

    @IBOutlet weak var meetingName: UILabel!
    @IBOutlet weak var meetingDate: UILabel!
    @IBOutlet weak var meetingTime: UILabel!
    @IBOutlet weak var moderatorPicture: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
