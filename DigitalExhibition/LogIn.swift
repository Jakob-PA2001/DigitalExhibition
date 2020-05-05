//
//  LogIn.swift
//  DigitalExhibition
//
//  Created by Admin on 4/5/20.
//  Copyright © 2020 PA2001. All rights reserved.
//

import SwiftUI

struct LogIn: View {
    
    @State var goBack = false
    @State var canSignIn = false
    @State var displayError = false
    
    var body: some View {
        return Group {
            if canSignIn {
                VideoGallery()
            }
            else if goBack {
                SurveyScreen()
            }
            else {
                LoginForm(goBack: $goBack, canSignIn: $canSignIn, displayError: $displayError)
            }
        }
    }
}

struct LoginForm: View {
    
    @Binding var goBack: Bool
    @Binding var canSignIn: Bool
    @Binding var displayError: Bool
    
    @State var username = ""
    @State var password = ""
    
    @State var dummy_user = "Admin"
    @State var dummy_pass = "PA2001"
        
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
                        Text("Username or password is incorrect, please try again.")
                            .font(.headline)
                            .foregroundColor(Color.red)
                    }
                }
            }
            VStack(alignment: .leading) {
                Section {
                    Text("Username")
                        .font(.headline)
                    TextField("", text: self.$username)
                        .padding(.all)
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 0.5))
                }
                .padding()
                Section {
                    Text("Password")
                        .font(.headline)
                    SecureField("", text: self.$password)
                        .padding(.all)
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                }
                .padding()
                Section {
                    HStack {
                        Spacer()
                        Button(action: {
                            if (self.username == self.dummy_user &&
                                self.password == self.dummy_pass) {
                                self.canSignIn = true
                                self.displayError = false
                            }
                            else {
                                self.canSignIn = false
                                self.displayError = true
                            }
                        }) {
                            Text("Sign in")
                                .font(.title)
                        }
                        Spacer()
                    }
                }
                .padding()
            }
            Spacer()
        }
    }
}
struct LogIn_Previews: PreviewProvider {
    static var previews: some View {
        LogIn()
    }
}
