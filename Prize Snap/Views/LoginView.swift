//
//  LoginView.swift
//  Prize Snap
//
//  Created by Filip Cyran (student LM) on 2/25/25.
//

import SwiftUI

struct LoginView: View {
    @State var username = ""
    @State var password = ""
    var body: some View {
        VStack {
            Image("logoapp")
                .resizable()
                .scaledToFit()
                .cornerRadius(360)
            
            TextField("Username", text: $username)
                .padding(15)
            
            TextField("Password", text: $password)
                .padding(.horizontal, 15)
            
        }
    }
}

#Preview {
    LoginView()
}
