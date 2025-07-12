//
//  ContentView.swift
//  CoderSchool working towards congrsional app challenge
//
//  Created by Shriya Patel on 5/24/25.
//

import SwiftUI


enum OnboardingStep: Int, CaseIterable, Identifiable {
    case welcome
    case features
    case statisticfeatures
    case goalfeatures
    case restrictedApps
    case age
    case name
    case username
    case password
    case review
    
    var id:Int { rawValue }
    // add age and passwoard
}

struct AppItem: Identifiable, Hashable {
    var id: String { name }  // Use name as unique ID
    let name: String
    let iconName: String
}
    struct Onboarding {
        
        var restrictedApps = RestrictedApps()
        var age = Age()
        var username = Username()
        var name = Name()
        var password = Password()
        
        
        
        struct RestrictedApps {
            var selectedApps: [AppItem] = []
        }
        
        struct Age {
            var value: Int = 0
        }
        struct Username {
            var name: String = ""
        }
        struct Name {
            var name2: String = ""
        }
        struct Password {
            var password: String = ""
        }
    }
    
struct FeatureScreen: View {
        let onboarding: Onboarding
        
        var body: some View {
            VStack {
                Image("Calender").resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(20)
                Spacer().frame(height: 160)
                Text("Calendar").font(.title).bold()
                Spacer().frame(height: 10)
                Text("Your screen usage monitered constantly and when you reach your screen time goal, STREAKS!!!!").multilineTextAlignment(.center).padding(.horizontal)
            }.frame(height:.infinity)
            
            
        }
    }
struct WelcomeScreen: View {
        let onboarding: Onboarding
        
        var body: some View {
            VStack {
                Spacer().frame(height: 160)
                Text("Welcome!!").font(.title).bold()
                Spacer().frame(height: 10)
                Text("New too the app? Countine through the introductory proccess! ").multilineTextAlignment(.center).padding(.horizontal)
                Spacer().frame(height: 10)
                Text("OR")
                Spacer().frame(height: 10)
                Text("Click the ______ below too log in")
            }.frame(height:.infinity)
            
            
        }
    }
    
struct GoalfeatureScreen: View {
        let onboarding: Onboarding
        
        var body: some View {
            VStack {
                Image("Goal").resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(20)
                Spacer().frame(height: 210)
                Text("Goals").font(.title).bold()
                Spacer().frame(height: 10)
                Text("Have the abilty to create personalized goals to keep yourself motivated").multilineTextAlignment(.center)
            }.frame(height:.infinity)
            
            
        }
    }
struct StatisticfeatureScreen: View {
        let onboarding: Onboarding
        
        var body: some View {
            VStack {
                Image("Chart").resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(20)
                Spacer().frame(height: 210)
                Text("Statistics").font(.title).bold()
                Spacer().frame(height: 10)
                Text("Your screen usage put into perspective").multilineTextAlignment(.center)
            }.frame(height:.infinity)
            
            
        }
    }



    
    
struct ReviewScreen: View {
    let onboarding: Onboarding

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Review Your Information")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)

            Divider().background(.white)

            Group {
                Text("Restricted Apps:")
                    .font(.headline)
                    .foregroundColor(.white)

                Text(Set(onboarding.restrictedApps.selectedApps).map { $0.name }.joined(separator: ", "))
                    .foregroundColor(.white.opacity(0.9))
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)

                Text("Age: \(onboarding.age.value)")
                    .font(.headline)
                    .foregroundColor(.white)

