//
//  HomeView.swift
//  Prize Snap
//
//  Created by Edison Zheng (student LM) on 2/26/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Home")
                .font(Constants.titleFont)
                .padding()
            Spacer()
            HStack {
                Button(action: {
                    
                }, label: {
                    Text("Cart")
                        .font(Constants.textFont)
                        .foregroundColor(.black)
                })
                .padding()
                .background(Color.base)
                .cornerRadius(10)
                Button(action: {
                    
                }, label: {
                    Text("Home")
                        .font(Constants.textFont)
                        .foregroundColor(.black)
                })
                .padding()
                .background(Color.base)
                .cornerRadius(10)
                Button(action: {
                    
                }, label: {
                    Text("Search Area")
                        .font(Constants.textFont)
                        .foregroundColor(.black)
                })
                .padding()
                .background(Color.base)
                .cornerRadius(10)
            }
        }
    }
}

#Preview {
    HomeView()
}
