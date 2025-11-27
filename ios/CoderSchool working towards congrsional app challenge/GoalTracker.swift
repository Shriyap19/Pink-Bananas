//
//  GoalTracker.swift
//  CoderSchool working towards congrsional app challenge
//
//  Created by Shriya Patel on 10/21/25.
//

import Foundation

final class GoalTracker: ObservableObject {
    @Published var streakDays: [Date: Bool] = [:]

    private let calendar = Calendar.current

    func markGoalCompleted(on date: Date = Date()) {
        let normalized = calendar.startOfDay(for: date)
        streakDays[normalized] = true
    }

    func isCompleted(on date: Date) -> Bool {
        streakDays[calendar.startOfDay(for: date)] == true
    }

    func resetAll() {
        streakDays.removeAll()
    }
}
