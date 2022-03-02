//
//  WeekPlanView.swift
//  MenuPlanner
//
//  Created by Julen Miner on 19/2/22.
//

import SwiftUI

struct WeekPlanView: View {
    @EnvironmentObject private var menuViewModel: MenuViewModel
    
    @State var selectedDay: Date = Date()
    @State var showAddMenu: Bool = false
    @State var selectedMenuId: UUID?
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Spacer()
                    WeekView(week: selectedDay.week(), selectedDate: $selectedDay)
                    Spacer()
                    Spacer()
                }
                List {
                    ForEach(menuViewModel.menus[selectedDay.weekdayNumber()] ?? []) { menu in
                        Section(header: Text(menu.type ?? "")) {
                            MenuMeals(selectedMenuId: $selectedMenuId, meals: menu.meals?.array as? [Meal] ?? [], id: menu.menuId ?? UUID())
                        }
                    }
                }
            }
            .toolbar {
                Button(action: { showAddMenu = true }){
                    Label("Add Item", systemImage: "plus")
                }
            }
            .navigationTitle("Plan")
            .sheet(isPresented: $showAddMenu) {
                AddWeekPlanView(showAddMenu: $showAddMenu)
            }
        }
    }
}

private struct MenuMeals: View {
    @EnvironmentObject private var menuViewModel: MenuViewModel
    @Environment(\.colorScheme) var currentMode
    
    @Binding var selectedMenuId: UUID?

    let meals: [Meal]
    let id: UUID
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading) {
                ForEach(meals) { meal in
                    Text("\(meal.emoji ?? "")  \(meal.name ?? "")")
                        .padding(.vertical, 1)
                }
            }
            Button(action: selectMenu, label: {EmptyView()})
                .frame(width: 0, height: 0)
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
    
    @ViewBuilder
    private var editMenuItems: some View {
        Section {
            editButton
        }
        Section {
            deleteButton
        }
    }
    
    private var editButton: some View {
        Button(action: selectMenu, label: {Label("Edit", systemImage: "pencil")})
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
    
    private func selectMenu() {
        selectedMenuId = id
    }
}


struct WeekPlanView_Previews: PreviewProvider {
    static var previews: some View {
        WeekPlanView()
            .environmentObject(MenuViewModel.preview)
    }
}
