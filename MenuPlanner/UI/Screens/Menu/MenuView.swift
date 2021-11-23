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
                        if let (id, breakfast) = menu.breakfastMeals() {
                            MenuMeals(breakfast, id: id, type: .breakfast)
                        }
                        if let (id, lunch) = menu.lunchMeals() {
                            MenuMeals(lunch, id: id, type: .lunch)
                        }
                        if let (id, dinner) = menu.dinnerMeals() {
                            MenuMeals(dinner, id: id, type: .dinner)
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
    @EnvironmentObject private var menuViewModel: MenuViewModel
    @Environment(\.colorScheme) var currentMode
    
    let meals: [Meal]
    let id: UUID
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
    
    init(_ meals: [Meal], id: UUID, type: MenuType) {
        self.meals = meals
        self.id = id
        self.menuType = type
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(header)
                    .font(.caption2)
                Spacer()
                menuButton
            }
            ForEach(meals) { meal in
                Text("\(meal.emoji ?? "")  \(meal.name ?? "")")
                    .padding(.vertical, 1)
            }
        }
        .padding(.vertical, 8)
        .contextMenu { editMenuItems }
    }
    
    private var menuButton: some View {
        SwiftUI.Menu {
            editMenuItems
        } label: {
            Image(systemName: "ellipsis")
                .foregroundColor(currentMode == .light ? Color.black : Color.white )
        }
    }
    
    private var editMenuItems: some View {
        deleteButton
    }
    
    private var deleteButton: some View {
        let action = {
            menuViewModel.delete(byId: id)
        }
        let label = Label("Delete", systemImage: "trash")
        if #available(iOS 15.0, *) {
            return Button(
                role: .destructive,
                action: action,
                label: { label }
            )
        } else {
            return Button(
                action: action,
                label: { label }
            )
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .environmentObject(MenuViewModel.preview)
    }
}
