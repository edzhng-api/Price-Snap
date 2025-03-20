

//
//  Product.swift
//  Prize Snap
//
//  Created by Edison Zheng (student LM) on 2/26/25.
//
import Foundation

struct Product: Codable, Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    let link: String
    let image: String
    let store: String
    
    init(name: String, price: Double, link: String, image: String, store: String) {
        self.name = name
        self.price = price
        self.link = link
        self.image = image
        self.store = store
    }
    
    var formattedPrice: String {
        return String(format: "$%.2f", price)
    }
}

struct Store: Codable {
    var name: String 
    let products: [Product]
}




