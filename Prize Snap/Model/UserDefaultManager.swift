//
//  UserDefaultsManager.swift
//  Prize Snap
//
//  Created by Filip Cyran (student LM) on 3/25/25.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let likedProductsKey = "likedProductsKey"

    func saveLikedProducts(_ products: [Product]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(products) {
            UserDefaults.standard.set(encoded, forKey: likedProductsKey)
        }
    }
    
    func loadLikedProducts() -> [Product]? {
        if let savedData = UserDefaults.standard.data(forKey: likedProductsKey) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Product].self, from: savedData) {
                return decoded
            }
        }
        return nil
    }
}

