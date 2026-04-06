//
//  Task.swift
//  kecedo
//
//  Created by Raka Febrian Syahputra on 06/04/26.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class TaskModel: Identifiable {
    @Attribute(.unique) var id: UUID
    var title: String
    var desc: String
    var startDate: Date
    var endDate: Date
    var priority: Priority
    
    init(id: UUID = UUID(), title: String, desc: String, startDate: Date, endDate: Date, priority: Priority) {
        self.id = id
        self.title = title
        self.desc = desc
        self.startDate = startDate
        self.endDate = endDate
        self.priority = priority
    }
    
    static var dummyTasks: [TaskModel] {
        let now = Date()
        
        let task1 = TaskModel(title: "Finish SwiftUI Onboarding", desc: "Lorem ipsum dolor sit amet", startDate: now, endDate: now.addingTimeInterval(96000), priority: Priority.doFirst)
        let task2 = TaskModel(title: "Read Self-Learning Research Paper", desc: "Lorem ipsum dolor sit amet", startDate: now, endDate: now.addingTimeInterval(86400 * 2), priority: Priority.schedule)
        
        return [task1, task2]
    }
}
