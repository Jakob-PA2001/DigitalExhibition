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
            List {
                ForEach(0 ..< users.count) {
                    Text(self.users[$0] + " " + self.users[$0])
                    Text("\($0)")
                    //users += 1
                }
            }
            List(attr, id: \.username) { user in
                Text(user.username)
                Spacer()
                Text(user.password)
                Spacer()
                if(user.username != "Username") {
                    Button(action: {self.showingDeleteAlert = true}) {
                        Image(systemName: "person.crop.circle.badge.minus")
                            .foregroundColor(Color.red)
                            .font(.title)
                    }
                    .alert(isPresented:self.$showingDeleteAlert) {
                        Alert(title: Text("SwiftUI Alert!"), message: Text("This is so easy"), primaryButton: .default(Text("Yes")) {
                            self.add(usernamee: user.username)
                        }, secondaryButton: .destructive(Text("Cancel")))
                    }
                }//if
            }
             
                
            //}
            /*ForEach(0 ..< nation.count) {
                Text(self.nation[$0])

            }*/
            /*Picker(selection: $selectedIndex, label: Text("")) {
                ForEach(nation, id: \.name) { nation in
                    Text("hell").tag(nations)
                    Text(nation.name).tag(nation)
                }
            }*/
            /*List(nation, id: \.name) { nation in
                Text(nation.name)
                Spacer()
            }*/
            //Text(nationality.name)
        }
        /*Picker(selection: $nationality.name, label: Text("Nationality")) {
        }*/
        /*Button(action: {self.du.DownloadUsers()}) {
            Text("Test")
        }*/
    }// End Body
    
    func add(usernamee: String) {
        print(usernamee)
    }
}

struct TestScreen_Previews: PreviewProvider {
    static var previews: some View {
        TestScreen()
    }
}
