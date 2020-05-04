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
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
