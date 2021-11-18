//
//  FoodCategoryStorage.swift
//  MenuPlanner
//
//  Created by Julen Miner on 12/11/21.
//

import Foundation
import CoreData
import Combine

class FoodCategoryStorage: NSObject, ObservableObject {
    var categories = CurrentValueSubject<[FoodCategory], Never>([])
    private let categoriesFetchController: NSFetchedResultsController<FoodCategory>
    
    private let viewContext: NSManagedObjectContext
    
    // Singleton instance
    static let shared: FoodCategoryStorage = FoodCategoryStorage()
    
    init(withViewContext viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
        let fetchRequest = FoodCategory.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \FoodCategory.name, ascending: true)]
        categoriesFetchController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        
        categoriesFetchController.delegate = self
        
        do {
            try categoriesFetchController.performFetch()
            categories.value = categoriesFetchController.fetchedObjects ?? []
        } catch {
            NSLog("Error: could not fetch objects: \(error.localizedDescription)")
        }
    }
    
    func add(name: String, emoji: String) {
        let newCategory = FoodCategory(context: viewContext)
        newCategory.name = name
        newCategory.emoji = emoji
        newCategory.categoryId = UUID()

        saveContext()
    }
    
    func update(withId id: UUID, newName name: String, newEmoji emoji: String) {
        guard let category = categories.value.first(where: { $0.categoryId == id }) else { return }
        
        category.name = name
        category.emoji = emoji
        
        saveContext()
    }
    
    func delete(ids: [UUID]) {
        let categoriesToDelete = categories.value.filter {
            guard let categoryId = $0.categoryId else { return false }
            return ids.contains(categoryId)
        }
        categoriesToDelete.forEach { category in
            viewContext.delete(category)
        }
        
        saveContext()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error while saving the food category context: \(error.localizedDescription)")
        }
    }
}

extension FoodCategoryStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let categories = controller.fetchedObjects as? [FoodCategory] else { return }
        self.categories.value = categories
    }
}
