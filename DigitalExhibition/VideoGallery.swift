//
//  VideoGallery.swift
//  DigitalExhibition
//
//  Created by Admin on 5/5/20.
//  Copyright © 2020 PA2001. All rights reserved.
//

import SwiftUI

struct VideoGallery: View {
    var body: some View {
        NavigationView {
            Text("BACKEND")
            .navigationBarTitle("Video Gallery")
            //.navigationBarItems(trailing:
                HStack {
                    Button("About") {
                        print("About tapped!")
                    }

                    Button("Logout") {
                        print("Help tapped!")
                    }
                }
            //)
        }
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