                Text("Username: \(onboarding.username.name)")
                    .font(.headline)
                    .foregroundColor(.white)
            }

            Spacer()
        }
        .padding()
        .background(Color.cyan.ignoresSafeArea())
    }
}
    
    struct RestrictedAppsView: View {
        @Binding var restrictedApps: Onboarding.RestrictedApps
        
        let availableApps: [AppItem] = [
            AppItem(name: "Instagram", iconName: "camera"),
            AppItem(name: "TikTok", iconName: "music.note"),
            AppItem(name: "YouTube", iconName: "play.rectangle"),
            AppItem(name: "Snapchat", iconName: "message"),
            AppItem(name: "Facebook", iconName: "globe")
        ]
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("Select Restricted Apps:").bold()
                    .font(.title)
                Text("Choose what apps you want restrictions to be applied too").font(.body)
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(availableApps) { app in
                            Button(action: {
                                if restrictedApps.selectedApps.contains(app) {
                                       restrictedApps.selectedApps.removeAll { $0 == app }
                                   } else {
                                       restrictedApps.selectedApps.append(app)}
                            }) {
                                HStack {
                                        Image(systemName: app.iconName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.cyan)
                                        
                                        Text(app.name)
                                            .foregroundColor(.white)
                                            .font(.headline)
                                        
                                        Spacer()
                                        
                                        if restrictedApps.selectedApps.contains(app) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.cyan)
                                        }
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(12)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
           
        }
    
struct AgeView: View {
    @Binding var age: Onboarding.Age

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image("Age")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(20)
            Spacer().frame(height: 18)

            Text("Enter Your Age")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)

            TextField("Age", value: $age.value, format: .number).foregroundColor(.cyan)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal)
                .font(.title2)

            Spacer().frame(height: 18)
        }
        .padding()
        .background(Color.cyan.ignoresSafeArea())
    }
}
struct UsernameView: View {
    @Binding var username: Onboarding.Username

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image("User")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(20)
            Spacer().frame(height: 18)

            Text("Enter Your Username")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)

            TextField("Username", text: $username.name).foregroundColor(.cyan)
                .textFieldStyle(.plain)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal)
                .font(.title2)

            Spacer().frame(height: 18)
        }
        .padding()
        .background(Color.cyan.ignoresSafeArea())
    }
}

struct PasswordView: View {
    @Binding var password: Onboarding.Password
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image("User")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(20)
            Spacer().frame(height: 18)
            
            Text("Enter Your Password")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            TextField("Password", text: $password.password).foregroundColor(.cyan)
                .textFieldStyle(.plain)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal)
                .font(.title2)
            
            Spacer().frame(height: 18)
        }
    }
}

struct NameView: View {
    @Binding var name: Onboarding.Name
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image("User")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(20)
            Spacer().frame(height: 18)
            
            Text("Enter Your Name")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            TextField("Name", text: $name.name2).foregroundColor(.cyan)
                .textFieldStyle(.plain)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal)
                .font(.title2)
            
            Spacer().frame(height: 18)
        }
        .padding()
        .background(Color.cyan.ignoresSafeArea())
    }
}
    
    
    
    
    
    struct ContentView: View {
        @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
        @State private var onboarding = Onboarding()
        @State private var currentStepIndex = 0
        
        var steps: [OnboardingStep] {
            OnboardingStep.allCases
        }
        
        var body: some View {
            if hasCompletedOnboarding {
                // Placeholder for your main app
                MainAppView()
            } else {
                onboardingFlow
            }
        }
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
        var onboardingFlow: some View {
            VStack {
                TabView(selection: $currentStepIndex) {
                    ForEach(steps) { step in
                        stepView(for: step)
                            .tag(step.id)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .animation(.easeIn, value: currentStepIndex)
                
                Button {
                    if currentStepIndex < steps.count - 1 {
                        withAnimation {
                            currentStepIndex += 1
                        }
                    } else {
                        hasCompletedOnboarding = true // ✅ Mark onboarding as complete
                    }
                } label: {
                    Text(currentStepIndex == steps.count - 1 ? "Get started" : "Next")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .foregroundStyle(.cyan)
                        .cornerRadius(10)
                }
                .buttonStyle(.borderedProminent)
                .padding([.horizontal, .bottom])
                .tint(.white)
            }
            .foregroundStyle(.white)
            .background(.cyan)
        }
        
        @ViewBuilder
        private func stepView(for step: OnboardingStep) -> some View {
            switch step {
            case .restrictedApps:
                RestrictedAppsView(restrictedApps: $onboarding.restrictedApps)
            case .age:
                AgeView(age: $onboarding.age)
            case .username:
                UsernameView(username: $onboarding.username)
            case .review:
                ReviewScreen(onboarding: onboarding)
            case .features:
                FeatureScreen(onboarding: onboarding)
            case .statisticfeatures:
                StatisticfeatureScreen(onboarding: onboarding)
            case .goalfeatures:
                GoalfeatureScreen(onboarding: onboarding)
            case .name:
                NameView(name: $onboarding.name)
            case .password:
                PasswordView(password: $onboarding.password)
            case .welcome:
                WelcomeScreen(onboarding: onboarding)
            }
        }
    }
    #Preview {
        ContentView()
    }
    

