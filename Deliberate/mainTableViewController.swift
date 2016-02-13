//
//  mainTableViewController.swift
//  Deliberate
//
//  Created by zane on 2/11/16.
//  Copyright © 2016 lzane. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import CoreData
import Spring

class mainTableViewController: UITableViewController {
    
    var type: String!
    var reminderList = [Reminder]()
    var predicate : NSPredicate!
    
    convenience init(Type type: String ){
        self.init()
        self.type = type
        if type == "mainView" {
            predicate = NSPredicate(format:"(isFinished == NO) AND (isInThought == NO)")
        }
        
    }
    
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
        reminderList = CoreDataController.fetchEntity("List", WithPredicate: predicate)!
        self.tableView.reloadData()
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
        
        //content
        
        let remind = reminderList[indexPath.row]
        
        cell.priorityBTn.selected = remind.isImportant
        cell.contentTextView.text = remind.content
        
        
        
        
        //fix arribute bug
        let attribute  = NSMutableAttributedString(string: cell.contentTextView.text)
        let range      = NSRange.init(location: 0, length: attribute.length)
        attribute.removeAttribute(NSStrikethroughStyleAttributeName, range: range)
        cell.contentTextView.attributedText = attribute
        
        //initialize
        let normalFont = UIFont.systemFontOfSize(18)
        let italicFont = UIFont.italicSystemFontOfSize(18)
        
        cell.contentTextView.font = normalFont
        cell.contentTextView.textColor = UIColor.blackColor()
        cell.priorityBTn.hidden = false
        cell.mydelegate = self

        
        //swipe table view cell
        cell.delegate = self
        cell.leftSwipeSettings.transition = MGSwipeTransition.Drag
        
        let expan           = MGSwipeExpansionSettings()
        expan.buttonIndex   = 0
        expan.fillOnTrigger = true
        expan.threshold     = 1.5
        cell.leftExpansion  = expan
        cell.rightExpansion = expan
        
        //if the cell is in thought
        if self.type == "mainView"{
            

            if remind.isFinished == true{
                attribute.addAttributes([NSStrikethroughStyleAttributeName:1],range: range)
                cell.contentTextView.attributedText = attribute
                cell.contentTextView.textColor = UIColor.lightGrayColor()
                cell.contentTextView.font = normalFont
                cell.priorityBTn.hidden = true
            }
            
            if remind.isInThought == true{
                
                cell.contentTextView.font = italicFont
                cell.contentTextView.textColor = UIColor.lightGrayColor()
                cell.priorityBTn.hidden = true
            }
            
        }
        
        return cell
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

extension mainTableViewController:MGSwipeTableCellDelegate{
    
    //function when the swipe button trigger
    func swipeTableCell(cell: MGSwipeTableCell!, tappedButtonAtIndex index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        
        let indexPath = self.tableView.indexPathForCell(cell)!
        let rowIndex = indexPath.row
        let remind = reminderList[rowIndex]
        let object = remind.managedObject!
        let mycell = cell as! mainTableViewCell
        
        //the delete Btn
        if direction == MGSwipeDirection.RightToLeft{
            if index == 0 {
                
                reminderList.removeAtIndex(rowIndex)
                CoreDataController.deleteObject(object, inEntity: "List")
                self.tableView.reloadData()
                
            }
        }else {
            if index == 0 {
                
                remind.isInThought = true
                CoreDataController.updateObject(object, byReminder: remind)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                mycell.priorityBTn.hidden = true
            }
        }
        
        return true
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, swipeButtonsForDirection direction: MGSwipeDirection, swipeSettings: MGSwipeSettings!, expansionSettings: MGSwipeExpansionSettings!) -> [AnyObject]! {
        //configure right buttons
        
        if direction == MGSwipeDirection.LeftToRight{
            return [MGSwipeButton(title: "加入思考", icon: UIImage(named:"check.png"), backgroundColor: UIColor ( red: 0.2421, green: 0.7965, blue: 0.4799, alpha: 1.0 )),]
        }else{
            return [MGSwipeButton(title: "删除", backgroundColor: UIColor ( red: 0.7744, green: 0.272, blue: 0.2278, alpha: 1.0 ))]
        }
        
    }
    
    
}

extension mainTableViewController:MainTableViewCellDelegate{
    func mainTableViewCellDel(cell: mainTableViewCell, priorityBtnDidClick btn: SpringButton) {
        
        let indexPath = self.tableView.indexPathForCell(cell)!
        let rowIndex = indexPath.row
        let remind = reminderList[rowIndex]
        let object = remind.managedObject!
        
        cell.priorityBTn.animation = "pop"
        cell.priorityBTn.animateNext { () -> () in
            cell.priorityBTn.hidden = true
        }
        
        remind.isFinished = !remind.isFinished
        CoreDataController.updateObject(object, byReminder: remind)
        
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)

    }
}