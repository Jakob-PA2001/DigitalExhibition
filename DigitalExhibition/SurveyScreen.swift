//
//  SurveyScreen.swift
//  DigitalExhibition
//
//  Created by Admin on 29/4/20.
//  Copyright © 2020 PA2001. All rights reserved.
//

import SwiftUI
import Combine

struct SurveyScreen: View {
    
    //Returns back to splashscreen if survey is open for 2 minutes.
    @State var maxTime = 120
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var completed = false
    @State var login = false
    @State var goBack = false
    
    var body: some View {
        return Group {
            if (completed) {
                HomeScreen()
            }
            else if (login) {
                LogIn()
            }
            else if (maxTime == 0 || goBack) {
                SplashScreen()
            }
            else {
                Survey(completed: $completed, login: $login, goBack: $goBack)
            }
            
            /* Waits 2 minutes before returning to splash screen.
             * Following code was modified from:
             * https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-a-timer-with-swiftui
             */
            Text("\(maxTime)")
                .onReceive(timer) { _ in
                    if self.maxTime > 0 {
                        self.maxTime -= 1
                }
            }
            .hidden()
        }
    }
}

let nations = Bundle.main.decode([Nationalities].self, from: "nationalities.json")

struct Survey: View {
    
    @Binding var completed: Bool
    @Binding var login: Bool
    @Binding var goBack: Bool
    
    @State var age = ""
    @State var errMessage = ""
    
    @State var selectedNation = 9
    @State var nationalityVisible = false
    
    let gender = ["Male", "Female", "Other"]
    @State var selectedGender = 1
    @State var genderVisible = false
    
    @State var nationalityTextPosX = 350
    @State var nationalityTextPosY = 360
    @State var nationalityPosX = 650
    @State var nationalityPosY = 360
    
    var body: some View {
        ZStack {
            
            Group {
                Button(action: {self.goBack.toggle()}) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                }
                .position(x: 20, y: 20)
                
                Button(action: {self.login.toggle()}) {
                    Image(systemName: "person.circle.fill")
                        .font(.title)
                }
                .position(x: 1050, y: 20)
            }
            
            Group {
                Text("Please fill in this short survey to view the exhibition:")
                    .font(.custom("Avenirnext-Regular", size: 28))
                    .position(x: 540, y: 40)
                
                Text(errMessage)
                    .foregroundColor(Color.red)
                    .position(x: 540, y: 80)
            }
            

            Group {
                Text("Enter Your Age : ")
                    .font(.custom("Avenirnext-Regular", size: 20))
                    .position(x: 350, y: 200)
                TextField("19, 20, 26..", text: self.$age)
                    .frame(width: 350, height: 45)
                    .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                    .cornerRadius(25)
                    .keyboardType(.numberPad)
                    .onReceive(Just(age)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0)}
                        if filtered != newValue {
                            self.age = filtered
                        }                }
                    .onTapGesture {
                        if self.nationalityVisible {
                            self.nationalityVisible.toggle()
                        }
                        if self.genderVisible {
                            self.genderVisible.toggle()
                            self.nationalityTextPosY = 360
                            self.nationalityPosY = 360
                        }

                    }
                    .multilineTextAlignment(.center)
                    .position(x: 650, y: 200)
            }
            
            
            Group {
                Text("Select Your Gender : ")
                    .font(.custom("Avenirnext-Regular", size: 20))
                    .position(x: 350, y: 280)
                if genderVisible {
                    Picker(selection: $selectedGender, label: Text("")) {
                        ForEach(0 ..< gender.count) {
                            Text(self.gender[$0])
                                .font(.custom("Avenirnext-Regular", size: 18))
                        }
                    }
                    .onTapGesture {
                        self.nationalityTextPosY = 360
                        self.nationalityPosY = 360
                        self.genderVisible.toggle()
                    }
                    .labelsHidden()
                    .position(x: 650, y: 350)
                }//if
                
                Button(action: {
                    if self.nationalityVisible {
                        self.nationalityVisible.toggle()
                    }
                    if self.genderVisible {
                        self.nationalityTextPosY = 360
                        self.nationalityPosY = 360
                    }
                    else {
                        self.nationalityTextPosY = 440
                        self.nationalityPosY = 440
                    }
                    self.genderVisible.toggle()
                }) {
                    Text(self.gender[selectedGender])
                    .font(.custom("Avenirnext-Regular", size: 18))
                }
                .frame(width: 350, height: 45)
                .foregroundColor(self.genderVisible ? .red : .black)
                .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                .cornerRadius(25)
                .position(x: 650, y: 280)
            }
            
            
            
            
            Group {
                Text("Select Your Nationality : ")
                    .font(.custom("Avenirnext-Regular", size: 20))
                    .position(x: CGFloat(nationalityTextPosX), y: CGFloat(nationalityTextPosY))
                
                if nationalityVisible {
                    Picker(selection: $selectedNation, label: Text("")) {
                        ForEach(0 ..< nations.count) {
                            Text(nations[$0].name)
                                .font(.custom("Avenirnext-Regular", size: 18))
                        }
                    }
                    .onTapGesture { self.nationalityVisible.toggle() }
                    .labelsHidden()
                    .cornerRadius(25)
                    .position(x: 650, y: 430)
                } //if
                
                Button(action: {
                    if self.genderVisible {
                        self.genderVisible.toggle()
                        self.nationalityTextPosY = 360
                        self.nationalityPosY = 360
                    }
                    self.nationalityVisible.toggle()
                }) {
                    Text(nations[selectedNation].name)
                        .font(.custom("Avenirnext-Regular", size: 18))
                }
                .frame(width: 350, height: 45)
                .foregroundColor(self.nationalityVisible ? .red : .black)
                .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                .cornerRadius(25)
                .position(x: CGFloat(nationalityPosX), y: CGFloat(nationalityPosY))
            }
            
            Group {
                Button(action: {
                    if(self.age.isEmpty) {
                        self.errMessage = "Please fill in your age."
                    }
                    else {
                        self.save()
                        if (self.completed == false) {
                            self.completed = true
                        }
                    }
                }) {
                    Text("Submit")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding()
                    .fixedSize()
                    .frame(width: 140, height: 45)
                    .foregroundColor(.white)
                    .background(Color(red: 0/255.0, green: 96/255.0, blue: 100/255.0, opacity: 1.0))
                    .cornerRadius(25)
                    .shadow(color: .gray, radius: 1, x: 0, y: 3)
                }
                .position(x: 540, y: 600)
            }
        }
    }
    
    func save() {
        let db = SurveyDBManager()
        db.addRow(gender: gender[selectedGender], age: self.age, nationality: nations[selectedNation].name)
    }
}

struct SurveyScreen_Previews: PreviewProvider {
    static var previews: some View {
        SurveyScreen()
    }
}


extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON")
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
}
