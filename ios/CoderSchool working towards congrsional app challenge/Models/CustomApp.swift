//
//  CustomApp.swift
//  CoderSchool working towards congrsional app challenge
//
//  Created by Jared Sinai Hernandez Adame on 10/22/25.
//

import Foundation

struct CustomApp: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let appIcon: String
    var isRestricted: Bool = false
}
