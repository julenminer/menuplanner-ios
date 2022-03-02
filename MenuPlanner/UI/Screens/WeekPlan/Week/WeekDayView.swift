//
//  WeekDayView.swift
//  MenuPlanner
//
//  Created by Julen Miner on 19/2/22.
//

import SwiftUI

struct WeekDayView: View {
    
    let date: String
    let isSelected: Bool

    var body: some View {
        if isSelected {
            selectedDateText
        } else {
            dateText
        }
    }
    
    private var dateText: some View {
        Text(date)
            .fixedSize(horizontal: false, vertical: true)
            .lineLimit(1)
            .font(.footnote)
            .truncationMode(.middle)
            .frame(width: 40, height: 40, alignment: .center)
    }
    
    private var selectedDateText: some View {
        dateText
            .background(Color.accentColor)
            .clipShape(Circle())
            .foregroundColor(Color.white)
    }
}

struct WeekDayView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WeekDayView(date: "Mon", isSelected: false)
                .previewLayout(.sizeThatFits)
            WeekDayView(date: "Mon", isSelected: true)
                .previewLayout(.sizeThatFits)
            WeekDayView(date: "Mon", isSelected: false)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
            WeekDayView(date: "Mon", isSelected: true)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
        
    }
}
