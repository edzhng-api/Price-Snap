//
//  ShoppingListView.swift
//  Prize Snap
//
//  Created by Esan Yi (student LM) on 3/3/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

// View that displays the list of products liked by the user
struct ShoppingListView: View {
    // State variables to hold the fetched product data and the liked product IDs
    @State private var products: [Product] = []
    @State private var likedProductIds: [String] = []

    // The main content of the view
    var body: some View {
        VStack { // Arranges elements vertically
            Text("Liked Products") // Title text for the view
                .font(.largeTitle)
                .bold()
                .padding() // Add padding around the title

            ScrollView { // Enables scrolling if the content exceeds the screen size
                if products.isEmpty {
                    // Message shown when there are no liked products
                    Text("No liked products found.")
                        .foregroundColor(.gray)
                } else {
                    // Loop through the fetched products and display them
                    ForEach(products, id: \.id) { product in
                        // NavigationLink to a detail view for each product
                        NavigationLink(destination: ProductDetailView(product: product, likedProductIds: $likedProductIds, allProducts: [])) { // Assumes ProductDetailView exists
                            HStack { // Arrange product details horizontally
                                // AsyncImage to load product images from a URL
                                AsyncImage(url: URL(string: product.image)) { phase in
                                    if let image = phase.image {
                                        // Display the loaded image
                                        image.resizable().scaledToFit().frame(width: 60, height: 60)
                                    } else {
                                        // Show a progress view while loading
                                        ProgressView().frame(width: 60, height: 60)
                                    }
                                }

                                VStack(alignment: .leading) { // Arrange text details vertically
                                    Text(product.name).font(.headline) // Product name
                                    Text("$\(product.price, specifier: "%.2f")").font(.subheadline) // Product price
                                }
                                Spacer() // Pushes content to the left
                            }
                        }
                        .padding() // Padding around each product row
                        .background(Color(.systemGray6)) // Background color for the row
                        .cornerRadius(10) // Rounded corners for the row background
                    }
                }
            }
            .padding() // Padding around the scroll view content
        }
        .navigationTitle("Liked Products") // Sets the title in the navigation bar
        // Action performed when the view appears
        .onAppear {
            fetchLikedProducts() // Fetch the list of liked product IDs
        }
    }

    // Function to fetch the IDs of liked products for the current user from Firestore
    func fetchLikedProducts() {
        // Ensure a user is logged in
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let db = Firestore.firestore()
        // Get the user's document from the "users" collection
        db.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                print("Error fetching liked products: \(error)")
                return
            }

            if let document = document, document.exists {
                // Attempt to get the "likedProducts" field as an array of strings
                if let likedIds = document.data()?["likedProducts"] as? [String] {
                    self.likedProductIds = likedIds // Update the state variable with liked IDs
                    fetchProductDetails() // Fetch the details of the products using these IDs
                }
            }
        }
    }

    // Function to fetch the details of the liked products from the "products" collection
    func fetchProductDetails() {
        // Only fetch if there are liked product IDs
        guard !likedProductIds.isEmpty else {
            products = [] // Clear products if the liked list is empty
            return
        }

        let db = Firestore.firestore()
        // Query the "products" collection for documents where the "id" field is in the likedProductIds array
        db.collection("products").whereField("id", in: likedProductIds).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching product details: \(error)")
                return
            }

            if let documents = snapshot?.documents {
                // Map the retrieved documents to Product objects, discarding any failures
                self.products = documents.compactMap { doc -> Product? in
                    try? doc.data(as: Product.self) // Attempt to decode the document data as a Product
                }
            }
        }
    }
}
