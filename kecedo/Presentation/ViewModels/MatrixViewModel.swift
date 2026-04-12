import Foundation
import Observation

@Observable
class MatrixViewModel {
    var tasks: [TaskEntity] = []
    var filterState = MatrixFilterState()
    
    // UI state
    var showingAddTask = false
    var selectedTask: TaskEntity? = nil
    var selectedPriority: Priority = .all
    
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
    
    func updateTask(_ task: TaskEntity) {
        do {
            try repository.updateTask(task)
            fetchTasks()
        } catch {
            print("Failed to update task: \(error)")
        }
    }
    
    func tasks(for priority: Priority) -> [TaskEntity] {
        tasks.applying(filter: filterState)
            .filter { $0.priority == priority }
            .sorted { $0.endDate < $1.endDate }
    }
    
    func listTasks() -> [TaskEntity] {
        let baseTasks = tasks.applying(filter: filterState)
        let matchedTasks = selectedPriority != .all ? baseTasks.filter { $0.priority == selectedPriority } : baseTasks
        return matchedTasks.sorted { $0.endDate < $1.endDate }
    }
}
