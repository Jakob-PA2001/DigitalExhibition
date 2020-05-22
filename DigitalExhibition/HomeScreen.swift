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
    //let randomInt = Int.random(in: 1...5)
    
    var body: some View {
        return Group {
            if(finishViewing) {
                SplashScreen()
            }
            else if(displayVideo) {
                EarthquakeVideoInformation(displayPopup: $displayPopup, choice: $choice)
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
                                .fixedSize()
                                .frame(width: 250, height: 45)
                                .foregroundColor(.white)
                                .background(Color(red: 28/255.0, green: 49/255.0, blue: 58/255.0, opacity: 1.0))
                                .cornerRadius(25)
                                .shadow(color: Color(red: 30/255.0, green: 50/255.0, blue: 60/255.0, opacity: 0.75), radius: 1, x: 0, y: 3)
                            }// HStack
                            .padding()
                            Spacer()
                            HStack {
                                Spacer()
                                VStack {
                                    Spacer()
                                    EarthquakeVideoButton(displayVideo: $displayVideo)
                                    Spacer()
                                    Video1Button(displayVideo1: $displayVideo1)
                                    Spacer()
                                    Video2Button(displayVideo2: $displayVideo2)
                                    Spacer()
                                    Video3Button(displayVideo3: $displayVideo3)
                                    Spacer()
                                }// VStack
                                .padding()
                                Spacer()
                                VStack {
                                    Spacer()
                                    CirclesOfEmotion(radius: 200, text: "Take the Circles of Emotion quiz!")
                                    Spacer()
                                    AboutLangtang(displayPopup: $displayPopup, choice: $choice)
                                    Spacer()
                                }// VStack
                                .padding()
                                Spacer()
                            }// HStack
                            Spacer()
                        }// VStack
                    }// ZStack
                }// VStack
            }
        }
    }
}



