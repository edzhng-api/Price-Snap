//
//  ThaiChickenView.swift
//  Prize Snap
//
//  Created by Filip Cyran (student LM) on 4/21/25.
//

import SwiftUI

// View to display details for the "Thai Chicken Peanut & Rice Skillet" recipe
struct ThaiChickenView: View {
    // State variables to control which section (recipe, instructions, shopping) is displayed
    @State var recipeOn = true // Controls visibility of the recipe view
    @State var instrustionsOn = false // Controls visibility of the instructions view
    @State var shoppingOn = false // Controls visibility of the shopping view

    // The main content of the view
    var body: some View {
        ScrollView { // Enables scrolling for the content
            VStack { // Arranges elements vertically
                Image("thaiChicken") // Recipe image (assumed local asset)
                    .resizable()
                    .scaledToFill() // Scale to fill the frame
                    .frame(width: 394, height: 260) // Set image frame size
                    .clipped() // Clip content to the frame
                    .cornerRadius(12) // Apply corner radius to the image
                    .padding(.top) // Add space above the image

                HStack { // Arrange selection buttons horizontally
                    Spacer() // Pushes buttons apart

                    // Button to show the Recipe section
                    Button(action: {
                        recipeOn = true // Turn recipe view ON
                        instrustionsOn = false // Turn instructions view OFF
                        shoppingOn = false // Turn shopping view OFF
                    }, label: {
                        Image(systemName: "book") // Book icon
                            .resizable()
                            .frame(width: 25, height: 25) // Icon size
                            .foregroundColor(.black) // Icon color
                    })

                    Spacer() // Pushes buttons apart

                    // Button to show the Instructions section
                    Button(action: {
                        instrustionsOn = true // Turn instructions view ON
                        recipeOn = false // Turn recipe view OFF
                        shoppingOn = false // Turn shopping view OFF
                    }, label: {
                        Image(systemName: "list.number") // List icon
                            .resizable()
                            .frame(width: 25, height: 25) // Icon size
                            .foregroundColor(.black) // Icon color
                    })

                    Spacer() // Pushes buttons apart

                    // Button to show the Shopping section
                    Button(action: {
                        shoppingOn = true // Turn shopping view ON
                        instrustionsOn = false // Turn instructions view OFF
                        recipeOn = false // Turn recipe view OFF
                    }, label: {
                        Image(systemName: "cart") // Cart icon
                            .resizable()
                            .frame(width: 25, height: 25) // Icon size
                            .foregroundColor(.black) // Icon color
                    })

                    Spacer() // Pushes buttons apart
                }

                // Conditional rendering based on state variables
                if recipeOn {
                    recipeThaiView() // Display the recipe ingredients view
                } else if instrustionsOn{
                    stepsThaiView() // Display the recipe instructions view
                } else if shoppingOn {
                    shoppingThaiView() // Display the shopping options view
                }

                Spacer() // Pushes content upwards
            }
        }
    }
}

// Helper view to display the recipe ingredients
struct recipeThaiView: View {
    var body: some View {
        VStack { // Arranges elements vertically
            HStack { // Arranges elements horizontally
                Text("Recipe") // Section title
                    .font(Constants.titleFont) // Assumes Constants struct exists
            }.padding() // Add padding

            // Text block containing the recipe ingredients
            Text("● 1 ½ pounds boneless skinless chicken breasts \n● ½ teaspoon kosher salt \n● ½ teaspoon ground black pepper \n● 2 tablespoons coconut oil \n● 1 red bell pepper thinly sliced \n● 1 leek thinly sliced\n● 2 cloves garlic minced\n● ½ teaspoon grated fresh ginger\n● 2 tablespoons red curry paste \n● 1 can full-fat coconut milk (14 ounces) (do not use light, or the sauce won't thicken properly) \n● 3 tablespoons fresh cilantro torn \n● Prepared brown rice for serving")
        }
    }
}

