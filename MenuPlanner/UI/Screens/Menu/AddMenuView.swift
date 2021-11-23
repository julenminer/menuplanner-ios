//
//  AddMenuView.swift
//  MenuPlanner
//
//  Created by Julen Miner on 18/11/21.
//

import SwiftUI

struct AddMenuView: View {
    @EnvironmentObject private var menuViewModel: MenuViewModel
    
    @Binding var showAddMenu: Bool
    
    @State var date = Date()
    @State var menuType: MenuType = .breakfast
    @State var selectedMeals = [Meal]()
    
    @State var showError: Bool = false
    
    var body: some View {
        NavigationView {
            Form{
                datePicker
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
        }
    }
    
    private var datePicker: some View {
        Section {
            DatePicker(
                "Select date",
                selection: $date,
                in: fromToday,
                displayedComponents: .date
            )
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
            NavigationLink(destination: AddMealToMenu(selectedMeals: $selectedMeals)) {}.opacity(0.0)
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
            try menuViewModel.add(date: date, type: menuType, meals: selectedMeals)
            showAddMenu = false
        } catch {
            showError = true
        }
    }
    
    
}

struct AddMenuView_Previews: PreviewProvider {
    static var previews: some View {
        AddMenuView(showAddMenu: .constant(true))
            .environmentObject(MenuViewModel.preview)
            .environmentObject(MealViewModel.preview)
    }
}
