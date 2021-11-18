//
//  DateExtensions.swift
//  MenuPlanner
//
//  Created by Julen Miner on 18/11/21.
//

import Foundation

extension Date{
    func toLocaleStringWithoutTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        return dateFormatter.string(from: self)
    }
}
