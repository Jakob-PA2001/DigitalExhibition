//
//  SurveyDBManager.swift
//  DigitalExhibition
//
//  Created by Admin on 18/5/20.
//  Copyright © 2020 PA2001. All rights reserved.
//

import SwiftUI
import Foundation
import CoreData
import Network

class SurveyDBManager: NSObject {
    
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
            products.append(product)
            try managedContext.save()
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
            fetchRequest.predicate = NSPredicate(format: "sid == %@", searchQuery)
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
        for product in products {
            msg.append((product.value(forKeyPath: "sid") as? String)!)
            msg.append((product.value(forKeyPath: "age") as? String)!)
            msg.append((product.value(forKeyPath: "gender") as? String)!)
            msg.append((product.value(forKeyPath: "nationality") as? String)!)
        }
        if (msg.isEmpty) {
            msg = []
        }
        return msg
    }
    
    func submitSurvey() { // return array of Strings
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
           return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Surveys")
        do {
           products  = try managedContext.fetch(fetchRequest)
        }
        catch let error as NSError{
           print("Error While Retrieving from Core Data" + (error as! String) )
        }
        
        if(!products.isEmpty) {
            let url = URL(string: "https://pa2001.cdms.westernsydney.edu.au/addsurvey.php")
            
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            
            var dataString = "secretWord=pa2001" // starting POST string with a secretWord
            // the POST string
            
            //var msg : [String] = []
            for product in products {
                dataString = dataString + "&a=\((product.value(forKeyPath: "gender") as? String)!)" // replace "username.txt with own declared variable.
                dataString = dataString + "&b=\((product.value(forKeyPath: "age") as? String)!)" // replace "password.txt with own declared variable.
                dataString = dataString + "&c=\((product.value(forKeyPath: "nationality") as? String)!)" // replace "password.txt with own declared variable.
                let dataD = dataString.data(using: .utf8) // convert to utf8 string
                
                do
                {
                
                    // EXECUTE POST REQUEST

                    let uploadJob = URLSession.shared.uploadTask(with: request, from: dataD)
                    {
                        data, response, error in
                        
                       
                    }
                    uploadJob.resume()
                    dataString = "secretWord=pa2001"
                }
            }
            deleteAll()
        }
        // convert POST string to utf8 format
        
    }
    
    struct surveyAttr {
      let sid: String
      let age: String
      let gender : String
      let nationality : String
    }
    
    func retrieveAttr() -> [SurveyDBManager.surveyAttr] {  // return array of Strings
       guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
           return [surveyAttr(sid: "", age: "", gender: "", nationality: "")]}
       let managedContext = appDelegate.persistentContainer.viewContext
       let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Surveys")
       do {
           products  = try managedContext.fetch(fetchRequest)
       }
       catch let error as NSError{
           print("Error While Retrieving from Core Data" + (error as! String) )
       }
       
       var surveyList = [surveyAttr(sid: "Survey-Id", age: "Age", gender: "Gender", nationality: "Nationality")]
        if(products.isEmpty) {
            surveyList.append(surveyAttr(sid: " ", age: " ", gender: " ", nationality: " "))
            
        }
        else {
           for product in products {
               
               surveyList.append(surveyAttr(sid: (product.value(forKeyPath: "sid") as? String)!, age: (product.value(forKeyPath: "age") as? String)!, gender: (product.value(forKeyPath: "gender") as? String)!, nationality: (product.value(forKeyPath: "nationality") as? String)!))
           }
        }
       return surveyList
    }
    
    //DELETES ALL SURVEY DATA
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
