//
//  VideoGallery.swift
//  DigitalExhibition
//
//  Created by Admin on 5/5/20.
//  Copyright © 2020 PA2001. All rights reserved.
//

import SwiftUI
import CoreData

struct VideoGallery: View {
    @Binding var username: String
    
    @State private var logout: Bool = false
    @State var allowRefresh: Bool = false
    @State var users = UserDBManager().retrieveUserAttr()
    
    var body: some View {
        return Group {
            if(logout) {
                SplashScreen()
            }
            else {
                Menu(currentUser: $username, logout: $logout, allowRefresh: $allowRefresh, users: self.$users)
            }
        }
    }// End Body
}

struct Menu: View {
    
    @Binding var currentUser: String
    @Binding var logout: Bool
    @Binding var allowRefresh: Bool
    @Binding var users: [UserDBManager.userAttr]
    
    var body: some View {
        NavigationView {
            VStack {
                Image("minimal.background")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(y: -100)
                    .padding(.bottom, -130)
                HStack() {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.title)
                        .offset(y: -30)
                    Text(currentUser)
                        .font(.headline)
                        .offset(y: -30)
                }// End HStack
                .padding(.bottom, -15)

                List{
                    NavigationLink(destination: Videos(allowRefresh: $allowRefresh)) {
                        HStack(alignment: .firstTextBaseline) {
                            Text("Video Gallery")
                            Spacer()
                            Image(systemName: "video.circle")
                        }
                    }
                    NavigationLink(destination: UserManagement(currentUser: $currentUser, users: self.$users)) {
                        HStack {
                            Text("User Management")
                            Spacer()
                            Image(systemName: "person.3")
                        }
                    }
                    NavigationLink(destination: SurveyManagement()) {
                        HStack {
                            Text("Survey Management")
                            Spacer()
                            Image(systemName: "doc.text")
                        }
                    }
                    Button(action: {
                        if(self.logout == false) {
                            self.logout = true
                        }
                    }) {
                        HStack {
                            Text("Logout")
                            Spacer()
                            Image(systemName: "escape")
                        }
                    }
                }// End List
            }//End Vstack
        }// End NavigationView
    }
}


struct videoAttributes {
  let videoname: String
  let description: String
  let videoNo : String
  let Url : String
}
var videoList = [
    videoAttributes(videoname: "kwUNhM2A3nT4WPsOF0WYjZPtxJwt6mFABh0724FP.mp4", description: "afd", videoNo: "afd", Url: ""),
]

func addvideos(){
    
    print("Syncing video database from server...")
    
    SyncVideoDatabase() //sync server database files
    
    if(showvideoDatabase()==true){ // if database is not empty
           videoList.removeAll()
             print("Syncing complete, Download videos from server")
        var videosize = getTableSize(tablename: "videos")
             for n in 1 ... videosize{
                print("downloading video:", n,"/",videosize)

                downloadVideos(filename: returnVideoNo(row: n, coloumname: "videoUrl"))
                 
       }//for ends
  
    
}


}
func loadvideosScreen(){ //loads array into screen for refresh
    if(showvideoDatabase()==true){ // if database is not empty
        videoList.removeAll()
          print("adding video database to screen")
          for n in 1 ... getTableSize(tablename: "videos") {
              print("tablesize", n)

              videoList.append(videoAttributes.init(videoname: returnVideoNo(row: n, coloumname: "videono"), description:returnVideoNo(row: n, coloumname: "videoname"),videoNo:returnVideoNo(row: n, coloumname: "videono") ,Url: returnVideoNo(row: n, coloumname: "videoUrl"))
              )
    }//for ends
              
          }
    
    
}

struct Videos: View {
    
    @Binding var allowRefresh: Bool
    @State var refreshCount = 0
    @State var refreshIcon: String = "rays"
    
    var body: some View {
        loadvideosScreen()
        return Group {
            if(allowRefresh && refreshCount == 1) {
                Videos(allowRefresh: $allowRefresh)
            }
            else {
                VStack {
                    refresh(allowRefresh: $allowRefresh, refreshCount: $refreshCount, refreshIcon: $refreshIcon)
                    // add content below refresh

                        
                    List(videoList, id: \.videoNo) { videoAttributes in

                        NavigationLink(destination: VideoView(link:  findlocalDir(filename: videoAttributes.Url).absoluteString) ) {
                                           
                          Text( videoAttributes.videoname)
                          Text( videoAttributes.description)
                                             
                         }.navigationBarTitle(Text("Videos")).navigationBarItems(
                         trailing: Button(action: addvideos, label: { Text("SyncVideos") }))//navlink
                         Text("View Video")
                
                        
                    }// End List
                    // Debug test for refresh, if changes in sim, refresh works.
                    Text("Debug " + String(allowRefresh))
                }// End VStack
            }
        }// End Group
    }
}

enum ActiveAlert {
    case first, second
}

