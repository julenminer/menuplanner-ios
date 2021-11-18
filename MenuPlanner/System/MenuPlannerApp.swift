//
//  menuplannerApp.swift
//  menuplanner
//
//  Created by Julen Miner on 1/9/21.
//

import SwiftUI

@main
struct MenuPlannerApp: App {
    @StateObject var foodCategoryViewModel = FoodCategoryViewModel()
    @StateObject var mealViewModel = MealViewModel()
    @StateObject var menuViewModel = MenuViewModel()

    var body: some Scene {
        WindowGroup {
            MainContentView()
                .environmentObject(foodCategoryViewModel)
                .environmentObject(mealViewModel)
                .environmentObject(menuViewModel)
        }
    }
}
