//
//  RestrictedApp.swift
//  CoderSchool working towards congrsional app challenge
//
//  Created by Jared Sinai Hernandez Adame on 10/22/25.
//

import Foundation
import ManagedSettings
import DeviceActivity
import FamilyControls

struct RestrictedApp: Identifiable, Codable, Hashable{
    var name: String
    var customApp : CustomApp
    var tokens: Set<ApplicationToken>?
    var threshold: Int
    var id: String {name}
//    let schedule: DeviceActivitySchedule
//    let activityName: DeviceActivityName
    //let completed: Bool
    //let streak: Int
}

