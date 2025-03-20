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

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("HOT DEALS")
                        .padding(.leading, 20)
                        .bold()
                        .font(Constants.titleFont)
                    Spacer()
                    NavigationLink(destination: EmptyView()) {
                        Text("See More")
                            .padding(.trailing, 20)
                            .font(Constants.textFont)
                    }
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        // TODO: Add deal items here
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

                ScrollView {
                    ForEach(products, id: \.id) { product in
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
                                .onAppear {
                                    if UIImage(named: getStoreLogo(for: product.store)) == nil {
                                        print("Store logo not found for \(product.store), using default logo.")
                                    }
                                }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
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
        case "Giant":
            return "giant_logo"
        case "Walmart":
            return "walmart_logo"
        case "Costco":
            return "costco_logo"
        case "Amazon":
            return "amazon_logo"
        default:
            return "default_logo"
        }
    }


    func loadData() {
        let storeFiles = ["GiantData", "WalmartData", "CostcoData", "AmazonData"]
        var allProducts: [Product] = []
        var stores: [Store] = []

        for file in storeFiles {
            if let url = Bundle.main.url(forResource: file, withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let decodedStore = try decoder.decode(Store.self, from: data)
                    
                    allProducts.append(contentsOf: decodedStore.products)
                    
                    stores.append(decodedStore)
                } catch {
                    print("Error loading \(file).json: \(error)")
                }
            } else {
                print("\(file).json not found in bundle")
            }
        }

        DispatchQueue.main.async {
            self.products = allProducts
            self.store = stores.first ?? Store(name: "DefaultStore", products: [])
        }
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
        ]))
    )
}
