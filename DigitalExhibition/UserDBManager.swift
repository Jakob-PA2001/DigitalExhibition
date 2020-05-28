//
//  UserDBManager.swift
//  DigitalExhibition
//
//  Created by Admin on 19/5/20.
//  Copyright © 2020 PA2001. All rights reserved.
//

import SwiftUI
import Foundation
import CoreData
import Network

class UserDBManager: NSObject {
    
    var products: [NSManagedObject] = []
    let monitor = NWPathMonitor()
    
    func addUser(username:String, password:String, location: String) {
        // set the core data to access the Product Entity
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "LocalUsers", in: managedContext)
        let product = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        product.setValue(username,  forKey: "username")
        product.setValue(password, forKey: "password")
        product.setValue(location,  forKey: "location")
        
        do {
            products.append(product)
            try managedContext.save()
       //     showMessage("Information is added")
        }
        catch let error as NSError {
            print("Error While Adding to Core Data: " + (error as! String) )
        }
    }// End addRow
    
    
    func retrieveUsers() -> [String] {  // return array of Strings
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return [""]}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LocalUsers")
        do {
            products  = try managedContext.fetch(fetchRequest)
        }
        catch let error as NSError{
            print("Error While Retrieving from Core Data" + (error as! String) )
        }
        
        var msg : [String] = []
        if(!products.isEmpty){
            for product in products {
                msg.append((product.value(forKeyPath: "username") as? String)!)
                msg.append((product.value(forKeyPath: "password") as? String)!)
            }
        }
        if (msg.isEmpty) {
            msg = []
        }
        return msg
    }
    
    struct userAttr {
      let username : String
      let password : String
      let location : String
    }
    
    func retrieveUserAttr() -> [UserDBManager.userAttr] {  // return array of Strings
       guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
           return []}
       let managedContext = appDelegate.persistentContainer.viewContext
       let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LocalUsers")
       do {
           products  = try managedContext.fetch(fetchRequest)
       }
       catch let error as NSError{
           print("Error While Retrieving from Core Data" + (error as! String) )
       }
       
        var userList = [userAttr(username: "Username", password: "Password", location: "location")]
        
        if(products.isEmpty) {
            userList.append(userAttr(username: " ", password: " ", location: " "))
            
        }
        else {
           for product in products {
               
            userList.append(userAttr(username: (product.value(forKeyPath: "username") as? String)!, password: (product.value(forKeyPath: "password") as? String)!, location: (product.value(forKeyPath: "location") as? String)!))
           }
        }
       return userList
    }
    
    func doesUserExist(username: String) -> Bool {  // return array of Strings
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LocalUsers")
        do {
            let searchQuery = username
            fetchRequest.predicate = NSPredicate(format: "username == %@", searchQuery)
            products  = try managedContext.fetch(fetchRequest)
        }
        catch let error as NSError{
            print("Error While Retrieving from Core Data" + (error as! String) )
        }
        
        //var msg : String = ""
        if(!products.isEmpty){
            return true
            /*for product in products {
                msg.append((product.value(forKeyPath: "username") as? String)!)
            }*/
        }
        else {
            return false
        }
        /*if (msg.isEmpty) {
            msg = ""
        }*/
        //return false
    }
    
    func deleteUser(username: String) {        // delete an item based on key: name
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LocalUsers")
        do {
            let searchQuery = username
            fetchRequest.predicate = NSPredicate(format: "username == %@", searchQuery)
            products  = try managedContext.fetch(fetchRequest)
            if(!products.isEmpty) {
                for product in products {
                    managedContext.delete(product)
                }
            }
        }
        catch { }
        do {
            try managedContext.save()
        }
            catch {  }
    }
    
    
    func uploadUsers() { // return array of Strings

        let queue = DispatchQueue(label: "Monitor")
        self.monitor.start(queue: queue)

        
        self.monitor.pathUpdateHandler = { path in
        if path.status == .satisfied {
            print("We're connected!")
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
               return}
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LocalUsers")
            do {
                self.products  = try managedContext.fetch(fetchRequest)
            }
            catch let error as NSError{
               print("Error While Retrieving from Core Data" + (error as! String) )
            }
            if(!self.products.isEmpty) {
                let url = URL(string: "https://pa2001.cdms.westernsydney.edu.au/addusers.php")
                
                var request = URLRequest(url: url!)
                request.httpMethod = "POST"
                
                var dataString = "secretWord=pa2001" // starting POST string with a secretWord
                // the POST string

                for product in self.products {
                    //msg.append((product.value(forKeyPath: "username") as? String)!)
                    if((product.value(forKeyPath: "location") as? String)! == "Offline") {
                        dataString = dataString + "&a=\((product.value(forKeyPath: "username") as? String)!)" // replace "username.txt with own declared variable.
                        dataString = dataString + "&b=\((product.value(forKeyPath: "password") as? String)!)" // replace "password.txt with own declared variable.
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
                        self.UpdateUserLocation(username: (product.value(forKeyPath: "username") as? String)!)
                    }
                }//for
            }
        } else {
            print("No connection.")
        }

        print(path.isExpensive)
        }
        // convert POST string to utf8 format
        
    }
    
    func UpdateUserLocation(username:String) {
         // set the core data to access the Product Entity
        let location = "Online"
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
             return }
         let managedContext = appDelegate.persistentContainer.viewContext
        
         let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LocalUsers")
         do {
             let searchQuery = username
             fetchRequest.predicate = NSPredicate(format: "username == %@", searchQuery)
             products  = try managedContext.fetch(fetchRequest)
         }
         catch let error as NSError{
             print("Error While Retrieving from Core Data" + (error as! String) )
         }

         for product in products {
             product.setValue(location,  forKey: "location")
            
              do {
                  products.append(product)
                  try managedContext.save()
             //     showMessage("Information is added")
              }
              catch let error as NSError {
                  print("Error While Adding to Core Data: " + (error as! String) )
              }
         }
         
    }
    
    //DELETES ALL USER DATA - FOR DEBUGGING ONLY
    func DeleteAll() {        // delete an item based on key: name
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LocalUsers")
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

}

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
