//
//  CoderSchool_working_towards_congrsional_app_challengeApp.swift
//  CoderSchool working towards congrsional app challenge
//
//  Created by Shriya Patel on 5/24/25.
//

import SwiftUI
import ManagedSettings
import DeviceActivity
import FamilyControls

@main

struct CoderSchool_working_towards_congrsional_app_challengeApp: App {
    @StateObject private var familyManager = FamilyControlsManager() //so varible is for app, not just onboarding
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(familyManager) //  makes it global
        }
    }
}
