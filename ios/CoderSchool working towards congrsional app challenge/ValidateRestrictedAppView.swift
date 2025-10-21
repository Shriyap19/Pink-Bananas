//
//  ValidateRestrictedAppView.swift
//  CoderSchool working towards congrsional app challenge
//
//  Created by Shriya Patel on 10/21/25.
//


import SwiftUI

struct ValidateRestrictedAppView: View {
    @State var hours: Int = 1


    var body: some View {
        VStack() {
            Text("Confirmation:").bold().font(.largeTitle)
            Spacer()
            Text("Did you select the following app for both of the previous screens:").font(.title2).multilineTextAlignment(.center)
            Text("Discord").frame(height: 80)
                .clipped()
                .background(.white.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal, 10)
            
            Spacer()
            
            Text("About how many hours do you spend on this app currently?").font(.title2).multilineTextAlignment(.center)
            Picker("Hours", selection: $hours ) {
                ForEach(1..<25, id: \.self) {
                    number in Text("\(number)")
                }
            }.pickerStyle(.wheel)
                .frame(height: 100)
                .clipped()
                .background(.white.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal, 29)
            Spacer()
            Text("Tip:").font(.callout).multilineTextAlignment(.center)
            Text(" If you have screen time enabled you can find your daily average there").font(.callout).multilineTextAlignment(.center)
            Spacer()
            
            Text("Submit").font(.headline).padding().foregroundStyle(.cyan).background(.white).clipShape(RoundedRectangle(cornerRadius: 10))
            
            
            Spacer()
            
            
            

            
            
        }.foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity).padding()
        .background(Color.cyan.ignoresSafeArea())
        
    }
}


#Preview {
    ValidateRestrictedAppView()
}
