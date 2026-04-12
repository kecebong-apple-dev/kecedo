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
            self.taskViewModel = TaskViewModel(repository: repository)
            self.calendarViewModel = CalendarViewModel(repository: repository)
            self.matrixViewModel = MatrixViewModel(repository: repository)
            self.statisticsViewModel = StatisticsViewModel(repository: repository)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
