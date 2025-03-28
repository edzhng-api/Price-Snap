//
//  ProductDetailVie.swift
//  Prize Snap
//
//  Created by Filip Cyran (student LM) on 3/25/25.
//

import SwiftUI

struct ProductDetailView: View {
    var product: Product
    @Binding var likedProductIds: [UUID] 

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: product.image)) { phase in
                if let image = phase.image {
                    image.resizable().scaledToFit().frame(width: 200, height: 200)
                } else {
                    ProgressView().frame(width: 200, height: 200)
                }
            }

            HStack {
                Text(product.name).font(Constants.titleFont).padding()
                Spacer()
                
                Button(action: {
                    toggleLike()
                }, label: {
                    Image(systemName: likedProductIds.contains(product.id) ? "star.fill" : "star")
                        .resizable()
                        .foregroundColor(.yellow)
                        .frame(width: 35, height: 35)
                        .padding(.trailing)
                })
            }

            Text("$\(product.price, specifier: "%.2f")").font(Constants.titleFont).padding()
            Link("Buy Now", destination: URL(string: product.link)!)
                .font(.subheadline)
                .foregroundColor(.blue)
                .padding()

            Spacer()
        }
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func toggleLike() {
        if let index = likedProductIds.firstIndex(of: product.id) {
            likedProductIds.remove(at: index)
        } else {
            likedProductIds.append(product.id)
        }
    }
}

#Preview {
    ProductDetailView(product: Product(
        name: "Apple",
        price: 3.99,
        link: "https://example.com/apple",
        image: "https://example.com/apple.jpg",
        store: "AmazonData"
    ), likedProductIds: .constant([]))
}
