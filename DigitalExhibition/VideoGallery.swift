//
//  VideoGallery.swift
//  DigitalExhibition
//
//  Created by Admin on 5/5/20.
//  Copyright © 2020 PA2001. All rights reserved.
//

import SwiftUI
import CoreData
import Network
let initialDeviceNo = "Device2"
var LocaldeviceNo = initialDeviceNo

struct VideoGallery: View {
    @Binding var username: String
    
    @State private var logout: Bool = false
    @State var allowRefresh: Bool = false
    @State var users = UserDBManager().retrieveUserAttr()
    @State var selectedDevice = 1
    @State var newUsersUploaded = false
    @State private var taps = 0
    
    var body: some View {
        //check internet before sync
        return Group {
            if(logout) {
                SplashScreen()
            }
            else {
                Menu(currentUser: $username, logout: $logout, allowRefresh: $allowRefresh, users: self.$users, selectedDevice: $selectedDevice, taps: $taps, newUsersUploaded: $newUsersUploaded)
            }
        }
    }// End Body
}

struct Menu: View {
    
    @Binding var currentUser: String
    @Binding var logout: Bool
    @Binding var allowRefresh: Bool
    @Binding var users: [UserDBManager.userAttr]
    @Binding var selectedDevice: Int
    @Binding var taps: Int
    @Binding var newUsersUploaded: Bool
    
    @State var displayVideoList = videoList
    @State private var showAlert = false
    let monitor = NWPathMonitor()
    
    var body: some View {
        NavigationView {
            VStack {
                Image("minimal.background")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(y: -100)
                    .padding(.bottom, -130)
                HStack {
                    VStack {
                        Text("You are logged in as: ")
                            .font(.custom("Avenirnext-Regular", size: 20))
                            .offset(x: 40, y: -60)
                        HStack {
                            Spacer()
                            Image(systemName: "person.crop.circle.fill")
                                .font(.custom("Avenirnext-Regular", size: 20))
                                .offset(x: 20, y: -60)
                                .onTapGesture {
                                    self.taps += 1
                                    if ( self.taps == 5) {
                                        print(String(self.taps))
                                    }
                            }
                            Text(currentUser)
                                .font(.custom("Avenirnext-Regular", size: 20))
                                .offset(x: 20, y: -60)
                            Spacer()
                        }
                    }
                }// End HStack
                .padding(.bottom, -70)

                List{
                    NavigationLink(destination: Home(currentUser: $currentUser, selectedDevice: $selectedDevice).onAppear() {
                        DispatchQueue.global().async(execute: {
                            DispatchQueue.main.sync {
                                SyncVideoDatabase()
                            }
                        })
                    }) {
                        HStack(alignment: .firstTextBaseline) {
                            Text("Home")
                            Spacer()
                            Image(systemName: "house.fill")
                        }
                    }
                    NavigationLink(destination: Videos(displayVideoList: $displayVideoList)) {
                        HStack(alignment: .firstTextBaseline) {
                            Text("Video Gallery")
                            Spacer()
                            Image(systemName: "video.circle")
                        }
                    }
                    NavigationLink(destination: UserManagement(currentUser: $currentUser, users: self.$users, newUsersUploaded: $newUsersUploaded)) {
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
                        if(self.newUsersUploaded) {
                            self.showAlert = true
                        }
                        else {
                            self.logout = true
                        }
                    }) {
                        HStack {
                            Text("Logout")
                            Spacer()
                            Image(systemName: "escape")
                        }
                    }
                    .alert(isPresented:self.$showAlert) {
                        Alert(title: Text("New users have not been synced!")
                        .foregroundColor(Color.red), message: Text("Are you sure you want to logout ?")
                        .foregroundColor(Color.red), primaryButton: .default(Text("Yes")) {
                            self.logout = true
                        }, secondaryButton: .destructive(Text("Cancel")))
                    }
                }// End List
            }//End Vstack
            Home(currentUser: $currentUser, selectedDevice: $selectedDevice).onAppear() {
                DispatchQueue.global().async(execute: {
                    DispatchQueue.main.sync {
                        SyncVideoDatabase()
                    }
                })
            }
        }// End NavigationView
    }
}

struct Home: View {
    @Binding var currentUser: String
    @State var allowRefresh: Bool = false
    @State var refreshCount = 0
    
    let deviceNo = ["Device1", "Device2", "Device3"]
    @Binding var selectedDevice: Int
    
    var body: some View {
        Group {
            if( allowRefresh ) {
                Home(currentUser: $currentUser, selectedDevice: $selectedDevice)
            }
            else {
                VStack {
                    HStack {
                        Text("Home")
                            .font(.title)
                    }
                    List {
                        Text("You are logged in as: " + currentUser )
                        VStack {
                            Text("Assign device number: ")
                            HStack {
                                Picker(selection: $selectedDevice, label: Text("Device: ")) {
                                    ForEach(0 ..< deviceNo.count) {
                                        Text(self.deviceNo[$0])
                                    }
                                }.pickerStyle(SegmentedPickerStyle())
                                    .labelsHidden()
                            }
                            Button(action: {
                                LocaldeviceNo = self.deviceNo[self.selectedDevice]
                                self.allowRefresh = true
                            }) {
                                Text("Assign")
                                    .foregroundColor(Color.blue)
                            }
                        }
                        Text("Current device number: " + LocaldeviceNo )
                        
                        Text("Video Database size: " + String(getTableSize(tablename: "videos")))
                    }
                }
            }
        }
    }
}

