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
    @State var str = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        return Group {
            if canExplore {
                //SurveyScreen()
                //TestScreen()
                //LogIn()
                FakeView(pass: $canExplore)
            }
            else {
                Welcome(canExplore: $canExplore)
            }//if

            Text(str)
                .onReceive(timer) { _ in
                    if (self.str == "01:00:00" || self.str == "04:00:00" || self.str == "07:00:00" || self.str == "10:00:00" || self.str == "13:00:00" || self.str == "16:00:00" || self.str == "19:00:00" || self.str == "22:00:00") {
                        self.str = "Boo"
                        AutoSync().SyncOptions()
                    }
                    else {
                        self.str = AutoSync().getDate()
                    }
            }
            .hidden()
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
    
    @State private var displaySurvey: Bool = false
    let monitor = NWPathMonitor()
    
    var body: some View {
        VStack {
            VStack {
                /*HStack {
                    Image("fire.logo")
                        .font(.subheadline)
                        .padding()
                    Spacer()
                    Image("wsu.logo")
                        .font(.subheadline)
                        .padding()
                }*/
                ZStack {
                    Color(red: 66/255.0, green: 142/255.0, blue: 146/255.0, opacity: 1.0)
                    HStack {
                        Image("frontpage")
                        .resizable()
                        .frame(width: 1000, height: 611)
                        .aspectRatio(contentMode: .fit)
                        .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
                    }
                    VStack {
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

                            print(path.isExpensive)
                        }
                            if(self.canExplore == false) {
                                self.canExplore = true
                            }
                        }) {
                                Text("Enter")
                                    .font(.custom("Papyrus", size: 48))
                                    .padding()
                                    .fixedSize()
                                    .frame(width: 180, height: 110)
                                    .foregroundColor(.black)
                                    .background(Color(red: 241/255.0, green: 248/255.0, blue: 233/255.0, opacity: 1.0))
                                    .cornerRadius(8)
                            
                        }
                    }
                    .position(x: 265, y: 590)
                }
            }
        }//VStack
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}

