//
//  SurveyScreen.swift
//  DigitalExhibition
//
//  Created by Admin on 29/4/20.
//  Copyright © 2020 PA2001. All rights reserved.
//

import SwiftUI

struct SurveyScreen: View {
    var body: some View {
        NavigationView {
            VStack {
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
                            .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
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
                            .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                    }
                    .padding()
                }
                Section {
                    NavigationLink(destination: HomeScreen())
                    {
                        Text("Submit")
                        .padding()
                            .font(.title)
                    }
                }
            }
            .padding()
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .padding()
    }
}

struct SurveyScreen_Previews: PreviewProvider {
    static var previews: some View {
        SurveyScreen()
    }
}

