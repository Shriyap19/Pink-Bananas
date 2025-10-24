//
//  UserModel.swift
//  CoderSchool working towards congrsional app challenge
//
//  Created by Shriya Patel on 9/30/25.
//

import Foundation
struct User: Codable {
    let selectedApps: [AppItem]
    let username: String
    let name: String
    let password: String
    let email: String
    let firstsurveyanswers: [String: String]
}
