//
//  tabBarViewController.swift
//  Deliberate
//
//  Created by zane on 2/10/16.
//  Copyright © 2016 lzane. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.hidden = true
        self.selectedIndex = 2

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    



}



extension TabBarViewController: MenuViewControllerDelegate{
    //MARK:MenuViewControllerDelegate
    
    func menuViewController(controller: MenuViewController, btnDidClickIndex index: Int) {
        self.selectedIndex = index
    }
}
