//
//  LoginView.swift
//  CoderSchool working towards congrsional app challenge
//
//  Created by Shriya Patel on 7/23/25.
//

import SwiftUI

struct LoginView: View {
    @Binding var isLoggingIn: Bool
    @Binding var isLoggedIn: Bool
    @Environment(\.dismiss) var dismiss
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    @State private var username = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var loginError = ""       // Stores error message// controls naigation
    @State private var showLogin = false //Visabilty of login form

    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            
            Button(action: {
                isLoggingIn = false
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .font(.title2).multilineTextAlignment(.leading).padding(10)
                    .contentShape(Rectangle())
            }
            
            Text("Log In").font(.largeTitle).multilineTextAlignment(.center).foregroundColor(.white)
            
            Spacer().frame(height: 81)
            Text("Welcome Back!! Please fill in your Username and Password to Sign into your account.").multilineTextAlignment(.center).foregroundColor(.white)
            TextField("Username", text: $username)
                .padding().background(Color(.systemGray6)).cornerRadius(8)
            
            HStack {
                Group {
                    if showPassword {
                        TextField("Password", text: $password)
                    } else {
                        SecureField("Password", text: $password)
                    }
                }
                Button {
                    showPassword.toggle()//anything in here iswhat the button does toggle switched form false and true
                } label: {
                    Image(systemName: showPassword ? "eye.slash" : "eye")//what the button looks like format for switching between button faces is condition ? valueIfTrue : valueIfFalse
                        .foregroundColor(.cyan.opacity(0.7))
                }
                .padding(.trailing, 8)
            }
            .padding().background(Color(.systemGray6)).cornerRadius(8)
            
            Spacer()
            
            Button("Sign In") {
                if username == "User" && password == "Pass" {
                    loginError = ""
                    hasCompletedOnboarding = true
                    isLoggedIn = true
                } else {
                    loginError = "Username or password is incorrect."
                }
                
                //dismiss()
                // Or set @AppStorage flag to show MainAppView
                
            }
            
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background((username.isEmpty || password.isEmpty) ? Color.white.opacity(0.5) : Color.white) //makes it so the button is gray when unavaliable same format:condition ? valueIfTrue : valueIfFalse
            .foregroundColor(.cyan)
            .cornerRadius(10)
            .disabled(username.isEmpty || password.isEmpty) //disalbes button if usernamr or pasword is empty
            .padding(.horizontal)
            
            
            if !loginError.isEmpty {
                Text(loginError)
                    .foregroundColor(.red)
                
                
            }
            
        
            
    }
            
            .padding()
            .background(Color.cyan.ignoresSafeArea())
        }
    
}


#Preview {
    LoginView(isLoggingIn: .constant(true), isLoggedIn: .constant(false))
}
