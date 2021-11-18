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
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Menu.date, ascending: true), NSSortDescriptor(keyPath: \Menu.type, ascending: true)]
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
}

extension MenuStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let menus = controller.fetchedObjects as? [Menu] else { return }
        self.menus.value = menus
    }
}
