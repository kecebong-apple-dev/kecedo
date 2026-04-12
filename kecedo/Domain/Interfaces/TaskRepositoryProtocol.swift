import Foundation

protocol TaskRepositoryProtocol {
    func getTasks() throws -> [TaskEntity]
    func addTask(_ task: TaskEntity) throws
    func updateTask(_ task: TaskEntity) throws
    func deleteTask(id: UUID) throws
}
