//
//  ProductDetailView.swift
//  Prize Snap
//
//  Created by Filip Cyran (student LM) on 3/25/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Foundation

// View that displays details for a single product
struct ProductDetailView: View {
    var product: Product // The product being displayed
    @Binding var likedProductIds: [String] // Binding to the list of liked product IDs
    var allProducts: [Product] // A list of all products (currently unused for recommendations)

    // Hardcoded list of products to show as "Similar Products"
    private let fixedSimilarProducts: [Product] = [
        Product(id: "https://www.walmart.com/ip/Fresh-Gala-Apple-Each/44390953?classType=REGULAR&athbdg=L1300&from=/search", name: "Fresh Gala Apple, Each", price: 0.62, link: "https://www.walmart.com/ip/Fresh-Gala-Apple-Each/44390953?classType=REGULAR&athbdg=L1300&from=/search", image: "https://i5.walmartimages.com/seo/Fresh-Gala-Apple-Each_f46d4fa7-6108-4450-a610-cc95a1ca28c5_3.38c2c5b2f003a0aafa618f3b4dc3cbbd.jpeg?odnHeight=2000&odnWidth=2000&odnBg=FFFFFF", store: "Walmart"),
        Product(id: "https://www.walmart.com/ip/Freshness-Guaranteed-5-Chocolate-Cake-15-9-oz-1-Count-Regular-Cake-Tray-Refrigerated/538575097?classType=REGULAR&from=/search", name: "Freshness Guaranteed 5 in. Chocolate Cake, 15.9 oz, 1 Count, Regular, Cake Tray, Refrigerated", price: 5.98, link: "https://www.walmart.com/ip/Freshness-Guaranteed-5-Chocolate-Cake-15-9-oz-1-Count-Regular-Cake-Tray-Refrigerated/538575097?classType=REGULAR&from=/search", image: "https://i5.walmartimages.com/seo/Freshness-Guaranteed-5-Chocolate-Cake-15-9-oz-1-Count-Regular-Cake-Tray-Refrigerated_f397fb39-4950-4791-9458-81450df43b47.d068a2447df21873c016ffd28ca01282.jpeg?odnHeight=640&odnWidth=640&odnBg=FFFFFF", store: "Walmart"),
        Product(id: "https://www.walmart.com/ip/Great-Value-Large-White-Eggs-12-Count/145051970?classType=REGULAR&athbdg=L1600&from=/search", name: "Great Value, Large White Eggs, 12 Count", price: 3.98, link: "https://www.walmart.com/ip/Great-Value-Large-White-Eggs-12-Count/145051970?classType=REGULAR&athbdg=L1600&from=/search", image: "https://i5.walmartimages.com/seo/Great-Value-Large-White-Eggs-12-Count_b6760ce4-ef2b-4ee7-9c54-1e573897ad73.0e934a9843adc83711b5c933c7777f52.jpeg?odnHeight=2000&odnWidth=2000&odnBg=FFFFFF", store: "Walmart"),
        Product(id: "https://www.walmart.com/ip/Ruffles-Potato-Chips-Original-8-5-oz-Bag/336304484?classType=REGULAR&athbdg=L1600&from=/search", name: "Ruffles Potato Chips Original Snack Chips, 8.5 Ounce Bag", price: 4.48, link: "https://www.walmart.com/ip/Ruffles-Potato-Chips-Original-8-5-oz-Bag/336304484?classType=REGULAR&athbdg=L1600&from=/search", image: "https://i5.walmartimages.com/seo/Ruffles-Potato-Chips-Original-Snack-Chips-8-5-Ounce-Bag_128fdc66-9430-4459-94ba-fc3e1e95be94.dc80d3b14598bcd66e1b047e2d0895e3.jpeg?odnHeight=2000&odnWidth=2000&odnBg=FFFFFF", store: "Walmart"),
        Product(id: "https://www.walmart.com/ip/Simply-Non-GMO-Orange-Juice-No-Pulp-52-fl-oz-Bottle/959033640?classType=REGULAR&athbdg=L1600&from=/search", name: "Simply Non GMO Orange Juice No Pulp, 52 fl oz Bottle", price: 4.48, link: "https://www.walmart.com/ip/Simply-Non-GMO-Orange-Juice-No-Pulp-52-fl-oz-Bottle/959033640?classType=REGULAR&athbdg=L1600&from=/search", image: "https://i5.walmartimages.com/seo/Simply-Non-GMO-Orange-Juice-No-Pulp-52-fl-oz-Bottle_205395dc-a35d-41d5-84ac-a99f3592f4d3.b02225d314ceb6ae483d8385a12533c2.jpeg?odnHeight=2000&odnWidth=2000&odnBg=FFFFFF", store: "Walmart")
    ]

