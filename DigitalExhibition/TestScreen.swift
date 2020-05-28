//
//  TestScreen.swift
//  DigitalExhibition
//
//  Created by Admin on 15/5/20.
//  Copyright © 2020 PA2001. All rights reserved.
//

import SwiftUI
import CoreData
import Network

//For Testing purposes


struct TestScreen: View {
        //@Binding var currentUser: String
        //@Binding var users: [UserDBManager.userAttr]
        @State var users = UserDBManager().retrieveUserAttr()
        @State var currentUser: String = "Jak"
        
        @State private var width: CGFloat? = 250.0
        @State var showAddView: Bool = false
        @State private var showAlert = false
        @State private var activeAlert: ActiveAlert = .first
        let monitor = NWPathMonitor()
        
        var body: some View {
            VStack {
                Text("Testing...")
                
                Button(action: {}) {
                    Text(/*@START_MENU_TOKEN@*/"Button"/*@END_MENU_TOKEN@*/)
                }
            }
    }
}

struct TestScreen_Previews: PreviewProvider {
    static var previews: some View {
        TestScreen()
    }
}
