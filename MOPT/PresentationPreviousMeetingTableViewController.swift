//
//  PresentationPreviousMeetingsTableViewController.swift
//  MOPT
//
//  Created by Filipe Marques on 11/04/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class PresentationPreviousMeetingsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.backgroundView?.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        header.textLabel?.textColor = UIColor(red:0.23, green:0.70, blue:0.48, alpha:1.0)
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        
    }
        
}
