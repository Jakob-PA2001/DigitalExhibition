//
//  HomeScreen.swift
//  DigitalExhibition
//
//  Created by Admin on 4/5/20.
//  Copyright © 2020 PA2001. All rights reserved.
//

import SwiftUI
import AVFoundation

struct HomeScreen: View {
    @State private var displayPopup: Bool = false
    @State private var displayVideo: Bool = false
    @State private var displayVideo1: Bool = false
    @State private var displayVideo2: Bool = false
    @State private var displayVideo3: Bool = false
    @State private var show_info: Bool = false
    @State private var choice: Int = 0
    @State private var finishViewing: Bool = false
    
    var body: some View {
        return Group {
            if(finishViewing) {
                SplashScreen()
            }
            else if(displayVideo) {
                EarthquakeVideoInformation(displayPopup: $displayPopup, choice: $choice, radius: 200, text: "What to do in an earthquake")
            }
            else if(displayVideo1) {
                Video1Information(displayPopup: $displayPopup, choice: $choice)
            }
            else if(displayVideo2) {
                Video2Information(displayPopup: $displayPopup, choice: $choice)
            }
            else if(displayVideo3) {
                Video3Information(displayPopup: $displayPopup, choice: $choice)
            }
            else {
                VStack {
                    ZStack {
                        Color(red: 66/255.0, green: 142/255.0, blue: 146/255.0, opacity: 1.0)
                        VStack {
                            HStack {
                                Button(action: {
                                    if(self.finishViewing == false) {
                                        self.finishViewing = true
                                    }
                                    
                                }) {
                                    Image(systemName: "arrow.left")
                                    Text("Finish Viewing")
                                }
                                .padding()
                                //.fixedSize()
                                .frame(width: 250, height: 45)
                                .foregroundColor(.white)
                                .background(Color(red: 28/255.0, green: 49/255.0, blue: 58/255.0, opacity: 1.0))
                                .cornerRadius(25)
                                .shadow(color: Color(red: 30/255.0, green: 50/255.0, blue: 60/255.0, opacity: 0.75), radius: 1, x: 0, y: 3)
                                    .offset(y: 10)
                                //.position(x: UIScreen.main.bounds.width/2, y: 40)
                            }// HStack
                            //.padding()
                            Spacer()
                            HStack {
                                VStack {
                                    Spacer()
                                    EarthquakeVideoButton(displayVideo: $displayVideo)
                                    .position(x: 300, y: 100)
                                    Spacer()
                                    Video1Button(displayVideo1: $displayVideo1)
                                        .position(x: 250, y: 70)
                                    Spacer()
                                    Video2Button(displayVideo2: $displayVideo2)
                                        .position(x: 250, y: 50)
                                    Spacer()
                                    Video3Button(displayVideo3: $displayVideo3)
                                        .position(x: 300, y: 20)
                                    Spacer()
                                }// VStack
                                //.padding()
                                Spacer()
                                VStack {
                                    Spacer()
                                    CirclesOfEmotion(radius: 200, text1: "Take the Circles of Emotion quiz!", text2: "How does this place make you feel?")
                                        .position(x: 250, y: 320)
                                    Spacer()
                                    AboutLangtang(displayPopup: $displayPopup, choice: $choice)
                                        .position(x: 250, y: 200)
                                    Spacer()
                                }// VStack
                                //.padding()
                                Spacer()
                            }// HStack
                            Spacer()
                        }// VStack
                    }// ZStack
                }// VStack
                //.edgesIgnoringSafeArea(.top)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
    }
}



struct EarthquakeVideoInformation: View {
    @Binding var displayPopup: Bool
    @Binding var choice: Int
    @State var goBack: Bool = false
    @State var tovideo: Bool = false
    var radius: Double
    var text: String
    var kerning: CGFloat = 4.0
    
    private var texts: [(offset: Int, element:Character)] {
        return Array(text.enumerated())
    }
    
    @State var textSizes: [Int:Double] = [:]
    
    var body: some View {
        return Group {
            if(self.goBack) {
                HomeScreen()
            }
            else {
                VStack {
                    ZStack {
                        LinearGradient(gradient: Gradient(colors: [Color.white, Color(red: 46/255.0, green: 125/255.0, blue: 50/255.0, opacity: 1.0)]), startPoint: .top, endPoint: .bottom)
                        VStack {
                            Button(action: {
                                if(self.goBack == false) {
                                    self.goBack = true
                                }
                            }){
                                HStack {
                                    Image(systemName: "arrow.left")
                                    Text("Return To Exhibition")
                                }
                            }
                            .frame(width: 250, height: 45)
                            .foregroundColor(.white)
                            .background(Color(red: 28/255.0, green: 49/255.0, blue: 58/255.0, opacity: 1.0))
                            .cornerRadius(25)
                            .shadow(color: Color(red: 30/255.0, green: 50/255.0, blue: 60/255.0, opacity: 0.75), radius: 1, x: 0, y: 3)
                            Spacer()

                            VStack{
                                Button(action: {
                                    self.displayPopup = true
                                    self.choice = 1
                                      
                                }) {
                                    ZStack() {
                                    ForEach(self.texts, id: \.self.offset) { (offset, element) in
                                        VStack {
                                            Text(String(element))
                                                .kerning(self.kerning)
                                                .background(Sizeable())
                                                .onPreferenceChange(WidthPreferenceKey.self, perform: { size in
                                                    self.textSizes[offset] = Double(size)
                                                })
                                                .font(.custom("Copperplate", size: 16))
                                            Spacer()
                                        }
                                        .rotationEffect(self.angle(at: offset))
                                        
                                    }.position(x: 460, y: 260)
                                    Image("preview.4")
                                    .rotationEffect(.degrees(50))
                                    Image(systemName: "play")
                                        .font(.title)
                                        .foregroundColor(Color.white)
                                        .rotationEffect(.degrees(50))
                                    }.rotationEffect(-self.angle(at: self.texts.count-1)/2)
                                }.sheet(isPresented: self.$displayPopup) {
                                    PopUp(choice: self.$choice)
                                }
                                .buttonStyle(PlainButtonStyle())
                                if(getVideoNoInfo(videono: 1, deviceNum: LocaldeviceNo, coloumname: "videoname") != ""){
                                  Text(getVideoNoInfo(videono: 1, deviceNum: LocaldeviceNo, coloumname: "videoname"))
                                    .font(.title)
                                  Text(getVideoNoInfo(videono: 1, deviceNum: LocaldeviceNo, coloumname: "description"))
                                  .multilineTextAlignment(.center)
                                  .lineSpacing(10)
                                  .foregroundColor(Color.black)
                                  .frame(width: UIScreen.main.bounds.width, height: 300)
                                  .font(.custom("Avenirnext-Regular", size: 20))
                                }else{
                                    Text("Video Not Yet Available").font(.title)
                                    Text("try re-sync video from the administrator area!")
                                      .multilineTextAlignment(.center)
                                      .lineSpacing(10)
                                      .foregroundColor(Color.black)
                                      .font(.custom("Avenirnext-Regular", size: 20))
                                }
                              
                            }
                            Spacer()
                        }
                    }
                }
            }//End if-else
        }// End Group
    }
    
    private func angle(at index: Int) -> Angle {
        guard let labelSize = textSizes[index] else {return .radians(0)}
        let percentOfLabelInCircle = labelSize / radius.perimeter
        let labelAngle = 2 * Double.pi * percentOfLabelInCircle
        
        
        let totalSizeOfPreChars = textSizes.filter{$0.key < index}.map{$0.value}.reduce(0,+)
        let percenOfPreCharInCircle = totalSizeOfPreChars / radius.perimeter
        let angleForPreChars = 2 * Double.pi * percenOfPreCharInCircle
        
        return .radians(angleForPreChars + labelAngle)
    }
}

struct Video1Information: View {
    @Binding var displayPopup: Bool
    @Binding var choice: Int
    @State var goBack: Bool = false
    var body: some View {
        return Group {
            if(self.goBack) {
                HomeScreen()
            }
            else {
                VStack {
                    VStack {
                        Button(action: {
                            if(self.goBack == false) {
                                self.goBack = true
                            }
                        }){
                            HStack {
                                Image(systemName: "arrow.left")
                                Text("Return To Exhibition")
                            }
                            
                        }
                        .frame(width: 250, height: 45)
                        .foregroundColor(.white)
                        .background(Color(red: 28/255.0, green: 49/255.0, blue: 58/255.0, opacity: 1.0))
                        .cornerRadius(25)
                        .shadow(color: Color(red: 30/255.0, green: 50/255.0, blue: 60/255.0, opacity: 0.75), radius: 1, x: 0, y: 3)
                        Spacer()
                       Button(action: {
                           self.displayPopup = true
                           self.choice = 2
                            
                       }) {
                           ZStack(alignment: .center) {
                           Image("preview.1")
                           Image(systemName: "play")
                               .font(.title)
                               .foregroundColor(Color.white)
                           }
                       }.sheet(isPresented: self.$displayPopup) {
                          PopUp(choice: self.$choice)
                       }
                       .buttonStyle(PlainButtonStyle())

                        if(getVideoNoInfo(videono: 2, deviceNum: LocaldeviceNo, coloumname: "videoname") != ""){
                            Text(getVideoNoInfo(videono: 2, deviceNum: LocaldeviceNo, coloumname: "videoname")).font(.title)
                            Text(getVideoNoInfo(videono: 2, deviceNum: LocaldeviceNo, coloumname: "description"))
                            .multilineTextAlignment(.center)
                            .lineSpacing(10)
                            .foregroundColor(Color.black)
                            .frame(width: UIScreen.main.bounds.width, height: 300)
                            .font(.custom("Avenirnext-Regular", size: 20))
                        }else{
                            Text("Video Not Yet Available").font(.title)
                            Text("try re-sync video from the administrator area!")
                              .multilineTextAlignment(.center)
                              .lineSpacing(10)
                              .foregroundColor(Color.black)
                              .font(.custom("Avenirnext-Regular", size: 20))
                        }
                        
                        Spacer()
                    }
                }.background(
                    Image("preview.1")
                    .resizable()
                    .frame(width: 1400, height: 1400)
                    .aspectRatio(contentMode: .fit)
                    .blur(radius: 10)
                )
            }//End if-else
        }// End Group
    }
}

struct Video2Information: View {
    @Binding var displayPopup: Bool
    @Binding var choice: Int
    @State var goBack: Bool = false
    var body: some View {
        return Group {
            if(self.goBack) {
                HomeScreen()
            }
            else {
                VStack {
                    Button(action: {
                        if(self.goBack == false) {
                            self.goBack = true
                        }
                    }){
                        HStack {
                            Image(systemName: "arrow.left")
                            Text("Return To Exhibition")
                        }
                    }
                    .frame(width: 250, height: 45)
                    .foregroundColor(.white)
                    .background(Color(red: 28/255.0, green: 49/255.0, blue: 58/255.0, opacity: 1.0))
                    .cornerRadius(25)
                    .shadow(color: Color(red: 30/255.0, green: 50/255.0, blue: 60/255.0, opacity: 0.75), radius: 1, x: 0, y: 3)
                    Spacer()

                    VStack{
                        Button(action: {
                            self.displayPopup = true
                            self.choice = 3
                              
                        }) {
                            ZStack {
                            Image("preview.2")
                            Image(systemName: "play")
                                .font(.title)
                                .foregroundColor(Color.white)
                            }
                        }.sheet(isPresented: self.$displayPopup) {
                            PopUp(choice: self.$choice)
                        }
                        .buttonStyle(PlainButtonStyle())
                        if(getVideoNoInfo(videono: 3, deviceNum: LocaldeviceNo, coloumname: "videoname") != ""){
                          Text(getVideoNoInfo(videono: 3, deviceNum: LocaldeviceNo, coloumname: "videoname")).font(.title)
                          Text(getVideoNoInfo(videono: 3, deviceNum: LocaldeviceNo, coloumname: "description"))
                          .multilineTextAlignment(.center)
                          .lineSpacing(10)
                          .foregroundColor(Color.black)
                          .frame(width: UIScreen.main.bounds.width, height: 300)
                          .font(.custom("Avenirnext-Regular", size: 20))
                        }else{
                            Text("Video Not Yet Available").font(.title)
                            Text("try re-sync video from the administrator area!")
                              .multilineTextAlignment(.center)
                              .lineSpacing(10)
                              .foregroundColor(Color.black)
                              .font(.custom("Avenirnext-Regular", size: 20))
                        }
                    }
                    Spacer()
                }.background(
                    Image("preview.2")
                    .resizable()
                    .frame(width: 1400, height: 1400)
                    .aspectRatio(contentMode: .fit)
                    .blur(radius: 10)
                )
            }//End if-else
        }// End Group
    }
}

struct Video3Information: View {
    @Binding var displayPopup: Bool
    @Binding var choice: Int
    @State var goBack: Bool = false
    var body: some View {
        return Group {
            if(self.goBack) {
                HomeScreen()
            }
            else {
                VStack {
                    Button(action: {
                        if(self.goBack == false) {
                            self.goBack = true
                        }
                    }){
                        HStack {
                            Image(systemName: "arrow.left")
                            Text("Return To Exhibition")
                        }
                    }
                    .frame(width: 250, height: 45)
                    .foregroundColor(.white)
                    .background(Color(red: 28/255.0, green: 49/255.0, blue: 58/255.0, opacity: 1.0))
                    .cornerRadius(25)
                    .shadow(color: Color(red: 30/255.0, green: 50/255.0, blue: 60/255.0, opacity: 0.75), radius: 1, x: 0, y: 3)
                    Spacer()

                    VStack{
                        Button(action: {
                            self.displayPopup = true
                            self.choice = 4
                              
                        }) {
                            ZStack {
                            Image("preview.3")
                            Image(systemName: "play")
                                .font(.title)
                                .foregroundColor(Color.white)
                            }
                        }.sheet(isPresented: self.$displayPopup) {
                            PopUp(choice: self.$choice)
                        }
                        .buttonStyle(PlainButtonStyle())
                      
                        if(getVideoNoInfo(videono: 4, deviceNum: LocaldeviceNo, coloumname: "videoname") != ""){
                            Text(getVideoNoInfo(videono: 4, deviceNum: LocaldeviceNo, coloumname: "videoname")).font(.title)
                            Text(getVideoNoInfo(videono: 4, deviceNum: LocaldeviceNo, coloumname: "description"))
                            .multilineTextAlignment(.center)
                            .lineSpacing(10)
                            .foregroundColor(Color.black)
                            .frame(width: UIScreen.main.bounds.width, height: 300)
                            .font(.custom("Avenirnext-Regular", size: 20))
                        }else{
                            Text("Video Not Yet Available").font(.title)
                            Text("try re-sync video from the administrator area!")
                            .multilineTextAlignment(.center)
                            .lineSpacing(10)
                            .foregroundColor(Color.black)
                            .font(.custom("Avenirnext-Regular", size: 20))
                        }
                    }
                    Spacer()
                }.background(
                    Image("preview.3")
                    .resizable()
                    .frame(width: 1400, height: 1400)
                    .aspectRatio(contentMode: .fit)
                    .blur(radius: 10)
                )
            }//End if-else
        }// End Group
    }
}

struct CirclesOfEmotion: View {
    var radius: Double
    var text1: String
    var text2: String
    var kerning: CGFloat = 7.0
    
    private var texts1: [(offset: Int, element:Character)] {
        return Array(text1.enumerated())
    }
    private var texts2: [(offset: Int, element:Character)] {
        return Array(text2.enumerated())
    }
    
    @State var textSizes: [Int:Double] = [:]
    
    var body: some View {
        Group {
            Button(action: {self.RedirectQuiz()}) {

                    ZStack {
                        ForEach(self.texts2, id: \.self.offset) { (offset, element) in
                            VStack {
                                Text(String(element))
                                    .kerning(self.kerning)
                                    .background(Sizeable())
                                    .onPreferenceChange(WidthPreferenceKey.self, perform: { size in
                                        self.textSizes[offset] = Double(size)
                                    })
                                    .font(.custom("Copperplate", size: 16))
                                Spacer()
                            }
                            .rotationEffect(self.angle(at: offset))
                            
                        }
                        .position(x: 250, y: 125)
                        ForEach(self.texts1, id: \.self.offset) { (offset, element) in
                            VStack {
                                Text(String(element))
                                    .kerning(self.kerning)
                                    .background(Sizeable())
                                    .onPreferenceChange(WidthPreferenceKey.self, perform: { size in
                                        self.textSizes[offset] = Double(size)
                                    })
                                    .font(.custom("Copperplate", size: 16))
                                Spacer()
                            }
                            .rotationEffect(self.angle(at: offset))
                            
                        }
                        .position(x: 210, y: 135)
                        
                        Image("circle.background")
                            .resizable()
                            .shadow(radius: 10)
                            .frame(width: 300, height: 300)
                            .aspectRatio(contentMode: .fit)
                        Image("circle")
                            .shadow(radius: 10)
                            .rotationEffect(.degrees(75))
                            //.offset(x: -22, y: 15)
                    }.rotationEffect(-self.angle(at: self.texts1.count-1)/2)
                    .frame(width: 300, height: 300, alignment: .center)
            }// End button
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    func RedirectQuiz() {
        if let url = URL(string: "https://circlesofemotion.org") {
            UIApplication.shared.open(url)
        }
    }// End func
    
    private func angle(at index: Int) -> Angle {
        guard let labelSize = textSizes[index] else {return .radians(0)}
        let percentOfLabelInCircle = labelSize / radius.perimeter
        let labelAngle = 2 * Double.pi * percentOfLabelInCircle
        
        
        let totalSizeOfPreChars = textSizes.filter{$0.key < index}.map{$0.value}.reduce(0,+)
        let percenOfPreCharInCircle = totalSizeOfPreChars / radius.perimeter
        let angleForPreChars = 2 * Double.pi * percenOfPreCharInCircle
        
        return .radians(angleForPreChars + labelAngle)
    }
}

extension Double {
    var perimeter: Double {
        return self * 2 * .pi
    }
}


//Get size for label helper
struct WidthPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat(0)
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
struct Sizeable: View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: WidthPreferenceKey.self, value: geometry.size.width)
        }
    }
}

