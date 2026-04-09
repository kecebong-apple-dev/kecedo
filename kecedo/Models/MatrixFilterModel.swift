//
//  MatrixFilterModel.swift
//  kecedo
//
//  Created by Nathan Gitu Loh on 06/04/26.
//

import Foundation

enum DateFilterType: String, CaseIterable, Identifiable {
    case all = "All"
    case today = "Today"
    case week = "Week"
    case period = "Period"
    
    var id: String { rawValue }
}

struct MatrixFilterState: Equatable {
    var dateType: DateFilterType = .all
    var startDate: Date = Date()
    var endDate: Date = Date().addingTimeInterval(86400 * 7)
    var showCompleted: Bool = true
}

extension Array where Element == TaskModel {
    func applying(filter: MatrixFilterState) -> [TaskModel] {
        self.filter { task in
            
            // Filter by completion status
            if !filter.showCompleted && task.isDone { return false }
            
            // Filter by date
            let calendar = Calendar.current
            switch filter.dateType {
            case .all:
                return true
            case .today:
                return calendar.isDateInToday(task.endDate)
            case .week:
                if let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())),
                   let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek) {
                    return task.endDate >= startOfWeek && task.endDate < endOfWeek
                }
                return true
            case .period:
                let start = calendar.startOfDay(for: filter.startDate)
                let end = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: filter.endDate)) ?? filter.endDate
                return task.endDate >= start && task.endDate < end
            }
        }
    }
}
