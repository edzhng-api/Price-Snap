

//
//  Product.swift
//  Prize Snap
//
//  Created by Edison Zheng (student LM) on 2/26/25.
//
import Foundation

struct Product: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var price: Double
    var link: String
    var image: String
    var store: String

    init(name: String, price: Double, link: String, image: String, store: String) {
        self.name = name
        self.price = price
        self.link = link
        self.image = image
        self.store = store
    }

    enum CodingKeys: String, CodingKey {
        case name, price, link, image, store
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.price = try container.decode(Double.self, forKey: .price)
        self.link = try container.decode(String.self, forKey: .link)
        self.image = try container.decode(String.self, forKey: .image)
        self.store = try container.decode(String.self, forKey: .store)

        self.id = UUID()
    }
    
    var formattedPrice: String {
        return String(format: "$%.2f", price)
    }
}




struct Store: Codable {
    let name: String
    var products: [Product]
}




