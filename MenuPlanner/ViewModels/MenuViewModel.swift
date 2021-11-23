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
            } else if (Calendar.current.compare(previousDate!, to: menu.date!, toGranularity: .day) == .orderedSame) {
                groupedMenus[currentIndex].addMenu(menu)
            } else {
                currentIndex += 1
                groupedMenus.append(MenuModel(date: menu.date!, withMenu: menu))
            }
            previousDate = menu.date!
        }
        return groupedMenus
    }
    
    func add(date: Date, type: MenuType, meals: [Meal]) {
        menuStorage.add(date: date, type: type, meals: meals)
    }
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
    
    func breakfastMeals() -> [Meal]? {
        guard let breakfast = breakfast?.meals?.array as? [Meal] else {
            return nil
        }
        if breakfast.isEmpty { return nil } else { return breakfast }

    }
    
    func lunchMeals() -> [Meal]? {
        guard let lunch = lunch?.meals?.array as? [Meal] else {
            return nil
        }
        if lunch.isEmpty { return nil } else { return lunch }
    }
    
    func dinnerMeals() -> [Meal]? {
        guard let dinner = dinner?.meals?.array as? [Meal] else {
            return nil
        }
        if dinner.isEmpty { return nil } else { return dinner }
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
