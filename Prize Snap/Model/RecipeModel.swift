//
//  RecipeModel.swift
//  Prize Snap
//
//  Created by Filip Cyran (student LM) on 4/8/25.
//

import Foundation


struct RecipeModel: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var products: [String]
    var time: String
    var image: String
    
    init(name: String = "", products: [String] = [], time: String = "", image: String = "roastedPotato.png") {
        self.name = name
        self.products = products
        self.time = time
        self.image = image
    }
}
