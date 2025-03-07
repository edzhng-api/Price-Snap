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
            
        }.onAppear {
            checkNotificationPermissions()
        }
        .onChange(of: permissionGranted) { _ in
            if permissionGranted {
                scheduleNotification()
            }
        }
    }
    
    private func checkNotificationPermissions() {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                if settings.authorizationStatus == .authorized {
                    permissionGranted = true
                } else {
                    requestNotificationPermissions()
                }
            }
        }

    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                permissionGranted = true
            } else {
                print("Notification permission denied: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    private func scheduleNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Reminder"
        notificationContent.body = "This is a reminder!"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            }
        }
    }

}

#Preview {
    ContentView()
        .environmentObject(User())
}
