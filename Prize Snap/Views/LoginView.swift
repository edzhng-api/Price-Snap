//
//  LoginView.swift
//  Prize Snap
//
//  Created by Filip Cyran (student LM) on 2/25/25.
//

import SwiftUI
import FirebaseAuth

// View for user login
struct LoginView: View {
    @EnvironmentObject var user: User // Accesses the shared user object for email, password, and auth state
    @State private var showAlert = false // State to control the visibility of the alert
    @State private var alertMessage = "" // State to hold the message displayed in the alert

    // The main content of the view
    var body: some View {
        NavigationView { // Provides navigation capabilities
            VStack { // Arranges elements vertically
                Text("LOGIN") // Title text
                    .font(Constants.titleFont) // Assumes Constants struct exists
                    .padding(.top) // Add space at the top

                Image("logoapp") // App logo image
                    .resizable().frame(width: 200, height: 200) // Make it resizable and set frame size
                    .scaledToFit() // Scale to fit within the frame
                    .cornerRadius(360) // Make the image circular
                    .padding() // Add padding around the image

                // Text field for email input
                TextField("Email", text: $user.email) // Binds text field to the user's email property
                    .overlay(Rectangle().frame(height: 1).foregroundColor(.gray), alignment: .bottom) // Add a bottom border
                    .padding(25) // Add padding

                // Secure text field for password input
                SecureField("Password", text: $user.password) // Binds secure text field to the user's password property
                    .overlay(Rectangle().frame(height: 1).foregroundColor(.gray), alignment: .bottom) // Add a bottom border
                    .padding(.horizontal, 25) // Add horizontal padding

                Spacer() // Pushes the content above it towards the top

                // Button to trigger the login action
                Button(action: {
                    Task { // Use a Task to perform the async login operation
                        await loginUser()
                    }
                }, label: {
                    Text("Login") // Button text
                        .font(Constants.titleFont)
                        .foregroundColor(.white)
                        .padding(.horizontal, 125) // Horizontal padding for button size
                        .padding(.vertical, 15) // Vertical padding for button size
                        .background(Color.green) // Button background color
                        .cornerRadius(12) // Rounded corners for the button
                })

                // Navigation link to the registration view
                NavigationLink(destination: RegisterView()) { // Assumes RegisterView exists
                    Text("Don't have an account yet?\n Create free account here. ") // Link text
                        .foregroundColor(.black)
                        .font(Constants.captionFont) // Assumes Constants struct exists
                }
                .padding(.bottom) // Add space at the bottom

            }
            // Alert to show login errors
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Login Failed"), // Alert title
                    message: Text(alertMessage), // Alert message from state variable
                    dismissButton: .default(Text("OK")) // Dismiss button
                )
            }
        }
        .navigationBarBackButtonHidden(true) // Hide the back button on the navigation bar
    }

    // Async function to perform user login using Firebase Auth
    func loginUser() async {
        do {
            // Attempt to sign in with email and password
            try await Auth.auth().signIn(withEmail: user.email, password: user.password)
            user.isUserAuth = true // Set user authentication status to true on success
        } catch let error as NSError {
            // Handle specific authentication errors
            if error.code == AuthErrorCode.wrongPassword.rawValue {
                alertMessage = "The password you entered is incorrect."
            } else if error.code == AuthErrorCode.invalidEmail.rawValue {
                alertMessage = "The email address is not valid."
            } else if error.code == AuthErrorCode.userNotFound.rawValue {
                alertMessage = "No user found with this email address."
            } else {
                // Handle other potential Firebase Auth errors
                alertMessage = "An unknown error occurred. Please try again."
            }
            showAlert = true // Show the alert with the error message
        }
    }
}

// Preview provider for SwiftUI Canvas
#Preview {
    LoginView()
        .environmentObject(User()) // Provide a mock User object for preview
}
