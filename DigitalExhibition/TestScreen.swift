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
        let du = OnlineUserDB()
        var body: some View {
            Button(action: {self.du.DownloadUsers()}) {
                Text("Test")
            }
        }// End Body
    }

struct TestScreen_Previews: PreviewProvider {
    static var previews: some View {
        TestScreen()
    }
}
