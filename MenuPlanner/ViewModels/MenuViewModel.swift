//
//  MenuViewModel.swift
//  MenuPlanner
//
//  Created by Julen Miner on 15/11/21.
//

import Foundation
import Combine
import UIKit

class MenuViewModel: ObservableObject {
    @Published var menus: Dictionary<Int, [Array<Menu>.Element]> = [:]
    private var rawMenus: [Menu] = []
    
    private var cancellable: AnyCancellable?
    private var menuStorage: MenuStorage
    
    init(menuStorage: MenuStorage = MenuStorage.shared, menuPublisher: AnyPublisher<[Menu], Never> = MenuStorage.shared.menus.eraseToAnyPublisher()) {
        self.menuStorage = menuStorage
        cancellable = menuPublisher.sink { menus in
            self.rawMenus = menus
            self.menus = Dictionary(grouping: menus) { Int($0.weekday) }
        }
    }
    
    func add(weekday: Int, type: MenuType, meals: [Meal]) throws {
        if(existsMenu(atWeekday: weekday, withType: type)) {
            throw MenuViewModelError.DuplicateMenu
        } else {
            menuStorage.add(weekday: weekday, type: type, meals: meals)
        }
    }
    
    func existsMenu(atWeekday weekday: Int, withType type: MenuType) -> Bool {
        guard let menus = menus[weekday] else { return false }
        return menus.contains { $0.type == type.description }
    }
    
    func delete(byId id: UUID) {
        menuStorage.delete(ids: [id])
    }
    
    func update(withId id: UUID, newWeekday weekday: Int, newType type: MenuType, newMeals meals: [Meal]) throws {
        if isSameDateAndType(forId: id, weekday: weekday, type: type) {
            menuStorage.update(withId: id, newWeekday: weekday, newType: type, newMeals: meals)
        } else if existsMenu(atWeekday: weekday, withType: type) {
            throw MenuViewModelError.DuplicateMenu
        } else {
            menuStorage.update(withId: id, newWeekday: weekday, newType: type, newMeals: meals)
        }
    }
    
    func getMenu(withId id: UUID) -> Menu? {
        guard let menu = rawMenus.first(where: { $0.menuId == id }) else { return nil }
        return menu
    }
    
    private func isSameDateAndType(forId id: UUID, weekday: Int, type: MenuType) -> Bool {
        guard let menu = getMenu(withId: id) else { return false }
        return menu.weekday == weekday && menu.type == type.description
    }
}

enum MenuViewModelError: Error {
    case DuplicateMenu
}

struct MenuModel: Identifiable {
    var id = UUID()
    
    var date: Date
    var breakfast: Menu?
    var lunch: Menu?
    var dinner: Menu?
    
    init(date: Date, withMenu menu: Menu) {
        self.date = date
        addMenu(menu)
    }
    
    mutating func addMenu(_ menu: Menu) {
        guard let menuTypeString = menu.type else { return }
        let menuType = MenuType.fromString(menuTypeString)
        switch(menuType) {
        case .breakfast:
            self.breakfast = menu
        case .lunch:
            self.lunch = menu
        case .dinner:
            self.dinner = menu
        }
    }
    
    func breakfastMeals() -> (UUID, [Meal])? {
        guard let breakfastId = breakfast?.menuId else { return nil }
        guard let breakfastMeals = breakfast?.meals?.array as? [Meal] else { return nil }
        if breakfastMeals.isEmpty { return nil } else { return (breakfastId, breakfastMeals) }
    }
    
    func lunchMeals() -> (UUID, [Meal])? {
        guard let lunchId = lunch?.menuId else { return nil }
        guard let lunchMeals = lunch?.meals?.array as? [Meal] else { return nil }
        if lunchMeals.isEmpty { return nil } else { return (lunchId, lunchMeals) }
    }
    
    func dinnerMeals() -> (UUID, [Meal])? {
        guard let dinnerId = dinner?.menuId else { return nil }
        guard let dinnerMeals = dinner?.meals?.array as? [Meal] else { return nil }
        if dinnerMeals.isEmpty { return nil } else { return (dinnerId, dinnerMeals) }
    }
}

#if DEBUG
extension MenuViewModel {
    static var preview: MenuViewModel {
        let menuStorage = MenuStorage(withViewContext: PersistenceController.preview.container.viewContext)
        return MenuViewModel(menuStorage: menuStorage, menuPublisher: menuStorage.menus.eraseToAnyPublisher())
    }
}
#endif
