//
//  AddParticipantsViewController.swift
//  MOPT
//
//  Created by Filipe Marques on 04/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class AddParticipantsViewController: UIViewController {
    
    @IBOutlet weak var invitedUserName: UITextField!
    
    @IBOutlet weak var invitedUserEmail: UITextField!
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        //Code to add a new participant and segue the program back to the meeting
        self.dismiss(animated: true, completion:nil)
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
