//
//  SurveyScreen.swift
//  DigitalExhibition
//
//  Created by Admin on 29/4/20.
//  Copyright © 2020 PA2001. All rights reserved.
//

import SwiftUI

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
    //@Environment(\.presentationMode) var presentationMode
    
    @Binding var completed: Bool
    @Binding var login: Bool
    @Binding var goBack: Bool
    
    @State var age = ""
    @State var errMessage = ""
    
    //let nation = NationalityDBManager().retrieveNation()
    @State var selectedNation = 0
    
    let gender = ["Male", "Female", "Other"]
    @State var selectedGender = 0
    
    var body: some View {
        
        VStack {
            HStack {
                Button(action: {
                    if (self.goBack == false) {
                        self.goBack = true
                    }
                }) {
                    Image(systemName: "chevron.left")
                    .padding()
                    .font(.title)
                    .foregroundColor(Color(red: 0/255.0, green: 96/255.0, blue: 100/255.0, opacity: 1.0))
                }
                Spacer()
                Button(action: {
                    if (self.login == false) {
                        self.login = true
                    }
                }) {
                    Image(systemName: "person.circle.fill")
                    .padding()
                    .font(.title)
                }
            }
            Section {
                Text("Please fill in this short survey to view the exhibition:")
                    .font(.title)
                Text(errMessage)
                    .foregroundColor(Color.red)
            }
            Spacer()
            VStack(alignment: .center) {
                Section {
                    HStack {
                        Text("Enter Your Age : ")
                            .font(.headline)
                            .offset(x: 25)
                        TextField("19, 20, 26..", text: self.$age)
                            .padding()
                            .frame(width: 350, height: 50)
                            .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                            .cornerRadius(25)
                            .offset(x: 35)
                    }
                }
                .padding()
                Section {
                    HStack {
                        Spacer()
                        Text("Select Your Gender : ")
                            .font(.headline)
                            .offset(x: 10)
                        Picker(selection: $selectedGender, label: Text("")) {
                            ForEach(0 ..< gender.count) {
                                Text(self.gender[$0])

                            }
                        }
                        .padding()
                        .labelsHidden()
                        .frame(height: 45)
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                        .cornerRadius(25)
                        .offset(x: 15)
                        Spacer()
                    }
                }
                .padding()
                Section {
                    HStack {
                        Spacer()
                        Text("Select Your Nationality : ")
                            .font(.headline)
                        Picker(selection: $selectedNation, label: Text("")) {
                            /*ForEach(0 ..< nation.count) {
                                Text(self.nation[$0])

                            }*/
                            ForEach(0 ..< nations.count) {
                                Text(nations[$0].name)

                            }
                        }
                        .padding()
                        .labelsHidden()
                        .frame(height: 45)
                        .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                        .cornerRadius(25)
                        Spacer()
                    }
                }
                .padding()
            }
            Spacer()
            Section {
                HStack {
                    Button(action: {
                        self.age = ""
                        self.selectedGender = 0
                        self.selectedNation = 0
                    }) {
                        Text("Clear")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding()
                            .fixedSize()
                            .frame(width: 140, height: 45)
                            .foregroundColor(.white)
                            .background(Color(red: 0/255.0, green: 96/255.0, blue: 100/255.0, opacity: 1.0))
                            .cornerRadius(8)
                        
                    }// End Button
                    .padding()
                    Button(action: {
                        if(self.age.isEmpty) {
                            self.errMessage = "Please fill in all the fields."
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
                            .cornerRadius(8)
                        
                    }// End Button
                    .padding()
                }//End HStack
                
                
            }
            Spacer()
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