    // The main layout of the view
    var body: some View {
        VStack { // Arranges elements vertically
            ZStack { // Allows overlaying elements
                HStack(alignment: .top) { // Arrange image and like button horizontally
                    // AsyncImage to load the product image
                    AsyncImage(url: URL(string: product.image)) { phase in
                        if let image = phase.image {
                            // Display loaded image
                            image.resizable().scaledToFit().frame(width: 200, height: 200)
                        } else {
                            // Show progress view while loading
                            ProgressView().frame(width: 200, height: 200)
                        }
                    }

                    HStack { // Contains the like button
                        Spacer() // Pushes the button to the right
                        // Button to toggle liking/unliking the product
                        Button(action: {
                            toggleLike() // Call the function to toggle the like status
                        }, label: {
                            // Star icon changes based on whether the product is liked
                            Image(systemName: likedProductIds.contains(product.id) ? "star.fill" : "star")
                                .resizable()
                                .foregroundColor(.yellow) // Color of the star icon
                                .frame(width: 35, height: 35) // Size of the star icon
                                .padding(8) // Add padding for easier tapping
                        })
                        .padding(.trailing) // Add space to the right of the button
                    }
                }
            }

            HStack { // Arrange product name and price horizontally
                Text(product.name) // Product name
                    .font(.headline)
                    .padding(.leading) // Add space to the left
                Spacer() // Pushes text to the sides
                Text("$\(product.price, specifier: "%.2f")") // Product price formatted to 2 decimal places
                    .font(.subheadline)
                    .padding(.trailing) // Add space to the right
            }
            .padding(.top, -20) // Adjust vertical spacing
            Spacer() // Pushes content upwards

            // Link to buy the product (if the link is valid)
            if let url = URL(string: product.link) {
                Link("Buy Now", destination: url) // Button that opens the product link
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding(.horizontal, 120)
                    .padding(.vertical)
                    .background(Color.green)
                    .cornerRadius(12)
                    .padding(.bottom) // Add space below the button
            }

            Divider() // A horizontal line separator
            Text("Recommended Products") // Title for the recommendations section
                .font(.headline)
                .padding(.top) // Add space above the title
                .frame(maxWidth: .infinity, alignment: .leading) // Align title to the left
                .padding(.leading) // Add space to the left

            // Horizontal scrolling view for recommended products
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) { // Arrange recommended products horizontally with spacing
                    // Loop through the fixed list of similar products
                    ForEach(fixedSimilarProducts) { similarProduct in
                        // NavigationLink to navigate to the detail view of a similar product
                        NavigationLink(destination: ProductDetailView(product: similarProduct, likedProductIds: $likedProductIds, allProducts: allProducts)) {
                            SimilarProductItemView(product: similarProduct) // Custom view for each similar product item
                        }
                        .buttonStyle(.plain) // Use a plain button style for the link
                    }
                }
                .padding(.horizontal) // Horizontal padding for the scroll view content
            }
        }
        .navigationTitle(product.name) // Set the navigation bar title to the product name
        .navigationBarTitleDisplayMode(.inline) // Display the title inline in the navigation bar
    }

    // Function to add or remove the current product from the liked list
    private func toggleLike() {
        // Get the current user's ID (if logged in)
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in. Cannot toggle like in Firestore.")
            // If not logged in, just update the local state
            if let index = likedProductIds.firstIndex(of: product.id) {
                likedProductIds.remove(at: index)
            } else {
                likedProductIds.append(product.id)
            }
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)

        // Check if the product is currently liked
        if let index = likedProductIds.firstIndex(of: product.id) {
            // If liked, remove from local list and Firestore
            likedProductIds.remove(at: index)
            userRef.updateData([
                "likedProducts": FieldValue.arrayRemove([product.id]) // Use Firestore's arrayRemove
            ]) { error in
                if let error = error {
                    print("Error removing liked product: \(error)")
                } else {
                    print("Successfully removed liked product \(product.id) from Firestore.")
                }
            }
        } else {
            // If not liked, add to local list and Firestore
            likedProductIds.append(product.id)
            userRef.updateData([
                "likedProducts": FieldValue.arrayUnion([product.id]) // Use Firestore's arrayUnion
            ]) { error in
                if let error = error {
                    print("Error adding liked product: \(error)")
                } else {
                    print("Successfully added liked product \(product.id) to Firestore.")
                }
            }
            // Also save the product details to the 'products' collection if it doesn't exist
            let productRef = db.collection("products").document(product.id)
            productRef.getDocument { docSnapshot, error in
                if let error = error {
                    print("Error getting product document from Firestore: \(error)")
                    return
                }

                if let doc = docSnapshot, !doc.exists {
                    // If the product document doesn't exist, create it
                    do {
                        try productRef.setData(from: product) { err in
                            if let err = err {
                                print("Error writing product \(product.id) to Firestore 'products' collection: \(err)")
                            } else {
                                print("Successfully wrote product \(product.id) to Firestore 'products' collection.")
                            }
                        }
                    } catch {
                        print("Error encoding product for Firestore: \(error)")
                    }
                } else {
                    print("Product \(product.id) already exists in Firestore 'products' collection.")
                }
            }
        }
    }
}

