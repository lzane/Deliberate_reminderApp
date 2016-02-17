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
        }else if type == "historyView" {
            predicate = NSPredicate(format:"isFinished == YES")
        }else if type == "siView"{
            predicate = NSPredicate(format:"(isInThought == YES) AND (isFinished == NO)")
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
        
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        reminderList = CoreDataController.fetchEntity("List", WithPredicate: predicate)!
        
        if self.type == "siView" || self.type == "historyView"{
            reminderList.sortInPlace { (remind1, remind2) -> Bool in
                let result :NSComparisonResult  = remind1.timeFinish.compare(remind2.timeFinish)
                return result == NSComparisonResult.OrderedDescending
            }
        }else{
            reminderList.sortInPlace({ (remind1, remind2) -> Bool in
                let result :NSComparisonResult  = remind1.timeCreat.compare(remind2.timeCreat)
                return result == NSComparisonResult.OrderedAscending
            })
        }
        
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
        cell.contentTextView.textAlignment = NSTextAlignment.Left
        cell.priorityBTn.userInteractionEnabled = true
        
        //swipe table view cell
        cell.delegate = self
        cell.leftSwipeSettings.transition = MGSwipeTransition.Drag
        
        let expanL           = MGSwipeExpansionSettings()
        expanL.buttonIndex   = 0
        expanL.fillOnTrigger = true
        expanL.threshold     = 1.5
        
        let expanR           = MGSwipeExpansionSettings()
        expanR.buttonIndex   = 0
        expanR.fillOnTrigger = true
        expanR.threshold     = 2
        
        cell.leftExpansion  = expanL
        cell.rightExpansion = expanR
        
        //if the cell is in thought or finish
        if self.type == "mainView"{
            
            if remind.isFinished == true{
                attribute.addAttributes([NSStrikethroughStyleAttributeName:1],range: range)
                cell.contentTextView.attributedText = attribute
                cell.contentTextView.textColor = UIColor.lightGrayColor()
                cell.contentTextView.font = normalFont
                cell.priorityBTn.hidden = true
                cell.contentTextView.textAlignment = NSTextAlignment.Right
            }
            
            if remind.isInThought == true{
                
                cell.contentTextView.font = italicFont
                cell.contentTextView.textColor = UIColor.lightGrayColor()
                cell.priorityBTn.hidden = true
                cell.contentTextView.textAlignment = NSTextAlignment.Right
            }
            
        }else if self.type == "historyView"{
            cell.contentTextView.font = normalFont
            cell.priorityBTn.userInteractionEnabled = false
            
            
        }else if self.type == "siView"{
            cell.contentTextView.font = normalFont
            cell.priorityBTn.userInteractionEnabled = false
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
    
    func swipeTableCell(cell: MGSwipeTableCell!, canSwipe direction: MGSwipeDirection, fromPoint point: CGPoint) -> Bool {
        if self.type == "mainView"{
            let indexPath = self.tableView.indexPathForCell(cell)!
            let rowIndex = indexPath.row
            let remind = reminderList[rowIndex]
            if direction == MGSwipeDirection.LeftToRight{
                if remind.isFinished == true || remind.isInThought == true{
                    return false
                }
            }
            
        }
        
        return true
    }
    
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
                if self.type == "mainView"{
                    remind.isInThought = true
                    remind.timeFinish = NSDate.init()
                    CoreDataController.updateObject(object, byReminder: remind)
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                    mycell.priorityBTn.hidden = true
                }else if self.type == "historyView"{
                    mycell.priorityBtnDidClick(mycell.priorityBTn)
                }else if self.type == "siView"{
                    mycell.priorityBtnDidClick(mycell.priorityBTn)
                }
                
            }
        }
        
        return true
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, swipeButtonsForDirection direction: MGSwipeDirection, swipeSettings: MGSwipeSettings!, expansionSettings: MGSwipeExpansionSettings!) -> [AnyObject]! {
        //configure right buttons
        
        if direction == MGSwipeDirection.LeftToRight{
            if self.type == "mainView" {
                return [MGSwipeButton(title: "加入思考", icon: UIImage(named:"check.png"), backgroundColor: UIColor ( red: 0.2421, green: 0.7965, blue: 0.4799, alpha: 1.0 )),]
            }else if self.type == "historyView" {
                return [MGSwipeButton(title: "恢复", icon: UIImage(named:"check.png"), backgroundColor: UIColor ( red: 0.2421, green: 0.7965, blue: 0.4799, alpha: 1.0 )),]
            }else if self.type == "siView"{
                return [MGSwipeButton(title: "完成思考", icon: UIImage(named:"check.png"), backgroundColor: UIColor ( red: 0.2421, green: 0.7965, blue: 0.4799, alpha: 1.0 )),]
            }
        }else{
            return [MGSwipeButton(title: "删除", backgroundColor: UIColor ( red: 0.7744, green: 0.272, blue: 0.2278, alpha: 1.0 ))]
        }
     
        
        return nil
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
            
            remind.isFinished = !remind.isFinished
            if remind.isFinished == false { // recover
                remind.timeCreat = NSDate.init()
                if self.type == "historyView"{
                remind.isInThought = false
                }
                
            } else { //finish
            remind.timeFinish = NSDate.init()
            }
            
            
            CoreDataController.updateObject(object, byReminder: remind)
            
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            
            if self.type == "historyView" || self.type == "siView"{
                self.viewWillAppear(true)
            }
        }
        
        
        
    }
    
    func mainTableViewCellDel(cell: mainTableViewCell, cellContentTextDidChanged text: String) {
        let indexPath = self.tableView.indexPathForCell(cell)!
        let rowIndex = indexPath.row
        let remind = reminderList[rowIndex]
        let object = remind.managedObject!
        
        remind.content = text
        CoreDataController.updateObject(object, byReminder: remind)
    }
    
    func mainTableViewCellDel(cell: mainTableViewCell, TextViewContentBeingChanged textView: UITextView) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}