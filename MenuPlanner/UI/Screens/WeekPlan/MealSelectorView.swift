//
//  MealSelectorView.swift
//  MenuPlanner
//
//  Created by Julen Miner on 21/2/22.
//

import SwiftUI

struct MealSelectorView: View {
    @EnvironmentObject private var mealViewModel: MealViewModel
    
    @Binding var selectedMeals: [Meal]
    
    var body: some View {
        List {
            ForEach(mealViewModel.meals.indices, id: \.self) { sectionIndex in
                let category = mealViewModel.foodCategory(at: sectionIndex)
                Section(header: Text("\(category?.emoji ?? "")  \(category?.name ?? "")")) {
                    ForEach(mealViewModel.meals[sectionIndex], id: \.self) { meal in
                        HStack {
                            Button(action: {
                                onMealClick(meal)
                            }, label: {Text(meal.emoji ?? "")})
                            Text(meal.name ?? "")
                            Spacer()
                            if(selectedMeals.contains(meal)) {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func onMealClick(_ meal: Meal) {
        if let index = selectedMeals.firstIndex(of: meal) {
            selectedMeals.remove(at: index)
        } else {
            selectedMeals.append(meal)
        }
    }
}

struct MealSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        SelectorPreview()
    }
    
    struct SelectorPreview: View {
        @State var selectedMeals = [Meal]()
        
        var body: some View {
            MealSelectorView(selectedMeals: $selectedMeals)
                .environmentObject(MealViewModel.preview)
        }
    }
}
