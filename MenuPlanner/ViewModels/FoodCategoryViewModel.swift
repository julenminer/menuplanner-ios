//
//  FoodCategoryViewModel.swift
//  MenuPlanner
//
//  Created by Julen Miner on 12/11/21.
//

import Foundation
import Combine

class FoodCategoryViewModel: ObservableObject {
    @Published var categories: [FoodCategory] = []
    
    private var cancellable: AnyCancellable?
    private var foodCategoryStorage: FoodCategoryStorage
    
    init(foodCategoryStorage: FoodCategoryStorage = FoodCategoryStorage.shared, foodCategoryPublisher: AnyPublisher<[FoodCategory], Never> = FoodCategoryStorage.shared.categories.eraseToAnyPublisher()) {
        
        self.foodCategoryStorage = foodCategoryStorage
        cancellable = foodCategoryPublisher.sink { categories in
            self.categories = categories
        }
    }
    
    func add(name: String, emoji: String) {
        foodCategoryStorage.add(name: name, emoji: emoji)
    }
    
    func update(withId id: UUID, newName name: String, newEmoji emoji: String) {
        foodCategoryStorage.update(withId: id, newName: name, newEmoji: emoji)
    }
    
    func delete(at offsets: IndexSet) {
        var categoriesToDelete = [FoodCategory]()
        for index in offsets {
            let category = categories[index]
            if(category.categoryId != nil) {
                categoriesToDelete.append(category)
            }
        }
        foodCategoryStorage.delete(ids: categoriesToDelete.map { $0.categoryId! })
    }
}

#if DEBUG
extension FoodCategoryViewModel {
    static var preview: FoodCategoryViewModel {
        let foodCategoryStorage = FoodCategoryStorage(withViewContext: PersistenceController.preview.container.viewContext)
        return FoodCategoryViewModel(foodCategoryStorage: foodCategoryStorage, foodCategoryPublisher: foodCategoryStorage.categories.eraseToAnyPublisher())
    }
}
#endif