struct AboutLangtang: View {
    func viewDidLoad() {
        //super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for family: String in UIFont.familyNames
        {
            print(family)
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
    }
    @Binding var displayPopup: Bool
    @Binding var choice: Int
    
    var body: some View {
        Group {
            Button(action: {
                self.viewDidLoad()
                self.displayPopup = true
                self.choice = 5
            }) {
                HStack {
                    Image("heritage")
                    .shadow(radius: 10)
                    Text("About The Langtang Heritage Trail")
                    .font(.custom("Herculanum", size: 22))
                }
            }// End button
            .sheet(isPresented: self.$displayPopup) {
                    PopUp(choice: self.$choice)
            }
            .buttonStyle(PlainButtonStyle())
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0/255.0, green: 76/255.0, blue: 64/255.0, opacity: 1.0), lineWidth: 3))
        }
    }
}
    
struct PopUp: View {
    
    @Binding var choice: Int
    
    var body: some View {
        //DisplayText()
        return Group {
            if(choice != 5) {
                DisplayVideo(choice: $choice)
            }
            else if(choice == 5) {
                DisplayText()
            }
        }
    }
}

struct DisplayVideo: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var choice: Int
    var body: some View {
        VStack {
            VideoView(link:  findlocalDir(filename: getVideoNoInfo(videono: choice, deviceNum: LocaldeviceNo, coloumname: "videoUrl")).absoluteString)
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                VStack {
                    Text("Display Video")
                    Image(systemName: "arrow.down")
                        .font(.title)
                }
                //.padding()
            }//.padding(.bottom, 50)
        }
    }
}

