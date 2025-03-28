//
//  ShoppingListView.swift
//  Prize Snap
//
//  Created by Esan Yi (student LM) on 3/3/25.
//

import SwiftUI
import FirebaseAuth



struct ShoppingListView: View {
    var products: [Product]  // All products
    var likedProductIds: [UUID]  // List of liked product IDs

    var body: some View {
        VStack {
            Text("Liked Products")
                .font(.largeTitle)
                .bold()
                .padding()

            ScrollView {
                // Filter products by checking if the product's ID is in the likedProductIds array
                ForEach(products.filter { likedProductIds.contains($0.id) }, id: \.id) { product in
                    HStack {
                        AsyncImage(url: URL(string: product.image)) { phase in
                            if let image = phase.image {
                                image.resizable().scaledToFit().frame(width: 60, height: 60)
                            } else {
                                ProgressView().frame(width: 60, height: 60)
                            }
                        }

                        VStack(alignment: .leading) {
                            Text(product.name).font(.headline)
                            Text("$\(product.price, specifier: "%.2f")").font(.subheadline)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle("Liked Products")
    }
}
