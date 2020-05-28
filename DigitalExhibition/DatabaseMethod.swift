//
//  DatabaseMethod.swift
//  DigitalExhibition
//
//  Created by Nege on 16/5/20.
//  Copyright © 2020 PA2001. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
import Foundation
import SQLite3

func databaseCreate(){
    //Generating core Database file for users database if not exist
       let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
           .appendingPathComponent("ExhibitionDatabase.sqlite")
       
       //Opening database at defined path. if database return is not sqlite(success)
       if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
           print("cannot open database")
       }
       
      print("Dir 4 database: ", fileURL)
    
if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, password TEXT)", nil, nil, nil) != SQLITE_OK {
          let er = String(cString: sqlite3_errmsg(db)!)
          print("cannot create users table on load: \(er)")
      }
    
    if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS videos (videoNo INTEGER, videoname TEXT,videoURl TEXT,deviceNo TEXT, description TEXT, locDirectory TEXT)", nil, nil, nil) != SQLITE_OK {
        let er = String(cString: sqlite3_errmsg(db)!)
        print("cannot create orders table on load: \(er)")
    }
   
 

    
}



//UTILITIES ******************************************************************************************************************************************************************************************************************
//
func getTableSize(tablename : String)->intmax_t{ //returns size of rows from tablename
    var size = 0
    var ge: OpaquePointer?
             let queryStringz = "SELECT * FROM " + tablename
                     if sqlite3_prepare(db, queryStringz, -1, &ge, nil) != SQLITE_OK{
                         let errmsg = String(cString: sqlite3_errmsg(db)!)
                         print("error  Retrieving " + tablename + ": \(errmsg)")
                         
                     }
                     while(sqlite3_step(ge) == SQLITE_ROW) {
                        size+=1
                     }
                print("Database size of Table" , tablename + "=" ,size)
    return size
    
}

func QueryDatabase(query : String){
    var stmt: OpaquePointer?
         //insert
    let str = NSString .localizedStringWithFormat(query as NSString)
                                let queryString = String(str)

              if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
                  let errmsg = String(cString: sqlite3_errmsg(db)!)
                  print("error preparing quering of database : \(errmsg)")
                  return
              }
              
              if sqlite3_step(stmt) != SQLITE_DONE {
                  let errmsg = String(cString: sqlite3_errmsg(db)!)
                  print("failure quering database: \(errmsg) " + query)
                  return
              }
    
    
}

//VIDEODATABASEMETHODS ******************************************************************************************************************************************************************************************************************

//videoNo INTEGER PRIMARY KEY, videoname TEXT,videoURl TEXT, description TEXT)"//

func SyncVideoDatabase(){
   var err = false
    //Sync server video database --> local user database, local video database gets erased
              print("Syncing Video Database")
                     //created NSURL
              let requestURL = Foundation.URL(string: URL_GET_VIDEO)
                     //creating NSMutableURLRequest
              let request = NSMutableURLRequest(url: requestURL!)
                    //setting the method to post
              request.httpMethod = "GET"
              //creating a task to send the post request
    
    
  
              let task = URLSession.shared.dataTask(with: request as URLRequest){
                     data, response, error in if error != nil{

                         print("error is \(error)")
                        videodesc = "Internet connection appears to be offline, Error Connecting to server"
                       err = true
                     }
                
                
        
                
                if (err == false){
                  QueryDatabase(query: "DELETE FROM videos")//delete local database, resync from server
                   
                     //parsing the response
                     do {
                         
                         //converting resonse to NSDictionary
                         var teamJSON: NSDictionary!
                      teamJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                         
                         //getting the JSON array teams from the response
                         let video: NSArray = teamJSON["videos"] as! NSArray
                         
                         //looping through all the json objects in the array teams
                         for i in 0 ..< video.count{
                             //getting the data at each index
                             //getting the data at each index
                          let videoNo:Int = ((video[i] as! NSDictionary)["videoNo"] as! Int?)!
                          let videoName:String = ((video[i] as! NSDictionary)["videoName"] as! String?)!
                            let videoUrl:String = ((video[i] as! NSDictionary)["videoUrl"] as! String?)!
                            let deviceNo:String = ((video[i] as! NSDictionary)["deviceNo"] as! String?)!
                             let Description:String = ((video[i] as! NSDictionary)["description"] as! String?)!
                              let locDirectory:String = ((video[i] as! NSDictionary)["locDirectory"] as! String?)!
                            
                            print(videoNo, " added")
                            let str = NSString .localizedStringWithFormat("INSERT INTO videos(videoNo, videoname,videoURL,deviceNo, description,locDirectory) VALUES('%@', '%@', '%@','%@','%@','%@')", String(videoNo), videoName,videoUrl,deviceNo,Description,locDirectory)
                                QueryDatabase(query: str as String)
                 
                         }
                        addvideos()
                             } catch {
                                     print(error)
                             } //doend
                }
                 }
         task.resume()
            

              
       
         
         
}
func getVideoNoInfo(videono : Int, deviceNum : String, coloumname : String) -> String{//return information of videoNo if database.deviceNo == the devicenumber
    var ge: OpaquePointer?
              let queryStringz = "SELECT * FROM videos"
                      if sqlite3_prepare(db, queryStringz, -1, &ge, nil) != SQLITE_OK{
                          let errmsg = String(cString: sqlite3_errmsg(db)!)
                          print("error  Retrieving users \(errmsg)")
                          
                      }
                    while(sqlite3_step(ge) == SQLITE_ROW) {
                          let videoNo = sqlite3_column_int(ge, 0)
                          let videoName = String(cString: sqlite3_column_text(ge, 1))
                          let videoUrl = String(cString: sqlite3_column_text(ge, 2))
                             let deviceNo = String(cString: sqlite3_column_text(ge, 3))
                          let Description = String(cString: sqlite3_column_text(ge, 4))
                         let locDirectory = String(cString: sqlite3_column_text(ge, 5)) //local directory of server
                        if(videoNo == videono && deviceNum == deviceNo){
                            if(coloumname == "videono"){
                                return String(videoNo)
                            }else if (coloumname == "videoname"){
                                return videoName
                            }else if (coloumname == "videoUrl"){
                                return videoUrl
                            }else if (coloumname == "description"){
                                return Description
                            }else if (coloumname == "deviceno"){
                                return deviceNo
                            }
                            else if (coloumname == "locDirectory"){
                                return locDirectory
                            }
                            
                        }
                      }
    
    
    return ""
    
}

