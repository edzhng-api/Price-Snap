//
//  ContentView.swift
//  Prize Snap
//
//  Created by Edison Zheng (student LM) on 2/25/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            HomeView()
                .tabItem {
                    Image(systemName: "cart")
                    Text("Cart")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            
        }
    }
}

#Preview {
    ContentView()
}
