//
//  topicsTableViewCell.swift
//  MOPT
//
//  Created by Filipe Marques on 03/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class topicsTableViewCell: UITableViewCell {

    @IBOutlet weak var topicName: UILabel!
    @IBOutlet weak var numberOfSubtopics: UILabel!
    @IBOutlet weak var topicCreatorPicture: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
