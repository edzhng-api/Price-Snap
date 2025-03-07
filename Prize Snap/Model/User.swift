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
    @Published var username: String
    @Published var isUserAuth: Bool = false
    
    
    init(email: String = "", password: String = "", username: String = "") {
        self.email = email
        self.password = password
        self.username = username
    }
}
