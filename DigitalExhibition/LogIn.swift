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
    
    var body: some View {
        return Group {
            if goBack {
                SurveyScreen()
            }
            else {
                LoginForm(goBack: $goBack)
            }
        }
    }
}

struct LoginForm: View {
    @Binding var goBack: Bool
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
            VStack(alignment: .leading) {
                Section {
                    Text("Username")
                        .font(.headline)
                    TextField("", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                        .padding(.all)
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 0.5))
                }
                .padding()
                Section {
                    Text("Password")
                        .font(.headline)
                    TextField("", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                        .padding(.all)
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
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
