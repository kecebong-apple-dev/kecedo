import Foundation
import Observation

@Observable
class StatisticsViewModel {
    var tasks: [TaskEntity] {
        taskViewModel.tasks
    }
    var navigateToSettings = false
    
    private let taskViewModel: TaskViewModel
    
    init(taskViewModel: TaskViewModel) {
        self.taskViewModel = taskViewModel
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
