//
//  NavigationTabs.swift
//  CoderSchool working towards congrsional app challenge
//
//  Created by Shriya Patel on 5/28/25.
//

import SwiftUI

struct NavigationTabs: View {
    var body: some View {
        NavigationView {
            TabView {
                Image(systemName: "house").tabItem { Image(systemName: "house")
                    Text("Home")
                    
                }
                
                NavigationStack {
                    
                        GoalsPageView()
                    
                }
                .tabItem {
                    Image(systemName: "star")
                    Text("Goals")
                }
                
                Image(systemName: "chart.pie").tabItem { Image(systemName: "chart.pie")
                    Text("Statistics")
                }
                Image(systemName: "checkmark.circle.fill").tabItem { Image(systemName: "checkmark.circle.fill")
                    Text("Recommendation")
                }
                Image(systemName: "gear").tabItem { Image(systemName: "gear")
                    Text("More")
                }
                
                
                
                
                
                
            }
        }
    }
}

#Preview {
    NavigationTabs()
}
