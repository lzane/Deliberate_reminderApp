//
//  MainViewController.swift
//  Deliberate
//
//  Created by zane on 2/10/16.
//  Copyright © 2016 lzane. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {
    let header = HeaderViewController()
    let tableViewController = mainTableViewController()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header.view.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 154)
        self.addChildViewController(header)
        self.view.addSubview(header.view)

        self.tableView.delegate = tableViewController
        self.tableView.dataSource = tableViewController
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.view.bringSubviewToFront(header.view)

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
        self.view.endEditing(true)
    }
    

}
