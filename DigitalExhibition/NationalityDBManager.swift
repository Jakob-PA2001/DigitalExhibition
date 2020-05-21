//
//  NationalityDBManager.swift
//  DigitalExhibition
//
//  Created by Admin on 21/5/20.
//  Copyright © 2020 PA2001. All rights reserved.
//

import SwiftUI
import Foundation
import CoreData

class NationalityDBManager: NSObject {
    
    var products: [NSManagedObject] = []
    //Decodes nationality json file
    //let nations = Bundle.main.decode([Nationalities].self, from: "nationalities.json")
    
    struct NationAttr {
        let name : String
    }
    
    func retrieveNation() -> [String] {  // return array of Strings
       guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
           return []}
       let managedContext = appDelegate.persistentContainer.viewContext
       let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Nationality")
       do {
           products  = try managedContext.fetch(fetchRequest)
       }
       catch let error as NSError{
           print("Error While Retrieving from Core Data" + (error as! String) )
       }
       
        var msg : [String] = []
        
        if(products.isEmpty) {
            msg.append("")
            
        }
        else {
           for product in products {
               
               msg.append((product.value(forKeyPath: "name") as? String)!)
           }
        }
       return msg
    }
    
    func retrieveNationAttr() -> [NationalityDBManager.NationAttr] {  // return array of Strings
       guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
           return []}
       let managedContext = appDelegate.persistentContainer.viewContext
       let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Nationality")
       do {
           products  = try managedContext.fetch(fetchRequest)
       }
       catch let error as NSError{
           print("Error While Retrieving from Core Data" + (error as! String) )
       }
       
        var nationList = [NationAttr(name: "name")]
        
        if(products.isEmpty) {
            nationList.append(NationAttr(name: "name"))
            
        }
        else {
           for product in products {
               
               nationList.append(NationAttr(name: (product.value(forKeyPath: "name") as? String)!))
           }
        }
       return nationList
    }
    
    // Adding nationality to local db
    func addNationality(name:String) {
        // set the core data to access the Product Entity
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Nationality", in: managedContext)
        let product = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        product.setValue(name, forKey: "name")
        
        
        do {
            products.append(product)
            try managedContext.save()
       //     showMessage("Information is added")
        }
        catch let error as NSError {
            print("Error While Adding to Core Data: " + (error as! String) )
        }
    }// End addRow
    
    func deleteAll() {        // delete an item based on key: name
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Nationality")
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
// Decodes local json files
/*extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON")
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
}*/
