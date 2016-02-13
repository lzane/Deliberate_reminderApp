//
//  mainTableViewController.swift
//  Deliberate
//
//  Created by zane on 2/11/16.
//  Copyright © 2016 lzane. All rights reserved.
//

import UIKit

class mainTableViewController: UITableViewController {
    
var reminderList = [Reminder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        //Data
        super.viewWillAppear(animated)

        let predicate = NSPredicate(format: " (isFinished == NO) AND (isInThought == NO)")
        reminderList = CoreDataController.fetchEntity("List", WithPredicate: predicate)!
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reminderList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mainCell", forIndexPath: indexPath) as! mainTableViewCell
        
        //backgroud color
        let isOdd = (indexPath.row % 2) == 0 ? true : false
        if isOdd {
            cell.backgroundColor = UIColor ( red: 0.8114, green: 0.8116, blue: 0.8114, alpha: 0.35 )
        }else{
            cell.backgroundColor = UIColor.clearColor()
        }
        
        
        cell.priorityBTn.selected = reminderList[indexPath.row].isImportant
        cell.contentTextView.text = reminderList[indexPath.row].content
        
        
        return cell
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.tableView.endEditing(true)
        
    }
    
}

extension mainTableViewController:mainViewControllerDelegate{
//MARK: mainViewControllerDelegate
    func mainViewController(mainVC: MainViewController, submitAdd remind: Reminder){
        CoreDataController.insertReminder(remind, toEntity: "List")
        reminderList.append(remind)
        self.tableView.reloadData()
    }
}