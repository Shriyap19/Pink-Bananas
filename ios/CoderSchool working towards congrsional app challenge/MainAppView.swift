//
//  MainAppView.swift
//  CoderSchool working towards congrsional app challenge
//
//  Created by Shriya Patel on 8/12/25.
//

import SwiftUI

struct MainAppView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    
    
    var body: some View {
        VStack {
            Text("Welcome to the Main App!")
                .font(.largeTitle)
                .foregroundColor(.cyan)
                .padding()
            
            Button("Reset Onboarding") {
                hasCompletedOnboarding = false
            }
            .font(.headline)
            .padding()
            .background(Color.white)
            .foregroundColor(.cyan)
            .cornerRadius(10)
        }
    }
}

#Preview {
    MainAppView()
}
