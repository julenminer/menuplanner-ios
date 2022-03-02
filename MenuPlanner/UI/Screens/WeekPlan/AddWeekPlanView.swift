//
//  AddWeekPlanView.swift
//  MenuPlanner
//
//  Created by Julen Miner on 21/2/22.
//

import SwiftUI

struct AddWeekPlanView: View {
    @EnvironmentObject private var menuViewModel: MenuViewModel
    
    @Binding var showAddMenu: Bool
    
    @State var selectedWeekdays: [Date] = [Date()]
    @State var menuType: MenuType = .breakfast
    @State var selectedMeals = [Meal]()
    
    @State var showError: Bool = false
    @State var showWeekdayError: Bool = false
    @State var showExistsError: Bool = false
    @State var existingWeekday: String? = nil

    var body: some View {
        NavigationView {
            Form {
                weekdayPicker
                menuTypePicker
                mealPicker
            }
            .navigationTitle("Add new menu")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: { showAddMenu = false }) {
                    Text("Close")
                },
                trailing: Button(action: save) {
                    Text("Save")
                })
            .alert(isPresented: $showError) {
                Alert(
                    title: Text("Menu already exists"),
                    message: Text("A menu for the selected date and type already exists"),
                    dismissButton: .default(Text("Accept"))
                )
            }
            .alert(isPresented: $showWeekdayError) {
                Alert(
                    title: Text("Select weekday"),
                    message: Text("At least one date has to be selected"),
                    dismissButton: .default(Text("Accept"))
                )
            }
            .alert(isPresented: $showExistsError) {
                Alert(
                    title: Text("Menu already exists"),
                    message: Text("A menu of the selected type for \(existingWeekday ?? "") already exists"),
                    dismissButton: .default(Text("Accept"))
                )
            }
        }
    }
    
    private var weekdayPicker: some View {
        Section (header: Text("Weekdays")){
            WeekDaysPickerView(week: Date().week(), selectedDates: $selectedWeekdays)
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
    
    private func save() {
        do {
            if(weekdaySelected() && anyMenuExists()) {
                try menuViewModel.add(weekday: selectedWeekdays.first!.weekdayNumber(), type: menuType, meals: selectedMeals)
                showAddMenu = false
            }
        } catch {
            showError = true
        }
    }
    
    private func weekdaySelected() -> Bool {
        showWeekdayError = selectedWeekdays.isEmpty
        return !selectedWeekdays.isEmpty
    }
    
    private func anyMenuExists() -> Bool {
        selectedWeekdays.forEach { day in
            if(menuViewModel.existsMenu(atWeekday: day.weekdayNumber(), withType: menuType)) {
                existingWeekday = day.longDayOfTheWeek().lowercased()
                showExistsError = true
            }
        }
        existingWeekday = nil
        return true
    }
}

struct AddWeekPlanView_Previews: PreviewProvider {
    static var previews: some View {
        AddWeekPlanView(showAddMenu: .constant(true))
            .environmentObject(MenuViewModel.preview)
            .environmentObject(MealViewModel.preview)
    }
}
