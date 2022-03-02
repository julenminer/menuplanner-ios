//
//  DateExtensions.swift
//  MenuPlanner
//
//  Created by Julen Miner on 18/11/21.
//

import Foundation

extension Date{
    func isSameDayAs(_ date: Date) -> Bool {
        return Calendar.current.compare(self, to: date, toGranularity: .day) == .orderedSame
    }
    
    func toLocaleStringWithoutTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        return dateFormatter.string(from: self)
    }
    
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        
        return dateFormatter.string(from: self)
    }
    
    func longDayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        return dateFormatter.string(from: self)
    }
    
    func weekdayNumber() -> Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    func day() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        
        return dateFormatter.string(from: self)
    }
    
    func week() -> [Date] {
        return Calendar.current.daysWithSameWeekOfYear(as: self)
    }
    
    func previousWeek() -> Date {
        return Calendar.current.date(byAdding: .day, value: -7, to: self)!
    }
    
    func followingWeek() -> Date {
        return Calendar.current.date(byAdding: .day, value: 7, to: self)!
    }
}

import Foundation

extension Calendar {
  func intervalOfWeek(for date: Date) -> DateInterval? {
    dateInterval(of: .weekOfYear, for: date)
  }

  func startOfWeek(for date: Date) -> Date? {
    intervalOfWeek(for: date)?.start
  }

  func daysWithSameWeekOfYear(as date: Date) -> [Date] {
    guard let startOfWeek = startOfWeek(for: date) else {
      return []
    }

    return (0 ... 6).reduce(into: []) { result, daysToAdd in
      result.append(Calendar.current.date(byAdding: .day, value: daysToAdd, to: startOfWeek))
    }
    .compactMap { $0 }
  }
}
