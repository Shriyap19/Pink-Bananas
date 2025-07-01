//
//  ContentView.swift
//  CoderSchool working towards congrsional app challenge
//
//  Created by Shriya Patel on 5/24/25.
//

import SwiftUI

enum OnboardingStep: Int, CaseIterable, Identifiable {
    case features
    case graduation
    case income
    case username
    case review
    
    var id:Int { rawValue }
}

struct Onboarding {
    
    var graduation = Graduation()
    var income = Income()
    var username = Username()
    
    
    struct Graduation {
        var graduated: Bool = false
    }
    
    struct Income {
        var total: Double = 0.0
    }
    struct Username {
        var name: String = ""
    }
}

struct FeatureScreen: View {
    let onboarding: Onboarding
    
    var body: some View {
        VStack {
            Image("Calender").resizable().frame(width: 290, height: 290)
            Spacer().frame(height: 210)
            Text("Calendar").font(.title).bold()
            Spacer().frame(height: 10)
            Text("Your screen usage monitered constantly and when you reach your screen time goal, STREAKS!!!!").multilineTextAlignment(.center)
        }.frame(height:.infinity)
          
            
    }
}



struct ReviewScreen: View {
    let onboarding: Onboarding
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Review Your information").font(.title2).bold()
            
            
            
            Divider()
            
            Group {
                Text("Graduated: \(onboarding.graduation.graduated ? "Yes" : "No")")
                Text("Income: \(String(format: "$%.2f", onboarding.income.total))")
                Text("Username: \(onboarding.username.name)")
            }.font(.headline)
            
            Spacer()
        }
        .padding()
    }
}

struct GraduationView: View {
    @Binding var graduation: Onboarding.Graduation
    
    var body: some View {
        Toggle("Graduated?", isOn: $graduation.graduated).padding()
    }
}

struct IncomeView: View {
    @Binding var income: Onboarding.Income
    
    var body: some View {
        VStack {
            Text("Enter your total income:")
            TextField("Income", value: $income.total, format: .number).keyboardType(.decimalPad).padding()
        }
    }
}

struct UsernameView: View {
    @Binding var username: Onboarding.Username
    
    var body: some View {
        VStack {
            Text("Enter your username:")
            TextField("Username", text: $username.name).textFieldStyle(.roundedBorder).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/).padding()
        }
    }
}

struct ContentView: View {
    @State private var onboarding = Onboarding()
    @State private var currentStepIndex = 0
    
    var steps: [OnboardingStep] {
        OnboardingStep.allCases
    }
    
    var body: some View {
        VStack {
            TabView(selection: $currentStepIndex) {
                ForEach(steps) { step in
                    stepView(for: step)
                        .tag(step.id)
                    
                    
                }
            }.tabViewStyle(.page(indexDisplayMode: .always ))
            
            
            Button {
                if currentStepIndex < steps.count - 1 {
                    withAnimation {
                        currentStepIndex += 1
                    }
                    
                }
            }  label: {
                Text(currentStepIndex == steps.count - 1 ? "Get started": "Next").foregroundStyle(.blue)
            }.buttonStyle(.borderedProminent).padding([.horizontal, .bottom]).tint(.white)
        }
        .foregroundStyle(.white)
        .background(.blue)
    }
    @ViewBuilder
    private func stepView(for step: OnboardingStep ) -> some View {
        switch step {
        case .graduation:
            GraduationView(graduation: $onboarding.graduation)
        case .income:
            IncomeView(income: $onboarding.income)
        case .username:
            UsernameView(username: $onboarding.username)
        case .review:
            ReviewScreen(onboarding: onboarding)
        case .features:
            FeatureScreen(onboarding: onboarding)
            
        }
    }
}

#Preview {
    ContentView()
}
