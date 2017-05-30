//
//  CommentsViewController.swift
//  mOpt Storyboards
//
//  Created by Filipe Marques on 03/05/17.
//  Copyright © 2017 Filipe Marques. All rights reserved.
//

import UIKit



class CommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //@IBOutlet weak var scrollViewComments: UIScrollView!
    
    var currentTopic:Topic!
    
    @IBOutlet weak var commentsTableView: UITableView!
    
    @IBOutlet weak var keyboardAccessoryView: UIView!
    
    @IBOutlet weak var commentTextField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commentsTableView.estimatedRowHeight = 150
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)

        // Do any additional setup after loading the view.
        self.commentTextField.inputAccessoryView = keyboardAccessoryView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = currentTopic.title
        //self.commentsTableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        } else {
            return (currentTopic?.comments.count)!
        }
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as! DescriptionTableViewCell
            cell.topicDescription.text = currentTopic.info ?? ""
            
            
            let dateFormatter = DateFormatter()
            let timeFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM"
            timeFormatter.dateFormat = "HH:mm"
            
            let topicDateCreation = dateFormatter.string(from:currentTopic.date)
            let topicTimeCreation = timeFormatter.string(from:currentTopic.date)
            
            cell.topicInformation.text = "[ Created by \((currentTopic?.creator.name)!) - \(topicDateCreation) \(topicTimeCreation) ]"
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
            cell.commentText.text = currentTopic?.comments[indexPath.row].text
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    
//    func keyboardWillShow(notification:NSNotification){
//        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
//        var userInfo = notification.userInfo!
//        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
//        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
//        
//        var contentInset:UIEdgeInsets = self.scrollViewComments.contentInset
//        contentInset.bottom = keyboardFrame.size.height
//        self.scrollViewComments.contentInset = contentInset
//    }
//    
//    func keyboardWillHide(notification:NSNotification){
//        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
//        self.scrollViewComments.contentInset = contentInset
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