struct DisplayText: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack{
            Color(red: 56/255.0, green: 142/255.0, blue: 60/255.0, opacity: 1.0)
            VStack {
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "arrow.left")
                                .font(.title)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(Color.white)
                    
                    Image("heritage")
                    Text("Langtang Heritage Trail")
                    .font(.custom("Herculanum", size: 22))
                }
                
                Group {
                    Text("The Langtang Heritage Trail is the product of several years of collaboration between the community of Langtang, Flagstaff International Relief Effort (FIRE) and archaeologists/anthropologists at Western Sydney Univeristy (WSU) in response to the precarity of the valley's heritage wrought by the 2015 earthquake. The impetus to 'activate' Langtang heritage arose from an observation: after returning to the valley following evacuation, the rebuilding of places with historical or spiritual significance was spontaneously prioritised by the valley's residents.")
                        .frame(width: 700, height: 180)
                    Text("Care for a common past seemed to anchor feelings of spiritual security in what, in the immediate aftermath, had become a physically insecure place. Heritage, we realised, had a role to play in the ongoing pursuit of wellbeing. Our objective became to work with the local community to find ways to bring about wellbeing benefits through a structured care for the past. Many local residents have shared their stories and memories about the valley and they housed on these iPads as an archive for community posterity as well as an invitation to visitors to communicate accross cultures. These are the stories of Langtang, the secret valley of 'Dagam Namgo', as told by its custodians.")
                    .frame(width: 700, height: 220)
                    Text("We invite you to contribute to this participatory research by recording your own emotions whilst you reflect on the places and the stories. To do so, please complete the 'Circle of Emotion' quiz. Your contributions will be used to evaluate the ways that emotional responses to the past can be built into tue everyday management of heritage.")
                    .frame(width: 700, height: 120)
                }// End group
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .foregroundColor(Color.white)
                    .font(.custom("Avenirnext-Regular", size: 16))
            }// End VStack
        }
    }
}


