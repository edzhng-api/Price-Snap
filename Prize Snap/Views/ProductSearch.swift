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
    
    var body: some View {
        VStack{
            Text("Search For A Product")
                .padding(20)
                .font(Constants.titleFont)
            
            Map(position: .constant(.region(viewModel.region))) {
                UserAnnotation()
            }
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
            
            TextField("Product Search", text: $searchText)
                .padding(20)
                .font(Constants.textFont)
            
            // Buttons For Navigation
            Spacer()
        }
        .onAppear {
            viewModel.requestAllowOnceLocationPermission()
        }
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
    ProductSearch()
}

