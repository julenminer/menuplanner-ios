//
//  MealViewModel.swift
//  MenuPlanner
//
//  Created by Julen Miner on 15/11/21.
//

import Foundation
import Combine

class MealViewModel: ObservableObject {
    @Published var meals: [[Meal]] = []
    
    private var cancellable: AnyCancellable?
    private var mealStorage: MealStorage

    init(mealStorage: MealStorage = MealStorage.shared, mealPublisher: AnyPublisher<[Meal], Never> = MealStorage.shared.meals.eraseToAnyPublisher()) {
        self.mealStorage = mealStorage
        cancellable = mealPublisher.sink { meals in
            self.meals = self.groupMeals(meals.sorted(by: self.sortMeals(_:_:)))
        }
    }
    
    func foodCategory(at index: Int) -> FoodCategory? {
        return meals[index].first?.category
    }
    
    private func sortMeals(_ meal1: Meal, _ meal2: Meal) -> Bool {
        if(meal1.category == meal2.category) {
            return meal1.name! < meal2.name!
        } else {
            return meal1.category!.name! < meal2.category!.name!
        }
    }
    
    private func groupMeals(_ meals: [Meal]) -> [[Meal]] {
        var groupedMeals = [[Meal]]()
        var previousCategory: FoodCategory?
        var currentIndex = 0
        for meal in meals {
            if(previousCategory == nil) {
                groupedMeals.append([meal])
            } else if (previousCategory == meal.category) {
                groupedMeals[currentIndex].append(meal)
            } else {
                currentIndex += 1;
                groupedMeals.append([meal])
            }
            previousCategory = meal.category
        }
        return groupedMeals
    }
    
    func add(name: String, emoji: String, category: FoodCategory) {
        mealStorage.add(name: name, emoji: emoji, foodCategory: category)
    }
    
    func update(withId id: UUID, newName name: String, newEmoji emoji: String, newCategory category: FoodCategory) {
        mealStorage.update(withId: id, newName: name, newEmoji: emoji, newCategory: category)
    }
    
    func delete(section: Int, at offsets: IndexSet) {
        var mealsToDelete = [Meal]()
        for index in offsets {
            let meal = meals[section][index]
            if(meal.mealId != nil) {
                mealsToDelete.append(meal)
            }
        }
        mealStorage.delete(ids: mealsToDelete.map { $0.mealId! })
    }
}

#if DEBUG
extension MealViewModel {
    static var preview: MealViewModel {
        let mealStorage = MealStorage(withViewContext: PersistenceController.preview.container.viewContext)
        return MealViewModel(mealStorage: mealStorage, mealPublisher: mealStorage.meals.eraseToAnyPublisher())
    }
}
#endif