func returnVideoNo(row : intmax_t, coloumname : String)-> String{ //returns video database (coloumn name) according to input row.
    var size = 0
    var ge: OpaquePointer?

              let queryStringz = "SELECT * FROM videos"
        
                      if sqlite3_prepare(db, queryStringz, -1, &ge, nil) != SQLITE_OK{
                          let errmsg = String(cString: sqlite3_errmsg(db)!)
                          print("error  Retrieving users \(errmsg)")
                          
                      }
                    while(sqlite3_step(ge) == SQLITE_ROW) {
                          let videoNo = sqlite3_column_int(ge, 0)
                          let videoName = String(cString: sqlite3_column_text(ge, 1))
                          let videoUrl = String(cString: sqlite3_column_text(ge, 2))
                             let deviceNo = String(cString: sqlite3_column_text(ge, 3))
                          let Description = String(cString: sqlite3_column_text(ge, 4))
                         let locDirectory = String(cString: sqlite3_column_text(ge, 5)) //local directory of server
                         size+=1
                        if(size == row){
                            if(coloumname == "videono"){
                                return String(videoNo)
                            }else if (coloumname == "videoname"){
                                return videoName
                            }else if (coloumname == "videoUrl"){
                                return videoUrl
                            }else if (coloumname == "description"){
                                return Description
                            }else if (coloumname == "deviceno"){
                                return deviceNo
                            }
                            else if (coloumname == "locDirectory"){
                                return locDirectory
                            }
                            
                        }
                      }
    
  
    return ""
}


func showvideoDatabase() ->Bool{//print local video database, returns true if entires exist else false.
    var ge: OpaquePointer?
         let queryStringz = "SELECT * FROM videos"
                 if sqlite3_prepare(db, queryStringz, -1, &ge, nil) != SQLITE_OK{
                     let errmsg = String(cString: sqlite3_errmsg(db)!)
                     print("error  Retrieving videos: \(errmsg)")
                     return false
                 }
                 
         var videoNamecompare = ""
                 while(sqlite3_step(ge) == SQLITE_ROW) {
                     
                     let videoNo = sqlite3_column_int(ge, 0)
                     let videoname = String(cString: sqlite3_column_text(ge, 1))
                     let videoURL = String(cString: sqlite3_column_text(ge, 2))
                       let deviceNo = String(cString: sqlite3_column_text(ge, 3))
                     let description = String(cString: sqlite3_column_text(ge, 4))
                     videoNamecompare = videoname
                    print("LocalVideoDatabase: " , videoNo,videoname,videoURL,deviceNo, description)
                 }
             if (videoNamecompare == ""){
                print("video database is empty")
             return false
             }  else{
                
                print("video database is notempty")
                return true}
         
    
    return false
}


//USERDATABASEMETHODS ******************************************************************************************************************************************************************************************************************
//

func showuserDatabase() ->Bool{ //show local user database, returns true if entires exist else false.
         var ge: OpaquePointer?
       let queryStringz = "SELECT * FROM users"
               if sqlite3_prepare(db, queryStringz, -1, &ge, nil) != SQLITE_OK{
                   let errmsg = String(cString: sqlite3_errmsg(db)!)
                   print("error  Retrieving users: \(errmsg)")
                   return false
               }
               
                
               //sets
       var USERNAME = ""
               while(sqlite3_step(ge) == SQLITE_ROW) {
                   
                   let id = sqlite3_column_int(ge, 0)
                   let username = String(cString: sqlite3_column_text(ge, 1))
                   let password = String(cString: sqlite3_column_text(ge, 2))
                   USERNAME = username
                   print(id,username,password)
               }
           if (USERNAME == ""){
           return false
           }  else{ return true}
       
   }
func insertIntoUsers(username : String , password :String){ //insert users into local user database
    var stmt: OpaquePointer?
      //insert
      let str = NSString .localizedStringWithFormat("INSERT INTO users(username, password) VALUES('%@', '%@')", username, password)
                          let queryString = String(str)

           if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
               let errmsg = String(cString: sqlite3_errmsg(db)!)
               print("error preparing inserting users: \(errmsg)")
               return
           }
           
           if sqlite3_step(stmt) != SQLITE_DONE {
               let errmsg = String(cString: sqlite3_errmsg(db)!)
               print("failure inserting users: \(errmsg)")
               return
           }
}

struct DatabaseMethod_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}



