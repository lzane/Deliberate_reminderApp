//
//  MainViewController.swift
//  Deliberate
//
//  Created by zane on 2/10/16.
//  Copyright © 2016 lzane. All rights reserved.
//

import UIKit
import CoreData
import Spring

protocol mainViewControllerDelegate: class{
    func mainViewController(mainVC: MainViewController, submitAdd remind: Reminder)
}

class MainViewController: UIViewController {
    let header = HeaderViewController()
    let tableViewController = mainTableViewController(Type: "mainView")
    
    weak var delegate: mainViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priorityBtn: SpringButton!
    @IBOutlet weak var addTextField: UITextField!
    @IBOutlet weak var fullScreenAsBtn: UIView!
    @IBOutlet weak var subScrollView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //View
        header.view.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 154)
      
        
        self.addChildViewController(header)
        self.subScrollView.addSubview(header.view)
        
        
        self.fullScreenAsBtn.hidden = true
        
        
        //Fix autolayout Problem
        header.view.translatesAutoresizingMaskIntoConstraints = false ;

        self.subScrollView.addConstraint(NSLayoutConstraint(item: header.view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.subScrollView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0))
        self.subScrollView.addConstraint(NSLayoutConstraint(item: header.view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.subScrollView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0))
        self.subScrollView.addConstraint(NSLayoutConstraint(item: header.view, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.subScrollView, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0))
        self.subScrollView.addConstraint(NSLayoutConstraint(item: header.view, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.subScrollView, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0))
        
        
        //priority button
        self.priorityBtn.animation = "slideLeft"
        self.priorityBtn.duration = 0
        self.priorityBtn.animateTo()
        
        self.priorityBtn.selected = false

        //delegate
        self.tableView.delegate = tableViewController
        self.tableView.dataSource = tableViewController
        self.tableViewController.view = self.tableView
        
        self.delegate = self.tableViewController
        self.scrollView.delegate = self
        
        
        self.scrollView.showsVerticalScrollIndicator = false
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.endEdit()
    }
    
    func endEdit(){
        self.view.endEditing(true)
        
        self.fullScreenAsBtn.hidden = true
        self.priorityBtn.animation = "slideLeft"
        self.priorityBtn.delay = 0.2
        self.priorityBtn.duration = 2
        self.priorityBtn.animateTo()
        
        self.priorityBtn.selected = false
    }
    
    @IBAction func editDidEndOnExit(sender: AnyObject) {
        let isImportant = self.priorityBtn.selected == true ? true : false
        let remind = Reminder(Content: self.addTextField.text!, isimportant: isImportant)
        self.addTextField.text = ""
        delegate?.mainViewController(self, submitAdd: remind)
        
        self.endEdit()
    }


    @IBAction func editBegin(sender: AnyObject) {
        self.fullScreenAsBtn.hidden = false
        
        self.priorityBtn.animation = "slideLeft"
        self.priorityBtn.delay = 0.4
        self.priorityBtn.duration = 0.7
        self.priorityBtn.animate()
        
    }
    @IBAction func endEditing(sender: AnyObject) {

        self.endEdit()
    }
    @IBAction func priorityBtnDidClick(sender: AnyObject) {
        let btn = sender as! SpringButton
        btn.selected = !btn.selected
        btn.animation = "pop"
        btn.animate()
    }
    
}

extension MainViewController: UIScrollViewDelegate{
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}
