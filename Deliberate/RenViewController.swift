//
//  renViewController.swift
//  Deliberate
//
//  Created by zane on 2/10/16.
//  Copyright © 2016 lzane. All rights reserved.
//

import UIKit

class RenViewController: UIViewController {
    
    let header = HeaderViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header.view.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 154)
        self.addChildViewController(header)
        self.view.addSubview(header.view)
        
        header.view.translatesAutoresizingMaskIntoConstraints = false ;
        
        self.view.addConstraint(NSLayoutConstraint(item: header.view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 20))
        self.view.addConstraint(NSLayoutConstraint(item: header.view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: header.view, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: header.view, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0))
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

}
