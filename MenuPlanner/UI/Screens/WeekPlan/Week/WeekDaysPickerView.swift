//
//  WeekDaysPickerView.swift
//  MenuPlanner
//
//  Created by Julen Miner on 21/2/22.
//

import SwiftUI

struct WeekDaysPickerView: View {
    let week: [Date]
    @Binding var selectedDates: [Date]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(week, id: \.self) { day in
                let isSelected = selectedDates.contains(where: { $0.isSameDayAs(day)})
                WeekDayView(date: day.dayOfTheWeek(), isSelected: isSelected)
                    .onTapGesture {
                        if (isSelected) {
                            selectedDates.removeAll(where: { $0.isSameDayAs(day)} )
                        } else {
                            selectedDates.append(day)
                        }
                    }
                if day != week.last {
                    Spacer()
                }
            }
        }
    }
}

struct WeekDaysPickerView_Previews: PreviewProvider {
    static var previews: some View {
        let today = Date()
        let week = today.week()

        WeekDaysPickerView(week: week, selectedDates: .constant([today]))
            .previewLayout(.sizeThatFits)
    }
}
