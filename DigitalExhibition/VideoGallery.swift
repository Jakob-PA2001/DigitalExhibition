//
//  VideoGallery.swift
//  DigitalExhibition
//
//  Created by Admin on 5/5/20.
//  Copyright © 2020 PA2001. All rights reserved.
//

import SwiftUI

struct VideoGallery: View {
    
    @State private var logout: Bool = false
    
    var body: some View {
        return Group {
            if(logout) {
                SplashScreen()
            }
            else {
                Menu(logout: $logout)
            }
        }
    }// End Body
}

struct Menu: View {
    
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
                    Text("Admin")
                        .font(.headline)
                        .offset(y: -10)
                }// End HStack
                .padding(.bottom, -15)

                List{
                    NavigationLink(destination: Videos()) {
                        HStack(alignment: .firstTextBaseline) {
                            Text("Video Gallery")
                            Spacer()
                            Image(systemName: "video.circle")
                        }
                    }
                    NavigationLink(destination: UserManagement()) {
                        HStack {
                            Text("User Management")
                            Spacer()
                            Image(systemName: "person.3")
                        }
                    }
                    NavigationLink(destination: SurveyManagement()) {
                        HStack {
                            Text("Survey Management")
                            Spacer()
                            Image(systemName: "doc.text")
                        }
                    }
                    Button(action: {
                        if(self.logout == false) {
                            self.logout = true
                        }
                    }) {
                        HStack {
                            Text("Logout")
                            Spacer()
                            Image(systemName: "escape")
                        }
                    }
                }// End List
            }//End Vstack
        }// End NavigationView
    }
}

struct Videos: View {
    var body: some View {
        Text("Video Gallery")
    }
}

struct UserManagement: View {
    var body: some View {
        Text("User Management")
    }
}

struct SurveyManagement: View {
    var body: some View {
        Text("Survey Management")
    }
}

struct VideoGallery_Previews: PreviewProvider {
    static var previews: some View {
        VideoGallery()
        /*.previewDevice("iPad mini 4")
        .previewLayout(
            PreviewLayout.fixed(
                width: 2732.0,
                height: 2048.0))*/
    }
}
