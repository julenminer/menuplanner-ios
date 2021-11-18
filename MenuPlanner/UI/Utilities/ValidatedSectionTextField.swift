//
//  ValidatedSectionTextField.swift
//  MenuPlanner
//
//  Created by Julen Miner on 15/11/21.
//

import SwiftUI

struct ValidatedSectionTextField: View {
    
    let sectionHeader: String
    let textFieldTitle: String
    @Binding var text: String
    @Binding var isTextValid: Bool
    let errorText: String
    let validation: (String) -> Bool
    
    var body: some View {
        Section(header: Text(sectionHeader)) {
            TextField(textFieldTitle, text: $text)
                .onChange(of: text) { _ in
                    withAnimation {
                        isTextValid = validation(text)
                    }
                }
            if(!isTextValid) {
                Text(errorText)
                    .font(.caption)
                    .foregroundColor(Color.red)
            }
        }
    }
}

struct ValidatedSectionTextField_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            ValidatedSectionTextField(
                sectionHeader: "Section header",
                textFieldTitle: "Name",
                text: .constant(""),
                isTextValid: .constant(false),
                errorText: "Error"
            ) { text in return !text.isEmpty }
        }.previewLayout(.sizeThatFits)
    }
}
