//
//  mainTableViewCell.swift
//  Deliberate
//
//  Created by zane on 2/11/16.
//  Copyright © 2016 lzane. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import Spring

protocol MainTableViewCellDelegate: class{
    func mainTableViewCellDel(cell: mainTableViewCell, priorityBtnDidClick btn:SpringButton)
}

class mainTableViewCell: MGSwipeTableCell {

    @IBOutlet weak var priorityBTn: SpringButton!
    @IBOutlet weak var contentTextView: UITextView!
    
    weak var mydelegate: MainTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func priorityBtnDidClick(sender: AnyObject) {
        mydelegate?.mainTableViewCellDel(self, priorityBtnDidClick: sender as! SpringButton)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    

    

}
