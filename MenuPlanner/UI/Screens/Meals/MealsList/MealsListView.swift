//
//  MealsListView.swift
//  MenuPlanner
//
//  Created by Julen Miner on 15/11/21.
//

import SwiftUI

struct MealsListView: View {
    @EnvironmentObject private var mealViewModel: MealViewModel
    
    @State private var showAddMeal = false
    @State private var selectedMeal: Meal?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(mealViewModel.meals.indices, id: \.self) { sectionIndex in
                    let category = mealViewModel.foodCategory(at: sectionIndex)
                    Section(header: Text("\(category?.emoji ?? "")  \(category?.name ?? "")")) {
                        ForEach(mealViewModel.meals[sectionIndex], id: \.self) { meal in
                            HStack {
                                Button(action: {
                                    selectedMeal = meal
                                }, label: {Text(meal.emoji ?? "")})
                                Text(meal.name ?? "")
                            }
                        }
                        .onDelete { offsets in
                            deleteItems(section: sectionIndex, at: offsets)
                        }
                    }
                }
            }
            .toolbar {
                Button(action: { showAddMeal = true }){
                    Label("Add Item", systemImage: "plus")
                }
            }
            .navigationTitle("Meals")
            .listStyle(.insetGrouped)
            .sheet(item: $selectedMeal, content: { meal in
                EditMealView(meal: meal)
            })
            .sheet(isPresented: $showAddMeal) {
                AddMealView(showAddMeal: $showAddMeal)
            }
        }
    }
    
    private func deleteItems(section: Int, at offsets: IndexSet) {
        withAnimation {
            mealViewModel.delete(section: section, at: offsets)
        }
    }
}

struct MealsListView_Previews: PreviewProvider {
    static var previews: some View {
        MealsListView()
            .environmentObject(MealViewModel.preview)
            .environmentObject(FoodCategoryViewModel.preview)
    }
}
