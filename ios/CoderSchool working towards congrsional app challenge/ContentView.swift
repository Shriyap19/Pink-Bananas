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
    case birthday
    case name
    case email
    case username
    case firstsurvey
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
        var birthday = Birthday()
        var username = Username()
        var name = Name()
        var password = Password()
        var email = Email()
        var firstsurvey = FirstSurvey()
        
        
        
        struct RestrictedApps {
            var selectedApps: [AppItem] = []
        }
        
        struct Birthday {
            var value = Date()
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
        struct Email {
            var email: String = ""
        }
        struct FirstSurvey {
            var firstsurveyanswers: [String: String] = [:]
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

struct EmailView: View {
    @Binding var email: Onboarding.Email
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "envelope.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(20)
            
            Spacer().frame(height: 18)
            
            Text("Enter Your Email")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            TextField("Email", text: $email.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .foregroundColor(.cyan)
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
struct WelcomeScreen: View {
    let onboarding: Onboarding
    @Binding var isLoggingIn: Bool

    var body: some View {
            VStack(spacing: 29) {
                Spacer().frame(height: 160)

                Text("Welcome!!")
                    .font(.title).bold()
                    .foregroundColor(.white)

                Text("New to the app? Continue through the intro, or if you already have an account, log in here.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal)

                Button(action: {
                    isLoggingIn = true
                }) {
                    Text("Log in")
                        .font(.headline)
                        .frame(maxWidth: .infinity, maxHeight: 55)
                        .background(Color.white)
                        .foregroundColor(.cyan)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(10)


                
                Spacer()
            }
            .background(Color.cyan.ignoresSafeArea())
        
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
    @State private var showPassword = false
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
                
                Text("Birthday: \(onboarding.birthday.value, style: .date)")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("Name: \(onboarding.name.name2)").font(.headline)
                    .foregroundColor(.white)
                
                Text("Username: \(onboarding.username.name)")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("Email: \(onboarding.email.email)")
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack {
                    Text("Password: ")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(showPassword ? onboarding.password.password : String(repeating: "•", count: onboarding.password.password.count))
                        .foregroundColor(.white.opacity(0.9))
                    
                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                ScrollView {
                    Text("Survey Answers:").font(.headline)
                        .foregroundColor(.white)
                    if !onboarding.firstsurvey.firstsurveyanswers.isEmpty {
                                   Divider().background(.white)
                                   
                                   
                                   VStack(alignment: .leading, spacing: 12) {
                                       ForEach(onboarding.firstsurvey.firstsurveyanswers.sorted(by: { $0.key < $1.key }), id: \.key) { question, answer in
                                           VStack(alignment: .leading, spacing: 4) {
                                               Text(question)
                                                   .font(.subheadline)
                                                   .foregroundColor(.white.opacity(0.7))
                                               Text(answer)
                                                   .font(.body)
                                                   .foregroundColor(.white)
                                                   .padding(6)
                                                   .background(Color.white.opacity(0.2))
                                                   .cornerRadius(8)
                                           }
                                       }
                                   }
                               }
                }
               
                
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
    
struct BirthdayView: View {
    @Binding var birthday: Onboarding.Birthday

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image("Age")
                .resizable()
                .scaledToFit()
                .frame(width: 220, height: 160)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(20)
            Text("Disclaimer: you will not be able to edit your birthday later, BE HONEST").multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)

            Text("Enter Your Birthday")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            DatePicker("", selection: $birthday.value, in:...Date(), displayedComponents: .date).labelsHidden().datePickerStyle(.compact) // has to be this cause apparently wheel is decrpicated
                .foregroundColor(.cyan)
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
    @State private var showPassword = false
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
            
            if showPassword {
                TextField("Password", text: $password.password).foregroundColor(.cyan)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .font(.title2)
            } else {
                SecureField("Password", text: $password.password).foregroundColor(.cyan)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .font(.title2)
            }

            Button(action: {
                showPassword.toggle()
            }) {
                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(.white.opacity(0.7))
            }
            
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

struct FirstSurveyView: View {
    @Binding var firstsurvey: Onboarding.FirstSurvey
    
    let questions: [String: [String]] = [
        "What do you hope to accomplish by reducing screen time?": ["Learn a new skill", "Get Outside", "Exercise", "Study", "Socialize", "Just Stay Off the Phone", "Other"],
        "How much time do you want to put at first into accomplishing the above goal?": ["Just a bit(10-20 minutes)", "Good amount(30-60 minutes)", "Alot(70-90 minutes)", "a Ton of Time(100+ minutes)" ],
        "How frequently would you like to complete the above goals": ["Once every 3 weeks","Once every 2 weeks","Once a Week","Twice a week","Three times a week", "Four times a week", "Five times a week", "Six times a week", "Every day"]
    ]
    
    let columns = [GridItem(.adaptive(minimum: 120), spacing: 10)]
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Survey")
                .font(.title)
                .bold()
                .foregroundColor(.white)
            Text("Please choose ONE answer per question").multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal).foregroundColor(.white)

            
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(Array(questions.keys), id: \.self) { question in
                        VStack(alignment: .leading, spacing: 12) {
                            Text(question)
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(questions[question]!, id: \.self) { answer in
                                    Button(action: {
                                        firstsurvey.firstsurveyanswers[question] = answer
                                    }) {
                                        Text(answer)
                                            .font(.subheadline)
                                            .multilineTextAlignment(.center)
                                            .padding(8)
                                            .frame(maxWidth: .infinity)
                                            .background(
                                                firstsurvey.firstsurveyanswers[question] == answer
                                                ? Color.cyan
                                                : Color.white.opacity(0.2)
                                            )
                                            .foregroundColor(.white)
                                            .cornerRadius(12)
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
        }
        .padding()
        .background(Color.cyan.ignoresSafeArea())
    }
}

    
    
    
    
    struct ContentView: View {
        @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
        @State private var onboarding = Onboarding()
        @State private var currentStepIndex = 0
        @State private var isLoggingIn = false
        @State private var isLoggedIn = false
        

        
        var steps: [OnboardingStep] {
            OnboardingStep.allCases
        }
        
        var body: some View {
            if hasCompletedOnboarding {
                // Placeholder for your main app
                MainAppView()
            } else if isLoggingIn{
                LoginView(isLoggingIn: $isLoggingIn, isLoggedIn: $isLoggedIn)
            }else if isLoggedIn{
                MainAppView()
            } else {
                onboardingFlow
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
            case .birthday:
                BirthdayView(birthday: $onboarding.birthday)
            case .username:
                UsernameView(username: $onboarding.username)
            case .email:
                EmailView (email: $onboarding.email)
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
                WelcomeScreen(onboarding: onboarding, isLoggingIn: $isLoggingIn)
            case .firstsurvey:
                FirstSurveyView(firstsurvey: $onboarding.firstsurvey)
            }
        }
    }
    #Preview {
        ContentView()
    }
    

