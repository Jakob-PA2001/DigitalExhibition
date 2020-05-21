//
//  TestScreen.swift
//  DigitalExhibition
//
//  Created by Admin on 15/5/20.
//  Copyright © 2020 PA2001. All rights reserved.
//

import SwiftUI
import CoreData

//For Testing purposes


struct TestScreen: View {
    //var nationality = Nationalities
    @State var nation = NationalityDBManager().retrieveNation()
    @State var selectedIndex = 0
    @State private var showingDeleteAlert = false
    @State var users = UserDBManager().retrieveUsers()
    @State var attr = UserDBManager().retrieveUserAttr()
    
    var body: some View {
        VStack {
            Text("Test")
            Button(action: {}) {
                Text("Test")
            }
        }
        /*Button(action: {self.du.DownloadUsers()}) {
            Text("Test")
        }*/
    }// End Body
    
    func add(usernamee: String) {
        print(usernamee)
    }
}

struct NewView: View {
    //@Binding var uuuu: String
    var body: some View {
        Text("h")
    }
}

struct TestScreen_Previews: PreviewProvider {
    static var previews: some View {
        TestScreen()
    }
}
