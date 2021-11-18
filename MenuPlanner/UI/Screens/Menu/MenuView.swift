//
//  MenuView.swift
//  MenuPlanner
//
//  Created by Julen Miner on 15/11/21.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject private var menuViewModel: MenuViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading, pinnedViews: .sectionHeaders) {
                    ForEach(menuViewModel.menus) { menu in
                        Section(header: MenuDateHeader(menu.date)) {
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
                    Spacer()
                }
                .padding()
                .navigationTitle("Menus")
            }
        }
    }
}

private struct MenuDateHeader: View {
    let date: Date
    
    init(_ date: Date) {
        self.date = date
    }
    
    var body: some View {
        HStack {
            Text(date.toLocaleStringWithoutTime())
            line
        }.background(Color(UIColor.systemBackground))
    }
    
    var line: some View {
        VStack {
            Divider()
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
        HStack {
            VStack(alignment: .leading) {
                ForEach(meals) { meal in
                    Text("\(meal.emoji ?? "")  \(meal.name ?? "")")
                        .padding(.vertical, 1)
                }
            }
            Spacer()
        }
        .padding(.vertical, 24)
        .padding(.horizontal)
        .overlay(
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray, lineWidth: 0.2)
                    .padding(.vertical, 10)
                Text(header)
                    .padding(.horizontal)
                    .background(Color(UIColor.systemBackground))
                    .padding(.horizontal)
            }
        ).padding(.horizontal, 1)
        
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MenuView()
                .environmentObject(MenuViewModel.preview)
            MenuView()
                .preferredColorScheme(.dark)
                .environmentObject(MenuViewModel.preview)
        }
    }
}
