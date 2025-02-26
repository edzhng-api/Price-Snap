//
//  User.swift
//  Prize Snap
//
//  Created by Filip Cyran (student LM) on 2/26/25.
//

import Foundation

class User: ObservableObject {
    @Published var email: String
    @Published var password: String
    @Published var isUserAuth: Bool
    
    
    init(email: String = "", password: String = "", isUserAuth: Bool = false) {
        self.email = email
        self.password = password
        self.isUserAuth = isUserAuth
    }
}
