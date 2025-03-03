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
        Product()
    ]
    var body: some View {
        
        ZStack {
            VStack {
                Text("Home")
                    .font(Constants.titleFont)
                    .padding()
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
                Spacer()
                HStack {
                    Button(action: {
                        
                    }, label: {
                        VStack {
                            Image(systemName: "cart.fill")
                                .foregroundColor(.black)
                            Text("Cart")
                                .font(Constants.captionFont)
                                .foregroundColor(.black)
                        }
                    })
                    .padding()
                    .background(Color.base)
                    .cornerRadius(10)
                    Button(action: {
                        
                    }, label: {
                        VStack {
                            Image(systemName: "house.fill")
                                .foregroundColor(.black)
                            Text("Home")
                                .font(Constants.captionFont)
                                .foregroundColor(.black)
                        }
                    })
                    .padding()
                    .background(Color.base)
                    .cornerRadius(10)
                    Button(action: {
                        
                    }, label: {
                        VStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.black)
                            Text("Search Area")
                                .font(Constants.captionFont)
                                .foregroundColor(.black)
                        }
                    })
                    .padding()
                    .background(Color.base)
                    .cornerRadius(10)
                }
            }
        }
    }
}
#Preview {
    HomeView()
}
