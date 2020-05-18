//
//  TestScreen.swift
//  DigitalExhibition
//
//  Created by Admin on 15/5/20.
//  Copyright © 2020 PA2001. All rights reserved.
//

import SwiftUI

//Testing purposes

struct TestScreen: View {
    
    @State private var logout: Bool = false
    
        var body: some View {
            return Group {
                if(logout) {
                    SplashScreen()
                }
                else {
                    Backend(logout: $logout)
                }
            }
        }// End Body
    }

    
    struct Backend: View {
        
        @Binding var logout: Bool
        
        var body: some View {
            NavigationView {
                VStack {
                    Image("Minimal_Background")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .offset(y: -100)
                        .padding(.bottom, -130)
                    HStack() {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.title)
                            .offset(y: -10)
                        Text("Username")
                            .font(.headline)
                            .offset(y: -10)
                    }// End HStack
                    .padding(.bottom, -15)

                    List{
                        NavigationLink(destination: Viideos()) {
                            HStack(alignment: .firstTextBaseline) {
                                Text("Video Gallery")
                                Spacer()
                                Image(systemName: "video.circle")
                            }
                        }
                        NavigationLink(destination: UsserManagement()) {
                            HStack {
                                Text("User Management")
                                Spacer()
                                Image(systemName: "person.3")
                            }
                        }
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
                    }// End List
                    
                }//End Vstack
                
                /*NavigationLink(destination: Videos()) {
                    Text("Video Gallery")
                }*/
                //.navigationBarTitle("The back")
                /*.navigationBarItems(trailing:
                    HStack {
                        Button("About") {
                            print("About tapped!")
                        }
                        Button("Logout") {
                            print("Help tapped!")
                        }
                    }
                )*/
                
            }// End NavigationView
        }
    }

struct Viideos: View {
    var body: some View {
        Text("Video Gallery")
    }
}

struct UsserManagement: View {
    var body: some View {
        Text("User Management")
    }
}

struct TestScreen_Previews: PreviewProvider {
    static var previews: some View {
        TestScreen()
    }
}
