//
//  MainContentView.swift
//  MenuPlanner
//
//  Created by Julen Miner on 15/11/21.
//

import SwiftUI

struct MainContentView: View {
    var body: some View {
        TabView {
            MenuView()
                .tabItem({
                    Image(systemName: "calendar")
                    Text("Menu")
                })
            MealsListView()
                .tabItem({
                    Image(systemName: "menucard")
                    Text("Meals")
                })
                .tag(MainTab.meals)
            CategoriesListView()
                .tabItem({
                    Image(systemName: "list.bullet")
                    Text("Categories")
                })
                .tag(MainTab.categories)
        }
    }
    
    enum MainTab {
        case meals
        case categories
    }
}

struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView()
            .environmentObject(FoodCategoryViewModel.preview)
            .environmentObject(MealViewModel.preview)
            .environmentObject(MenuViewModel.preview)
    }
}
