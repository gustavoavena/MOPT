//
//  SubjectTableViewCell.swift
//  mOpt Storyboards
//
//  Created by Filipe Marques on 30/04/17.
//  Copyright © 2017 Filipe Marques. All rights reserved.
//

import UIKit

class SubjectTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var toggleButton: UIImageView!
    public var collapsed = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
