//
//  HomeView.swift
//  Prize Snap
//
//  Created by Edison Zheng (student LM) on 2/26/25.
//
import SwiftUI
struct HomeView: View {
    @State var products: [Product] = [
        Product(),
        Product(),
        Product(),
        Product(),
        Product(),
        Product(),
        Product(),
        Product(),
        Product(),
        Product(),
        Product(),
        Product(),
        Product()
    ]
    var body: some View {
        
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Text("HOT DEALS")
                            .padding(.leading,20)
                            .bold()
                            .font(Constants.titleFont)
                        NavigationLink {
                            EmptyView()
                        } label: {
                            HStack {
                                Spacer()
                                Text("See More")
                                    .padding(.trailing,20)
                                    .font(Constants.textFont)
                            }
                    }
                    }
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(products.prefix(10)) {product in
                                VStack{
                                    Image(product.picture)
                                        .resizable()
                                        .frame(width: 150, height: 100)
                                    HStack {
                                        Text(product.name)
                                            .font(Constants.textFont)
                                        Text("$" + String(product.price))
                                            .font(Constants.textFont)
                                    }
                                }
                                Spacer()
                            }
                        }
                    }
                    HStack {
                        Text("For You")
                            .bold()
                            .font(Constants.titleFont)
                            .padding(.leading,20)
                        Spacer()
                        
                    }
                    ScrollView{
                        VStack {
                            ForEach(products) {product in
                                HStack{
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
                }
            }.navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
#Preview {
    HomeView()
}
