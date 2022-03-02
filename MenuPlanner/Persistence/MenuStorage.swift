//
//  MenuStorage.swift
//  MenuPlanner
//
//  Created by Julen Miner on 15/11/21.
//

import Foundation
import CoreData
import Combine

class MenuStorage: NSObject, ObservableObject {
    var menus = CurrentValueSubject<[Menu], Never>([])
    private let menuFetchController: NSFetchedResultsController<Menu>
    
    private let viewContext: NSManagedObjectContext
    
    // Singleton instance
    static let shared: MenuStorage = MenuStorage()

    init(withViewContext viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
        let fetchRequest = Menu.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Menu.type, ascending: true)]
        menuFetchController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        
        menuFetchController.delegate = self
        
        do {
            try menuFetchController.performFetch()
            menus.value = menuFetchController.fetchedObjects ?? []
        } catch {
            NSLog("Error: could not fetch objects: \(error.localizedDescription)")
        }
    }
    
    func add(weekday: Int, type: MenuType, meals: [Meal]) {
        let newMenu = Menu(context: viewContext)
        newMenu.weekday = Int16(weekday)
        newMenu.menuId = UUID()
        newMenu.type = type.description
        newMenu.meals = NSOrderedSet(array: meals)
        
        saveContext()
    }
    
    func delete(ids: [UUID]) {
        let menusToDelete = menus.value.filter {
            guard let menuId = $0.menuId else { return false }
            return ids.contains(menuId)
        }
        menusToDelete.forEach { menu in
            viewContext.delete(menu)
        }
        
        saveContext()
    }
    
    func update(withId id: UUID, newWeekday weekday: Int, newType type: MenuType, newMeals meals: [Meal]) {
        guard let menu = menus.value.first(where: { $0.menuId == id }) else { return }
        
        menu.weekday = Int16(weekday)
        menu.type = type.description
        menu.meals = NSOrderedSet(array: meals)
        
        saveContext()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error while saving the menu context: \(error.localizedDescription)")
        }
    }

}

extension MenuStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let menus = controller.fetchedObjects as? [Menu] else { return }
        self.menus.value = menus
    }
}
