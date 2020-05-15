//
//  VideoGallery.swift
//  DigitalExhibition
//
//  Created by Admin on 5/5/20.
//  Copyright © 2020 PA2001. All rights reserved.
//
/*
import SwiftUI

struct VideoGalleryV2: View {
    
    @State private var show_videos: Bool = false
    @State private var show_userManagement: Bool = false
    @State private var show_SurveyManagement: Bool = false
    @State private var logout: Bool = false
    
    var body: some View {
        VStack {
            return Group {
                if(logout) {
                    SplashScreen()
                }
                else {
                    VStack {
                        Button(action: {
                            self.show_videos = true
                        }) {
                            VStack {
                                Image(systemName: "video.circle")
                                    .padding()
                                    .font(.title)
                                Text("Video Gallery")
                            }
                        }.sheet(isPresented: self.$show_videos) {
                            Videos()
                        }// End Button
                        
                        Button(action: {
                            self.show_userManagement = true
                        }) {
                            VStack {
                                Image(systemName: "person.3")
                                    .padding()
                                    .font(.title)
                                Text("User Management")
                            }
                        }.sheet(isPresented: self.$show_userManagement) {
                            UserManagement()
                        }// End Button
                        
                        Button(action: {
                            self.show_SurveyManagement = true
                        }) {
                            VStack {
                                Image(systemName: "doc.fill")
                                    .padding()
                                    .font(.title)
                                Text("Survey Management")
                            }
                        }.sheet(isPresented: self.$show_SurveyManagement) {
                            SurveyManagement()
                        }// End Button
                        
                        Button(action: {
                            if(self.logout == false) {
                                self.logout = true
                            }
                        }) {
                            VStack {
                                Image(systemName: "escape")
                                    .padding()
                                    .font(.title)
                                Text("Logout")
                            }
                        }
                    }// End Vstack
                }// End if-else
            }
            
        }// End VStack
    }// End Body
}

struct Videos: View {
    // 1. Add the environment variable
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Video Gallery")
            
            // 3. Add a button with the following action
            Button(action: {
                print("dismisses form")
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Dismiss")
            }.padding(.bottom, 50)
        }
    }
}

struct UserManagement: View {
    // 1. Add the environment variable
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("User Management")
            
            // 3. Add a button with the following action
            Button(action: {
                print("dismisses form")
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Dismiss")
            }.padding(.bottom, 50)
        }
    }// End Body
}// End UserManagement

struct SurveyManagement: View {
    // 1. Add the environment variable
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Survey Management")
            
            // 3. Add a button with the following action
            Button(action: {
                print("dismisses form")
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Dismiss")
            }.padding(.bottom, 50)
        }
    }// End Body
}

struct VideoGalleryV2_Previews: PreviewProvider {
    static var previews: some View {
        VideoGallery()
        /*.previewDevice("iPad mini 4")
        .previewLayout(
            PreviewLayout.fixed(
                width: 2732.0,
                height: 2048.0))*/
    }
}
*/

struct VideoGalleryV2_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
