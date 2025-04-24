//
//  RegisterView.swift
//  Prize Snap
//
//  Created by Filip Cyran (student LM) on 2/26/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

// View for user registration
struct RegisterView: View {
    @EnvironmentObject var user: User // Accesses the shared user object for email, password, username, and auth state
    @State private var showAlert = false // State to control the visibility of the alert
    @State private var alertMessage = "" // State to hold the message displayed in the alert

    // The main content of the view
    var body: some View {
        NavigationView { // Provides navigation capabilities
            VStack { // Arranges elements vertically
                Text("REGISTER") // Title text
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
                    .padding(.horizontal,25) // Add horizontal padding
                    .padding(.vertical, 10) // Add vertical padding

                // Text field for username input
                TextField("Username", text: $user.username) // Binds text field to the user's username property
                    .overlay(Rectangle().frame(height: 1).foregroundColor(.gray), alignment: .bottom) // Add a bottom border
                    .padding(.horizontal,25) // Add horizontal padding
                    .padding(.vertical, 10) // Add vertical padding


                // Secure text field for password input
                SecureField("Password", text: $user.password) // Binds secure text field to the user's password property
                    .overlay(Rectangle().frame(height: 1).foregroundColor(.gray), alignment: .bottom) // Add a bottom border
                    .padding(.horizontal,25) // Add horizontal padding
                    .padding(.vertical, 10) // Add vertical padding

                Spacer() // Pushes the content above it towards the top

                // Button to trigger the registration action
                Button(action: {
                    Task { // Use a Task to perform the async registration operation
                        await createUser()
                    }
                }, label: {
                    Text("Register") // Button text
                        .font(Constants.titleFont)
                        .foregroundColor(.white)
                        .padding(.horizontal, 125) // Horizontal padding for button size
                        .padding(.vertical, 15) // Vertical padding for button size
                        .background(Color.green) // Button background color
                        .cornerRadius(12) // Rounded corners for the button
                })

                // Navigation link back to the login view
                NavigationLink(destination: LoginView()) { // Assumes LoginView exists
                    Text("Already have an account?\n Login here.") // Link text
                        .foregroundColor(.black)
                        .font(Constants.captionFont) // Assumes Constants struct exists
                }
                .padding(.bottom) // Add space at the bottom


            }.alert(isPresented: $showAlert) { // Alert to show registration errors
                Alert(
                    title: Text("Register Failed"), // Alert title
                    message: Text(alertMessage), // Alert message from state variable
                    dismissButton: .default(Text("OK")) // Dismiss button
                )
            }
        }.navigationBarBackButtonHidden(true) // Hide the back button on the navigation bar
    }

    // Async function to create a new user using Firebase Auth and save data to Firestore
    func createUser() async {
        do {
            // Attempt to create user with email and password
            let authResult = try await Auth.auth().createUser(withEmail: user.email, password: user.password)
            user.isUserAuth = true // Set user authentication status to true on success

            // Get a reference to the Firestore database
            let db = Firestore.firestore()
            // Create a document in the "users" collection with the user's UID
            let userRef = db.collection("users").document(authResult.user.uid)
            // Set the user's username and email in the Firestore document
            try await userRef.setData([
                "username": user.username,
                "email": user.email
            ])

        } catch let error as NSError {
            // Handle specific authentication errors during creation
            if error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                alertMessage = "The email is already in use."
            } else if error.code == AuthErrorCode.weakPassword.rawValue {
                alertMessage = "Password is too weak."
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
    RegisterView()
        .environmentObject(User()) // Provide a mock User object for preview
}
