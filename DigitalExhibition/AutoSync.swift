//
//  AutoSync.swift
//  DigitalExhibition
//
//  Created by Admin on 29/5/20.
//  Copyright © 2020 PA2001. All rights reserved.
//

import SwiftUI
import Network

class AutoSync {
    let monitor = NWPathMonitor()
    
    func SyncOptions() {
        let queue = DispatchQueue(label: "Monitor")
        
        self.monitor.start(queue: queue)
        
        self.monitor.pathUpdateHandler = { path in
            
            if path.status == .satisfied {
                print("We're connected!")
                DispatchQueue.global().async(execute: {
                    DispatchQueue.main.sync {
                        UserDBManager().DeleteAll()
                    }
                    OnlineUserDB().DownloadUsers()
                    SyncVideoDatabase()
                    SurveyDBManager().submitSurvey()
                })
            } else {
                print("No connection.")
            }
        }
    }
    
    func getDate()->String{
      let time = Date()
      let timeFormatter = DateFormatter()
      timeFormatter.dateFormat = "HH:mm:ss"
      let stringDate = timeFormatter.string(from: time)
      return stringDate
     }
}
