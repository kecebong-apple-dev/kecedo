import Foundation
import SwiftData

class SwiftDataTaskRepository: TaskRepositoryProtocol {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func getTasks() throws -> [TaskEntity] {
        let descriptor = FetchDescriptor<TaskDataModel>()
        let models = try context.fetch(descriptor)
        return models.map { TaskMapper.toEntity(from: $0) }
    }
    
    func addTask(_ task: TaskEntity) throws {
        let model = TaskMapper.toDataModel(from: task)
        context.insert(model)
        try context.save()
    }
    
    func updateTask(_ task: TaskEntity) throws {
        let taskID = task.id
        let descriptor = FetchDescriptor<TaskDataModel>(predicate: #Predicate { $0.id == taskID })
        if let model = try context.fetch(descriptor).first {
            TaskMapper.updateDataModel(model: model, from: task)
            try context.save()
        } else {
            throw NSError(domain: "TaskRepository", code: 404, userInfo: [NSLocalizedDescriptionKey: "Task not found"])
        }
    }
    
    func deleteTask(id: UUID) throws {
        let descriptor = FetchDescriptor<TaskDataModel>(predicate: #Predicate { $0.id == id })
        if let model = try context.fetch(descriptor).first {
            context.delete(model)
            try context.save()
        }
    }
}
