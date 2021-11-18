//
//  AddMealView.swift
//  MenuPlanner
//
//  Created by Julen Miner on 15/11/21.
//

import SwiftUI

struct AddMealView: View {
    @EnvironmentObject private var foodCategoryViewModel: FoodCategoryViewModel
    @EnvironmentObject private var mealViewModel: MealViewModel
    
    @Binding var showAddMeal: Bool
    
    @State var name = ""
    @State var isNameCorrect = true
    @State var emoji = ""
    @State var isEmojiCorrect = true
    @State var foodCategoryIndex = 0
    
    var body: some View {
        NavigationView {
            Form {
                mealNameTextField
                emojiTextField
                foodCategoryPicker
            }
            .navigationTitle("Add new category")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: { showAddMeal = false }) {
                    Text("Close")
                },
                trailing: Button(action: save) {
                    Text("Save")
                })
        }
    }
    
    private var mealNameTextField: some View {
        ValidatedSectionTextField(
            sectionHeader: "Meal name",
            textFieldTitle: "Name",
            text: $name,
            isTextValid: $isNameCorrect,
            errorText: "Name value can not be empty",
            validation: validateName(name:))
    }
    
    private var emojiTextField: some View {
        ValidatedSectionTextField(
            sectionHeader: "Meal emoji",
            textFieldTitle: "Emoji",
            text: $emoji,
            isTextValid: $isEmojiCorrect,
            errorText: "You have to select one emoji",
            validation: validateEmoji(emoji:))
    }
    
    private var foodCategoryPicker: some View {
        Section {
            Picker("Category", selection: $foodCategoryIndex) {
                ForEach(0..<foodCategoryViewModel.categories.count) { index in
                    let category = foodCategoryViewModel.categories[index]
                    Text("\(category.emoji ?? "")  \(category.name ?? "")")
                        .tag(index)
                }
            }
        }
    }
    
    private func save() {
        withAnimation {
            isNameCorrect = validateName(name: name)
            isEmojiCorrect = validateEmoji(emoji: emoji)
        }
        if(self.isNameCorrect && self.isEmojiCorrect) {
            let foodCategory = foodCategoryViewModel.categories[foodCategoryIndex]
            withAnimation {
                mealViewModel.add(name: name, emoji: emoji, category: foodCategory)
            }
            showAddMeal = false
        }
    }
    
    private func validateName(name: String) -> Bool {
        return !name.isEmpty
    }
    
    private func validateEmoji(emoji: String) -> Bool{
        return emoji.isSingleEmoji
    }
}

struct AddMealView_Previews: PreviewProvider {
    static var previews: some View {
        AddMealView(showAddMeal: .constant(true))
            .environmentObject(MealViewModel.preview)
            .environmentObject(FoodCategoryViewModel.preview)
    }
}
