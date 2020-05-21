//
//  OnlineUserDB.swift
//  DigitalExhibition
//
//  Created by Admin on 19/5/20.
//  Copyright © 2020 PA2001. All rights reserved.
//

import SwiftUI
import UIKit
import Foundation

class OnlineUserDB: NSObject, URLSessionDataDelegate {

    private var observation: NSKeyValueObservation?

    deinit {
      observation?.invalidate()
    }
    let urlPath = "https://pa2001.cdms.westernsydney.edu.au/databaseGettest/getusers.php" //Change to the web address of your stock_service.php file
    
    func DownloadUsers() -> [String] {

        var msg : [String] = []
        //Sync server video database --> local user database
                         //created NSURL
        let requestURL = Foundation.URL(string: self.urlPath)
                 //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL!)
                //setting the method to post
        request.httpMethod = "GET"
          //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in if error != nil{
                 print("error is \(error)")
            }
            do {
                var teamJSON: NSDictionary!
                teamJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                     
                     //getting the JSON array teams from the response
                let user: NSArray = teamJSON["users"] as! NSArray

                     //looping through all the json objects in the array teams
                for i in 0 ..< user.count{
                    msg.append(((user[i] as! NSDictionary)["username"] as! String?)!)
                    //msg.append(((user[i] as! NSDictionary)["password"] as! String?)!)
                }
                print(msg)
            } catch {
                print(error)
            } //doend
            
        }
        self.observation = task.progress.observe(\.fractionCompleted) { progress, _ in
          print("progress: ", progress.fractionCompleted)
        }
        task.resume()
        print("? \(msg)")
        
        return msg
    }
    
}//Class
