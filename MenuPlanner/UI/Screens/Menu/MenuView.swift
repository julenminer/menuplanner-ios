//
//  MenuView.swift
//  MenuPlanner
//
//  Created by Julen Miner on 22/11/21.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject private var menuViewModel: MenuViewModel
    
    @State var showAddMenu: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(menuViewModel.menus) { menu in
                    Section(header: Text(menu.date.toLocaleStringWithoutTime())) {
                        if let breakfast = menu.breakfastMeals() {
                            MenuMeals(breakfast, type: .breakfast)
                        }
                        if let lunch = menu.lunchMeals() {
                            MenuMeals(lunch, type: .lunch)
                        }
                        if let dinner = menu.dinnerMeals() {
                            MenuMeals(dinner, type: .dinner)
                        }
                    }
                }
            }
            .toolbar {
                Button(action: { showAddMenu = true }){
                    Label("Add Item", systemImage: "plus")
                }
            }
            .navigationTitle("Menus")
            .sheet(isPresented: $showAddMenu) {
                AddMenuView(showAddMenu: $showAddMenu)
            }
        }
    }
}

private struct MenuMeals: View {
    let meals: [Meal]
    let menuType: MenuType
    var header: String {
        switch(menuType) {
        case .breakfast:
            return "Breakfast"
        case .lunch:
            return "Lunch"
        case .dinner:
            return "Dinner"
        }
    }
    
    init(_ meals: [Meal], type: MenuType) {
        self.meals = meals
        self.menuType = type
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(header)
                .font(.caption2)
            ForEach(meals) { meal in
                Text("\(meal.emoji ?? "")  \(meal.name ?? "")")
                    .padding(.vertical, 1)
            }
        }.padding(.vertical, 8)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .environmentObject(MenuViewModel.preview)
    }
}
