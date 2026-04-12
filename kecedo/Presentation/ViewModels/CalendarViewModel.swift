import Foundation
import Observation

@Observable
class CalendarViewModel {
    var tasks: [TaskEntity] = []
    
    var currentMonth: Date
    var selectedDate: Date
    var isMonthPickerPresented = false
    var showingFilter = false
    var navigateToSettings = false
    
    private let repository: TaskRepositoryProtocol
    
    init(repository: TaskRepositoryProtocol) {
        self.repository = repository
        
        // Setup initial dates
        let calendar = Calendar.current
        self.currentMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: .now)) ?? .now
        self.selectedDate = calendar.startOfDay(for: .now)
        
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
    
    func updateCurrentMonth(to newMonth: Date) {
        let calendar = Calendar.current
        let normalizedMonth = calendar.date(
            from: calendar.dateComponents([.year, .month], from: newMonth)
        ) ?? newMonth

        currentMonth = normalizedMonth

        let selectedDay = calendar.component(.day, from: selectedDate)
        let dayRange = calendar.range(of: .day, in: .month, for: normalizedMonth) ?? 1..<29
        let clampedDay = min(selectedDay, dayRange.count)

        if let updatedSelectedDate = calendar.date(
            from: DateComponents(
                year: calendar.component(.year, from: normalizedMonth),
                month: calendar.component(.month, from: normalizedMonth),
                day: clampedDay
            )
        ) {
            selectedDate = calendar.startOfDay(for: updatedSelectedDate)
        }
    }
    
    func filteredTasks(for date: Date) -> [TaskEntity] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        return tasks
            .filter { $0.endDate >= startOfDay && $0.endDate < endOfDay }
            .sorted { $0.endDate < $1.endDate }
    }
}
