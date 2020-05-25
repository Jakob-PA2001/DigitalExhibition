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
    var body: some View {
        return Group {
            if canExplore {
                SurveyScreen()
            }
            else {
                Welcome(canExplore: $canExplore)
            }
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
                HStack {
                    Image("fire.logo")
                        .font(.subheadline)
                        .padding()
                    Spacer()
                    Image("wsu.logo")
                        .font(.subheadline)
                        .padding()
                }
                ZStack {
                    HStack {
                        Image("splash")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height * 3/4)
                        .aspectRatio(contentMode: .fit)
                        .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/3)
                    }
                    VStack {
                        Text("Welcome to the Langtang Heritage Trail")
                            .font(.largeTitle)
                            .shadow(color: .gray, radius: 2, x: 0, y: 5)
                            .padding()
                        Button(action: {
                            let queue = DispatchQueue(label: "Monitor")
                            self.monitor.start(queue: queue)
                            
                            self.monitor.pathUpdateHandler = { path in
                            if path.status == .satisfied {
                                print("We're connected!")
                                UserDBManager().DeleteAll()
                                OnlineUserDB().DownloadUsers()
                            } else {
                                print("No connection.")
                            }

                            print(path.isExpensive)
                        }
                            if(self.canExplore == false) {
                                self.canExplore = true
                            }
                        }) {
                                Text("EXPLORE")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .padding()
                                    .fixedSize()
                                    .frame(width: 140, height: 45)
                                    .foregroundColor(.white)
                                    .background(Color(red: 0/255.0, green: 96/255.0, blue: 100/255.0, opacity: 1.0))
                                    .cornerRadius(25)
                                    .shadow(color: .gray, radius: 2, x: 0, y: 5)
                            
                        }
                    }
                    .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/3)
                }
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}