struct EarthquakeVideoInformation: View {
    @Binding var displayPopup: Bool
    @Binding var choice: Int
    @State var goBack: Bool = false
    @State var tovideo: Bool = false
    var body: some View {
        return Group {
            if(self.goBack) {
                HomeScreen()
            }
            else {
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
                        .padding()
                        .fixedSize()
                        .frame(width: 250, height: 45)
                        .foregroundColor(.white)
                        .background(Color(red: 28/255.0, green: 49/255.0, blue: 58/255.0, opacity: 1.0))
                        .cornerRadius(25)
                        .shadow(color: Color(red: 30/255.0, green: 50/255.0, blue: 60/255.0, opacity: 0.75), radius: 1, x: 0, y: 3)
                        Spacer()

                        VStack{
                            Button(action: {
                                //self.tovideo = true
                                self.displayPopup = true
                                self.choice = 1
                                  
                            }) {
                                HStack(alignment: .center, spacing: 5.0) {
                                Image("preview.1").clipShape(Circle()).overlay(Circle().stroke(Color.orange, lineWidth:4) ).shadow(radius: 10)
                                Image(systemName: "play")
                                    .font(.title)
                                    .foregroundColor(Color.white)
                                    .offset(x: -85)
                                }
                            }.sheet(isPresented: self.$displayPopup) {
                                PopUp(choice: self.$choice)
                            }
                            .buttonStyle(PlainButtonStyle())
                          
                          Text(returnVideoNo(row: 1, coloumname: "videoname")).font(.title)
                          Text(returnVideoNo(row: 1, coloumname: "description"))
                          .multilineTextAlignment(.center)
                          .lineSpacing(10)
                          .foregroundColor(Color.black)
                          .font(.headline)
                          .padding()
                          
                        }
                        Spacer()
                    }
                }
            }//End if-else
        }// End Group
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
                    .padding()
                    .fixedSize()
                    .frame(width: 250, height: 45)
                    .foregroundColor(.white)
                    .background(Color(red: 28/255.0, green: 49/255.0, blue: 58/255.0, opacity: 1.0))
                    .cornerRadius(25)
                    .shadow(color: Color(red: 30/255.0, green: 50/255.0, blue: 60/255.0, opacity: 0.75), radius: 1, x: 0, y: 3)
                    Spacer()

                    VStack{
                        Button(action: {
                            //self.tovideo = true
                            self.displayPopup = true
                            self.choice = 1
                              
                        }) {
                            HStack(alignment: .center, spacing: 5.0) {
                            Image("preview.1").clipShape(Circle()).overlay(Circle().stroke(Color.orange, lineWidth:4) ).shadow(radius: 10)
                            Image(systemName: "play")
                                .font(.title)
                                .foregroundColor(Color.white)
                                .offset(x: -85)
                            }
                        }.sheet(isPresented: self.$displayPopup) {
                            PopUp(choice: self.$choice)
                        }
                        .buttonStyle(PlainButtonStyle())
                      
                      Text(returnVideoNo(row: 1, coloumname: "videoname")).font(.title)
                      Text(returnVideoNo(row: 1, coloumname: "description"))
                      .multilineTextAlignment(.center)
                      .lineSpacing(10)
                      .foregroundColor(Color.black)
                      .font(.headline)
                      .padding()
                      
                    }
                    Spacer()
                }
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
                    .padding()
                    .fixedSize()
                    .frame(width: 250, height: 45)
                    .foregroundColor(.white)
                    .background(Color(red: 28/255.0, green: 49/255.0, blue: 58/255.0, opacity: 1.0))
                    .cornerRadius(25)
                    .shadow(color: Color(red: 30/255.0, green: 50/255.0, blue: 60/255.0, opacity: 0.75), radius: 1, x: 0, y: 3)
                    Spacer()

                    VStack{
                        Button(action: {
                            //self.tovideo = true
                            self.displayPopup = true
                            self.choice = 2
                              
                        }) {
                            HStack(alignment: .center, spacing: 5.0) {
                            Image("preview.1").clipShape(Circle()).overlay(Circle().stroke(Color.orange, lineWidth:4) ).shadow(radius: 10)
                            Image(systemName: "play")
                                .font(.title)
                                .foregroundColor(Color.white)
                                .offset(x: -85)
                            }
                        }.sheet(isPresented: self.$displayPopup) {
                            PopUp(choice: self.$choice)
                        }
                        .buttonStyle(PlainButtonStyle())
                      
                      Text(returnVideoNo(row: 2, coloumname: "videoname")).font(.title)
                      Text(returnVideoNo(row: 2, coloumname: "description"))
                      .multilineTextAlignment(.center)
                      .lineSpacing(10)
                      .foregroundColor(Color.black)
                      .font(.headline)
                      .padding()
                      
                    }
                    Spacer()
                }
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
                    .padding()
                    .fixedSize()
                    .frame(width: 250, height: 45)
                    .foregroundColor(.white)
                    .background(Color(red: 28/255.0, green: 49/255.0, blue: 58/255.0, opacity: 1.0))
                    .cornerRadius(25)
                    .shadow(color: Color(red: 30/255.0, green: 50/255.0, blue: 60/255.0, opacity: 0.75), radius: 1, x: 0, y: 3)
                    Spacer()

                    VStack{
                        Button(action: {
                            //self.tovideo = true
                            self.displayPopup = true
                            self.choice = 3
                              
                        }) {
                            HStack(alignment: .center, spacing: 5.0) {
                            Image("preview.1").clipShape(Circle()).overlay(Circle().stroke(Color.orange, lineWidth:4) ).shadow(radius: 10)
                            Image(systemName: "play")
                                .font(.title)
                                .foregroundColor(Color.white)
                                .offset(x: -85)
                            }
                        }.sheet(isPresented: self.$displayPopup) {
                            PopUp(choice: self.$choice)
                        }
                        .buttonStyle(PlainButtonStyle())
                      
                      Text(returnVideoNo(row: 3, coloumname: "videoname")).font(.title)
                      Text(returnVideoNo(row: 3, coloumname: "description"))
                      .multilineTextAlignment(.center)
                      .lineSpacing(10)
                      .foregroundColor(Color.black)
                      .font(.headline)
                      .padding()
                      
                    }
                    Spacer()
                }
            }//End if-else
        }// End Group
    }
}

struct CirclesOfEmotion: View {
    var radius: Double
    var text: String
    var kerning: CGFloat = 7.0
    
    private var texts: [(offset: Int, element:Character)] {
        return Array(text.enumerated())
    }
    
    @State var textSizes: [Int:Double] = [:]
    
