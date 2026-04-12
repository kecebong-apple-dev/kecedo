import Foundation
import SwiftData

@Observable
class DIContainer {
    let taskRepository: TaskRepositoryProtocol
    let taskViewModel: TaskViewModel
    let calendarViewModel: CalendarViewModel
    let matrixViewModel: MatrixViewModel
    let statisticsViewModel: StatisticsViewModel
    
    init() {
        let schema = Schema([TaskDataModel.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            let context = ModelContext(container)
            let repository = SwiftDataTaskRepository(context: context)
            self.taskRepository = repository
            let taskVM = TaskViewModel(repository: repository)
            self.taskViewModel = taskVM
            self.calendarViewModel = CalendarViewModel(taskViewModel: taskVM)
            self.matrixViewModel = MatrixViewModel(taskViewModel: taskVM)
            self.statisticsViewModel = StatisticsViewModel(taskViewModel: taskVM)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
