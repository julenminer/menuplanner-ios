//
//  MenuType.swift
//  MenuPlanner
//
//  Created by Julen Miner on 15/11/21.
//

import Foundation

enum MenuType: CaseIterable {
    case breakfast
    case lunch
    case dinner
    
    var description: String {
        switch self {
        case .breakfast: return "Breakfast"
        case .lunch: return "Lunch"
        case .dinner: return "Dinner"
        }
    }
    
    static func fromString(_ type: String) -> MenuType {
        switch(type){
        case MenuType.breakfast.description: return .breakfast
        case MenuType.lunch.description: return .lunch
        case MenuType.dinner.description: return .dinner
        default: return .breakfast
        }
    }
}
