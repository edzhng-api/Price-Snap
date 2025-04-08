//
//  ProductSearch.swift
//  Prize Snap
//
//  Created by Sebastian Steed (student LM) on 2/25/25.
//
import SwiftUI
import CoreLocation
import MapKit
struct ProductSearch: View {
    
    var radii = [1, 3, 5, 10, 20, 50]
    
    @State private var selectedRadius: Int = 3
    @State private var latitudeDelta: Double = 1/23
    @StateObject private var viewModel = ContentViewModel()
    @State private var searchText = ""
    
    @Binding var products: [Product]
    @Binding var likedProductIds: [UUID]
    
    var body: some View {
        NavigationView() {
            VStack{
                ScrollView() {
                    Text("Search For A Product")
                        .padding(20)
                        .font(Constants.titleFont)
                    
                    Map(position: .constant(.region(viewModel.region))) {
                        UserAnnotation()
                    } .frame(height: 300)
                    HStack {
                        Text("Choose Radius")
                            .font(Constants.textFont)
                        Picker("Radii", selection: $selectedRadius) {
                            ForEach(radii, id: \.self) { radius in
                                Text("\(radius) mi")
                            }
                        }
                        .onChange(of: selectedRadius) { newValue in
                            viewModel.updateSearchRadius(newValue)
                            viewModel.requestAllowOnceLocationPermission()
                        }
                    }
                    
                    TextField("Enter Product", text: $searchText)
                        .padding(30)
                        .font(Constants.textFont)
                    
                    ForEach(searchSort(), id: \.id) { product in
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
            .onAppear {
                viewModel.requestAllowOnceLocationPermission()
            }
        }
    }
    
    func searchSort() -> [Product] {
        var sortedProducts: [Product] = []
        for product in products {
            if product.name.contains(searchText){
                sortedProducts.append(product)
            }
        }
        return sortedProducts.sorted { discountPercentage(for: $0) > discountPercentage(for: $1) }
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
    
    func highestPrice(for productName: String) -> Double {
        var allProducts: [Product] = []
        for product in products {
            if product.name == productName {
                allProducts.append(product)
            }
        }
        return allProducts.sorted { $0.price > $1.price }.first?.price ?? 0.0
    }

    func discountPercentage(for product: Product) -> Double {
        let highest = highestPrice(for: product.name)
        guard highest > 0 else { return 0 }
        return ((highest - product.price) / highest) * 100
    }
    
    
}

final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39.9526, longitude: -75.1652), span: MKCoordinateSpan(latitudeDelta: 1/23, longitudeDelta: 1/23))
    
    let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func requestAllowOnceLocationPermission(){
        locationManager.requestWhenInUseAuthorization()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let latestLocation = locations.last else{
            return
        }
        
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: latestLocation.coordinate, span: self.region.span)
            self.location = latestLocation
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
    
    func updateSearchRadius(_ radius: Int)  {
        let latitudeLongitudeDelta = CLLocationDegrees(Double(radius) / 69.0)
        region.span = MKCoordinateSpan(latitudeDelta: latitudeLongitudeDelta, longitudeDelta: latitudeLongitudeDelta)
    }
    
}


#Preview {
    ProductSearch(
        products: .constant([
            Product(name: "Apple", price: 3.99, link: "https://example.com/apple", image: "https://example.com/apple.jpg", store: "AmazonData"),
            Product(name: "Banana", price: 1.99, link: "https://example.com/banana", image: "https://example.com/banana.jpg", store: "WalmartData")
        ]),
        likedProductIds: .constant([
        ])
    )
}

