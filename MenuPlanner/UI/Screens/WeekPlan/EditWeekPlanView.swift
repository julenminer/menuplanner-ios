//
//  EditWeekPlanView.swift
//  MenuPlanner
//
//  Created by Julen Miner on 21/2/22.
//

import SwiftUI

struct EditWeekPlanView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject private var menuViewModel: MenuViewModel
    
    var menuId: UUID
    
    @State var selectedWeekday: Date = Date()
    @State var menuType: MenuType = .breakfast
    @State var selectedMeals: [Meal] = []
    
    @State var showError: Bool = false

    var body: some View {
        NavigationView {
            Form {
                weekdayPicker
                menuTypePicker
                mealPicker
            }
            .navigationTitle("Edit menu")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: dismiss) {
                    Text("Close")
                },
                trailing: Button(action: update) {
                    Text("Save")
                })
            .alert(isPresented: $showError) {
                Alert(
                    title: Text("Menu already exists"),
                    message: Text("A menu for the selected date and type already exists"),
                    dismissButton: .default(Text("Accept"))
                )
            }
        }.onAppear {
            if let menu = menuViewModel.getMenu(withId: menuId) {
                selectedWeekday = Date().week().first { $0.weekdayNumber() == menu.weekday } ?? Date()
                menuType = MenuType.fromString(menu.type!)
                selectedMeals = menu.meals?.array as! [Meal]
            } else {
                dismiss()
            }
        }
    }
    
    private var weekdayPicker: some View {
        Section (header: Text("Weekdays")){
            WeekView(week: selectedWeekday.week(), selectedDate: $selectedWeekday)
                .font(.title)
        }
    }
    
    private let today = Date()
    private var fromToday: PartialRangeFrom<Date> { today... }
    
    private var menuTypePicker: some View {
        Section {
            Picker("Meal type", selection: $menuType) {
                ForEach(MenuType.allCases, id:\.self) { type in
                    Text(type.description)
                }
            }
        }
    }
    
    private var mealPicker: some View {
        Section(header: mealsHeaderWithEditButton) {
            mealsList
            addMealButton
        }
    }
    
    private var mealsHeaderWithEditButton: some View {
        EditButton()
            .frame(maxWidth: .infinity, alignment: .trailing)
            .overlay(Text("Meals"), alignment: .leading)
    }
    
    private var mealsList: some View {
        List {
            ForEach(selectedMeals) { meal in
                HStack {
                    Text(meal.emoji ?? "")
                    Text(meal.name ?? "")
                }
            }
            .onMove { indexSet, offset in
                selectedMeals.move(fromOffsets: indexSet, toOffset: offset)
            }
            .onDelete { indexSet in
                selectedMeals.remove(atOffsets: indexSet)
            }
        }
    }
    
    private var addMealButton: some View {
        ZStack {
            NavigationLink(destination: MealSelectorView(selectedMeals: $selectedMeals)) {}.opacity(0.0)
            HStack {
                Text("Add meal...")
                Spacer()
                Image(systemName: "plus")
                    .foregroundColor(.gray)
            }
            
        }
    }
    
    private func update() {
        do {
            try menuViewModel.update(withId: menuId, newWeekday: selectedWeekday.weekdayNumber(), newType: menuType, newMeals: selectedMeals)
            dismiss()
        } catch {
            showError = true
        }
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct EditWeekPlanView_Previews: PreviewProvider {
    static var previews: some View {
        EditWeekPlanView(menuId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")!)
            .environmentObject(MenuViewModel.preview)
            .environmentObject(MealViewModel.preview)
    }
}
