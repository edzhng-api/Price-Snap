//
//  ShoppingListView.swift
//  Prize Snap
//
//  Created by Esan Yi (student LM) on 3/3/25.
//
import SwiftUI
import FirebaseAuth
struct ShoppingListView: View {
    @Binding var products: [Product]
    
    // Compute total before the view body
    var total: Double {
        products.reduce(0) { $0 + $1.price }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "cart.fill")
                    .foregroundColor(.black)
                Text("Shopping List: ")
                    .font(Constants.titleFont)
                    .padding()
                
                ScrollView {
                    VStack {
                        ForEach(products) { product in
                            HStack {
                                Image(product.picture)
                                    .resizable()
                                    .frame(width: 150, height: 100)
                                
                                VStack {
                                    Text(product.name)
                                        .font(Constants.textFont)
                                    Text(product.location)
                                        .font(Constants.textFont)
                                    Text("$" + String(product.price))
                                        .font(Constants.textFont)
                                }
                            }
                            Spacer()
                        }
                    }
                }
                
                Spacer()
                
                HStack {
                    Text("Total Cost: $" + String(format: "%.2f", total))
                        .font(Constants.textFont)
                        .padding()
                }
            }
        }
    }
}
    
#Preview {
    ShoppingListView(products: Binding.constant([Product(), Product(), Product()]))
}

