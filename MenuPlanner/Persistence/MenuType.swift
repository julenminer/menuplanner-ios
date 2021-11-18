//
//  MenuType.swift
//  MenuPlanner
//
//  Created by Julen Miner on 15/11/21.
//

import Foundation

enum MenuType {
    case breakfast
    case lunch
    case dinner
    
    var description: String {
        switch self {
        case .breakfast: return "1 BREAKFAST"
        case .lunch: return "2 LUNCH"
        case .dinner: return "3 DINNER"
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
