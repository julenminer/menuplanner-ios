//
//  EditCategoryView.swift
//  MenuPlanner
//
//  Created by Julen Miner on 6/10/21.
//

import SwiftUI

struct EditCategoryView: View {
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject private var foodCategoryViewModel: FoodCategoryViewModel
        
    var category: FoodCategory
    
    @State var name: String
    @State var isNameCorrect = true
    @State var emoji: String
    @State var isEmojiCorrect = true
    
    init(category: FoodCategory) {
        self.category = category
        self._name = State(initialValue: category.name ?? "")
        self._emoji = State(initialValue: category.emoji ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form{
                categoryNameTextField
                emojiTextField
            }
            .navigationTitle("Update category")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: dismiss) {
                    Text("Close")
                },
                trailing: Button(action: update) {
                    Text("Update")
                })
        }
    }
    
    private var categoryNameTextField: some View {
        ValidatedSectionTextField(
            sectionHeader: "Category name",
            textFieldTitle: "Name",
            text: $name,
            isTextValid: $isNameCorrect,
            errorText: "Name value can not be empty",
            validation: validateName(name:))
    }
    
    private var emojiTextField: some View {
        ValidatedSectionTextField(
            sectionHeader: "Category emoji",
            textFieldTitle: "Emoji",
            text: $emoji,
            isTextValid: $isEmojiCorrect,
            errorText: "You have to select one emoji",
            validation: validateEmoji(emoji:))
    }
    
    private func update() {
        withAnimation {
            isNameCorrect = validateName(name: name)
            isEmojiCorrect = validateEmoji(emoji: emoji)
        }
        if(self.isNameCorrect && self.isEmojiCorrect) {
            guard let id = category.categoryId else { return }
            foodCategoryViewModel.update(withId: id, newName: name, newEmoji: emoji)
            dismiss()
        }
    }
    
    private func validateName(name: String) -> Bool {
        return !name.isEmpty
    }
    
    private func validateEmoji(emoji: String) -> Bool {
        return emoji.isSingleEmoji
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct EditCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        EditCategoryView(category: FoodCategoryViewModel.preview.categories[0])
            .environmentObject(FoodCategoryViewModel.preview)
    }
}
