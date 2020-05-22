//
//  TestScreen.swift
//  DigitalExhibition
//
//  Created by Admin on 15/5/20.
//  Copyright © 2020 PA2001. All rights reserved.
//

import SwiftUI
import CoreData
import Network

//For Testing purposes


struct TestScreen: View {
    
    var body: some View {
        VStack {
            ZStack {
                Color(red: 66/255.0, green: 142/255.0, blue: 146/255.0, opacity: 1.0)
                VStack {
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "arrow.left")
                            Text("Finish Viewing")
                        }
                        .padding()
                        .fixedSize()
                        .frame(width: 250, height: 45)
                        .foregroundColor(.white)
                        .background(Color(red: 28/255.0, green: 49/255.0, blue: 58/255.0, opacity: 1.0))
                        .cornerRadius(25)
                        .shadow(color: Color(red: 30/255.0, green: 50/255.0, blue: 60/255.0, opacity: 0.75), radius: 1, x: 0, y: 3)
                    }// HStack
                    .padding()
                    Spacer()
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            Text("EEE")
                            Spacer()
                            Text("111")
                            Spacer()
                            Text("222")
                            Spacer()
                            Text("333")
                            Spacer()
                        }// VStack
                        .padding()
                        Spacer()
                        VStack {
                            Spacer()
                            Text("Circle")
                            Spacer()
                            Text("About")
                            Spacer()
                        }// VStack
                        .padding()
                        Spacer()
                    }// HStack
                    Spacer()
                }// VStack
            }// ZStack
        }// VStack
    }// End Body
    
    func test() {
    }
}

struct TestScreen_Previews: PreviewProvider {
    static var previews: some View {
        TestScreen()
    }
}
