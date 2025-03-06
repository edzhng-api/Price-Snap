//
//  LoginView.swift
//  Prize Snap
//
//  Created by Filip Cyran (student LM) on 2/25/25.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var user: User
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("LOGIN")
                    .font(Constants.titleFont)
                    .padding(.top)
                
                Image("logoapp")
                    .resizable().frame(width: 200, height: 200)
                    .scaledToFit()
                    .cornerRadius(360)
                    .padding()
                
                TextField("Email", text: $user.email)
                    .overlay(Rectangle().frame(height: 1).foregroundColor(.gray), alignment: .bottom)
                    .padding(25)
                
                SecureField("Password", text: $user.password)
                    .overlay(Rectangle().frame(height: 1).foregroundColor(.gray), alignment: .bottom)
                    .padding(.horizontal, 25)
                
                Spacer()
                
                Button(action: {
                    Task {
                        await loginUser()
                    }
                }, label: {
                    Text("Login")
                        .font(Constants.titleFont)
                        .foregroundColor(.white)
                        .padding(.horizontal, 125)
                        .padding(.vertical, 15)
                        .background(Color.green)
                        .cornerRadius(12)
                })
                
                NavigationLink(destination: RegisterView()) {
                    Text("Don't have an account yet?\n Create free account here. ")
                        .foregroundColor(.black)
                        .font(Constants.captionFont)
                }
                .padding(.bottom)
                
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Login Failed"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func loginUser() async {
        do {
            try await Auth.auth().signIn(withEmail: user.email, password: user.password)
            user.isUserAuth = true
        } catch let error as NSError {
            if error.code == AuthErrorCode.wrongPassword.rawValue {
                alertMessage = "The password you entered is incorrect."
            } else if error.code == AuthErrorCode.invalidEmail.rawValue {
                alertMessage = "The email address is not valid."
            } else if error.code == AuthErrorCode.userNotFound.rawValue {
                alertMessage = "No user found with this email address."
            } else {
                alertMessage = "An unknown error occurred. Please try again."
            }
            showAlert = true
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(User())
}
