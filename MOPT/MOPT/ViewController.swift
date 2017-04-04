//
//  ViewController.swift
//  MOPT
//
//  Created by Slackers: on 28/03/17.
//  Gustavo Avena
//  Filipe Marques
//  Rodrigo Hilkner
//  Adann Sergio
// 
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

let recordTypes = ["Meeting", "Topic", "Comment", "User", "TimeControl"]

class ViewController: UIViewController {
    
    @IBOutlet weak var meetingName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        User.testQuery()
                
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

