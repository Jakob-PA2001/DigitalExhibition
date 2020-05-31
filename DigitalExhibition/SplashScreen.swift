//
//  SplashScreen.swift
//  DigitalExhibition
//
//  Created by Admin on 28/4/20.
//  Copyright © 2020 PA2001. All rights reserved.
//

import SwiftUI
import Network

struct SplashScreen: View {
    @State var canExplore = false
    @State var displaySurvey = false
    
    var body: some View {
        return Group {
            if canExplore {
                //SurveyScreen()
                //TestScreen()
                FakeView(pass: $canExplore)
            }
            else {
                Welcome(canExplore: $canExplore)
            }//if

        }//return
        //.statusBar(hidden: true)
    }
}

struct FakeView: View {
    @Binding var pass: Bool
    var body: some View {
        return Group {
            if pass {
                SurveyScreen()
                //TestScreen()
            }
            Text("").hidden()
        }
    }
}

struct Welcome: View {
    @Binding var canExplore: Bool
    
    @State var str = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var displaySurvey: Bool = false
    let monitor = NWPathMonitor()
    
    var body: some View {
        ZStack {
            Group {
                Image("back")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 10)
                    .aspectRatio(contentMode: .fill)
                    .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
            }
            
            Group {
                Image("frontpage")
                    .resizable()
                    .frame(width: 1000, height: 673)
                    .aspectRatio(contentMode: .fit)
                    .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2 - 20)
            }
            

            Group {
                Button(action: {
                    let queue = DispatchQueue(label: "Monitor")
                    self.monitor.start(queue: queue)
                    
                    self.monitor.pathUpdateHandler = { path in
                    if path.status == .satisfied {
                        print("We're connected!")
                        DispatchQueue.global().async(execute: {
                            DispatchQueue.main.sync {
                                UserDBManager().DeleteAll()
                            }
                            OnlineUserDB().DownloadUsers()
                        })
                    } else {
                        print("No connection.")
                    }
                }
                    if(self.canExplore == false) {
                        self.canExplore = true
                    }
                }) {
                        Text("E")
                            .font(.custom("Papyrus", size: 64))
                            .position(x: 50, y: 58)
                        Text("nter")
                            .font(.custom("Papyrus", size: 50))
                            .frame(width: 90)
                            .position(x: 10, y: 58)
                }
                .fixedSize()
                .frame(width: 170, height: 90)
                .foregroundColor(.black)
                .background(Color(red: 241/255.0, green: 248/255.0, blue: 233/255.0, opacity: 1.0))
                .cornerRadius(8)
                .shadow(color: .black, radius: 2, x: 0, y: 3)
                .position(x: 283, y: 540)
                
            }//Group
            

            Image("fire.logo")
                .font(.subheadline)
                .position(x: 100, y: 760)

            Image("wsu.logo")
                .font(.subheadline)
                .position(x: 300, y: 757)
            
        }// ZStack
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}

