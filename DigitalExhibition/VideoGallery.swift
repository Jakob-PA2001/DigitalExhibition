//
//  VideoGallery.swift
//  DigitalExhibition
//
//  Created by Admin on 5/5/20.
//  Copyright © 2020 PA2001. All rights reserved.
//

import SwiftUI

struct VideoGallery: View {
    
    @State private var logout: Bool = false
    @State var allowRefresh: Bool = false
    
    var body: some View {
        return Group {
            if(logout) {
                SplashScreen()
            }
            else {
                Menu(logout: $logout, allowRefresh: $allowRefresh)
            }
        }
    }// End Body
}

struct Menu: View {
    
    @Binding var logout: Bool
    @Binding var allowRefresh: Bool
    
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
                        .offset(y: -10)
                    Text("Admin")
                        .font(.headline)
                        .offset(y: -10)
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
                    NavigationLink(destination: UserManagement()) {
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
}
var videoList = [
    videoAttributes(videoname: "kwUNhM2A3nT4WPsOF0WYjZPtxJwt6mFABh0724FP.mp4", description: "afd", videoNo: "afd"),
]

func addvideos(){
    
    videoList.append(videoAttributes.init(videoname: "testadd", description: "testadd", videoNo: "testadd"))
    downloadVideos(filename: "kwUNhM2A3nT4WPsOF0WYjZPtxJwt6mFABh0724FP.mp4")
    
   //findlocalDir(filename: "kwUNhM2A3nT4WPsOF0WYjZPtxJwt6mFABh0724FP.mp4")
    
    /*if(showvideoDatabase()==true){ // if database is not empty
        for n in 1 ... getTableSize(tablename: "videos") {
            print("tablesize", n)

            videoList.append(videoAttributes.init(videoname: returnVideoNo(row: n, coloumname: "videono"), description:returnVideoNo(row: n, coloumname: "videoname"),videoNo:returnVideoNo(row: n, coloumname: "videono") )
            )
  }//for ends
            
        }else{
            SyncVideoDatabase() //sync server database files

        }*/
 
    
}

struct Videos: View {
    
    @Binding var allowRefresh: Bool
    @State var refreshCount = 0
    @State var refreshIcon: String = "rays"
    
    var body: some View {
        return Group {
            if(allowRefresh && refreshCount == 1) {
                Videos(allowRefresh: $allowRefresh)
            }
            else {
                VStack {
                    /*refresh(allowRefresh: $allowRefresh, refreshCount: $refreshCount, refreshIcon: $refreshIcon)*/
                    // add content below refresh

                        
                    List(videoList, id: \.videoNo) { videoAttributes in

                     NavigationLink(destination: VideoView(link:  findlocalDir(filename: videoAttributes.videoname).absoluteString) ) {
                                           
                          Text( videoAttributes.videoname)
                          Text( videoAttributes.description)
                                             
                         }.navigationBarTitle(Text("Videos")).navigationBarItems(
                            trailing: Button(action: addvideos, label: {refresh(allowRefresh: self.$allowRefresh, refreshCount: self.$refreshCount, refreshIcon: self.$refreshIcon)}))//navlink
                         Text("View Video")
                
                        
                    }// End List
                    // Debug test for refresh, if changes in sim, refresh works.
                    Text("Debug " + String(allowRefresh))
                }// End VStack
            }
        }// End Group
    }
}

struct UserManagement: View {
    var body: some View {
        Text("User Management")
    }
}

struct SurveyManagement: View {
    var body: some View {
        Text("Survey Management")
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
        VideoGallery()
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

