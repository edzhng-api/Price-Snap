//
//  SettingsView.swift
//  Prize Snap
//
//  Created by Filip Cyran (student LM) on 3/2/25.
//

    


import SwiftUI
import FirebaseAuth
import UserNotifications

struct SettingsView: View {
    @EnvironmentObject var user: User
    @Binding var permissionGranted: Bool
    @State private var errorMessage: String? = nil
    @State private var showAlert = false
    @State private var showDeleteAlert = false
    @State private var isDeleting = false
    @State private var isNotificationsExpanded = false
    @State private var isNotificationsEnabled: Bool
    
    init(permissionGranted: Binding<Bool>) {
        _permissionGranted = permissionGranted
        let savedPreference = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        _isNotificationsEnabled = State(initialValue: savedPreference)
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Account Settings")) {
                    Text(user.username)
                        .font(Constants.textFont)
                        .shadow(radius: 2)

                    Button(action: {
                        Task {
                            await signOut()
                        }
                    }) {
                        Text("Sign Out")
                            .foregroundColor(.red)
                            .font(Constants.textFont)
                            .shadow(radius: 2)
                    }

                    Button(action: {
                        showDeleteAlert = true
                    }) {
                        Text("Delete Account")
                            .foregroundColor(.red)
                            .font(Constants.textFont)
                            .shadow(radius: 2)
                    }
                }

                Section(header: Text("App Settings")) {
                    Button(action: {
                        withAnimation {
                            isNotificationsExpanded.toggle()
                        }
                    }) {
                        HStack {
                            Text("Notifications")
                                .font(Constants.textFont)
                                .shadow(radius: 2)
                            Spacer()
                            Image(systemName: isNotificationsExpanded ? "chevron.down" : "chevron.right")
                        }
                    }
                    if isNotificationsExpanded {
                        VStack(alignment: .leading) {
                            Toggle(isOn: $isNotificationsEnabled) {
                                Text("Enable Notifications")
                                    .font(Constants.textFont)
                                    .shadow(radius: 2)
                                    .foregroundColor(.primary)
                            }
                            .onChange(of: isNotificationsEnabled) { newValue in
                                UserDefaults.standard.set(newValue, forKey: "notificationsEnabled")
                                
                                if newValue {
                                    requestNotificationPermissions()
                                } else {
                                    cancelNotification()
                                }
                            }

                            Button(action: {
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                            }) {
                                Text("Notification Settings")
                                    .font(Constants.textFont)
                                    .shadow(radius: 2)
                            }
                        }
                        .padding(.top, 5)
                    }

                    Button(action: {
                        // About action
                    }) {
                        Text("About")
                            .font(Constants.textFont)
                            .shadow(radius: 2)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Settings")
        }
    }

    func signOut() async {
        do {
            try await Auth.auth().signOut()
            user.isUserAuth = false
            user.email = ""
            errorMessage = nil
            
        } catch let signOutError as NSError {
            errorMessage = "Error signing out: \(signOutError.localizedDescription)"
            showAlert = true
        }
    }

    func deleteAccount() async {
        guard let currentUser = Auth.auth().currentUser else {
            errorMessage = "No user is currently logged in."
            showAlert = true
            return
        }

        isDeleting = true
        do {
            try await currentUser.delete()
            user.isUserAuth = false
            user.email = ""
            errorMessage = "Account deleted successfully."
            showAlert = true
        } catch let deleteError as NSError {
            errorMessage = "Error deleting account: \(deleteError.localizedDescription)"
            showAlert = true
        }
        isDeleting = false
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

    private func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

#Preview {
    SettingsView(permissionGranted: .constant(false))
        .environmentObject(User())
}



