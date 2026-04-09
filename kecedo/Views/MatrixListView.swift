//
//  MatrixListView.swift
//  kecedo
//
//  Created by oky faishal on 07/04/26.
//

import SwiftUI
import SwiftData

// MARK: - Types

// MatrixMode has been replaced by Priority from Constants

// MARK: - Extensions / Helpers

extension DateFormatter {
    static let matrixTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter
    }()
}

// MARK: - Subviews

/// A visual badge representing the 4-quadrant Eisenhower Matrix.
/// Selected quadrants are highlighted based on the provided priority.
struct MatrixGridBadge: View {
    let priority: Priority
    
    var body: some View {
        VStack(spacing: 3) {
            HStack(spacing: 3) {
                quadrantSquare(for: .doFirst, color: Priority.doFirst.color.primary)
                quadrantSquare(for: .schedule, color: Priority.schedule.color.primary)
            }
            HStack(spacing: 3) {
                quadrantSquare(for: .delegate, color: Priority.delegate.color.primary)
                quadrantSquare(for: .eliminate, color: Priority.eliminate.color.primary)
            }
        }
    }
    
    /// Generates a single square within the matrix grid.
    /// Highlights the square if it matches the current priority.
    @ViewBuilder
    private func quadrantSquare(for targetPriority: Priority, color: Color) -> some View {
        if priority == .all {
            // Fill all quadrants if the selected priority is 'all'
            RoundedRectangle(cornerRadius: 3)
                .fill(color)
        } else if priority == targetPriority {
            // Outline and highlight the specific target quadrant
            RoundedRectangle(cornerRadius: 3)
                .stroke(color, lineWidth: 2)
                .background(RoundedRectangle(cornerRadius: 3).fill(Color.clear))
        } else {
            // Dim non-matching quadrants
            RoundedRectangle(cornerRadius: 3)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1.5)
        }
    }
}

// TopBar struct removed to use standard .toolbarMain

/// A horizontal selector for picking a matrix priority filter
private struct PrioritySelector: View {
    let selected: Priority
    let onSelect: (Priority) -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(Priority.allCases, id: \.self) { priority in
                Button {
                    withAnimation {
                        onSelect(priority)
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(backgroundColor(for: priority, isSelected: priority == selected))
                            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                        
                        MatrixGridBadge(priority: priority)
                            .frame(width: 28, height: 28)
                    }
                    .frame(width: 60, height: 60)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
    }
    
    /// Determines the background color based on selection and priority
    private func backgroundColor(for priority: Priority, isSelected: Bool) -> Color {
        guard isSelected else { return .white }
        
        // Special handling for '.all' since its default secondary hex is completely black
//        if priority == .all {
//            return .gray.opacity(0.15)
//        }
        
        return priority.color.secondary
    }
}

/// An individual row representing a task, displaying its matrix badge and deadline status
private struct TaskRow: View {
    let task: TaskModel
    let onToggle: () -> Void
    let onTap: () -> Void
    
    /// Determines the display text, text color, and icon based on task deadline and status
    private var statusInfo: (text: String, color: Color, icon: String?) {
        let dateString = DateFormatter.matrixTime.string(from: task.endDate)
        
        // Display neutral gray if the task is already completed
        if task.isDone {
            return (dateString, .gray, nil)
        }
        
        let timeInterval = task.endDate.timeIntervalSinceNow
        
        if timeInterval < 0 {
            // Task is overdue
            return ("Overdue - \(dateString)", Priority.eliminate.color.primary, "exclamationmark.circle.fill")
        } else if timeInterval < 86400 {
            // Task is due in less than 24 hours
            let hours = Int(timeInterval / 3600)
            let hourText = hours > 0 ? "Due in \(hours) \(hours == 1 ? "hour" : "hours")" : "Due in less than an hour"
            return ("\(hourText) - \(dateString)", Priority.schedule.color.primary, "alarm.fill")
        } else {
            // Normal state (more than 24 hours remaining)
            return (dateString, .gray, nil)
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            MatrixGridBadge(priority: task.priority)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(task.isDone ? .gray : .primary)
                    .strikethrough(task.isDone, color: .gray)
                    .lineLimit(1) // Truncate long task titles with "..."
                
                let status = statusInfo
                HStack(spacing: 4) {
                    if let icon = status.icon {
                        Image(systemName: icon)
                    }
                    Text(status.text)
                }
                .font(.system(size: 13, weight: status.icon != nil ? .medium : .regular))
                .foregroundColor(status.color)
            }
            
            Spacer(minLength: 12) // pushes the content to the left to avoid overlapping the button
            
            toggleButton
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 5, y: 2)
        .contentShape(Rectangle())
        .onTapGesture { onTap() }
    }
    
    /// The circular toggle button for changing task completion status
    private var toggleButton: some View {
        Button(action: onToggle) {
            ZStack {
                Circle()
                    .stroke(task.isDone ? Color.clear : Color.gray.opacity(0.4), lineWidth: 1.5)
                    .frame(width: 28, height: 28)
                
                if task.isDone {
                    Circle()
                        .fill(task.priority.color.primary)
                        .frame(width: 28, height: 28)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Main View

struct MatrixListView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \TaskModel.endDate) private var tasks: [TaskModel]
    
    var filterState: MatrixFilterState = MatrixFilterState()
    var onSettings: () -> Void = {}
    var onFilter: () -> Void = {}
    var onSwap: () -> Void = {}
    
    @State private var showingAddTask = false
    @State private var selectedPriority: Priority = .all
    @State private var selectedTask: TaskModel? = nil
    
    private var filteredTasks: [TaskModel] {
        let baseTasks = tasks.applying(filter: filterState)
        if selectedPriority != .all {
            return baseTasks.filter { $0.priority == selectedPriority }
        } else {
            return baseTasks
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Manual large title used alongside inline nav bar 
            // to prevent default UIKit scroll hijacking behaviors
            HStack {
                Text("Matrix")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 4)
            .padding(.bottom, 4)
            
            ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        PrioritySelector(selected: selectedPriority, onSelect: { selectedPriority = $0 })
                        
                        Text("Today")
                            .font(.title2)
                            .bold()
                            .padding(.top, 8)
                        
                        LazyVStack(spacing: 12) {
                            ForEach(filteredTasks) { task in
                                TaskRow(task: task,
                                        onToggle: {
                                            withAnimation {
                                                task.isDone.toggle()
                                            }
                                        },
                                        onTap: {
                                            selectedTask = task
                                        })
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarMain(
                items: .matrix,
                showingAddTask: $showingAddTask,
                onSettings: onSettings,
                onFilter: onFilter,
                onSwap: onSwap
            )
            .sheet(isPresented: $showingAddTask) {
                AddTaskView()
            }
            // Edit an existing task. We use .sheet(item:) to ensure the sheet
            // correctly re-renders when tapping different tasks sequentially.
            .sheet(item: $selectedTask) { task in
                AddTaskView(taskToEdit: task)
            }
    }
}

// MARK: - Preview Setup

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: TaskModel.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        for task in TaskModel.dummyTasks {
            container.mainContext.insert(task)
        }
        return container
    } catch {
        fatalError("Failed to create preview container: \(error)")
    }
}()

#Preview {
    MatrixListView()
        .modelContainer(previewContainer)
}
