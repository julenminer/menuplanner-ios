//
//  CategoriesListView.swift
//  menuplanner
//
//  Created by Julen Miner on 1/9/21.
//

import SwiftUI
import CoreData

struct CategoriesListView: View {
    @EnvironmentObject private var foodCategoryViewModel: FoodCategoryViewModel
    
    @State private var showAddCategory = false
    @State private var selectedCategory: FoodCategory?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(foodCategoryViewModel.categories) { category in
                    HStack {
                        Button(action: {
                            selectedCategory = category
                        }, label: { Text(category.emoji ?? "") })
                        Text(category.name ?? "")
                    }
                }
                .onDelete(perform: deleteItems)
                
            }
            .toolbar {
                Button(action: { showAddCategory = true }){
                    Label("Add Item", systemImage: "plus")
                }
            }
            .navigationTitle("Categories")
            .listStyle(InsetGroupedListStyle())
            .sheet(item: $selectedCategory, content: { category in
                EditCategoryView(category: category)
            })
            .sheet(isPresented: $showAddCategory) {
                AddCategoryView(showAddCategory: $showAddCategory)
            }
        }
    }
    
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            foodCategoryViewModel.delete(at: offsets)
        }
    }
}

struct CategoriesListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesListView()
            .environmentObject(FoodCategoryViewModel.preview)
    }
}
