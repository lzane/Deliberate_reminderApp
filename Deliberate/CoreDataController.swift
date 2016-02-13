//
//  CoreDataController.swift
//  Deliberate
//
//  Created by zane on 2/12/16.
//  Copyright © 2016 lzane. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: NSObject {

    class func insertReminder(reminder:Reminder, toEntity entity:String){
        let appDel  = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext

        let item    = NSEntityDescription.insertNewObjectForEntityForName(entity, inManagedObjectContext: context)
        
        item.setValue(reminder.content, forKey: "content")
        item.setValue(reminder.isFinished, forKey: "isFinished")
        item.setValue(reminder.isImportant, forKey: "isImportant")
        item.setValue(reminder.isInThought, forKey: "isInThought")
        item.setValue(reminder.timeCreat, forKey: "timeCreat")
        item.setValue(reminder.timeFinish, forKey: "timeFinish")
        reminder.managedObject = item
        
        do{
            try context.save()
            
        } catch {
            print("Coredata save Error")
        }
    }
    

    class func fetchEntity(entity: String ,WithPredicate predicate:NSPredicate) -> [Reminder]?{
        let appDel  = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext

        let request = NSFetchRequest(entityName: entity)
        request.predicate = predicate
        
        do{
            let results = try context.executeFetchRequest(request)
            var reminders = [Reminder]()
            for result in results as! [NSManagedObject] {
                let mid = Reminder(ReminderfromNSMangedObject: result)
                reminders.append(mid)
            }
            
            return reminders
        }catch{
            print("fetch Error")
        }
        return nil
    }
    
    class func updateObject(object: NSManagedObject, byReminder reminder:Reminder){
        
        let appDel  = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext

        object.setValue(reminder.content, forKey: "content")
        object.setValue(reminder.isFinished, forKey: "isFinished")
        object.setValue(reminder.isImportant, forKey: "isImportant")
        object.setValue(reminder.isInThought, forKey: "isInThought")
        object.setValue(reminder.timeCreat, forKey: "timeCreat")
        object.setValue(reminder.timeFinish, forKey: "timeFinish")
        
        do{
            try context.save()
            
        } catch {
            print("update Error")
        }

        
    }
    
    
    class func deleteObject(object: NSManagedObject, inEntity entity: String){
        let appDel  = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext
        
        context.deleteObject(object)
        
        do{
            try context.save()
        }catch{
            print("delete Error")
        }
        
    }
}

