//
//  Persistence.swift
//  menuplanner
//
//  Created by Julen Miner on 1/9/21.
//

import CoreData

protocol PersistentStore {
    
}

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MenuPlanner")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

#if DEBUG
extension PersistenceController {
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        fillDummy(viewContext)
        return result
    }()
    
    static func fillDummy(_ viewContext: NSManagedObjectContext) {
        let previewCategory1 = FoodCategory(context: viewContext)
        previewCategory1.emoji = "🍝"
        previewCategory1.name = "Pasta"
        previewCategory1.categoryId = UUID()
        
        let previewCategory2 = FoodCategory(context: viewContext)
        previewCategory2.emoji = "🍮"
        previewCategory2.name = "Postres"
        previewCategory2.categoryId = UUID()
        
        let meal1 = Meal(context: viewContext)
        meal1.category = previewCategory1
        meal1.name = "Pasta con tomate"
        meal1.emoji = "🍝"
        meal1.mealId = UUID()
        
        let meal2 = Meal(context: viewContext)
        meal2.category = previewCategory1
        meal2.name = "Pasta con pesto"
        meal2.emoji = "🤑"
        meal2.mealId = UUID()
        
        let meal3 = Meal(context: viewContext)
        meal3.category = previewCategory2
        meal3.name = "Flan"
        meal3.emoji = "🍮"
        meal3.mealId = UUID()
        
        let meal4 = Meal(context: viewContext)
        meal4.category = previewCategory2
        meal4.name = "Tortitas con sirope de arce"
        meal4.emoji = "🥞"
        meal4.mealId = UUID()
        
        let meal5 = Meal(context: viewContext)
        meal5.category = previewCategory2
        meal5.name = "Tortitas con sirope de chocolate"
        meal5.emoji = "🥞"
        meal5.mealId = UUID()
        
        let meal6 = Meal(context: viewContext)
        meal6.category = previewCategory2
        meal6.name = "Tortitas con nata"
        meal6.emoji = "🥞"
        meal6.mealId = UUID()
        
        let meal7 = Meal(context: viewContext)
        meal7.category = previewCategory2
        meal7.name = "Café con leche"
        meal7.emoji = "☕️"
        meal7.mealId = UUID()
        
        let menu1 = Menu(context: viewContext)
        menu1.type = MenuType.breakfast.description
        menu1.weekday = 2
        menu1.meals = [meal1, meal2]
        menu1.menuId = UUID()
        
        let menu2 = Menu(context: viewContext)
        menu2.type = MenuType.lunch.description
        menu2.weekday = 2
        menu2.meals = [meal3, meal4, meal5]
        menu2.menuId = UUID()
        
        let menu3 = Menu(context: viewContext)
        menu3.type = MenuType.dinner.description
        menu3.weekday = 2
        menu3.meals = [meal6, meal7]
        menu3.menuId = UUID()
        
        let menu4 = Menu(context: viewContext)
        menu4.type = MenuType.breakfast.description
        menu4.weekday = 3
        menu4.meals = [meal6, meal7]
        menu4.menuId = UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")
        
        let menu5 = Menu(context: viewContext)
        menu5.type = MenuType.breakfast.description
        menu5.weekday = 4
        menu5.meals = [meal2, meal5]
        menu5.menuId = UUID()
        
        let menu6 = Menu(context: viewContext)
        menu6.type = MenuType.breakfast.description
        menu6.weekday = 7
        menu6.meals = [meal2, meal5]
        menu6.menuId = UUID()
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
#endif
