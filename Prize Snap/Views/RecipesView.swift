//
//  RecipesView.swift
//  Prize Snap
//
//  Created by Filip Cyran (student LM) on 4/8/25.
//

import SwiftUI
// Main view for displaying a list of recipes with search and sort options
struct RecipesView: View {
    // State variable for the text entered in the search bar
    @State private var searchText = ""
    // State variable for the currently selected sort option
    @State private var selectedSort: SortOption = .alphabeticalAZ

    // Enum defining available sorting options
    enum SortOption: String, CaseIterable, Identifiable {
        case alphabeticalAZ = "A → Z"
        case alphabeticalZA = "Z → A"
        case timeLowHigh = "Time ↑"
        case timeHighLow = "Time ↓"

        var id: String { self.rawValue } // Unique identifier for each case
    }

    // Your existing recipes array (ensure it uses the RecipeModel struct)
    // Hardcoded list of recipes
    private var recipes: [RecipeModel] = [
        RecipeModel(name: "Roasted Potatos", products: ["3 pounds small red new potatoes", "¼ cup olive oil", "1 teaspoon salt and freshly ground black pepper"], time: "25 min", image: "roastedPotato"),
        RecipeModel(name: "Chicken Pot Pie", products: [""], time: "60 min", image: "chickenPotPie"),
        RecipeModel(name: "Fettuccine Alfredo", products: [""], time: "30 min", image: "Fettuccine"),
        RecipeModel(name: "Honey Garlic Chicken", products: [""], time: "30 min", image: "honeyChicken"),
        RecipeModel(name: "Korean Gochujang Beef Bowls", products: [""], time: "20 min", image: "koreanBread"),
        RecipeModel(name: "Spicy Sesame Butter Chicken", products: [""], time: "45 min", image: "spicyChicken"),
        RecipeModel(name: "Red Wine Braised Pot Roast", products: [""], time: "255 min", image: "redwineBraisedPot"),
        RecipeModel(name: "Ground Beef Tacos", products: [""], time: "15 min", image: "beefTacos"),
        RecipeModel(name: "Smash burgers", products: [""], time: "20 min", image: "smashBurger"),
        RecipeModel(name: "Beef and Broccoli Stir Fry", products: [""], time: "15 min", image: "beefBrocoli"),
        RecipeModel(name: "BBQ Chicken Wraps", products: ["", "", "", ""], time: "60 min", image: "bbqChicken"),
        RecipeModel(name: "Butternut Squash Soup with Tortellini", products: ["", "", "", ""], time: "60 min", image: "squashSoup"),
        RecipeModel(name: "Nutella Steel Cut Overnight Oats", products: ["", "", "", ""], time: "5 min", image: "nutella"),
        RecipeModel(name: "Easy Drunken Noodle", products: ["", "", "", ""], time: "25 min", image: "easyNoodle"),
        RecipeModel(name: "Ginger Garlic Stir Fry with Chicken", products: ["", "", "", ""], time: "20 min", image: "garlicChicken"),
        RecipeModel(name: "Easy Chicken Burrito", products: ["", "", "", ""], time: "60 min", image: "easyBurrito"),
        RecipeModel(name: "Baked Salsa Chicken", products: ["", "", "", ""], time: "45 min", image: "salsaChicken"),
        RecipeModel(name: "Thai Chicken Peanut & Rice Skillet", products: ["", "", "", ""], time: "40 min", image: "thaiChicken"), // The target recipe
        RecipeModel(name: "Shrimp Stir Fry", products: ["", "", "", ""], time: "20 min", image: "shrimpStirFry"),
        RecipeModel(name: "Jackfruit BBQ Burritos", products: ["", "", "", ""], time: "50 min", image: "JackfruitBurrito"),
        RecipeModel(name: "Chicken Fettuccine Alfredo", products: ["", "", "", ""], time: "30 min", image: "chickenAlfredo"),
        RecipeModel(name: "Chicken Divan", products: ["", "", "", ""], time: "30 min", image: "chickenDivan")
    ]

    // Computed property to filter and sort the recipes based on search text and selected sort option
    var filteredAndSortedRecipes: [RecipeModel] {
        // Filter recipes by search text (case-insensitive)
        var filtered = recipes.filter {
            searchText.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(searchText)
        }

        // Sort the filtered recipes based on the selected sort option
        switch selectedSort {
        case .alphabeticalAZ:
            return filtered.sorted { $0.name < $1.name } // Sort A to Z
        case .alphabeticalZA:
            return filtered.sorted { $0.name > $1.name } // Sort Z to A
        case .timeLowHigh:
            return filtered.sorted {
                extractMinutes(from: $0.time) < extractMinutes(from: $1.time) // Sort by time, low to high
            }
        case .timeHighLow:
            return filtered.sorted {
                extractMinutes(from: $0.time) > extractMinutes(from: $1.time) // Sort by time, high to low
            }
        }
    }

