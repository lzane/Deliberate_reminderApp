//
//  MenuViewController.swift
//  Deliberate
//
//  Created by zane on 2/10/16.
//  Copyright © 2016 lzane. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: class {
    func menuViewController(controller: MenuViewController, btnDidClickIndex index:Int)
}

class MenuViewController: UIViewController {
    
    weak var delegate: MenuViewControllerDelegate?
    
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
             // Put it somewhere, give it a frame...
        UIView.animateWithDuration(0.5) {
            self.blurEffectView.effect = UIBlurEffect(style: .Light)
        }
        
        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

//MARK: button click
    @IBAction func dismissBtnDidClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func currentBtnDidClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.menuViewController(self, btnDidClickIndex: 0)
    }
    
    @IBAction func historyBtnDidClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.menuViewController(self, btnDidClickIndex: 1)
    }
    
    @IBAction func renBtnDidClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.menuViewController(self, btnDidClickIndex: 2)
    }
    
    @IBAction func siBtnDidClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.menuViewController(self, btnDidClickIndex: 3)
    }
    
}
