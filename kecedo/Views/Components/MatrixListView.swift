//
//  MatrixListView.swift
//  kecedo
//
//  Created by oky faishal on 07/04/26.
//

import SwiftUI
import SwiftData

// MARK: - Extensions / Helpers

extension DateFormatter {
    static let matrixTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter
    }()
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
//            HStack {
//                Text("Matrix")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                Spacer()
//            }
//            .padding(.horizontal, 16)
//            .padding(.top, 4)
//            .padding(.bottom, 4)
            
            ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        PrioritySelector(selected: selectedPriority, onSelect: { selectedPriority = $0 })
                        
                        Text(LocalizedStringKey(filterState.dateType.rawValue))
                            .font(.title2)
                            .bold()
                            .padding(.top, 8)
                        
                        LazyVStack(spacing: 12) {
                            ForEach(filteredTasks) { task in
                                TaskRow(task: task,
                                        iconMode: task.priority,
                                        onToggle: {
                                            withAnimation {
                                                task.toggleDone()
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
                title: "Matrix",
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