struct EarthquakeVideoButton: View {
    
    //@Binding var displayPopup: Bool
    @Binding var displayVideo: Bool
    //@Binding var choice: Int
    
    var body: some View {
        Group {
            Button(action: {
                if(self.displayVideo == false) {
                    self.displayVideo = true
                }
            }) {
                HStack {
                    Text("What to do in the event of an earthquake")
                    .font(.custom("Avenirnext-Regular", size: 16))
                    .frame(width: 250)
                    Image("preview.4")
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color(red: 0/255.0, green: 96/255.0, blue: 100/255.0, opacity: 1.0), lineWidth: 4))
                        .shadow(radius: 10)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct Video1Button: View {
    
    @Binding var displayVideo1: Bool
    //@Binding var choice: Int
    
    var body: some View {
        Group {
            Button(action: {
                if(self.displayVideo1 == false) {
                    self.displayVideo1 = true
                }
            }) {
                HStack {
                    Text("Stories from Langtang")
                    .font(.custom("Avenirnext-Regular", size: 16))
                    .frame(width: 200)
                    Image("preview.1")
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color(red: 0/255.0, green: 96/255.0, blue: 100/255.0, opacity: 1.0), lineWidth: 4))
                        .shadow(radius: 10)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct Video2Button: View {
    
    @Binding var displayVideo2: Bool
    
    var body: some View {
        Group {
            Button(action: {
                if(self.displayVideo2 == false) {
                    self.displayVideo2 = true
                }
            }) {
                HStack {
                    Text("Stories from Langtang")
                    .font(.custom("Avenirnext-Regular", size: 16))
                    .frame(width: 200)
                    Image("preview.2")
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color(red: 0/255.0, green: 96/255.0, blue: 100/255.0, opacity: 1.0), lineWidth: 4))
                        .shadow(radius: 10)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct Video3Button: View {
    
    @Binding var displayVideo3: Bool
    //@Binding var choice: Int
    
    var body: some View {
        Group {
            Button(action: {
                if(self.displayVideo3 == false) {
                    self.displayVideo3 = true
                }
            }) {
                HStack {
                    Text("Stories from Langtang")
                    .font(.custom("Avenirnext-Regular", size: 16))
                    .frame(width: 200)
                    Image("preview.3")
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color(red: 0/255.0, green: 96/255.0, blue: 100/255.0, opacity: 1.0), lineWidth: 4))
                        .shadow(radius: 10)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}


struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}