struct UserManagement: View {
    @Binding var currentUser: String
    @Binding var users: [UserDBManager.userAttr]
    
    @State private var width: CGFloat? = 250.0
    @State var showAddView: Bool = false
    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .first
    
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
                            self.activeAlert = .second
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
                                    self.deleteUser(username: users.username)
                                }, secondaryButton: .destructive(Text("Cancel")))
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

    func deleteUser(username: String){
        let db = UserDBManager()
        db.deleteUser(username: username)
        users = UserDBManager().retrieveUserAttr()
    }
}

struct ShowAddView: View {
    @Binding var users: [UserDBManager.userAttr]
    
    @State var username = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State var hidePass: Bool = false
    @State var errMessage = ""
    @State var successfullAdd: Bool = false
    
    var body: some View {
        VStack {
            Text("Add New User")
                .font(.title)
            Text("Fill in the following form:")
            Text(errMessage)
                .foregroundColor(Color.red)
            VStack {
                Section {
                    Text("Enter a Username")
                        .font(.headline)
                        .padding(.bottom, -20)
                    TextField("", text: self.$username)
                        .padding()
                        //.fixedSize()
                        .frame(width: 600)
                        //.frame(width: UIScreen.main.bounds.width - 34)
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                        .cornerRadius(10)
                }
                .padding()
                Section {
                    Text("Enter a Password")
                        .font(.headline)
                        .padding(.bottom, -20)
                    SecureField("", text: self.$password)
                        .padding()
                        //.fixedSize()
                        .frame(width: 600)
                        //.frame(width: UIScreen.main.bounds.width - 34)
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 0.5))
                        .cornerRadius(10)
                    }
                .padding()
                Section {
                    Text("Confirm Password")
                        .font(.headline)
                    SecureField("", text: self.$confirmPassword)
                        .padding()
                        //.fixedSize()
                        .frame(width: 600)
                        //.frame(width: UIScreen.main.bounds.width - 34)
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 0.5))
                        .cornerRadius(10)
                    }//Section
                }
                .padding()
                HStack {
                    Button(action: {
                        if(self.username.isEmpty || self.password.isEmpty || self.confirmPassword.isEmpty) {
                            self.errMessage = "Please fill in all the fields"
                        }
                        else if(self.password != self.confirmPassword) {
                            self.errMessage = "Passwords do not match!"
                        }
                        else if(self.username == "Username") {
                            self.errMessage = "Username cannot be 'Username'!"
                        }
                        else {
                            self.addUser()
                        }
                    }) {
                        Text("Add User")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding()
                        .fixedSize()
                        .frame(width: 140, height: 45)
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(8)
                    }
                }//HStack
            }//Vstack
            .offset(y: -100)
        }
    func addUser(){
        var userExists: Bool = false
        let db = UserDBManager()
        userExists = db.doesUserExist(username: self.username)
        if(userExists) {
            errMessage = "Username already exists!"
        }
        else {
            db.addUser(username: self.username, password: self.password)
            errMessage = "User has successfully been added!"
            users = UserDBManager().retrieveUserAttr()
            self.username = ""
            self.password = ""
            self.confirmPassword = ""
        }
    }
}

/*struct ShowDeleteView: View {
    @Binding var users: [UserDBManager.userAttr]
    @Binding var user: String
    
    @State var errMessage = ""
    @State var username = ""
    @State var popUpConfirm: Bool = false
    @State var confirm: Bool = false
    
    var body: some View {
        return Group {
            VStack {
                VStack {
                    Text("Delete User")
                        .font(.title)
                    Text("Please enter the username of the user to be deleted:")
                    Text(errMessage)
                        .foregroundColor(Color.red)
                    VStack {
                        Section {
                            Text("Username")
                                .font(.headline)
                                .padding(.bottom, -20)
                            TextField("", text: self.$username)
                                .padding()
                                .frame(width: 600)
                                //.frame(width: UIScreen.main.bounds.width - 34)
                                .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                                .cornerRadius(10)
                        }
                        .padding()
                        Button(action: {
                            if(self.username.isEmpty) {
                                self.errMessage = "Please enter a username!"
                            }else {
                                self.errMessage = ""
                                self.popUpConfirm = true
                            }
                        }) {
                            Text("Delete User")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding()
                            .fixedSize()
                            .frame(width: 140, height: 45)
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(8)
                        }.sheet(isPresented: self.$popUpConfirm) {
                            ConfirmDelete(users: self.$users, username: self.$username, errMessage: self.$errMessage)
                        }
                    }
                }
            }//Vstack
        }// End VStack
        .offset(y: -50)
    }*/
    
    /*struct ConfirmDelete: View {
        @Environment(\.presentationMode) var presentationMode
        @Binding var users: [UserDBManager.userAttr]
        @Binding var username: String
        @Binding var errMessage: String
        var body: some View {
            VStack {
                Text("Please tap confirm to delete user: " + self.username)
                    .font(.headline)
                    .padding()
                Button(action: {
                    if(deleteUser(username: self.username)) {
                        self.username = ""
                        self.errMessage = "User has successfully been deleted."
                        self.users = UserDBManager().retrieveUserAttr()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    else {
                        self.username = ""
                        self.errMessage = "User does not exist!"
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Confirm")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding()
                    .fixedSize()
                    .frame(width: 140, height: 45)
                    .foregroundColor(.white)
                    .background(Color(red: 183/255.0, green: 28/255.0, blue: 28/255.0, opacity: 1.0))
                    .cornerRadius(8)
                }
            }
        }
    }
}*/



