//
//  AddTopicConclusionViewController.swift
//  MOPT
//
//  Created by Adann Sérgio Simões on 05/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import CloudKit

class AddTopicConclusionViewController: UIViewController {
    
    var currentTopic:Topic!
//    private var topicServices = TopicServices()
	
    @IBOutlet weak var topicConclusion: UITextField!
    
    
    @IBAction func doneConclusionButton(_ sender: UIBarButtonItem) {
//        topicServices.addTopicConclusion(topicRecordID: (currentTopic?.recordID)!, conclusion: self.topicConclusion.text!)
		currentTopic.conclusion = self.topicConclusion.text!
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
