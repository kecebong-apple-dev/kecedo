//
//  TaskDataModel.swift
//  kecedo
//
//  Created by Raka Febrian Syahputra on 06/04/26.
//

import Foundation
import SwiftData

@Model
class TaskDataModel: Identifiable {
    @Attribute(.unique) var id: UUID
    var title: String
    var desc: String
    var startDate: Date
    var endDate: Date
    var priorityRaw: String
    var isDone: Bool
    var completedAt: Date?
 
    init(id: UUID = UUID(), title: String, desc: String, startDate: Date, endDate: Date, priority: String, isDone: Bool = false, completedAt: Date? = nil) {
        self.id = id
        self.title = title
        self.desc = desc
        self.startDate = startDate
        self.endDate = endDate
        self.priorityRaw = priority
        self.isDone = isDone
        self.completedAt = completedAt ?? (isDone ? Date() : nil)
    }
}
