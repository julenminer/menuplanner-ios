//
//  MealStorage.swift
//  MenuPlanner
//
//  Created by Julen Miner on 15/11/21.
//

import Foundation
import CoreData
import Combine

class MealStorage: NSObject, ObservableObject {
    var meals = CurrentValueSubject<[Meal], Never>([])
    private let mealsFetchController: NSFetchedResultsController<Meal>
    
    private let viewContext: NSManagedObjectContext
    
    // Singleton instance
    static let shared: MealStorage = MealStorage()
    
    init(withViewContext viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
        let fetchRequest = Meal.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Meal.category?.name, ascending: true)]
        mealsFetchController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        
        mealsFetchController.delegate = self
        
        do {
            try mealsFetchController.performFetch()
            meals.value = mealsFetchController.fetchedObjects ?? []
        } catch {
            NSLog("Error: could not fetch objects: \(error.localizedDescription)")
        }
    }
    
    func add(name: String, emoji: String, foodCategory: FoodCategory) {
        let newMeal = Meal(context: viewContext)
        newMeal.name = name
        newMeal.emoji = emoji
        newMeal.category = foodCategory
        newMeal.mealId = UUID()

        saveContext()
    }
    
    func update(withId id: UUID, newName name: String, newEmoji emoji: String, newCategory category: FoodCategory) {
        guard let meal = meals.value.first(where: { $0.mealId == id }) else { return }
        
        meal.name = name
        meal.emoji = emoji
        meal.category = category
        
        saveContext()
    }
    
    func delete(ids: [UUID]) {
        let mealsToDelete = meals.value.filter {
            guard let mealId = $0.mealId else { return false }
            return ids.contains(mealId)
        }
        mealsToDelete.forEach { meal in
            viewContext.delete(meal)
        }
        
        saveContext()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error while saving the meal context: \(error.localizedDescription)")
        }
    }
}

extension MealStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let meals = controller.fetchedObjects as? [Meal] else { return }
        self.meals.value = meals
    }
}
