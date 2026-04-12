import Foundation
import Observation

@Observable
class StatisticsViewModel {
    var tasks: [TaskEntity] = []
    var navigateToSettings = false
    
    private let repository: TaskRepositoryProtocol
    
    init(repository: TaskRepositoryProtocol) {
        self.repository = repository
        fetchTasks()
    }
    
    func fetchTasks() {
        do {
            self.tasks = try repository.getTasks()
        } catch {
            print("Failed to fetch tasks: \(error)")
        }
    }
    
    var completedTasks: [TaskEntity] {
        tasks.filter { $0.isDone }
    }
    
    var tasksCompletedToday: Int {
        completedTasks.filter { task in
            if let completedAt = task.completedAt {
                return Calendar.current.isDateInToday(completedAt)
            }
            return Calendar.current.isDateInToday(task.endDate)
        }.count
    }
    
    var activeTasksCount: Int {
        tasks.filter { !$0.isDone }.count
    }
}