// Helper view for displaying a single item in the "Similar Products" list
struct SimilarProductItemView: View {
    var product: Product // The product to display

    // The layout for a similar product item
    var body: some View {
        VStack(alignment: .leading) { // Arrange elements vertically, aligned to the left
            // AsyncImage to load the product image
            AsyncImage(url: URL(string: product.image)) { phase in
                if let image = phase.image {
                    // Display loaded image
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80) // Set image size
                        .clipShape(RoundedRectangle(cornerRadius: 5)) // Round corners
                } else {
                    // Show progress view while loading
                    ProgressView()
                        .frame(width: 80, height: 80)
                        .background(Color.gray.opacity(0.1)) // Placeholder background
                        .clipShape(RoundedRectangle(cornerRadius: 5)) // Round corners
                }
            }

            Text(product.name) // Product name
                .font(.caption) // Smaller font
                .lineLimit(1) // Limit to one line
                .padding(.horizontal, 2) // Horizontal padding
            Text("$\(product.price, specifier: "%.2f")") // Product price
                .font(.caption2) // Even smaller font
                .foregroundColor(.secondary) // Secondary text color
                .padding(.horizontal, 2) // Horizontal padding
        }
        .frame(width: 90) // Set a fixed width for the item
    }
}

// Preview provider for SwiftUI Canvas
#Preview {
    // Sample data for preview
    let sampleProducts = [
        Product(id: "apple1", name: "Apple", price: 3.99, link: "https://example.com/apple1", image: "https://via.placeholder.com/150/FF0000/FFFFFF?text=Apple+1", store: "AmazonData"),
        Product(id: "banana1", name: "Banana", price: 0.59, link: "https://example.com/banana1", image: "https://via.placeholder.com/150/00FF00/FFFFFF?text=Banana+1", store: "GroceryStore"),
        Product(id: "apple2", name: "Apple", price: 4.50, link: "https://example.com/apple2", image: "https://via.placeholder.com/150/FF0000/FFFFFF?text=Apple+2", store: "AppleStore"),
        Product(id: "orange1", name: "Orange", price: 1.20, link: "https://example.com/orange1", image: "https://via.placeholder.com/150/FFA500/FFFFFF?text=Orange+1", store: "GroceryStore"),
        Product(id: "apple3", name: "Apple", price: 3.75, link: "https://example.com/apple3", image: "https://via.placeholder.com/150/FF0000/FFFFFF?text=Apple+3", store: "Supermarket"),
        Product(id: "apple4", name: "Apple", price: 4.10, link: "https://example.com/apple4", image: "https://via.placeholder.com/150/FF0000/FFFFFF?text=Apple+4", store: "LocalShop"),
        Product(id: "apple5", name: "Apple", price: 3.50, link: "https://example.com/apple5", image: "https://via.placeholder.com/150/FF0000/FFFFFF?text=Apple+5", store: "OnlineMarket"),
        Product(id: "apple6", name: "Apple", price: 4.05, link: "https://example.com/apple6", image: "https://via.placeholder.com/150/FF0000/FFFFFF?text=Apple+6", store: "FruitStand")
    ]

    let currentProduct = sampleProducts[0] // Select a product for preview

    return NavigationView { // Embed in a NavigationView for title display
        ProductDetailView(product: currentProduct, likedProductIds: .constant(["apple2"]), allProducts: sampleProducts) // Provide sample data and a constant binding for liked status
    }
}
