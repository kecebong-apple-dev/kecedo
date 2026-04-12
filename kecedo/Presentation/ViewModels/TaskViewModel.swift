import Foundation

@Observable
class TaskViewModel {
    var tasks: [TaskEntity] = []
    
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
    
    func addTask(_ task: TaskEntity) {
        do {
            try repository.addTask(task)
            fetchTasks()
        } catch {
            print("Failed to add: \(error)")
        }
    }
    
    func updateTask(_ task: TaskEntity) {
        do {
            try repository.updateTask(task)
            fetchTasks()
        } catch {
            print("Failed to update: \(error)")
        }
    }
    
    func deleteTask(id: UUID) {
        do {
            try repository.deleteTask(id: id)
            fetchTasks()
        } catch {
            print("Failed to delete: \(error)")
        }
    }
}
