//
//  Prize_SnapApp.swift
//  Prize Snap
//
//  Created by Edison Zheng (student LM) on 2/25/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct Prize_SnapApp: App {
    @StateObject var user = User() 
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
//            ContentView(
//                               products: [Product](), // Default empty products array
//                               store: Store(name: "AmazonData", products: []) // Default store with empty product list
//                           )
//                           .environmentObject(user)
            if user.isUserAuth {
                ContentView(
                    products: [Product](),
                    store: Store(name: "AmazonData", products: [])
                )
                .environmentObject(user)
            } else {
                LoginView()
                    .environmentObject(user)
            }
            
        }
    }
}
