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
        }.navigationBarBackButtonHidden(true)
    }
    func loginUser() async {
        do {
            try await Auth.auth().signIn(withEmail: user.email, password: user.password)
            user.isUserAuth = true
        } catch let e as Error {
            print(e)
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(User())
}
