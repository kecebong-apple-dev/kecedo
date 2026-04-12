import Foundation
import Observation

@Observable
class MatrixViewModel {
    var tasks: [TaskEntity] {
        taskViewModel.tasks
    }
    var filterState = MatrixFilterState()
    
    // UI state
    var isListView = false
    var showingFilter = false
    var navigateToSettings = false
    var showingAddTask = false
    var selectedTask: TaskEntity? = nil
    var selectedPriority: Priority = .all
    
    private let taskViewModel: TaskViewModel
    
    init(taskViewModel: TaskViewModel) {
        self.taskViewModel = taskViewModel
    }
    
    func updateTask(_ task: TaskEntity) {
        taskViewModel.updateTask(task)
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