    // Helper function to extract minutes as an integer from the time string
    func extractMinutes(from timeString: String) -> Int {
        // Remove " min" and convert to Int, default to 0 if conversion fails
        return Int(timeString.replacingOccurrences(of: " min", with: "")) ?? 0
    }

    // The main layout of the view
    var body: some View {
        // Navigation is managed by NavigationView
        NavigationView { // Provides navigation bar and title
            VStack { // Arranges elements vertically
                // Search bar view
                SearchBar(text: $searchText) // Binds the search text state
                    .padding(.horizontal) // Horizontal padding

                // Picker for selecting the sort option
                Picker("Sort by", selection: $selectedSort) { // Binds to the selectedSort state
                    ForEach(SortOption.allCases) { option in
                        Text(option.rawValue).tag(option) // Display option text and tag
                    }
                }
                .pickerStyle(SegmentedPickerStyle()) // Style the picker as segments
                .padding(.horizontal) // Horizontal padding

                ScrollView { // Enables scrolling for the recipe list
                    VStack(spacing: 16) { // Arrange recipe items vertically with spacing
                        // Use the unique ID for the ForEach loop
                        ForEach(filteredAndSortedRecipes) { recipe in
                            // --- Conditional Navigation Logic ---
                            // Check if the current recipe is the specific "Thai Chicken Peanut & Rice Skillet"
                            if recipe.name == "Thai Chicken Peanut & Rice Skillet" {
                                // If it's the Thai Chicken recipe, wrap it in a NavigationLink
                                NavigationLink(destination: ThaiChickenView()) { // Navigates to ThaiChickenView (assumed to exist)
                                    RecipesModelView(recipeModel: recipe) // Display the recipe card view
                                }
                                // Use plain button style to prevent default blue link appearance
                                .buttonStyle(.plain)
                            } else {
                                // For all other recipes, just display the view without navigation
                                RecipesModelView(recipeModel: recipe) // Display the recipe card view
                            }
                        }
                    }
                    .padding(.top) // Add space at the top of the scrollable content
                }
                .navigationTitle("Recipes") // Set the title for the main list view
            }
        }
    }

    // --- Your Existing SearchBar ---
    // A helper struct for the search input field
    struct SearchBar: View {
        @Binding var text: String // Binding to the search text from the parent view

        // The layout for the search bar
        var body: some View {
            HStack { // Arrange icon, text field, and clear button horizontally
                Image(systemName: "magnifyingglass") // Magnifying glass icon
                TextField("Search recipes...", text: $text) // Text field for search input
                    .textFieldStyle(PlainTextFieldStyle()) // Use plain style for the text field
                    .autocapitalization(.none) // Prevent auto-capitalization
                    .disableAutocorrection(true) // Disable auto-correction

                // Show a clear button if the text field is not empty
                if !text.isEmpty {
                    Button(action: {
                        text = "" // Clear the text field
                    }) {
                        Image(systemName: "xmark.circle.fill") // Clear button icon
                            .foregroundColor(.gray) // Color of the clear button icon
                    }
                }
            }
            .padding(10) // Padding around the search bar content
            .background(Color(.systemGray5)) // Background color
            .cornerRadius(8) // Rounded corners
        }
    }
}

// Helper view for displaying a single recipe item in the list
struct RecipesModelView: View {
    var recipeModel: RecipeModel // The recipe data to display

    // The layout for a single recipe card
    var body: some View {
        ZStack { // Allows stacking elements (rectangle behind content)
            Rectangle() // Background rectangle
                .foregroundColor(Color(.systemGray5))
                .frame(width: 360, height: 260) // Set size
                .cornerRadius(12) // Rounded corners

            VStack(spacing: 0) { // Arrange image and text vertically
                Image(recipeModel.image) // Recipe image (assumed local asset)
                    .resizable()
                    .scaledToFill() // Scale to fill the frame
                    .frame(width: 360, height: 200) // Set image frame size
                    .clipped() // Clip the image content to the frame
                    .cornerRadius(12) // Rounded corners for the image (might need specific corners)

                HStack { // Arrange name and time horizontally
                    Text("\(recipeModel.name)") // Recipe name
                        .font(Constants.titleFont) // Assumes Constants struct exists
                        .padding(.leading) // Padding on the left
                    Spacer() // Pushes elements apart
                    Text("\(recipeModel.time)") // Recipe time
                        .font(Constants.titleFont)
                        .padding(.trailing) // Padding on the right
                }
                .frame(height: 60) // Give the bottom HStack a fixed height
                .background(Color(.systemGray5)) // Background color for the text area
                // Corner radius on specific corners is more complex, applying to VStack for simplicity here
            }
            .frame(width: 360, height: 260) // Match the rectangle size
            .cornerRadius(12) // Apply corner radius to the VStack content
            .clipped() // Clip content within the rounded corners
        }
    }
}

// Preview provider for SwiftUI Canvas
#Preview {
    RecipesView() // Display the RecipesView for preview
}
