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
import Network

class OnlineUserDB: NSObject, URLSessionDataDelegate {

    private var observation: NSKeyValueObservation?
    
    let monitor = NWPathMonitor()
    
    let urlPath = "https://pa2001.cdms.westernsydney.edu.au/databaseGettest/getusers.php"
    let urlDelete = "https://pa2001.cdms.westernsydney.edu.au/deleteusers.php"  //Change to the web address of your stock_service.php file
    
    func DownloadUsers(){
        let queue = DispatchQueue(label: "Monitor")
        self.monitor.start(queue: queue)
        
        self.monitor.pathUpdateHandler = { path in
        if path.status == .satisfied {
            print("We're connected!")
            var onlineUsers : [String] = []
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
                        onlineUsers.append(((user[i] as! NSDictionary)["username"] as! String?)!)
                        onlineUsers.append(((user[i] as! NSDictionary)["password"] as! String?)!)
                        print(((user[i] as! NSDictionary)["username"] as! String?)! + " : " + ((user[i] as! NSDictionary)["password"] as! String?)!)
                    }
                    let localUsers = UserDBManager().retrieveUsers()
                    if(localUsers.isEmpty) {
                        //Insert online into local
                        let localDb = UserDBManager()
                        var saveUser = ""
                        print(onlineUsers.count)
                        for i in 0 ..< onlineUsers.count {
                            if i % 2 == 0 {
                                saveUser = onlineUsers[i]
                            } else {
                                localDb.addUser(username: saveUser, password: onlineUsers[i], location: "Online")
                            }
                        }
                    }// if
                } catch {
                    print(error)
                } //doend
                
            }
            task.resume()
        } else {
            print("No connection.")
        }

        print(path.isExpensive)
        }
    }//func
    
    func DeleteUser(username:String, password:String) {// return array of Strings
        print("Debug: " + username)
        print("Debug: " + password)
        let queue = DispatchQueue(label: "Monitor")
        self.monitor.start(queue: queue)
        
        print("?")
        self.monitor.pathUpdateHandler = { path in
        if path.status == .satisfied {
            print("DELETE: We're connected!")
            let url = URL(string: "https://pa2001.cdms.westernsydney.edu.au/deleteusers.php")
            
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            
            var dataString = "secretWord=pa2001" // starting POST string with a secretWord
            // the POST string

            //var msg : [String] = []
            
            //for product in products {
                //msg.append((product.value(forKeyPath: "username") as? String)!)
            dataString = dataString + "&a=\(username)" // replace "username.txt with own declared variable.
            dataString = dataString + "&b=\(password)" // replace "password.txt with own declared variable.
            print(dataString)
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
        } else {
            print("No connection.")
        }

        print(path.isExpensive)
        }
    }
    
}//Class
