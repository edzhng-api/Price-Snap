

//
//  Product.swift
//  Prize Snap
//
//  Created by Edison Zheng (student LM) on 2/26/25.
//
import Foundation
struct Product: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var price: Double
    var location: String
    var quantity: Int
    var picture: String
    
    init(name: String = "Name", price: Double = 0.00, location: String = "Location Not Found", quantity: Int = 1, picture: String = "Placeholder") {
        self.name = name
        self.price = price
        self.location = location
        self.quantity = quantity
        self.picture = picture
    }
}
