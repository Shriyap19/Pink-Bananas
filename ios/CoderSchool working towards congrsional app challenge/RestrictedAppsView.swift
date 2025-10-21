//
//  RestrictedAppsView.swift
//  CoderSchool working towards congrsional app challenge
//
//  Created by Jared Sinai Hernandez Adame on 10/21/25.
//

import SwiftUI
import FamilyControls

struct RestrictedAppsView: View {
    @StateObject var familyManager:ScreenTimeManager = ScreenTimeManager.shared  // controls familyPicker
    @State var showFamilyPicker: Bool = false // controls is family picer, restoricted apps popus shows or not
    

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
            NavigationLink(value:NavigationDestinations.SearchView){
                ZStack{
                    Text("Continue").font(.headline)
                        .padding()
                        .foregroundStyle(.cyan)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            Spacer()
        }
        .frame(maxWidth:.infinity,maxHeight:.infinity)
        .sheet(isPresented: $showFamilyPicker) { //shows the pop up
            FamilyActivityPicker(selection: $familyManager.selection) // apple privde the pop up display and the selection thin js tracks the change when u select
                .presentationDetents([.medium, .large]) //adjust size
                .onDisappear { // called when thing is closed
                    // Save selection whenever picker closes
                    familyManager.saveSelection()
                    // Update your onboarding restricted apps if needed
//                    restrictedApps.selectedApps = familyManager.selection.applications.map {
//                        AppItem(name: $0.bundleIdentifier ?? "Unknown", iconName: $0.bundleIdentifier ?? "")
//                    }
//                    print("Picker dismissed. Restricted apps:", restrictedApps.selectedApps)
                }
        }
        .onChange(of: familyManager.selection) {  // runs everytime the actuall varible saving the thing everytime the selection var changes
            familyManager.saveSelection()
        }

        .background(Color.cyan.ignoresSafeArea())
    }
}

//#Preview {
//    RestrictedAppsView()
//}
