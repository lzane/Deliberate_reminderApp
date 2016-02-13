//
//  HeaderViewController.swift
//  Deliberate
//
//  Created by zane on 2/10/16.
//  Copyright © 2016 lzane. All rights reserved.
//

import UIKit
import Spring

class HeaderViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func menuBtnDidClick(sender: AnyObject) {
        
        if let parentVC = self.parentViewController {
            parentVC.performSegueWithIdentifier("menuSegue", sender: self)
        }
        
    }
    
}
