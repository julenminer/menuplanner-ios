//
//  AddCategoryView.swift
//  menuplanner
//
//  Created by Julen Miner on 9/9/21.
//

import SwiftUI

struct AddCategoryView: View {
    @EnvironmentObject private var foodCategoryViewModel: FoodCategoryViewModel
    
    @Binding var showAddCategory: Bool
    
    @State var name = ""
    @State var isNameCorrect = true
    @State var emoji = ""
    @State var isEmojiCorrect = true
    
    var body: some View {
        NavigationView {
            Form {
                categoryNameTextField
                emojiTextField
            }
            .navigationTitle("Add new category")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: { showAddCategory = false }) {
                    Text("Close")
                },
                trailing: Button(action: save) {
                    Text("Save")
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
    
    private func save() {
        withAnimation {
            isNameCorrect = validateName(name: name)
            isEmojiCorrect = validateEmoji(emoji: emoji)
        }
        if(self.isNameCorrect && self.isEmojiCorrect) {
            withAnimation {
                foodCategoryViewModel.add(name: name, emoji: emoji)
            }
            showAddCategory = false
        }
    }
    
    private func validateName(name: String) -> Bool {
        return !name.isEmpty
    }
    
    private func validateEmoji(emoji: String) -> Bool{
        return emoji.isSingleEmoji
    }
}

struct AddCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddCategoryView(showAddCategory: .constant(true))
            .environmentObject(FoodCategoryViewModel.preview)
    }
}
