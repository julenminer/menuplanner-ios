//
//  AddMenuView.swift
//  MenuPlanner
//
//  Created by Julen Miner on 18/11/21.
//

import SwiftUI

struct AddMenuView: View {
    @EnvironmentObject private var menuViewModel: MenuViewModel
    @EnvironmentObject private var mealViewModel: MealViewModel
    
    @Binding var showAddMenu: Bool
    
    @State var date: Date = Date()
    @State var menuType: MenuType = .breakfast
    
    var body: some View {
        NavigationView {
            Form{
                datePicker
                menuTypePicker
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
    
    private func save() {
    }
    
    
}

struct AddMenuView_Previews: PreviewProvider {
    static var previews: some View {
        AddMenuView(showAddMenu: .constant(true))
            .environmentObject(MenuViewModel.preview)
            .environmentObject(MealViewModel.preview)
    }
}
