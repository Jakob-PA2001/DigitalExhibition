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
                VStack{
                    HStack {
                        NavigationLink(destination: ShowAddView(users: self.$users)) {
                                HStack(alignment: .firstTextBaseline) {
                                    Text("Add User")
                                    Image(systemName: "person.crop.circle.badge.plus")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                        }
                        Spacer()
                    }.padding(.leading)
                }
                Rectangle()
                    .frame(height: 5)
                    .foregroundColor(Color(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, opacity: 1.0))
                List(users, id: \.username) { users in
                    Text(users.username)
                        .frame(width: self.width, alignment: .leading)
                        .lineLimit(1)
                        .background(CenteringView())
                    Spacer()
                    Text(users.password)
                        .frame(width: self.width, alignment: .leading)
                        .lineLimit(1)
                        .background(CenteringView())
                    Spacer()
                    if(users.username != "Username") {
                        Button(action: {
                            if(users.username == self.currentUser) {
                                self.activeAlert = .first
                            } else {
                                if(users.location == "Offline") {
                                    print("loc: " + users.location)
                                    self.activeAlert = .second
                                }
                                else if(users.location == "Online"){
                                    let queue = DispatchQueue(label: "Monitor")
                                    self.monitor.start(queue: queue)
                                    
                                    self.monitor.pathUpdateHandler = { path in
                                    if path.status == .satisfied {
                                        print("We're connected!")
                                        print("stat: " + users.location)
                                        self.activeAlert = .third
                                    } else {
                                        print("No connection.")
                                        self.activeAlert = .fourth
                                    }

                                    print(path.isExpensive)
                                    }
                                }
                            }
                            self.showAlert = true
                        }) {
                            Image(systemName: "person.crop.circle.badge.minus")
                                .foregroundColor(Color.red)
                                .font(.title)
                        }
                        .alert(isPresented:self.$showAlert) {
                            switch self.activeAlert {
                                case .first:
                                    return Alert(title: Text("Alert!")
                                            .foregroundColor(Color.red), message: Text("You cannot delete yourself.")
                                            .foregroundColor(Color.red), dismissButton: .default(Text("Ok")))
                                case .second:
                                    return Alert(title: Text("Alert!")
                                        .foregroundColor(Color.red), message: Text("Are you sure you want to delete " + users.username)
                                        .foregroundColor(Color.red), primaryButton: .default(Text("Yes")) {
                                            self.deleteLocalUser(username: users.username)
                                        }, secondaryButton: .destructive(Text("Cancel")))
                                case .third:
                                    return Alert(title: Text("Alert!")
                                        .foregroundColor(Color.red), message: Text("Are you sure you want to delete " + users.username)
                                        .foregroundColor(Color.red), primaryButton: .default(Text("Yes")) {
                                            self.deleteOnlineUser(username: String(users.username), password: String(users.password))
                                        }, secondaryButton: .destructive(Text("Cancel")))
                                case .fourth:
                                    return Alert(title: Text("Alert!")
                                        .foregroundColor(Color.red), message: Text("Please connect to the internet to delete " + users.username)
                                        .foregroundColor(Color.red), dismissButton: .default(Text("Ok")))
                            }//switch
                        }//alertz
                    }//if
                    else {
                        Button(action: {}) {
                            Image(systemName: "person.crop.circle.badge.minus")
                                .foregroundColor(Color.white)
                                .font(.title)
                        }
                    }
                    
                }
            }// End VStack
            .navigationBarTitle(Text("User Management")).navigationBarItems(
            trailing: Button(action: {
                let db = UserDBManager()
                db.uploadUsers()
            }) {
                    Text("Sync Users")
                    Image(systemName: "rays")
                })
        }

        func deleteLocalUser(username: String){
            let localDb = UserDBManager()
            //localDb.deleteUser(username: username)
            users = UserDBManager().retrieveUserAttr()
        }

        func deleteOnlineUser(username: String, password: String){
            let localDb = UserDBManager()
            let onlineDb = OnlineUserDB()
            onlineDb.DeleteUser(username: username, password: password)
            //localDb.deleteUser(username: username)
            //users = UserDBManager().retrieveUserAttr()
        }
    }

struct TestScreen_Previews: PreviewProvider {
    static var previews: some View {
        TestScreen()
    }
}
