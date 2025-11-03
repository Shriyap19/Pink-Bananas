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
    var goalItem: GoalItem?
    var todayFullfilled: Bool = true
    var currentStreak:Int = 0
    var daysCompleted:Int = 0
    var category: String
    var timeSaved: [Day] = []
    //let completed: Bool
    //let streak: Int
}

struct Day: Identifiable, Codable, Hashable{
    var date: Date = Date() // Current Day
    var time: Int // Time Saved
    var id: Date {date}
}