func checkDeviceno()-> Bool{ //checks if localdeviceNo is empty or not. false = empty else true
    if (LocaldeviceNo == ""){
        return false
    }
    return true
}

struct videoAttributes {
  let videoname: String
  let description: String
  let videoNo : String
  let Url : String
}
var videoList = [
    videoAttributes(videoname: "EmptyVideos.", description: "", videoNo: "Please Sync from server", Url: ""),
]

func addvideos(){
    print("adding video to array...")
    
    videodesc = ("downloading video for device: " + LocaldeviceNo)
    if(showvideoDatabase()==true){ // if database is not empty, go through and download videos if matching device No
           videoList.removeAll() //remove all previous records of display video records
             print("Syncing complete, Download videos from server")
        
        
            var videosize = getTableSize(tablename: "videos")  //get table size of video database
             for n in 1 ... videosize{  //forloop to go through all videodatabase record
                print(returnVideoNo(row: n, coloumname: "deviceno"))
                if (returnVideoNo(row: n, coloumname: "deviceno") == LocaldeviceNo){  //if the return deviceNo = the localdeviceNo Downloadvideo.
                    print("downloading video for device: ",returnVideoNo(row: n, coloumname: "deviceno"))
                    downloadVideos(filename: returnVideoNo(row: n, coloumname: "videoUrl"), storageURL: returnVideoNo(row: n, coloumname: "locDirectory"))


                }// if statelemt end
            
                 
       }//for ends, (video database for statement)
        loadvideosScreen()
    }//if database is not empty statement ends
  
    
}


func deleteVideos(filename : String){ //delete filename in userdocument directory

    print("deleting Vids:" + filename)
    let fileManager = FileManager.default
    let documentsUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as NSURL
        let documentsPath = documentsUrl.path
    do{
        try fileManager.removeItem(at: findlocalDir(filename: filename))
    } catch {
        print("Could not delete file:" + filename + "\(error)")
           }
    
}

func loadvideosScreen(){ //loads array into screen for refresh [videoList] array
    print("loading videos to screen...")
    
    if(showvideoDatabase()==true){ // if database is not empty
        videoList.removeAll()
          print("adding video database to screen")
          for n in 1 ... getTableSize(tablename: "videos") { //for condition to loop through video database
            if(returnVideoNo(row: n, coloumname: "deviceno")==LocaldeviceNo){ //compares each and if deviceNo = loaldeviceNo , append database daa onto videoList array to display.
                
              videoList.append(videoAttributes.init(videoname: returnVideoNo(row: n, coloumname: "videoname"), description:returnVideoNo(row: n, coloumname: "description"),videoNo:returnVideoNo(row: n, coloumname: "videono") ,Url: returnVideoNo(row: n, coloumname: "videoUrl"))
                
        
              )
                
                    }// if statement ends
    }//for condition ends/ loops through video database
              
          }//if database is not empty condition ends
    
    
}
var videodesc = "VideoDatabase Retrieved Successfully"

struct Videos: View {
    @Binding var displayVideoList: [videoAttributes]
    
    @State var allowRefresh: Bool = false
    @State var refreshCount = 0
    @State var refreshIcon: String = "rays"
    let monitor = NWPathMonitor()
    @State private var showAlert = false
    
    
    var body: some View {
        //loadvideosScreen()
        VStack {

            List(displayVideoList, id: \.videoname) { videoAttributes in

                NavigationLink(destination: VideoView(link:  findlocalDir(filename: videoAttributes.Url).absoluteString) ) {
                                   
                    Text( videoAttributes.videoname + " \nVideo: " + videoAttributes.videoNo)
                                     
                }.navigationBarTitle(Text("Videos")).navigationBarItems(
                 trailing: Button(action: {
                         let queue = DispatchQueue(label: "Monitor")
                         self.monitor.start(queue: queue)
                         
                         self.monitor.pathUpdateHandler = { path in
                         if path.status == .satisfied {
                            self.showAlert = false
                            DispatchQueue.global().async(execute: {
                                DispatchQueue.main.sync {
                                    SyncVideoDatabase()
                                }
                                self.displayVideoList = self.UpdateList()
                            })
                             print("We're connected!")
                         } else {
                             self.showAlert = true
                             print("No connection.")
                         }

                         print(path.isExpensive)
                     }
                     }) {
                         Text("Sync Videos")
                         Image(systemName: "rays")
                     }
                     .alert(isPresented:self.$showAlert) {
                         Alert(title: Text("Alert!")
                         .foregroundColor(Color.red), message: Text("Please connect to the internet to sync videos.")
                         .foregroundColor(Color.red), dismissButton: .default(Text("Ok")))
                    })
                 Text("View Video")
        
                
            }// End List
            // Debug test for refresh, if changes in sim, refresh works.
            Text(videodesc)
        }// End VStack
    }
    
