//
//  LogIn.swift
//  DigitalExhibition
//
//  Created by Admin on 4/5/20.
//  Copyright © 2020 PA2001. All rights reserved.
//

import SwiftUI
import UIKit
import Foundation
import SQLite3

struct LogIn: View {

    @State var goBack = false
    @State var canSignIn = false
    @State var displayError = false
    @State var username = ""
    

    var body: some View {
        return Group {
            if canSignIn {
                VideoGallery(username: $username)
            }
            else if goBack {
                SurveyScreen()
            }
            else {
                LoginForm(goBack: $goBack, canSignIn: $canSignIn, displayError: $displayError, username: $username)
            }
        }
    }
}
    var errormessage = ""
struct LoginForm: View {

    @Binding var goBack: Bool
    @Binding var canSignIn: Bool
    @Binding var displayError: Bool
    
    @Binding var username: String
    @State var password = ""
        
    var body: some View {
        
        VStack {
            
            HStack {
                Button(action: {
                    if (self.goBack == false) {
                        self.goBack = true
                    }
                }) {
                    Image(systemName: "chevron.left")
                    .padding()
                        .font(.title)
                }
                Spacer()
            }
            Section {
                HStack {
                    Text("Admin Sign-In")
                        .font(.title)
                    Image(systemName: "person.circle")
                        .font(.title)
                }
            .padding()
            }
            Section {
                HStack {
                    if( self.displayError == true) {
                        Text(errormessage)
                            .font(.headline)
                            .foregroundColor(Color.red)
                    }
                }
            }
            VStack(alignment: .leading) {
                Section {
                    Text("Username")
                        .font(.headline)
                        .padding(.bottom, -20)
                    TextField("Username...", text: self.$username)
                        .padding()
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 0.5))
                        .cornerRadius(25)
                }
                .padding()
                Section {
                    Text("Password")
                        .font(.headline)
                        .padding(.bottom, -20)
                    SecureField("Password...", text: self.$password)
                        .padding()
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                        .cornerRadius(25)
                }
                .padding()
                Section {
                    HStack {
                        Spacer()
                        Button(action: {
                            self.confirmUser(enteredUsername: self.username, enteredPassword: self.password)
                            
                        }) {
                            Text("Sign in")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding()
                            .fixedSize()
                            .frame(width: 140, height: 45)
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(8)
                        }  //end of button funct
                        Spacer()
                    }
                }
                .padding()
            }
            Spacer()
        }
        
    }
    func confirmUser(enteredUsername: String, enteredPassword: String) {
        let user = UserDBManager().retrieveUserAttr()
        var i = 0
        while i != user.count {
            if(user[i].username == enteredUsername && user[i].password == enteredPassword) {
                displayError = false
                errormessage = ""
                canSignIn = true
                break
            }
            else {
                displayError = true
                errormessage = "Username or password is incorrect!"
                canSignIn = false
            }
            i += 1
        }
    }
}



struct LogIn_Previews: PreviewProvider {
    static var previews: some View {
        LogIn()
    }
}



//DATABASE ADMIN USER FUNCTIONS

func syncUserzDatabase(){
            //Sync server user database --> local user database
       
            //allow abb load -> info.plist
            print("===================")
            // Do any additional setup after loading the view, typically from a nib.
                   
                   
                   //created NSURL
            let requestURL = Foundation.URL(string: URL_GET_USERS)
                   
                   //creating NSMutableURLRequest
            let request = NSMutableURLRequest(url: requestURL!)
                    
                         //setting the method to post
            request.httpMethod = "GET"

            //creating a task to send the post request
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){
                   data, response, error in if error != nil{
                    
                       print("error is \(error)")
                 
                   }
                QueryDatabase(query: "DELETE FROM USERS")
                 
                   //parsing the response
                   do {
                       
                       //converting resonse to NSDictionary
                       var teamJSON: NSDictionary!
                    teamJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                       
                       //getting the JSON array teams from the response
                       let teams: NSArray = teamJSON["users"] as! NSArray
                       
                       //looping through all the json objects in the array teams
                       for i in 0 ..< teams.count{
                           //getting the data at each index
                           //getting the data at each index
                        let teamId:Int = ((teams[i] as! NSDictionary)["id"] as! Int?)!
                        let username:String = ((teams[i] as! NSDictionary)["username"] as! String?)!
                           let password:String = ((teams[i] as! NSDictionary)["password"] as! String?)!
                         //  print(username + " added")
                          insertIntoUsers(username: username, password: password)
                       }
                       
                   
                           } catch {
                                   print(error)
                           } //doend
                   
       
                
               }
       
                    task.resume()

            
     
       
       
   }

func deleteUsers(){
    var stmt: OpaquePointer?
         
           let str = NSString .localizedStringWithFormat("DELETE FROM users" )
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

 var db: OpaquePointer?

func authenticate(USERNAME :String , PASSWORD :String) ->Bool{ //returns true if USERNAME and PASS matches user database
    var ge: OpaquePointer?
         let queryStringz = "SELECT * FROM users"
                 if sqlite3_prepare(db, queryStringz, -1, &ge, nil) != SQLITE_OK{
                     let errmsg = String(cString: sqlite3_errmsg(db)!)
                     print("error  Retrieving users: \(errmsg)")
                     return false
                 }
                 

                 while(sqlite3_step(ge) == SQLITE_ROW) {
                     
                     let id = sqlite3_column_int(ge, 0)
                     let username = String(cString: sqlite3_column_text(ge, 1))
                     let password = String(cString: sqlite3_column_text(ge, 2))
                    if(USERNAME == username && PASSWORD == password){

                        print("matching user: " + USERNAME + " " + PASSWORD)
                        return true
                    }
                 }
    return false
}






    
       

           



      
