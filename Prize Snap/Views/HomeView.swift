//
//  HomeView.swift
//  Prize Snap
//
//  Created by Edison Zheng (student LM) on 2/26/25.
//
import SwiftUI

struct HomeView: View {
    @Binding var products: [Product]
    @Binding var store: Store
    @State var allStores: [Store] = []
    @Binding var likedProductIds: [UUID]
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    HStack {
                        Text("HOT DEALS")
                            .padding(.leading, 20)
                            .bold()
                            .font(Constants.titleFont)
                        Spacer()
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(getTopDeals(), id: \.id) { product in
                                VStack {
                                    AsyncImage(url: URL(string: product.image)) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 80, height: 80)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        } else if phase.error != nil {
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 80, height: 80)
                                                .foregroundColor(.gray)
                                        } else {
                                            ProgressView()
                                                .frame(width: 80, height: 80)
                                        }
                                    }
                                    
                                    HStack {
                                        Text(product.name)
                                            .font(.headline)
                                            .multilineTextAlignment(.center)
                                        
                                        Spacer()

                                        Text("$\(product.price, specifier: "%.2f")")
                                            .font(.subheadline)
                                            .foregroundColor(.green)
                                    }
                                    HStack {
                                        Spacer()
                                        Text("Save \(discountPercentage(for: product), specifier: "%.1f")%")
                                            .font(.caption)
                                            .bold()
                                            .foregroundColor(.red)
                                    }
                                }
                                .frame(width: 120)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                    }

                    HStack {
                        Text("For You")
                            .bold()
                            .font(Constants.titleFont)
                            .padding(.leading, 20)
                        Spacer()
                    }
                    ForEach(sortedProducts(), id: \.id) { product in
                        NavigationLink(destination: ProductDetailView(product: product, likedProductIds: $likedProductIds)) {
                            HStack {
                                AsyncImage(url: URL(string: product.image)) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60, height: 60)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    } else if phase.error != nil {
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60, height: 60)
                                            .foregroundColor(.gray)
                                    } else {
                                        ProgressView()
                                            .frame(width: 60, height: 60)
                                    }
                                }

                                VStack(alignment: .leading) {
                                    Text(product.name)
                                        .font(.headline)
                                    Text("$\(product.price, specifier: "%.2f")")
                                        .font(.subheadline)
                                    Text("Save \(discountPercentage(for: product), specifier: "%.1f")%")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                    Link("Buy Now", destination: URL(string: product.link)!)
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                }
                                Spacer()
                                
                                Image(getStoreLogo(for: product.store))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                    }.padding(.horizontal)
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            loadData()
        }
    }

    func getStoreLogo(for storeName: String) -> String {
        switch storeName {
        case "Giant": return "giant_logo"
        case "Walmart": return "walmart_logo"
        case "Costco": return "costco_logo"
        case "Amazon": return "amazon_logo"
        default: return "default_logo"
        }
    }

    func loadData() {
        let storeFiles = ["GiantData", "WalmartData", "ACMEData", "TargetData"]
        var allProducts: [Product] = []
        var loadedStores: [Store] = []

        for file in storeFiles {
            if let url = Bundle.main.url(forResource: file, withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    
                    var decodedStore = try decoder.decode(Store.self, from: data)

                    decodedStore.products = decodedStore.products.map { product in
                        var mutableProduct = product
                        mutableProduct.id = product.id
                        return mutableProduct
                    }

                    allProducts.append(contentsOf: decodedStore.products)
                    loadedStores.append(decodedStore)
                } catch {
                    print("Error loading \(file).json: \(error)")
                }
            } else {
                print("\(file).json not found in bundle")
            }
        }

        DispatchQueue.main.async {
            self.products = allProducts
            self.allStores = loadedStores
            self.store = loadedStores.first ?? Store(name: "DefaultStore", products: [])
        }
    }

    func highestPrice(for productName: String) -> Double {
        let allPrices = allStores.flatMap { $0.products }
            .filter { $0.name == productName }
            .map { $0.price }
        
        return allPrices.max() ?? 0
    }

    func discountPercentage(for product: Product) -> Double {
        let highest = highestPrice(for: product.name)
        guard highest > 0 else { return 0 }
        return ((highest - product.price) / highest) * 100
    }

    func sortedProducts() -> [Product] {
        return products.sorted { discountPercentage(for: $0) > discountPercentage(for: $1) }
    }

    func getTopDeals() -> [Product] {
        return products
            .sorted { discountPercentage(for: $0) > discountPercentage(for: $1) }
            .prefix(10)
            .map { $0 }
    }
}

#Preview {
    HomeView(
        products: .constant([
            Product(name: "Apple", price: 3.99, link: "https://example.com/apple", image: "https://example.com/apple.jpg", store: "AmazonData"),
            Product(name: "Banana", price: 1.99, link: "https://example.com/banana", image: "https://example.com/banana.jpg", store: "WalmartData")
        ]),
        store: .constant(Store(name: "AmazonData", products: [
            Product(name: "Apple", price: 0.62, link: "https://example.com/apple", image: "https://example.com/apple.jpg", store: "AmazonData")
        ])), likedProductIds: .constant([])
    )
}

