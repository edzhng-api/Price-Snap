//
//  ContentView.swift
//  Prize Snap
//
//  Created by Edison Zheng (student LM) on 2/25/25.
//

import SwiftUI
import UserNotifications
import FirebaseFirestore
import FirebaseAuth
import Foundation // Needed for UUID

// The main container view that sets up the TabView and manages shared data
struct ContentView: View {
    // State variable to track if notification permission is granted
    @State private var permissionGranted = false
    // State variables to hold product and store data, initialized empty
    @State var products: [Product] = []
    @State var store: Store = Store(name: "Initial Store", products: []) // Initialize with a default Store
    // AppStorage for local persistence of liked product IDs (comma-separated string)
    @AppStorage("likedProductIdsString") private var likedProductIdsString: String = ""
    // State variable derived from AppStorage, used within the view hierarchy
    @State private var likedProductIds: [String] = []

    // The main layout using a TabView
    var body: some View {
        TabView {
            // Home Tab: Displays product data and handles liked products
            HomeView(products: $products, store: $store, likedProductIds: $likedProductIds) // Pass data as bindings
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            // Shopping List Tab
            ShoppingListView() // Assumed to manage its own data or use environment objects
                .tabItem {
                    Image(systemName: "cart")
                    Text("Cart")
                }

            // Recipes Tab
            RecipesView() // Assumed to manage its own data
                .tabItem {
                    Image(systemName: "book")
                    Text("Recipes")
                }

            // Product Search Tab
            ProductSearch() // This view might also need product data
                .tabItem {
                    Image(systemName: "safari")
                    Text("Search")
                }

            // Settings Tab: Manages user settings and notification permissions
            SettingsView(permissionGranted: $permissionGranted) // Pass permission status as a binding
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        // Action performed when the view appears
        .onAppear {
            // Load liked products from Firebase and check notification status on app launch
            loadLikedProducts()
            checkNotificationPermissions()
        }
        // Observe changes to the local liked product IDs state
        .onChange(of: likedProductIds) { oldValue, newValue in
            // Save the updated list to Firebase and AppStorage
            saveLikedProducts()
            likedProductIdsString = newValue.joined(separator: ",") // Save to AppStorage
        }
        // Observe changes to the AppStorage string
        .onChange(of: likedProductIdsString) { oldValue, newValue in
            // Update the local state if AppStorage changes externally (e.g., on launch)
            let loadedIds = newValue.components(separatedBy: ",").filter { !$0.isEmpty }
            if loadedIds != self.likedProductIds {
                self.likedProductIds = loadedIds
            }
        }
        // Observe changes to the notification permission status
        .onChange(of: permissionGranted) { oldValue, newValue in
            if newValue { // If permission is granted
                scheduleNotification() // Schedule the daily reminder
            } else { // If permission is denied or revoked
                cancelNotification() // Cancel any pending notifications
            }
        }
    }

    // Function to check the current notification authorization status
    func checkNotificationPermissions() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            // Update the state variable on the main thread
            DispatchQueue.main.async {
                permissionGranted = settings.authorizationStatus == .authorized
            }
        }
    }

    // Schedule a daily reminder notification
    func scheduleNotification() {
        cancelNotification() // Remove any existing notifications first

        let content = UNMutableNotificationContent()
        content.title = "Prize Snap Reminder"
        content.body = "Don't miss out on the latest deals! Check your liked products."
        content.sound = UNNotificationSound.default

        // Configure the trigger for 10 AM every day
        var dateComponents = DateComponents()
        dateComponents.hour = 10 // 10 AM
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyPrizeSnapReminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for 10 AM daily.")
            }
        }
    }

    // Cancel all pending notifications
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("All pending notifications cancelled.")
    }

    // Load liked products from Firestore for the current user
    func loadLikedProducts() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("loadLikedProducts: User not logged in. Using AppStorage.")
            // If user is not logged in, load from AppStorage
            self.likedProductIds = likedProductIdsString.components(separatedBy: ",").filter { !$0.isEmpty }
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists {
                // Safely cast the data to [String]
                if let liked = document.data()?["likedProducts"] as? [String] {
                    DispatchQueue.main.async {
                        self.likedProductIds = liked
                        // Sync AppStorage with Firestore data on load
                        self.likedProductIdsString = liked.joined(separator: ",")
                        print("Loaded \(liked.count) liked products from Firestore for user \(userId).")
                    }
                } else {
                    // If 'likedProducts' field is missing or wrong type, initialize empty and save
                    print("Firestore document for user \(userId) exists but 'likedProducts' field is missing or wrong type. Initializing empty.")
                    self.likedProductIds = []
                    self.saveLikedProducts() // Create the field with empty array
                }
            } else if let error = error {
                print("Error loading liked products from Firestore for user \(userId): \(error.localizedDescription)")
                // Fallback to AppStorage if Firestore load fails
                self.likedProductIds = likedProductIdsString.components(separatedBy: ",").filter { !$0.isEmpty }
            } else {
                // Document doesn't exist (maybe new user), initialize with empty liked products and save
                print("Firestore document for user \(userId) does not exist. Initializing with empty liked products.")
                self.likedProductIds = []
                self.saveLikedProducts() // Create the document
            }
        }
    }

    // Save liked products to Firestore for the current user
    func saveLikedProducts() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("saveLikedProducts: User not logged in. Saving only to AppStorage.")
            // Saving to AppStorage is handled by the .onChange observer
            return
        }

        let db = Firestore.firestore()
        // Use merge: true to create the document if it doesn't exist or just update the field
        db.collection("users").document(userId).setData([
            "likedProducts": likedProductIds
        ], merge: true) { error in
            if let error = error {
                print("Error saving liked products to Firestore for user \(userId): \(error.localizedDescription)")
            } else {
                print("Successfully saved \(likedProductIds.count) liked products to Firestore for user \(userId).")
            }
        }
    }
}

// Preview provider for SwiftUI Canvas
#Preview {
    ContentView(
        products: [], // Provide empty default values for preview
        store: Store(name: "Giant", products: [])
    )
}
