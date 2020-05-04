//
//  SplashScreen.swift
//  DigitalExhibition
//
//  Created by Admin on 28/4/20.
//  Copyright © 2020 PA2001. All rights reserved.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
            NavigationView {
                VStack {
                    Text("Welcome to the Langtang Heritage Trail")
                        .font(.largeTitle)
                    NavigationLink(destination: SurveyScreen())
                    {
                        Text("EXPLORE")
                        .padding()
                            .font(.title)
                    }
                }
            }
        .navigationViewStyle(StackNavigationViewStyle())
        .padding()

    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
