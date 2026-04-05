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
    
    init(id: UUID = UUID(), title: String, description: String, startDate: Date, endDate: Date) {
        self.id = id
        self.title = title
        self.desc = description
        self.startDate = startDate
        self.endDate = endDate
    }
    
    static var dummyTasks: [TaskModel] {
        let now = Date()
        
        let task1 = TaskModel(title: "Finish SwiftUI Onboarding", description: "Lorem ipsum dolor sit amet", startDate: now, endDate: now.addingTimeInterval(96000))
        let task2 = TaskModel(title: "Read Self-Learning Research Paper", description: "Lorem ipsum dolor sit amet", startDate: now, endDate: now.addingTimeInterval(86400 * 2))
        
        return [task1, task2]
    }
}