// Helper view to display the recipe instructions
struct stepsThaiView: View {
    var body: some View {
        VStack { // Arranges elements vertically
            HStack { // Arranges elements horizontally
                Text("Instructions").font(Constants.titleFont) // Section title
            }.padding() // Add padding
            // Text block containing the recipe instructions
            Text("● Place a rack in the center of your oven and preheat the oven to 375°F. Season the chicken with salt and black pepper. \n● Melt the coconut oil over medium-high heat in a large, ovenproof skillet. Add the chicken and sear on both sides until deeply golden brown. Transfer to a plate. \n● Reduce the heat to medium-low. Add the bell pepper, leek, garlic, and ginger, and stir to combine. Cook for 2 minutes, until slightly softened. \n● Stir in the curry paste. Cook for 5 additional minutes, stirring often. Slowly pour in the coconut milk while stirring to combine. Return the reserved chicken to the skillet.\n● Place the skillet in the oven and bake for 25 minutes. The chicken will be fully cooked when a thermometer inserted in the thickest part of the chicken registers 165°F, and the juices run clear. (Note: Smaller chicken breasts may be done closer to the 15-minute mark.)\n● Top with cilantro. Serve with rice, spooning lots of the yummy curry coconut milk sauce over the top.")
        }.padding() // Add padding around the VStack
    }
}

// Helper view to display shopping options for the recipe
struct shoppingThaiView: View {
    var body: some View{
        VStack { // Arranges elements vertically
            HStack { // Arranges elements horizontally
                Text("Shop").font(Constants.titleFont) // Section title
            }.padding() // Add padding
            // Card for Giant store
            Rectangle()
                .frame(width: 360, height: 100)
                .cornerRadius(12)
                .foregroundColor(.secondary).opacity(0.4)
                .overlay( // Overlay content on the rectangle
                    HStack { // Arrange logo and price/button horizontally
                        Image("giant_logo") // Giant logo (assumed local asset)
                            .resizable()
                            .frame(width: 150, height: 35)
                            .scaledToFit()
                            .padding()
                        Spacer() // Pushes content apart

                        VStack { // Arrange price and button vertically
                            Text("$48.12").font(Constants.titleFont) // Price (hardcoded)

                            Button(action: {
                                // Action for "Shop now!" button (currently empty)
                            }, label: {
                                Text("Shop now!") // Button text
                                    .padding(5)
                                    .background(Color.green)
                                    .cornerRadius(12)
                                    .foregroundColor(.black)
                            })

                        }.padding()
                    }
                )
            // Card for Walmart store (similar structure)
            Rectangle()
                .frame(width: 360, height: 100)
                .cornerRadius(12)
                .foregroundColor(.secondary).opacity(0.4)
                .overlay(
                    HStack {
                        Image("walmart_logo") // Walmart logo (assumed local asset)
                            .resizable()
                            .frame(width: 150, height: 35)
                            .scaledToFit()
                            .padding()
                        Spacer()

                        VStack {
                            Text("$54.23").font(Constants.titleFont) // Price (hardcoded)

                            Button(action: {
                                // Action for "Shop now!" button (currently empty)
                            }, label: {
                                Text("Shop now!")
                                    .padding(5)
                                    .background(Color.green)
                                    .cornerRadius(12)
                                    .foregroundColor(.black)
                            })

                        }.padding()
                    }
                )
            // Card for Acme store (similar structure)
            Rectangle()
                .frame(width: 360, height: 100)
                .cornerRadius(12)
                .foregroundColor(.secondary).opacity(0.4)
                .overlay(
                    HStack {
                        Image("acme_logo") // Acme logo (assumed local asset)
                            .resizable()
                            .frame(width: 150, height: 85)
                            .scaledToFit()
                            .padding()
                        Spacer()

                        VStack {
                            Text("$55.87").font(Constants.titleFont) // Price (hardcoded)

                            Button(action: {
                                // Action for "Shop now!" button (currently empty)
                            }, label: {
                                Text("Shop now!")
                                    .padding(5)
                                    .background(Color.green)
                                    .cornerRadius(12)
                                    .foregroundColor(.black)
                            })

                        }.padding()
                    }
                )
            // Card for Target store (similar structure)
            Rectangle()
                .frame(width: 360, height: 100)
                .cornerRadius(12)
                .foregroundColor(.secondary).opacity(0.4)
                .overlay(
                    HStack {
                        Image("target_logo") // Target logo (assumed local asset)
                            .resizable()
                            .frame(width: 90, height: 80)
                            .scaledToFit()
                            .padding()
                        Spacer()

                        VStack {
                            Text("$58.59").font(Constants.titleFont) // Price (hardcoded)

                            Button(action: {
                                // Action for "Shop now!" button (currently empty)
                            }, label: {
                                Text("Shop now!")
                                    .padding(5)
                                    .background(Color.green)
                                    .cornerRadius(12)
                                    .foregroundColor(.black)
                            })

                        }.padding()
                    }
                )
        }
    }
}

// Preview provider for SwiftUI Canvas
#Preview {
    ThaiChickenView() // Display the ThaiChickenView for preview
}
