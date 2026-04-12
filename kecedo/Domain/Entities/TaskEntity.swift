import Foundation

struct TaskEntity: Identifiable, Hashable {
    let id: UUID
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
    
    mutating func toggleDone() {
        isDone.toggle()
        completedAt = isDone ? Date() : nil
    }
}