struct SurveyManagement: View {
    
    @State var surveys = SurveyDBManager().retrieveAttr()
    @State private var width: CGFloat? = nil
    
    var body: some View {
        VStack {
            List(surveys, id: \.sid) {surveys in
                HStack {
                    Text(surveys.sid)
                        .frame(width: self.width, alignment: .leading)
                        .lineLimit(1)
                        .background(CenteringView())
                    Spacer()
                    Text(surveys.age)
                        .frame(width: self.width, alignment: .leading)
                        .lineLimit(1)
                        .background(CenteringView())
                    Spacer()
                    Text(surveys.gender)
                        .frame(width: self.width, alignment: .leading)
                        .lineLimit(1)
                        .background(CenteringView())
                    Spacer()
                    Text(surveys.nationality)
                        .frame(width: self.width, alignment: .leading)
                        .lineLimit(1)
                        .background(CenteringView())
                }.onPreferenceChange(CenteringColumnPreferenceKey.self) { preferences in
                    for p in preferences {
                        let oldWidth = self.width ?? CGFloat.zero
                        if p.width > oldWidth {
                            self.width = p.width
                        }
                    }
                }
            }
            
        }//End VStack
            .navigationBarTitle(Text("Survey Management")).navigationBarItems(
        trailing: Button(action: {
                let db = SurveyDBManager()
                db.submitSurvey()
                self.surveys = SurveyDBManager().retrieveAttr()
            }) {
                Text("Upload Surveys")
                Image(systemName: "square.and.arrow.up")
            })
    }// End body
}
/*
 The following 
 */
struct CenteringColumnPreferenceKey: PreferenceKey {
    typealias Value = [CenteringColumnPreference]

    static var defaultValue: [CenteringColumnPreference] = []

    static func reduce(value: inout [CenteringColumnPreference], nextValue: () -> [CenteringColumnPreference]) {
        value.append(contentsOf: nextValue())
    }
}

struct CenteringColumnPreference: Equatable {
    let width: CGFloat
}

struct CenteringView: View {
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.clear)
                .preference(
                    key: CenteringColumnPreferenceKey.self,
                    value: [CenteringColumnPreference(width: geometry.frame(in: CoordinateSpace.global).width)]
                )
        }
    }
}

struct refresh: View {
    
    @Binding var allowRefresh: Bool
    @Binding var refreshCount: Int
    @Binding var refreshIcon: String
    
    var body: some View {
        Button(action: {
            if(self.allowRefresh == false) {
                self.allowRefresh = true
                self.refreshCount = 1
            }
            else {
                self.allowRefresh = false
                self.refreshCount = 0
            }
        }) {
            HStack {
                Text("Sync")
                Image(systemName: refreshIcon)
            }
        }
    }
}

struct VideoGallery_Previews: PreviewProvider {
    static var previews: some View {
        Text("Preview")
        //VideoGallery()
        /*.previewDevice("iPad mini 4")
        .previewLayout(
            PreviewLayout.fixed(
                width: 2732.0,
                height: 2048.0))*/
    }
}


//video download
let storageURL = "https://pa2001.cdms.westernsydney.edu.au/f/storage/app/public/"
//this is the directory for video storage
func downloadVideos (filename : String){
    print("DownloadVideo from:" , storageURL + filename)
          // Create destination URL
           let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
           //default.url = default path
          let destinationFileUrl = documentsUrl.appendingPathComponent(filename)
          //Create URL to the source file you want to download
          let fileURL = URL(string: storageURL + filename)
          
          let sessionConfig = URLSessionConfiguration.default
          let session = URLSession(configuration: sessionConfig)
          let request = URLRequest(url:fileURL!)
          
          let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
              if let tempLocalUrl = tempLocalUrl, error == nil {
                  // Success
                  if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                      print("Successfully downloaded. Status code: \(statusCode)")
                  }
                  do {
                      try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                  } catch (let writeError) {
                      print("Error creating a file \(destinationFileUrl) : \(writeError)")
                  }
                  
              } else {
                 print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
              }
          }
          task.resume()
   }
   

        
  //loc dir find
func findlocalDir(filename: String) -> URL {
    let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! /*for demoz*/
    print ("doc dir = " + documentsDirectory)
  let destination = URL(fileURLWithPath: String(format: "%@/%@", documentsDirectory,filename))
  return destination
}

