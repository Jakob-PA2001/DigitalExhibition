//
//  DBManager.swift
//  DigitalExhibition
//
//  Created by Admin on 11/5/20.
//  Copyright © 2020 PA2001. All rights reserved.
//

import UIKit
import CoreData

class DBManager: NSObject {
    
    var products: [NSManagedObject] = []
    
    func addRow( gender:String, age:String, nationality:String) {
        // set the core data to access the Product Entity
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let prefix = "S-"
        let sid = prefix + getNewId()
        
        let entity = NSEntityDescription.entity(forEntityName: "Surveys", in: managedContext)
        let product = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        product.setValue(sid, forKey: "sid")
        product.setValue(age, forKey: "age")
        product.setValue(gender,  forKey: "gender")
        product.setValue(nationality, forKey: "nationality")
        
        do {
            try managedContext.save()
            products.append(product)
       //     showMessage("Information is added")
        }
        catch let error as NSError {
            print("Error While Adding to Core Data: " + (error as! String) )
        }
    }
    
    
    func getNewId() -> String {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return ""}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Surveys")
        do {
            let searchQuery = "S-1"
            fetchRequest.predicate = NSPredicate(format: "id == %@", searchQuery)
            products  = try managedContext.fetch(fetchRequest)
        }
        catch let error as NSError{
            print("Error While Retrieving from Core Data" + (error as! String) )
        }
        var msg: String = "1"
        
        if(products.isEmpty) {
            return msg;
        } else {
            msg = getLastSurvey()
            print(msg)
        }
        return msg
    }
    
    func getLastSurvey() -> String {
        var msg : String!
        var newSid: Int!
        
        let yolo = retrieveRows()
        
        //For loop for debugging
        for counter in 0...(yolo.count - 1)  {
            print(yolo[counter])
        }
        
        msg = yolo[yolo.count - 4]
        let lastSid = msg.split(separator: "-")
        let sidSuffix = Int(lastSid[1])
        newSid = sidSuffix
        newSid = newSid + 1
        msg = String(newSid)
        
        return msg
    }
    
    func retrieveRows() -> [String] {  // return array of Strings
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return [""]}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Surveys")
        do {
            products  = try managedContext.fetch(fetchRequest)
        }
        catch let error as NSError{
            print("Error While Retrieving from Core Data" + (error as! String) )
        }
        var msg : [String] = []
        print(products.count)
        for product in products {
                msg.append((product.value(forKeyPath: "id") as? String)!)
                msg.append((product.value(forKeyPath: "age") as? String)!)
                msg.append((product.value(forKeyPath: "gender") as? String)!)
                msg.append((product.value(forKeyPath: "nationality") as? String)!)
        }
        return msg
    }
    
    //DEBUG FUNCTION - DELETES ALL SURVEY DATA
    func deleteAll() {        // delete an item based on key: name
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Surveys")
        do {
            products  = try managedContext.fetch(fetchRequest)
            for product in products {
                managedContext.delete(product)
            }
        }
        catch { }
        do {
            try managedContext.save()
        }
            catch {  }
    }
    //}

}
