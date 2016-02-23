//
//  HistoryViewController.swift
//  Deliberate
//
//  Created by zane on 2/10/16.
//  Copyright © 2016 lzane. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    let header = HeaderViewController()
    let tableViewController = mainTableViewController(Type: "historyView")
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subScrollView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header.view.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 154)
        self.addChildViewController(header)
        self.subScrollView.addSubview(header.view)

        //Fix autolayout Problem
        header.view.translatesAutoresizingMaskIntoConstraints = false ;
        
        self.subScrollView.addConstraint(NSLayoutConstraint(item: header.view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.subScrollView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0))
        self.subScrollView.addConstraint(NSLayoutConstraint(item: header.view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.subScrollView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0))
        self.subScrollView.addConstraint(NSLayoutConstraint(item: header.view, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.subScrollView, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0))
        self.subScrollView.addConstraint(NSLayoutConstraint(item: header.view, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.subScrollView, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0))
        
        //delegate
        self.tableView.delegate = tableViewController
        self.tableView.dataSource = tableViewController
        self.tableViewController.view = self.tableView

        
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.delegate = self

    }
    
    override func viewWillAppear(animated: Bool) {
        self.view.bringSubviewToFront(header.view)
        self.tableViewController.viewWillAppear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "menuSegue"{
            let menuCV = segue.destinationViewController as! MenuViewController
            menuCV.delegate = self.tabBarController as! TabBarViewController
        }
    }

    @IBAction func deleteBtnDidClick(sender: AnyObject) {
        let alert = UIActionSheet.init(title: "确定删除", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "确定")
        alert.showInView(self.view)
    }
}

extension HistoryViewController: UIActionSheetDelegate{
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        let reminderList = self.tableViewController.reminderList
        for unit in reminderList{
            CoreDataController.deleteObject(unit.managedObject!, inEntity: "List")
        }
        self.tableViewController.viewWillAppear(true)
    }
}

extension HistoryViewController: UIScrollViewDelegate{
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}
