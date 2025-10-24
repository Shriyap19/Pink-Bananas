//
//  RestrictedAppsView.swift
//  CoderSchool working towards congrsional app challenge
//
//  Created by Jared Sinai Hernandez Adame on 10/21/25.
//

import SwiftUI
import FamilyControls

struct RestrictedAppsView: View {
    @ObservedObject var familyManager:ScreenTimeManager = ScreenTimeManager.shared  // controls familyPicker
    @State var showFamilyPicker: Bool = false // controls is family picer, restoricted apps popus shows or not
    @State var continueDisabled: Bool = true
    @Binding var restrictedApp: RestrictedApp
    @Binding var selection: FamilyActivitySelection

    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            Spacer()
            Text("Select a Restricted App:")
                .bold()
                .font(.title)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text("Choose what app you want restrictions to be applied to")
                .font(.body)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // Button to open FamilyActivityPicker
            Button(action: {
                
                if !familyManager.isAuthorized {
                    
                    Task{
//                        familyManager.loadSelection(restrictedapp: restrictedApp)
                        await familyManager.requestAuthorization()
                    }
                }
                showFamilyPicker = true
            }) {
                HStack {
                    Image(systemName: "square.stack")
                    Text("Choose from device")
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 24)
                .background(Color.white)
                .foregroundColor(.cyan)
                .cornerRadius(12)
            }

            Spacer()
            
            if continueDisabled == true{
                Text("Only select one app to continue!")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            NavigationLink(value:NavigationDestinations.SearchView){
                ZStack{
                    Text("Continue").font(.headline)
                        .padding()
                        .foregroundStyle(.cyan)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }.disabled(continueDisabled)
            Spacer()
        }
        .frame(maxWidth:.infinity,maxHeight:.infinity)
        .sheet(isPresented: $showFamilyPicker) { //shows the pop up
            FamilyActivityPicker(selection: $selection)// apple privde the pop up display and the selection thin js tracks the change when u select
                .presentationDetents([.medium, .large]) //adjust size
                .onDisappear { // called when thing is closed
                    // Save selection whenever picker closes
//                    if selection.applications.count <= 1 {
//                        familyManager.saveSelection(restrictedapp:restrictedApp)
//                    }
                    if(selection.applications.count == 1){
                        continueDisabled = false
                    }else{
                        continueDisabled = true
                    }
                    
                   
                }
        }
        .onChange(of: familyManager.selection) {  // runs everytime the actuall varible saving the thing everytime the selection var changes
            if selection.applications.count > 0 {
                showFamilyPicker = false
            }
//            if selection.applications.count <= 1 {
//                familyManager.saveSelection(restrictedapp: restrictedApp)
//            }
            
            
        }

        .background(Color.cyan.ignoresSafeArea())
    }
}

//#Preview {
//    RestrictedAppsView()
//}