    var body: some View {
        Group {
            Button(action: {self.RedirectQuiz()}) {

                    ZStack {
                        ForEach(self.texts, id: \.self.offset) { (offset, element) in
                            VStack {
                                Text(String(element))
                                    .kerning(self.kerning)
                                    .background(Sizeable())
                                    .onPreferenceChange(WidthPreferenceKey.self, perform: { size in
                                        self.textSizes[offset] = Double(size)
                                    })
                                Spacer()
                            }
                            .rotationEffect(self.angle(at: offset))
                            
                        }
                        
                        Image("circle")
                            .shadow(radius: 10)
                            .rotationEffect(.degrees(70))
                            .offset(x: -22, y: 15)
                    }.rotationEffect(-self.angle(at: self.texts.count-1)/2)
                        
                    .frame(width: 300, height: 300, alignment: .center)
                //}
        
                /*VStack {
                    Text("Take")
                        .rotationEffect(.degrees(-10))
                        .offset(x: -75, y:50)
                    Text("the")
                        .rotationEffect(.degrees(-5))
                        .offset(x: -75, y:50)
                    Text("circles of")
                        .rotationEffect(.degrees(0))
                        .offset(x: -5, y: 20)
                    Text("emotion quiz!")
                        .rotationEffect(.degrees(15))
                        .offset(x: 85, y:12)
                    Image("circle")
                        .shadow(radius: 10)
                }*/
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
    
    @Binding var displayPopup: Bool
    @Binding var choice: Int
    
    var body: some View {
        Group {
            Button(action: {
                self.displayPopup = true
                self.choice = 5
            }) {
                HStack {
                    Image("heritage")
                        .shadow(radius: 10)
                        .offset(y: -10)
                    Text("About The Langtang Heritage Trail")
                        .offset(x: -20, y: 0)
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
                //HomeScreen()
                DisplayVideo(choice: $choice)
            }
            else if(choice == 5) {
                DisplayText()//End ZStack
            }
        }
    }
}

struct DisplayVideo: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var choice: Int
    var body: some View {
        VStack {
            VideoView(link:  findlocalDir(filename: returnVideoNo(row: choice, coloumname: "videoUrl")).absoluteString)
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                VStack {
                    Text("Display Video")
                    Image(systemName: "arrow.down")
                        .font(.title)
                }
                .padding()
            }.padding(.bottom, 50)
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
                            //Text("Return")
                            Image(systemName: "arrow.left")
                                .font(.title)
                                .padding()
                                /*.foregroundColor(.white)
                                .background(Color(red: 28/255.0, green: 49/255.0, blue: 58/255.0, opacity: 1.0))
                                .cornerRadius(25)
                                .shadow(color: Color(red: 30/255.0, green: 50/255.0, blue: 60/255.0, opacity: 0.75), radius: 0.5, x: 0, y: 2)*/
                        }
                        .padding()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(Color.white)
                    .offset(x: -50)
                    
                    Image("heritage")
                    Text("Langtang Heritage Trail")
                        .font(.title)
                        .offset(y: 10)
                }
                .offset(x: -50)
                
                Group {
                    Text("The Langtang Heritage Trail is the product of several years of collaboration between the community of Langtang, Flagstaff International Relief Effort (FIRE) and archaeologists/anthropologists at Western Sydney Univeristy (WSU) in response to the precarity of the valley's heritage wrought by the 2015 earthquake. The impetus to 'activate' Langtang heritage arose from an observation: after returning to the valley following evacuation, the rebuilding of places with historical or spiritual significance was spontaneously prioritised by the valley's residents.")
                    Text("Care for a common past seemed to anchor feelings of spiritual security in what, in the immediate aftermath, had become a physically insecure place. Heritage, we realised, had a role to play in the ongoing pursuit of wellbeing. Our objective became to work with the local community to find ways to bring about wellbeing benefits through a structured care for the past. Many local residents have shared their stories and memories about the valley and they housed on these iPads as an archive for community posterity as well as an invitation to visitors to communicate accross cultures. These are the stories of Langtang, the secret valley of 'Dagam Namgo', as told by its custodians.")
                    Text("We invite you to contribute to this participatory research by recording your own emotions whilst you reflect on the places and the stories. To do so, please complete the 'Circle of Emotion' quiz. Your contributions will be used to evaluate the ways that emotional responses to the past can be built into tue everyday management of heritage.")
                }// End group
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .foregroundColor(Color.white)
                    .font(.headline)
                    .padding()
            }// End VStack
            //.offset(y: -100)
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
                //self.displayPopup = true
                //self.choice = 1
            }) {
                HStack {
                    Image("preview.4")
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color(red: 0/255.0, green: 96/255.0, blue: 100/255.0, opacity: 1.0), lineWidth: 4))
                        .shadow(radius: 10)
                    Text("What to do in the event of an earthquake")
                }
            }// End button
                //.sheet(isPresented: self.$displayPopup) {
                    //PopUp(choice: self.$choice)
            //}
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
                //self.displayPopup = true
                //self.choice = 1
            }) {
                HStack {
                    Image("preview.1")
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color(red: 0/255.0, green: 96/255.0, blue: 100/255.0, opacity: 1.0), lineWidth: 4))
                        .shadow(radius: 10)
                    Text("Stories from Langtang")
                    .lineLimit(1)
                }
            }// End button
                //.sheet(isPresented: self.$displayPopup) {
                    //PopUp(choice: self.$choice)
            //}
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
                    Image("preview.2")
                        .clipShape(Circle())
                        /*.overlay(
                            Circle().stroke(Color(red: 0/255.0, green: 96/255.0, blue: 100/255.0, opacity: 1.0), lineWidth: 4))*/
                        .shadow(radius: 10)
                    Text("Stories from Langtang")
                    .lineLimit(1)
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
                //self.displayPopup = true
                //self.choice = 1
            }) {
                HStack {
                    Image("preview.3")
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color(red: 0/255.0, green: 96/255.0, blue: 100/255.0, opacity: 1.0), lineWidth: 4))
                        .shadow(radius: 10)
                    Text("Stories from Langtang")
                    .lineLimit(1)
                }
            }// End button
                //.sheet(isPresented: self.$displayPopup) {
                    //PopUp(choice: self.$choice)
            //}
            .buttonStyle(PlainButtonStyle())
        }
    }
}


struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}


