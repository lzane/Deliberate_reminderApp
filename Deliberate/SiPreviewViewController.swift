//
//  siPreviewViewController.swift
//  Deliberate
//
//  Created by zane on 2/10/16.
//  Copyright © 2016 lzane. All rights reserved.
//

import UIKit
import Spring

class SiPreviewViewController: UIViewController {

    
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var closeBtn: SpringButton!
    
    @IBOutlet weak var priorityBtn: SpringButton!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var inThoughtTimeLabel: UILabel!
    @IBOutlet weak var mottoView: UIView!
    
    var reminderList : [Reminder]!
    var index : Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        animator = UIDynamicAnimator(referenceView: view)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        refreshData(false)
        
        self.closeBtn.transform = CGAffineTransformMakeTranslation(50, 0)
        self.closeBtn.hidden = false
        self.closeBtn.alpha = 0.7
        UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options:[], animations: { () -> Void in
            self.closeBtn.transform = CGAffineTransformMakeTranslation(0, 0)
            }) { (bool) -> Void in
                
        }
        
    }
    
    func refreshData(next:Bool){
        if next {
            index++
        }
        if index == self.reminderList.count{
            self.mottoView.hidden = false
            return
        }
        
        if self.reminderList.count == 0 {
            self.mottoView.hidden = false
            return
        }else{
            self.mottoView.hidden = true
        }
        
        
        delay(0.3) { () -> () in
            let scale = CGAffineTransformMakeScale(0.5, 0.5)
            let translate = CGAffineTransformMakeTranslation(0, -200)
            self.dialogView.transform = CGAffineTransformConcat(scale, translate)
            self.dialogView.hidden = false
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                let scale = CGAffineTransformMakeScale(1, 1)
                let translate = CGAffineTransformMakeTranslation(0, 0)
                self.dialogView.transform = CGAffineTransformConcat(scale, translate)

            })
            
            self.animator.removeAllBehaviors()
            self.dialogView.center = self.view.center
            self.snapBehavior = UISnapBehavior(item: self.dialogView, snapToPoint: self.view.center)
            self.animator.addBehavior(self.snapBehavior)
            
            let remind = self.reminderList[self.index]
            self.priorityBtn.selected = remind.isImportant
            self.contentLabel.text = remind.content
            let interval = -remind.timeFinish.timeIntervalSinceNow
            let day:Int = Int(interval)/(60*60*12)
            if day == 0 {
                self.inThoughtTimeLabel.text = "Today"
            }else{
                self.inThoughtTimeLabel.text = "\(day)D"
            }
            
            }
        
        
    }
    
    @IBAction func closeBtnDidClick(sender: AnyObject) {
        self.closeBtn.animation = "pop"
        self.closeBtn.animate()
       
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    var animator : UIDynamicAnimator!
    var attachmentBehavior : UIAttachmentBehavior!
    var gravityBehaviour : UIGravityBehavior!
    var snapBehavior : UISnapBehavior!
    
    @IBAction func panGesture(sender: AnyObject) {
        let myView = dialogView
        let location = sender.locationInView(view)
        let boxLocation = sender.locationInView(dialogView)
        
        if sender.state == UIGestureRecognizerState.Began {
            if snapBehavior != nil {
                animator.removeBehavior(snapBehavior)
            }
            
            let centerOffset = UIOffsetMake(boxLocation.x - CGRectGetMidX(myView.bounds), boxLocation.y - CGRectGetMidY(myView.bounds));
            attachmentBehavior = UIAttachmentBehavior(item: myView, offsetFromCenter: centerOffset, attachedToAnchor: location)
            attachmentBehavior.frequency = 0
            
            animator.addBehavior(attachmentBehavior)
        }
        else if sender.state == UIGestureRecognizerState.Changed {
            attachmentBehavior.anchorPoint = location
        }
        else if sender.state == UIGestureRecognizerState.Ended {
            animator.removeBehavior(attachmentBehavior)
            
            snapBehavior = UISnapBehavior(item: myView, snapToPoint: view.center)
            animator.addBehavior(snapBehavior)
            
            let translation = sender.translationInView(view)
//            print(translation)
            if translation.y > 180 {
                animator.removeAllBehaviors()
                let gravity = UIGravityBehavior(items: [dialogView])
                gravity.gravityDirection = CGVectorMake(0, 10)
                animator.addBehavior(gravity)
                
                let remind = self.reminderList[index]
                remind.timeFinish = NSDate.init()
                remind.isFinished = true
                CoreDataController.updateObject(remind.managedObject!, byReminder: remind)
                self.reminderList.removeAtIndex(index)
                refreshData(false)
                
                
                
            }else if translation.x < -120 {
                
                animator.removeAllBehaviors()
                let gravity = UIGravityBehavior(items: [dialogView])
                gravity.gravityDirection = CGVectorMake(-10, 0)
                animator.addBehavior(gravity)
                refreshData(true)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
}
