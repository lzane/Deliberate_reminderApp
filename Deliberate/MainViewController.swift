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
    let tableViewController = mainTableViewController()
    
    weak var delegate: mainViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priorityBtn: SpringButton!
    @IBOutlet weak var addTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //View
        header.view.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 154)

        self.addChildViewController(header)
        self.view.addSubview(header.view)

        self.tableView.delegate = tableViewController
        self.tableView.dataSource = tableViewController
        self.tableViewController.view = self.tableView
        
        self.delegate = self.tableViewController
    }
    
    override func viewWillAppear(animated: Bool) {
        self.priorityBtn.hidden = true
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
        
        self.priorityBtn.animation = "slideLeft"
        self.priorityBtn.delay = 0.2
        self.priorityBtn.duration = 2
        self.priorityBtn.animateTo()
        
        self.priorityBtn.selected = false
    }
    
    @IBAction func editDidEndOnExit(sender: AnyObject) {
        let isImportant = self.priorityBtn.selected == true ? true : false
        var remind = Reminder(Content: self.addTextField.text!, isimportant: isImportant)
        self.addTextField.text = ""
        delegate?.mainViewController(self, submitAdd: remind)
        
        self.endEdit()
    }


    @IBAction func editBegin(sender: AnyObject) {
        self.priorityBtn.hidden = false
        self.priorityBtn.animation = "slideLeft"
        self.priorityBtn.delay = 0.2
        self.priorityBtn.duration = 0.7
        self.priorityBtn.animate()
        
    }
    @IBAction func priorityBtnDidClick(sender: AnyObject) {
        let btn = sender as! SpringButton
        btn.selected = !btn.selected
        btn.animation = "pop"
        btn.animate()
    }
    
}
