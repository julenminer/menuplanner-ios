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
    @Published var menus: [MenuModel] = []
    
    private var cancellable: AnyCancellable?
    private var menuStorage: MenuStorage
    
    init(menuStorage: MenuStorage = MenuStorage.shared, menuPublisher: AnyPublisher<[Menu], Never> = MenuStorage.shared.menus.eraseToAnyPublisher()) {
        self.menuStorage = menuStorage
        cancellable = menuPublisher.sink { menus in
            self.menus = self.menusToMenuModelList(menus: menus)
        }
    }
    
    private func menusToMenuModelList(menus: [Menu]) -> [MenuModel] {
        var groupedMenus = [MenuModel]()
        var previousDate: Date?
        var currentIndex = 0
        for menu in menus {
            if(previousDate == nil) {
                groupedMenus.append(MenuModel(date: menu.date!, withMenu: menu))
            } else if (sameDate(previousDate!, menu.date!)){
                groupedMenus[currentIndex].addMenu(menu)
            } else {
                currentIndex += 1
                groupedMenus.append(MenuModel(date: menu.date!, withMenu: menu))
            }
            previousDate = menu.date!
        }
        return groupedMenus
    }
    
    private func sameDate(_ date1: Date, _ date2: Date) -> Bool {
        return Calendar.current.compare(date1, to: date2, toGranularity: .day) == .orderedSame
    }
    
    func add(date: Date, type: MenuType, meals: [Meal]) throws {
        if(existsMenu(atDate: date, withType: type)) {
            throw MenuViewModelError.DuplicateMenu
        } else {
            menuStorage.add(date: date, type: type, meals: meals)
        }
    }
    
    private func existsMenu(atDate date: Date, withType type: MenuType) -> Bool {
        guard let menu = menus.first(where: { sameDate($0.date, date) }) else { return false }
        switch(type) {
        case .breakfast:
            return menu.breakfast != nil
        case .lunch:
            return menu.lunch != nil
        case .dinner:
            return menu.dinner != nil
        }
    }
    
    func delete(byId id: UUID) {
        menuStorage.delete(ids: [id])
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
