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
    func mainTableViewCellDel(cell: mainTableViewCell, cellContentTextDidChanged text:String)
    func mainTableViewCellDel(cell: mainTableViewCell, TextViewContentBeingChanged textView:UITextView)
}

class mainTableViewCell: MGSwipeTableCell {

    @IBOutlet weak var priorityBTn: SpringButton!
    @IBOutlet weak var contentTextView: UITextView!
    
    weak var mydelegate: MainTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentTextView.delegate = self
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


extension mainTableViewCell: UITextViewDelegate{
    func textViewDidEndEditing(textView: UITextView) {
        self.mydelegate?.mainTableViewCellDel(self, cellContentTextDidChanged: textView.text)
    }
    
    func textViewDidChange(textView: UITextView) {
        self.mydelegate?.mainTableViewCellDel(self, TextViewContentBeingChanged: textView)
    }
}