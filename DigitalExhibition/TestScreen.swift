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

let randomInt = Int.random(in: 0...10)

struct TestScreen: View {
    @State var leaveTest = false
    @State var str = "Hello"
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
    var body: some View {
        return Group {
            if leaveTest {
                SplashScreen()
            }
            else {
                ZStack {
                    Text("Testing...")
                        .font(.largeTitle)
                        .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
                    Button(action: {self.leaveTest.toggle()}) {
                        Text("Exit")
                    }
                    .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2 + 100)
                    Text("Hioiiiiiiiii")
                        .position(x: 100, y: 100)
                    Text("hello")
                    .position(x: 150, y: 100)
                    Text("helloooo")
                    .position(x: 100, y: 150)
                    Text("Hello")
                    .position(x: 200, y: 100)
                    Text("Hello")
                    .position(x: 50, y: 200)
                    Text("Hello")
                    .position(x: 100, y: 200)
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                        Text(/*@START_MENU_TOKEN@*/"Button"/*@END_MENU_TOKEN@*/)
                    }
                    if leaveTest {
                        Text("Bye")
                    }
                    //.position(x: UIScreen.main.bounds.width/2, y: 0)
                }
                /*VStack {
                    Text("Testing...")
                        .font(.largeTitle)
                    Button(action: {self.leaveTest.toggle()}) {
                        Text("Exit")
                    }
                    HStack {
                        VStack {
                            Text("Hioiiiiiiiii")
                        }
                        .position(x: 100, y: 100)
                        Text("hello")
                        Text("helloooo")
                        HStack {
                            Text("Hello")
                            Text("Hello")
                            Text("Hello")
                        }
                    }//.position(x: UIScreen.main.bounds.width/2, y: 0)
                }*/
            }
        }
    }
}

struct TestScreen_Previews: PreviewProvider {
    static var previews: some View {
        TestScreen()
    }
}
