//
//  ValidateRestrictedAppView.swift
//  CoderSchool working towards congrsional app challenge
//
//  Created by Shriya Patel on 10/21/25.
//


import SwiftUI
import FamilyControls

struct ValidateRestrictedAppView: View {
    @State var hours: Int = 1
    @Binding var path: NavigationPath
    @State var appName: String = ""
    @Binding var restrictedApp: RestrictedApp
    @Binding var selection: FamilyActivitySelection
    @ObservedObject var manager = ScreenTimeManager.shared
    @State private var selectedCategory: String = "Social"
    let categories = ["Gaming", "Entertainment", "Other", "Social"]

    var body: some View {
        VStack() {
            Text("Confirmation:").bold().font(.largeTitle)
            Spacer()
            Text("Please fully type the name of the app you selected in the previous screens:").font(.title2).multilineTextAlignment(.center)
            TextField("ex: Youtube",text: $appName)
                .padding(16)
                .overlay(
                    RoundedRectangle(cornerRadius:10).stroke(Color.gray.opacity(0.6), lineWidth:1)
                )
            
            Spacer()
            
            Text("About how many hours do you spend on this app currently?").font(.title2).multilineTextAlignment(.center)
            Picker("Hours", selection: $hours ) {
                ForEach(1..<25, id: \.self) {
                    number in Text("\(number)")
                }
            }.pickerStyle(.wheel)
                .frame(height: 100)
                .clipped()
                .background(.white.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal, 29)
            Spacer()
            Text("Tip:").font(.callout).multilineTextAlignment(.center)
            Text(" If you have screen time enabled you can find your daily average there").font(.callout).multilineTextAlignment(.center)
            Spacer()
            
            Text("What category would you put this into of the following?").font(.title2).multilineTextAlignment(.center)
            Menu {
                            ForEach(categories, id: \.self) { category in
                                Button(category) {
                                    selectedCategory = category
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedCategory)
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .padding()
                            .background(.white.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(.horizontal, 29)
                        }
            
            
            
Button(action:{
                restrictedApp.name = appName
                restrictedApp.threshold = hours
                restrictedApp.tokens = selection.applicationTokens
                manager.restrictedApps.append(restrictedApp)
                restrictedApp = RestrictedApp(name: "",customApp:CustomApp(id: "", name: "", appIcon: ""),threshold: 0)
                path.removeLast(path.count)
            }){
                Text("Submit").font(.headline).padding().foregroundStyle(.cyan).background(.white).clipShape(RoundedRectangle(cornerRadius: 10))
            }            
            
            Spacer()

        }.foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity).padding()
        .background(Color.cyan.ignoresSafeArea())
        
    }
}


//#Preview {
//    ValidateRestrictedAppView(path:.constant(NavigationPath()), restrictedApp:.constant(RestrictedApp(name: "", threshold: 0)))
//}
