//
//  WeekView.swift
//  MenuPlanner
//
//  Created by Julen Miner on 19/2/22.
//

import SwiftUI

struct WeekView: View {
    let week: [Date]
    @Binding var selectedDate: Date
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(week, id: \.self) { day in
                WeekDayView(date: day.dayOfTheWeek(), isSelected: selectedDate.isSameDayAs(day))
                    .onTapGesture {
                        selectedDate = day
                    }
                if day != week.last {
                    Spacer()
                }
            }
        }
    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        let today = Date()
        let week = today.week()
        WeekView(week: week, selectedDate: .constant(today))
            .previewLayout(.sizeThatFits)
        WeekView(week: week, selectedDate: .constant(today))
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
