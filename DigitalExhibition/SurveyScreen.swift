//
//  SurveyScreen.swift
//  DigitalExhibition
//
//  Created by Admin on 29/4/20.
//  Copyright © 2020 PA2001. All rights reserved.
//

import SwiftUI

struct SurveyScreen: View {
    
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
    
    @Binding var completed: Bool
    @Binding var login: Bool
    
    var body: some View {
        VStack {
            HStack {
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
                    Text("Gender")
                        .font(.headline)
                    TextField("Male or Female", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                        .padding(.all)
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 0.5))
                }
                .padding()
                Section {
                    Text("Age")
                        .font(.headline)
                    TextField("19, 20, 26..", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                        .padding(.all)
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                }
                .padding()
                Section {
                    Text("Nationality")
                        .font(.headline)
                    TextField("Australian, American, French, etc.", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                        .padding(.all)
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 0.5))
                }
                .padding()
            }
            Section {
                Button(action: {
                    if (self.completed == false) {
                        self.completed = true
                    }
                }) {
                    Text("Submit")
                        .font(.title)
                        .foregroundColor(Color.blue)
                    
                }
            }
            Spacer()
        }
    }
}

struct SurveyScreen_Previews: PreviewProvider {
    static var previews: some View {
        SurveyScreen()
    }
}

