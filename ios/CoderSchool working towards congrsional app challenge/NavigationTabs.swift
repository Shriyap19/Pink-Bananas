//
//  NavigationTabs.swift
//  CoderSchool working towards congrsional app challenge
//
//  Created by Shriya Patel on 5/28/25.
//

import SwiftUI

struct NavigationTabs: View {
    var body: some View {

        TabView {
            MainAppView().tabItem { Image(systemName: "house")
                Text("Home")
        }
            Image(systemName: "star").tabItem { Image(systemName: "star")
                Text("Goals")
        }
            StatsView().tabItem { Image(systemName: "chart.pie")
                Text("Statistics")
        }
            Image(systemName: "checkmark.circle.fill").tabItem { Image(systemName: "checkmark.circle.fill")
                Text("Recommendation")
        }
            Image(systemName: "gear").tabItem { Image(systemName: "gear")
                Text("Settings")
        }


        }
    }
}

#Preview {
    NavigationTabs()
}
