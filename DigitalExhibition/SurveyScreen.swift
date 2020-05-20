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
    @State var goBack = false
    
    var body: some View {
        return Group {
            if (completed) {
                HomeScreen()
            }
            else if (login) {
                LogIn()
            }
            else if (maxTime == 0 || goBack) {
                SplashScreen()
            }
            else {
                Survey(completed: $completed, login: $login, goBack: $goBack)
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
    @Binding var goBack: Bool
    
    @State var gender = ""
    @State var age = ""
    @State var nationality = ""
    @State var errMessage = ""
    
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
                    .foregroundColor(Color(red: 0/255.0, green: 96/255.0, blue: 100/255.0, opacity: 1.0))
                }
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
                Text("Please fill in this short survey to view the exhibition:")
                    .font(.title)
                Text(errMessage)
                    .foregroundColor(Color.red)
            }
            VStack(alignment: .leading) {
                Section {
                    Text("Age")
                        .font(.headline)
                    TextField("19, 20, 26..", text: self.$age)
                        .padding()
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                        .cornerRadius(25)
                }
                .padding()
                Section {
                    Text("Gender")
                        .font(.headline)
                    TextField("Male or Female", text: self.$gender)
                        .padding()
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 0.5))
                        .cornerRadius(25)
                }
                .padding()
                Section {
                    Text("Nationality")
                        .font(.headline)
                    TextField("Australian, American, French, etc.", text: self.$nationality)
                        .padding()
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                        .cornerRadius(25)
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
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding()
                            .fixedSize()
                            .frame(width: 140, height: 45)
                            .foregroundColor(.white)
                            .background(Color(red: 0/255.0, green: 96/255.0, blue: 100/255.0, opacity: 1.0))
                            .cornerRadius(8)
                        
                    }// End Button
                    .padding()
                    Button(action: {
                        if(self.age.isEmpty || self.gender.isEmpty || self.nationality.isEmpty) {
                            self.errMessage = "Please fill in all the fields."
                        }
                        else {
                            self.save()
                            if (self.completed == false) {
                                self.completed = true
                                
                            }
                        }
                    }) {
                        Text("Submit")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding()
                            .fixedSize()
                            .frame(width: 140, height: 45)
                            .foregroundColor(.white)
                            .background(Color(red: 0/255.0, green: 96/255.0, blue: 100/255.0, opacity: 1.0))
                            .cornerRadius(8)
                        
                    }// End Button
                    .padding()
                }//End HStack
                
                
            }
            Spacer()
        }

    }
    func save() {
        let db = SurveyDBManager()
        db.addRow(gender: self.gender, age: self.age, nationality: self.nationality)
    }
}

struct SurveyScreen_Previews: PreviewProvider {
    static var previews: some View {
        SurveyScreen()
    }
}

