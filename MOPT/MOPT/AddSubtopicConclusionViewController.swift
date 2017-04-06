//
//  AddSubtopicConclusionViewController.swift
//  MOPT
//
//  Created by Adann Sérgio Simões on 05/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import CloudKit

class AddSubtopicConclusionViewController: UIViewController {
    
    var currentSubtopic:CKRecord?
    private var subtopicServices = SubtopicServices()
    
    @IBOutlet weak var subtopicConclusion: UITextField!
    
    @IBAction func doneSubtopicConclusion(_ sender: UIBarButtonItem) {
        subtopicServices.addSubopicConclusion(topicRecordID: currentSubtopic?.recordID, conclusion: self.subtopicConclusion.text)
        self.navigationController?.popViewController(animated: true)
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
