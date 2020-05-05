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
    @Binding var canExplore: Bool
    var body: some View {
        VStack {
            HStack {
                Image("Fire_Logo")
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .padding()
                Spacer()
                Image("WSU_Logo")
                    .font(.subheadline)
                    .multilineTextAlignment(.trailing)
                    .padding()
            }
            .padding(.top, -620)
            .offset(y: 250)
            Image("Splash")
                .resizable()
                .padding(.top, -620)
                .offset(y: 360)
                .aspectRatio(contentMode: .fit)
            VStack {
                Text("Welcome to the Langtang Heritage Trail")
                    .font(.largeTitle)
                Button(action: {
                    if (self.canExplore == false)
                    {
                        self.canExplore = true
                    }
                }) {
                    Text("EXPLORE")
                        .font(.title)
                        .fontWeight(.medium)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                    
                }
                .padding(.all, 5)
                .border(Color(red: 0/255.0, green: 131/255.0, blue: 143/255.0, opacity: 0.5), width: 2)
                .background(Color(red: 0/255.0, green: 131/255.0, blue: 143/255.0, opacity: 1.0))
                .cornerRadius(5.0)
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
