//
//  DescriptionTableViewCell.swift
//  mOpt Storyboards
//
//  Created by Filipe Marques on 30/04/17.
//  Copyright © 2017 Filipe Marques. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var topicDescription: UILabel!
    @IBOutlet weak var topicInformation: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
