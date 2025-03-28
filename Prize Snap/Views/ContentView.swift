//
//  ContentView.swift
//  Prize Snap
//
//  Created by Edison Zheng (student LM) on 2/25/25.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var permissionGranted = false
    @State var products: [Product] = []
    @State var store: Store
    @State var likedProductIds: [UUID] = []
    
    var body: some View {
        TabView {
            HomeView(products: $products, store: $store)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            ShoppingListView(products: products, likedProductIds: likedProductIds)
                .tabItem {
                    Image(systemName: "cart")
                    Text("Cart")
                }
            ProductSearch()
                .tabItem {
                    Image(systemName: "safari")
                    Text("Search")
                }
            SettingsView(permissionGranted: $permissionGranted)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .onAppear {
            checkNotificationPermissions()
        }
        .onChange(of: permissionGranted) { _ in
            if permissionGranted {
                scheduleNotification()
            } else {
                cancelNotification()
            }
        }
    }
    
    private func checkNotificationPermissions() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                permissionGranted = true
            } else {
                permissionGranted = false
            }
        }
    }

    private func scheduleNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Reminder"
        notificationContent.body = "This is a reminder!"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: true)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            }
        }
    }
    
    private func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

#Preview {
    ContentView(
        products: [Product](),
        store: Store(name: "GiantData", products: [])
    )
    .environmentObject(User())
}
