//
//  HomeScreen.swift
//  DigitalExhibition
//
//  Created by Admin on 4/5/20.
//  Copyright © 2020 PA2001. All rights reserved.
//

import SwiftUI

struct HomeScreen: View {
    @State private var displayPopup: Bool = false
    @State private var show_info: Bool = false
    @State private var choice: Int = 0
    @State private var finishViewing: Bool = false
    //let randomInt = Int.random(in: 1...5)
    
    var body: some View {
        return Group {
            if(finishViewing) {
                SplashScreen()
            }
            else {
                ZStack(/*alignment: .leading*/) {
                    Color(red: 66/255.0, green: 142/255.0, blue: 146/255.0, opacity: 1.0)
                    VStack {
                        HStack {
                            Button(action: {
                                if(self.finishViewing == false) {
                                    self.finishViewing = true
                                }
                            }) {
                                Image(systemName: "arrow.left")
                                Text("Finish Viewing")
                            }
                            .foregroundColor(Color.black)
                        }
                        // Earthquake video
                        EarthquakeVideo(displayPopup: $displayPopup, choice: $choice)// End Group
                            //.offset(x: 100)
                        //Video 1
                        Video1(displayPopup: $displayPopup, choice: $choice)// End Group
                        
                        //Video 2
                        Video2(displayPopup: $displayPopup, choice: $choice)// End Group
                        
                        //Video 3
                        Video3(displayPopup: $displayPopup, choice: $choice)// End Group
                        
                        //Langtang information
                        AboutLangtang(displayPopup: $displayPopup, choice: $choice)// End Group
                    }// End VStack
                    .padding()
                }// End ZStack
                .edgesIgnoringSafeArea(.top)
            }
        }
    }
}

struct EarthquakeVideo: View {
    
    @Binding var displayPopup: Bool
    @Binding var choice: Int
    
    var body: some View {
        Group {
            Button(action: {
                self.displayPopup = true
                self.choice = 1
            }) {
                HStack {
                    Image("preview.4")
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color(red: 0/255.0, green: 96/255.0, blue: 100/255.0, opacity: 1.0), lineWidth: 4))
                        .shadow(radius: 10)
                    Text("What to do in the event of an earthquake")
                }
            }// End button
                .sheet(isPresented: self.$displayPopup) {
                    PopUp(choice: self.$choice)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct Video1: View {
    
    @Binding var displayPopup: Bool
    @Binding var choice: Int
    
    var body: some View {
        Group {
            Button(action: {
                self.displayPopup = true
                self.choice = 1
            }) {
                HStack {
                    Image("preview.1")
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color(red: 0/255.0, green: 96/255.0, blue: 100/255.0, opacity: 1.0), lineWidth: 4))
                        .shadow(radius: 10)
                    Text("Stories from Langtang")
                }
            }// End button
                .sheet(isPresented: self.$displayPopup) {
                    PopUp(choice: self.$choice)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct Video2: View {
    
    @Binding var displayPopup: Bool
    @Binding var choice: Int
    
    var body: some View {
        Group {
            Button(action: {
                self.displayPopup = true
                self.choice = 1
            }) {
                HStack {
                    Image("preview.2")
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color(red: 0/255.0, green: 96/255.0, blue: 100/255.0, opacity: 1.0), lineWidth: 4))
                        .shadow(radius: 10)
                    Text("Stories from Langtang")
                }
            }// End button
                .sheet(isPresented: self.$displayPopup) {
                    PopUp(choice: self.$choice)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct Video3: View {
    
    @Binding var displayPopup: Bool
    @Binding var choice: Int
    
    var body: some View {
        Group {
            Button(action: {
                self.displayPopup = true
                self.choice = 1
            }) {
                HStack {
                    Image("preview.3")
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color(red: 0/255.0, green: 96/255.0, blue: 100/255.0, opacity: 1.0), lineWidth: 4))
                        .shadow(radius: 10)
                    Text("Stories from Langtang")
                }
            }// End button
                .sheet(isPresented: self.$displayPopup) {
                    PopUp(choice: self.$choice)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct AboutLangtang: View {
    
    @Binding var displayPopup: Bool
    @Binding var choice: Int
    
    var body: some View {
        Group {
            Button(action: {
                self.displayPopup = true
                self.choice = 2
            }) {
                HStack {
                    Image("heritage")
                        .shadow(radius: 10)
                    Text("About The Langtang Heritage Trail")
                }
            }// End button
                .sheet(isPresented: self.$displayPopup) {
                    PopUp(choice: self.$choice)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
    
struct PopUp: View {
    
    @Binding var choice: Int
    
    var body: some View {
        return Group {
            if(choice == 1) {
                DisplayVideo()
            }
            else if(choice == 2) {
                DisplayText()//End ZStack
            }
        }
    }
}

struct DisplayVideo: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                VStack {
                    Text("Display Video")
                    Image(systemName: "arrow.down")
                        .font(.title)
                }
                .padding()
            }.padding(.bottom, 50)
        }
    }
}

struct DisplayText: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack{
            Color(red: 56/255.0, green: 142/255.0, blue: 60/255.0, opacity: 1.0)
            VStack {
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            //Text("Return")
                            Image(systemName: "arrow.left")
                                .font(.title)
                        }
                        .padding()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(Color.white)
                    .offset(x: -50)
                    
                    Image("heritage")
                    Text("Langtang Heritage Trail")
                        .font(.title)
                        .offset(y: 10)
                }
                .offset(x: -50)
                
                Group {
                    Text("The Langtang Heritage Trail is the product of several years of collaboration between the community of Langtang, Flagstaff International Relief Effort (FIRE) and archaeologists/anthropologists at Western Sydney Univeristy (WSU) in response to the precarity of the valley's heritage wrought by the 2015 earthquake. The impetus to 'activate' Langtang heritage arose from an observation: after returning to the valley following evacuation, the rebuilding of places with historical or spiritual significance was spontaneously prioritised by the valley's residents.")
                    Text("Care for a common past seemed to anchor feelings of spiritual security in what, in the immediate aftermath, had become a physically insecure place. Heritage, we realised, had a role to play in the ongoing pursuit of wellbeing. Our objective became to work with the local community to find ways to bring about wellbeing benefits through a structured care for the past. Many local residents have shared their stories and memories about the valley and they housed on these iPads as an archive for community posterity as well as an invitation to visitors to communicate accross cultures. These are the stories of Langtang, the secret valley of 'Dagam Namgo', as told by its custodians.")
                    Text("We invite you to contribute to this participatory research by recording your own emotions whilst you reflect on the places and the stories. To do so, please complete the 'Circle of Emotion' quiz. Your contributions will be used to evaluate the ways that emotional responses to the past can be built into tue everyday management of heritage.")
                }// End group
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .foregroundColor(Color.white)
                    .font(.headline)
                    .padding()
            }// End VStack
            //.offset(y: -100)
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}

