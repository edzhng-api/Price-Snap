//
//  RegisterView.swift
//  Prize Snap
//
//  Created by Filip Cyran (student LM) on 2/26/25.
//

import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @EnvironmentObject var user: User
    @State var username: String = ""
    @State var password = ""
    var body: some View {
        NavigationView {
            VStack {
                Text("REGISTER")
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
                        await createUser()
                    }
                }, label: {
                    Text("Register")
                        .font(Constants.titleFont)
                        .foregroundColor(.white)
                        .padding(.horizontal, 125)
                        .padding(.vertical, 15)
                        .background(Color.green)
                        .cornerRadius(12)
                })
                
                NavigationLink(destination: LoginView()) {
                    Text("Already have an account?\n Login here.")
                        .foregroundColor(.black)
                        .font(Constants.captionFont)
                }
                .padding(.bottom)
                
                
            }
        }.navigationBarBackButtonHidden(true)
    }
    func createUser() async {
        if let auth = try? await Auth.auth().createUser(withEmail: user.email, password: user.password) {
            user.isUserAuth = true
        }
    }
}

#Preview {
    RegisterView()
        .environmentObject(User())
}
