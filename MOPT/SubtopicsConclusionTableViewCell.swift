//
//  SubtopicsConclusionTableViewCell.swift
//  MOPT
//
//  Created by Filipe Marques on 04/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class SubtopicsConclusionTableViewCell: UITableViewCell {

    @IBOutlet weak var subtopicTitle: UILabel!
    @IBOutlet weak var subtopicMinute: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
