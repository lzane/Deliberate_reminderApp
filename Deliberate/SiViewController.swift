//
//  siViewController.swift
//  Deliberate
//
//  Created by zane on 2/10/16.
//  Copyright © 2016 lzane. All rights reserved.
//

import UIKit

class SiViewController: UIViewController {

    let header = HeaderViewController()
    let tableViewController = mainTableViewController(Type: "siView")

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subScrollView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header.view.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 154)
        self.addChildViewController(header)
        self.subScrollView.addSubview(header.view)
        
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
    @IBAction func si_PreViewBtnDidClick(sender: AnyObject) {
        self.performSegueWithIdentifier("si_Preview", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "menuSegue"{
            let menuCV = segue.destinationViewController as! MenuViewController
            menuCV.delegate = self.tabBarController as! TabBarViewController
        }else if segue.identifier == "si_Preview"{
            let siPreViewVC = segue.destinationViewController as! SiPreviewViewController
            siPreViewVC.reminderList = self.tableViewController.reminderList
        }
        
        
    }

}



extension SiViewController: UIScrollViewDelegate{
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}
