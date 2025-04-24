//
//  HomeView.swift
//  Prize Snap
//
//  Created by Edison Zheng (student LM) on 2/26/25.
//
import SwiftUI
import Foundation // Needed for URL, UUID

struct HomeView: View {
    // These bindings are managed by ContentView
    @Binding var products: [Product] // This will hold ALL products loaded from JSON
    @Binding var store: Store // This binding seems to hold the *first* store loaded, might need clarification depending on usage
    @Binding var likedProductIds: [String] // Binding for liked product IDs

    // Internal state for HomeView
    @State private var allStores: [Store] = [] // Stores data loaded internally
    @State private var hasLoaded = false // Flag to load data only once
    @State private var isLoading = true // Loading state indicator

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading Products...") // Show loading indicator
                        .padding()
                } else if products.isEmpty {
                     // Handle case where loading finished but no products were found
                     Text("No products available.")
                         .foregroundColor(.gray)
                         .padding()
                }
                else {
                    ScrollView {
                        SectionHeader(title: "HOT DEALS")
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                // Use a NavigationLink to ProductDetailView for hot deals cards too
                                ForEach(getTopDeals()) { product in
                                    // Pass the product, likedProductIds binding, and the *entire* products array
                                    NavigationLink(destination: ProductDetailView(product: product, likedProductIds: $likedProductIds, allProducts: products)) {
                                         ProductCard(product: product, discount: discountPercentage(for: product))
                                    }
                                     // Ensure NavigationLink content uses .buttonStyle(.plain)
                                     // to prevent default button appearance
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                        }

                        SectionHeader(title: "For You")
                        // Use a NavigationLink to ProductDetailView for main product rows
                        ForEach(sortedProducts()) { product in
                            // Pass the product, likedProductIds binding, and the *entire* products array
                            NavigationLink(destination: ProductDetailView(product: product, likedProductIds: $likedProductIds, allProducts: products)) { // <<-- STILL PASSING 'products'
                                ProductRow(product: product, discount: discountPercentage(for: product), storeLogo: getStoreLogo(for: product.store))
                            }
                             // Ensure NavigationLink content uses .buttonStyle(.plain)
                             // to prevent default button appearance
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            // Load data only the first time HomeView appears
            if !hasLoaded {
                isLoading = true // Start loading indicator
                loadData()
                hasLoaded = true
            }
        }
    }

    // MARK: - View Components

    @ViewBuilder
    func SectionHeader(title: String) -> some View {
        HStack {
            Text(title)
                .bold()
                // Using standard font style
                // .font(Constants.titleFont) // Use this if Constants.titleFont is defined
                .font(.title3.bold()) // Fallback standard font
                .padding(.leading, 20)
            Spacer()
        }
        .padding(.top, 5) // Add a little space above section headers
    }

    @ViewBuilder
    func ProductCard(product: Product, discount: Double) -> some View {
        VStack {
            AsyncImage(url: URL(string: product.image)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                case .failure(_):
                    Image(systemName: "photo").resizable().foregroundColor(.gray)
                default:
                    ProgressView()
                }
            }
            .scaledToFit()
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            HStack {
                Text(product.name)
                    .font(.headline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Spacer()
                Text("$\(product.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.green)
            }
             .padding(.horizontal, 5) // Added padding
            HStack {
                 Spacer()
                // Only show discount if it's positive
                if discount > 0 {
                    Text("Save \(discount, specifier: "%.1f")%")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.red)
                } else {
                     // Add an empty space or something if no discount, to maintain layout
                     Text("")
                }
            }
            .padding(.horizontal, 5) // Added padding
        }
        .frame(width: 120)
        .padding(.vertical, 5) // Adjusted padding
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }

    @ViewBuilder
    func ProductRow(product: Product, discount: Double, storeLogo: String) -> some View {
        HStack {
            AsyncImage(url: URL(string: product.image)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                case .failure(_):
                    Image(systemName: "photo").resizable().foregroundColor(.gray)
                default:
                    ProgressView()
                }
            }
            .scaledToFit()
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.headline)
                Text("$\(product.price, specifier: "%.2f")")
                    .font(.subheadline)
                // Only show discount if it's positive
                if discount > 0 {
                    Text("Save \(discount, specifier: "%.1f")%")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.red)
                } else {
                     // Add an empty space or something if no discount
                     Text("").font(.caption)
                }

                 // Removed "Buy Now" link from ProductRow as the whole row is tappable
                 // and the link is available in ProductDetailView
            }

            Spacer()

            // Display store logo if available
            if !storeLogo.isEmpty && storeLogo != "default_logo" {
                 Image(storeLogo)
                     .resizable()
                     .scaledToFit()
                     .frame(width: 40, height: 40)
                     .clipShape(RoundedRectangle(cornerRadius: 5))
            } else {
                // Placeholder or initials if no logo
                 Text(product.store.prefix(1))
                     .font(.headline)
                     .frame(width: 40, height: 40)
                     .background(Color.blue.opacity(0.3))
                     .cornerRadius(5)
            }

        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }

    // MARK: - Helpers

    func getStoreLogo(for storeName: String) -> String {
        switch storeName {
        case "Giant": return "giant_logo" // Make sure you have these assets
        case "Walmart": return "walmart_logo"
        case "Target": return "target_logo"
        case "ACME": return "acme_logo"
        default: return "default_logo" // Or handle missing assets gracefully
        }
    }

    // Function to extract a keyword from a product name
    func keywordFromProductName(_ name: String) -> String {
         // Simple approach: take words longer than 2 characters
         let words = name
             .lowercased()
             .components(separatedBy: CharacterSet.alphanumerics.inverted)
             .filter { !$0.isEmpty && $0.count > 2 }

         // You might need a more sophisticated keyword extraction
         // For now, just return the name if no suitable words found
         return words.first ?? name.lowercased() // Use the first long word, or the whole name if none
    }


     // Finds the highest price for a *similar* product across all stores
     // "Similar" is defined by sharing the keyword derived from the product name.
    func highestPrice(for productName: String) -> Double {
        let keyword = keywordFromProductName(productName)
         // Avoid returning 0 if no products match the keyword
        let matchingProducts = allStores
             .flatMap { $0.products } // Flatten all products from all stores into one array
             .filter { $0.name.lowercased().contains(keyword) } // Filter by keyword presence
             .map { $0.price } // Get just the prices

         return matchingProducts.max() ?? 0 // Return the max price or 0 if no matches
    }


    func discountPercentage(for product: Product) -> Double {
        let highest = highestPrice(for: product.name)
        guard highest > 0 else { return 0 } // Avoid division by zero
        return ((highest - product.price) / highest) * 100
    }

    func sortedProducts() -> [Product] {
        // Sort products by discount percentage in descending order
        products.sorted {
            discountPercentage(for: $0) > discountPercentage(for: $1)
        }
    }

    func getTopDeals() -> [Product] {
        // Take the top 10 sorted products
        Array(sortedProducts().prefix(10))
    }

    // Loads product data from JSON files
    func loadData() {
        let storeFiles = ["GiantData", "WalmartData", "ACMEData", "TargetData"] // Your JSON file names
        var allLoadedProducts: [Product] = [] // Temp array to collect all products
        var loadedStores: [Store] = [] // Temp array to collect all stores

        print("Attempting to load data from JSON files...")

        for file in storeFiles {
            guard let url = Bundle.main.url(forResource: file, withExtension: "json") else {
                print("Error: \(file).json not found in bundle.")
                continue // Skip to the next file
            }
             print("Found \(file).json at URL: \(url)")

            do {
                let data = try Data(contentsOf: url)
                var decodedStore = try JSONDecoder().decode(Store.self, from: data)
                print("Successfully decoded data for store: \(decodedStore.name)")

                // Assign a unique ID to each product, using link as ID
                decodedStore.products = decodedStore.products.map {
                    var updated = $0
                    // Use link as ID (assuming link is unique per product), or generate UUID if link isn't guaranteed unique
                    updated.id = $0.link.isEmpty ? UUID().uuidString : $0.link
                    return updated
                }
                print("Processed \(decodedStore.products.count) products for \(decodedStore.name).")

                allLoadedProducts.append(contentsOf: decodedStore.products) // Add products to the total list
                loadedStores.append(decodedStore) // Add the store to the stores list

            } catch {
                print("Error loading or decoding \(file).json: \(error)")
            }
        }

         print("Finished processing JSON files. Total products found: \(allLoadedProducts.count)")

        // Update state on the main thread
        DispatchQueue.main.async {
            self.products = allLoadedProducts // Update the bound 'products' state
            self.allStores = loadedStores // Update the internal 'allStores' state
            // Set the 'store' binding to the first loaded store (or handle as needed)
             self.store = loadedStores.first ?? Store(name: "DefaultStore", products: [])
             self.isLoading = false // Hide loading indicator
             print("State updated: \(self.products.count) products available.")
        }
    }
}
