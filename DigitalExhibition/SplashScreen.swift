//
//  SplashScreen.swift
//  DigitalExhibition
//
//  Created by Admin on 28/4/20.
//  Copyright © 2020 PA2001. All rights reserved.
//

import SwiftUI

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
    
    @State private var displaySurvey: Bool = false
    @Binding var canExplore: Bool
    
    var body: some View {
        //NavigationView {
            VStack {
                HStack {
                    Image("fire.logo")
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .padding()
                    Spacer()
                    Image("wsu.logo")
                        .font(.subheadline)
                        .multilineTextAlignment(.trailing)
                        .padding()
                }
                .padding(.top, -620)
                .offset(y: 250)
                Image("splash")
                    .resizable()
                    .padding(.top, -620)
                    .offset(y: 360)
                    .aspectRatio(contentMode: .fit)
                VStack {
                    Text("Welcome to the Langtang Heritage Trail")
                        .font(.largeTitle)
                    Button(action: {
                        if(self.canExplore == false) {
                            self.canExplore = true
                        }
                        //self.displaySurvey = true
                    }) {
                            Text("EXPLORE")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .padding()
                                .fixedSize()
                                .frame(width: 140, height: 45)
                                .foregroundColor(.white)
                                .background(Color(red: 0/255.0, green: 96/255.0, blue: 100/255.0, opacity: 1.0))
                                .cornerRadius(8)
                        
                    }
                    .offset(y: 5)
                    /*.sheet(isPresented: self.$displaySurvey) {
                        SurveyScreen()
                    }*/
                }
            }
        //}
        //.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