    func UpdateList() -> [videoAttributes]{
        loadvideosScreen()
        return videoList
    }
}

struct refresh: View {
    
    @Binding var allowRefresh: Bool
    @Binding var refreshCount: Int
    @Binding var refreshIcon: String
    
    var body: some View {
        Button(action: {
            print("Syncing video database from server...")
            SyncVideoDatabase() //sync server database files
            addvideos()
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
                Text("Download videos")
               // Image(systemName: refreshIcon)
            }
        }
    }
}

enum ActiveAlert {
    case first, second, third, fourth
}

struct UserManagement: View {
    @Binding var currentUser: String
    @Binding var users: [UserDBManager.userAttr]
    @Binding var newUsersUploaded: Bool
    
    @State private var width: CGFloat? = nil
    @State var showAddView: Bool = false
    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .first
    @State private var showSyncAlert = false
    let monitor = NWPathMonitor()
    
    var body: some View {
            VStack {
                VStack{
                    HStack {
                        NavigationLink(destination: ShowAddView(users: self.$users, newUsersUploaded: $newUsersUploaded)) {
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
                //users = self.UpdateList()
                List(users, id: \.username) { users in
                    if(users.location == "Offline") {
                        Text(users.username)
                            .frame(width: self.width, alignment: .leading)
                            .lineLimit(1)
                            .background(CenteringView())
                            .foregroundColor(Color.gray)
                        Spacer()
                        Text(users.password)
                            .frame(width: self.width, alignment: .leading)
                            .lineLimit(1)
                            .background(CenteringView())
                            .foregroundColor(Color.gray)
                        Spacer()
                    } else {
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
                    }
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

                let queue = DispatchQueue(label: "Monitor")
                self.monitor.start(queue: queue)
                
                self.monitor.pathUpdateHandler = { path in
                if path.status == .satisfied {
                    print("We're connected!")
                    DispatchQueue.global().async(execute: {
                        let db = UserDBManager()
                        DispatchQueue.main.sync {
                            db.uploadUsers()
                            
                        }
                    self.newUsersUploaded = false
                    self.users = self.UpdateList()
                    })
                } else {
                    print("No connection.")
                    self.showSyncAlert = true
                }

                print(path.isExpensive)
                }
            })
                {
                    Text("Sync Users")
                    Image(systemName: "rays")
        })
        .alert(isPresented:self.$showSyncAlert) {
            Alert(title: Text("Alert!")
            .foregroundColor(Color.red), message: Text("Please connect to the internet to sync users.")
            .foregroundColor(Color.red), dismissButton: .default(Text("Ok")))
        }
    }
    
    func UpdateList() -> [UserDBManager.userAttr] {
        return UserDBManager().retrieveUserAttr()
    }

    func deleteLocalUser(username: String){
        let localDb = UserDBManager()
        localDb.deleteUser(username: username)
        self.newUsersUploaded = false
        users = UserDBManager().retrieveUserAttr()
    }

    func deleteOnlineUser(username: String, password: String){
        let localDb = UserDBManager()
        let onlineDb = OnlineUserDB()
        onlineDb.DeleteUser(username: username, password: password)
        localDb.deleteUser(username: username)
        users = UserDBManager().retrieveUserAttr()
    }
}

struct ShowAddView: View {
    @Binding var users: [UserDBManager.userAttr]
    @Binding var newUsersUploaded: Bool
    
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
            db.addUser(username: self.username, password: self.password, location: "Offline")
            errMessage = "User has successfully been added!"
            users = UserDBManager().retrieveUserAttr()
            self.username = ""
            self.password = ""
            self.confirmPassword = ""
            newUsersUploaded = true
        }
    }
}

struct SurveyManagement: View {
    @State var surveys = SurveyDBManager().retrieveAttr()
    @State private var width: CGFloat? = nil
    let monitor = NWPathMonitor()
    @State private var showAlert = false
    
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
                let queue = DispatchQueue(label: "Monitor")
                self.monitor.start(queue: queue)
                
                self.monitor.pathUpdateHandler = { path in
                if path.status == .satisfied {
                    self.showAlert = false
                    let db = SurveyDBManager()
                    db.submitSurvey()
                    self.surveys = SurveyDBManager().retrieveAttr()
                    print("We're connected!")
                } else {
                    self.showAlert = true
                    print("No connection.")
                }

                print(path.isExpensive)
            }
            }) {
                Text("Upload Surveys")
                Image(systemName: "square.and.arrow.up")
            }
            .alert(isPresented:self.$showAlert) {
                Alert(title: Text("Alert!")
                .foregroundColor(Color.red), message: Text("Please connect to the internet to upload surveys.")
                .foregroundColor(Color.red), dismissButton: .default(Text("Ok")))
                
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

func downloadVideos (filename : String, storageURL : String){
    //downloads video from server URL, local videos of same name will be erased beforehand.
    deleteVideos(filename: filename)
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

