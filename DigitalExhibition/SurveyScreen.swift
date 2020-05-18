//
//  SurveyScreen.swift
//  DigitalExhibition
//
//  Created by Admin on 29/4/20.
//  Copyright © 2020 PA2001. All rights reserved.
//

import SwiftUI

struct SurveyScreen: View {
    
    //Returns back to splashscreen if survey is open for 2 minutes.
    @State var maxTime = 120
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var completed = false
    @State var login = false
    
    var body: some View {
        return Group {
            if (completed) {
                HomeScreen()
            }
            else if (login) {
                LogIn()
            }
            else if (maxTime == 0) {
                SplashScreen()
            }
            else {
                Survey(completed: $completed, login: $login)
            }
            
            /* Waits 2 minutes before returning to splash screen.
             * Following code was modified from:
             * https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-a-timer-with-swiftui
             */
            Text("\(maxTime)")
                .onReceive(timer) { _ in
                    if self.maxTime > 0 {
                        self.maxTime -= 1
                }
            }
            .hidden()
        }
    }
}

struct Survey: View {
    //@Environment(\.presentationMode) var presentationMode
    
    @Binding var completed: Bool
    @Binding var login: Bool
    
    @State var gender = ""
    @State var age = ""
    @State var nationality = ""
    
    var body: some View {
        VStack {
            HStack {
                /*Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    VStack {
                        Text("Return")
                        Image(systemName: "arrow.down")
                        .font(.title)
                    }
                    .padding()
                }.padding(.bottom, 50)*/
                Spacer()
                Button(action: {
                    if (self.login == false) {
                        self.login = true
                    }
                }) {
                    Image(systemName: "person.circle.fill")
                    .padding()
                        .font(.title)
                }
            }
            Section {
                Text("Please in fill the following:")
                    .font(.title)
            }
            VStack(alignment: .leading) {
                Section {
                    Text("Age")
                        .font(.headline)
                    TextField("19, 20, 26..", text: self.$age)
                        .padding(.all)
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                }
                .padding()
                Section {
                    Text("Gender")
                        .font(.headline)
                    TextField("Male or Female", text: self.$gender)
                        .padding(.all)
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 0.5))
                }
                .padding()
                Section {
                    Text("Nationality")
                        .font(.headline)
                    TextField("Australian, American, French, etc.", text: self.$nationality)
                        .padding(.all)
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 0.5))
                }
                .padding()
            }
            Section {
                HStack {
                    Button(action: {
                        self.age = ""
                        self.gender = ""
                        self.nationality = ""
                    }) {
                        Text("Clear")
                            .font(.title)
                        
                    }// End Button
                    .padding()
                    Button(action: {
                        //self.debugging()
                        //self.deleteALLSurveyData()
                        self.save()
                        //self.submitSurvey()
                        if (self.completed == false) {
                            self.completed = true
                            //self.retrieve()
                            
                        }
                    }) {
                        Text("Submit")
                            .font(.title)
                        
                    }// End Button
                    .padding()
                }//End HStack
                
                
            }
            Spacer()
        }
        
    }
    
    func debugging() {
        let db = SurveyDBManager()
        _ = db.getNewId()
    }
    
    
    func deleteALLSurveyData() {
        let db = SurveyDBManager()
        db.deleteAll()
    }
    
    func retrieve(/*sender: AnyObject*/) {
        let db = SurveyDBManager()
        //var yolo: [String]
        
        let yolo = db.retrieveRows()
        for counter in 0...(yolo.count - 1)  {
            print(yolo[counter])
        }
    }
    
    func save(/*sender: AnyObject*/) {
        let db = SurveyDBManager()
        db.addRow(gender: self.gender, age: self.age, nationality: self.nationality)
    } // assume 2 TextViews: id & name

    func submitSurvey() {
        let url = URL(string: "https://pa2001.cdms.westernsydney.edu.au/addsurvey.php")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        var dataString = "secretWord=pa2001" // starting POST string with a secretWord
        // the POST string

        dataString = dataString + "&a=\(self.gender)" // replace "username.txt with own declared variable.
        dataString = dataString + "&b=\(self.age)" // replace "password.txt with own declared variable.
        dataString = dataString + "&c=\(self.nationality)" // replace "password.txt with own declared variable.
        
        // convert POST string to utf8 format
        
        let dataD = dataString.data(using: .utf8) // convert to utf8 string
        
        do
        {
        
            // EXECUTE POST REQUEST

            let uploadJob = URLSession.shared.uploadTask(with: request, from: dataD)
            {
                data, response, error in
                
               
            }
            uploadJob.resume()
        }
    }
}

struct SurveyScreen_Previews: PreviewProvider {
    static var previews: some View {
        SurveyScreen()
    }
}

