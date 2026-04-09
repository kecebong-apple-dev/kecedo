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
    var isDone: Bool
    var completedAt: Date?
 
    init(id: UUID = UUID(), title: String, desc: String, startDate: Date, endDate: Date, priority: Priority, isDone: Bool = false, completedAt: Date? = nil) {
        self.id = id
        self.title = title
        self.desc = desc
        self.startDate = startDate
        self.endDate = endDate
        self.priority = priority
        self.isDone = isDone
        self.completedAt = completedAt ?? (isDone ? Date() : nil)
    }
    
    func toggleDone() {
        isDone.toggle()
        completedAt = isDone ? Date() : nil
    }
    
    static var dummyTasks: [TaskModel] {
        let now = Date()
        
        return [
            // MARK: - Do First (Urgent & Important)
            TaskModel(title: "Fix GraphQL query fetching error for weather data", desc: "API is returning 500 on weather integration module.", startDate: now, endDate: now.addingTimeInterval(-3600), priority: .doFirst, isDone: false), // Overdue 1 jam lalu
            TaskModel(title: "Submit MoU", desc: "Need to upload the signed document to the portal before the deadline closes.", startDate: now, endDate: now.addingTimeInterval(7200), priority: .doFirst, isDone: false), // Due 2 jam lagi
            TaskModel(title: "Refactor MatrixView layout and fix navigation bugs", desc: "The top bar isn't displaying correctly on smaller screens.", startDate: now, endDate: now.addingTimeInterval(14400), priority: .doFirst, isDone: false),
            TaskModel(title: "Draft final project: Sistem Manajemen Tugas Terintegrasi Cuaca", desc: "Complete the first 3 chapters of the thesis.", startDate: now, endDate: now.addingTimeInterval(86400 * 2), priority: .doFirst, isDone: true, completedAt: now.addingTimeInterval(-86400 * 2)), // Completed 2 days ago
            TaskModel(title: "Review pull request from team member", desc: "Check the new SwiftUI components.", startDate: now, endDate: now.addingTimeInterval(18000), priority: .doFirst, isDone: true, completedAt: now), // Completed today
            
            // MARK: - Schedule (Not Urgent & Important)
            TaskModel(title: "Read documentation on SwiftData migrations and relationships", desc: "Prepare for the next database schema update.", startDate: now, endDate: now.addingTimeInterval(86400 * 3), priority: .schedule, isDone: false),
            TaskModel(title: "Survey and book a kost in Surabaya for the next 10 months", desc: "Check options near the campus with good Wi-Fi and parking.", startDate: now, endDate: now.addingTimeInterval(86400 * 7), priority: .schedule, isDone: false),
            TaskModel(title: "Plan motovlog route from Semarang to Surabaya", desc: "Map out rest stops, gas stations, and scenic routes for the trip.", startDate: now, endDate: now.addingTimeInterval(86400 * 14), priority: .schedule, isDone: false),
            TaskModel(title: "Test DJI Osmo Action 4 battery life and mounting setups", desc: "Do a trial run around the city to check audio and wind noise.", startDate: now, endDate: now.addingTimeInterval(86400 * 4), priority: .schedule, isDone: false),
            TaskModel(title: "Watch tutorial series on advanced Ionic Vue integration", desc: "Need this for the cross-platform app module.", startDate: now, endDate: now.addingTimeInterval(86400 * 5), priority: .schedule, isDone: true, completedAt: now.addingTimeInterval(-86400 * 5)), // Completed 5 days ago
            
            // MARK: - Delegate (Urgent & Not Important)
            TaskModel(title: "Reply to general inquiry emails and schedule updates", desc: "Mostly clearing out the inbox.", startDate: now, endDate: now.addingTimeInterval(5400), priority: .delegate, isDone: false),
            TaskModel(title: "Ask friend to pick up laundry", desc: "Laundry ticket is on the desk.", startDate: now, endDate: now.addingTimeInterval(10800), priority: .delegate, isDone: false),
            TaskModel(title: "Buy groceries and snacks for the week", desc: "Milk, eggs, bread, coffee.", startDate: now, endDate: now.addingTimeInterval(-7200), priority: .delegate, isDone: true, completedAt: now.addingTimeInterval(-86400)), // Completed yesterday
            TaskModel(title: "Clean and wash the Honda Vario", desc: "It's been raining all week, need to wash it before the weekend.", startDate: now, endDate: now.addingTimeInterval(21600), priority: .delegate, isDone: false),
            TaskModel(title: "Organize messy download folder on ThinkPad", desc: "Move large files to the external drive.", startDate: now, endDate: now.addingTimeInterval(86400), priority: .delegate, isDone: false),
            
            // MARK: - Eliminate (Not Urgent & Not Important)
            TaskModel(title: "Scroll endlessly on social media reading debates", desc: "Waste of time.", startDate: now, endDate: now.addingTimeInterval(86400 * 2), priority: .eliminate, isDone: false),
            TaskModel(title: "Binge watch the new seasonal anime episodes", desc: "Just one more episode...", startDate: now, endDate: now.addingTimeInterval(86400), priority: .eliminate, isDone: false),
            TaskModel(title: "Sort out spam and promotional emails from 2023", desc: "Not really necessary right now.", startDate: now, endDate: now.addingTimeInterval(86400 * 10), priority: .eliminate, isDone: false),
            TaskModel(title: "Check specifications for new tech rumors", desc: "I already have good devices.", startDate: now, endDate: now.addingTimeInterval(86400 * 4), priority: .eliminate, isDone: true, completedAt: now), // Completed today
            TaskModel(title: "Play video games until 3 AM on a weekday", desc: "Bad idea for productivity.", startDate: now, endDate: now.addingTimeInterval(36000), priority: .eliminate, isDone: false)
        ]
    }
}
