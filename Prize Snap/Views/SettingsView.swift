//
//  SettingsView.swift
//  Prize Snap
//
//  Created by Filip Cyran (student LM) on 3/2/25.
//
import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @EnvironmentObject var user: User
    @State private var errorMessage: String? = nil
    @State private var showAlert = false
    @State private var showDeleteAlert = false
    @State private var isDeleting = false

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
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Error"),
                            message: Text(errorMessage ?? "Unknown error"),
                            dismissButton: .default(Text("OK"))
                        )
                    }

                    Button(action: {
                        showDeleteAlert = true
                    }) {
                        Text("Delete Account")
                            .foregroundColor(.red)
                            .font(Constants.textFont)
                            .shadow(radius: 2)
                    }
                    .alert(isPresented: $showDeleteAlert) {
                        Alert(
                            title: Text("Are you sure you want to delete the account?"),
                            primaryButton: .destructive(Text("OK"), action: {
                                Task {
                                    await deleteAccount()
                                }
                            }),
                            secondaryButton: .cancel()
                        )
                    }
                }

                Section(header: Text("App Settings")) {
                    Button(action: {
                        
                    }) {
                        Text("Notifications")
                            .font(Constants.textFont)
                            .shadow(radius: 2)
                    }
                    Button(action: {
                        
                    }) {
                        Text("Privacy")
                            .font(Constants.textFont)
                            .shadow(radius: 2)
                    }
                    Button(action: {
                        
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
}

#Preview {
    SettingsView()
        .environmentObject(User())
}

