//
//  AddConclusionViewController.swift
//  MOPT
//
//  Created by Filipe Marques on 12/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import CloudKit

class AddConclusionViewController: UIViewController {
    
    var currentTopic:CKRecord?
    
    @IBAction func finishConclusionButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var conclusion: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = currentTopic?["title"] as? String
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
