//
//  Reminder.swift
//  Deliberate
//
//  Created by zane on 2/12/16.
//  Copyright © 2016 lzane. All rights reserved.
//

import UIKit
import CoreData

class Reminder: NSObject {
    var content :      String!
    var isFinished :   Bool!
    var isImportant :  Bool!
    var isInThought :  Bool!
    var timeCreat :    NSDate!
    var timeFinish :   NSDate!
    var managedObject: NSManagedObject?
    
    override init() {
        super.init()
        content     = ""
        isFinished  = false
        isImportant = false
        isInThought = false
        timeCreat   = NSDate.init()
        timeFinish  = NSDate.init()
    }
    
    init(ReminderfromNSMangedObject object:NSManagedObject){
    
        content     = object.valueForKey("content") as! String
        isFinished  = object.valueForKey("isFinished") as! Bool
        isImportant = object.valueForKey("isImportant") as! Bool
        isInThought = object.valueForKey("isInThought") as! Bool
        timeCreat   = object.valueForKey("timeCreat") as! NSDate
        timeFinish  = object.valueForKey("timeFinish") as! NSDate
        managedObject = object
        
    }
    
    convenience init(Content content:String, isimportant important:Bool){
        self.init()
        self.content = content
        self.isImportant = important
    }
    
}
