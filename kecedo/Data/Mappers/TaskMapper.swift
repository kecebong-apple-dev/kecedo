import Foundation

struct TaskMapper {
    static func toEntity(from model: TaskDataModel) -> TaskEntity {
        let priority = Priority(rawValue: model.priorityRaw) ?? .all
        
        return TaskEntity(
            id: model.id,
            title: model.title,
            desc: model.desc,
            startDate: model.startDate,
            endDate: model.endDate,
            priority: priority,
            isDone: model.isDone,
            completedAt: model.completedAt
        )
    }
    
    static func toDataModel(from entity: TaskEntity) -> TaskDataModel {
        return TaskDataModel(
            id: entity.id,
            title: entity.title,
            desc: entity.desc,
            startDate: entity.startDate,
            endDate: entity.endDate,
            priority: entity.priority.rawValue,
            isDone: entity.isDone,
            completedAt: entity.completedAt
        )
    }
    
    static func updateDataModel(model: TaskDataModel, from entity: TaskEntity) {
        model.title = entity.title
        model.desc = entity.desc
        model.startDate = entity.startDate
        model.endDate = entity.endDate
        model.priorityRaw = entity.priority.rawValue
        model.isDone = entity.isDone
        model.completedAt = entity.completedAt
    }
}
