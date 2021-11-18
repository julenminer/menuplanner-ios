//
//  EditMealView.swift
//  MenuPlanner
//
//  Created by Julen Miner on 15/11/21.
//

import SwiftUI

struct EditMealView: View {
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject private var foodCategoryViewModel: FoodCategoryViewModel
    @EnvironmentObject private var mealViewModel: MealViewModel

    var meal: Meal
    
    @State var name: String
    @State var isNameCorrect = true
    @State var emoji: String
    @State var isEmojiCorrect = true
    @State var foodCategoryIndex: Int = 0
    
    init(meal: Meal) {
        self.meal = meal
        self._name = State(initialValue: meal.name ?? "")
        self._emoji = State(initialValue: meal.emoji ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                mealNameTextField
                emojiTextField
                foodCategoryPicker
            }
            .navigationTitle("Edit meal")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: dismiss) {
                    Text("Close")
                },
                trailing: Button(action: update) {
                    Text("Update")
                })
        }
        .onAppear {
            foodCategoryIndex =  foodCategoryViewModel.categories.firstIndex(where: { $0.categoryId == meal.category?.categoryId}) ?? 0
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
    
    private func update() {
        withAnimation {
            isNameCorrect = validateName(name: name)
            isEmojiCorrect = validateEmoji(emoji: emoji)
        }
        if(self.isNameCorrect && self.isEmojiCorrect) {
            let foodCategory = foodCategoryViewModel.categories[foodCategoryIndex]
            guard let id = meal.mealId else { return }
            mealViewModel.update(withId: id, newName: name, newEmoji: emoji, newCategory: foodCategory)
            
            dismiss()
        }
    }
    
    private func validateName(name: String) -> Bool {
        return !name.isEmpty
    }
    
    private func validateEmoji(emoji: String) -> Bool{
        return emoji.isSingleEmoji
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct EditMealView_Previews: PreviewProvider {
    static var previews: some View {
        EditMealView(meal: MealViewModel.preview.meals[0][0])
            .environmentObject(MealViewModel.preview)
            .environmentObject(FoodCategoryViewModel.preview)
    }
}
