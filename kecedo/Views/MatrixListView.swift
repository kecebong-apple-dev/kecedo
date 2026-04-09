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

private struct ModeSelector: View {
    let selected: MatrixMode
    let onSelect: (MatrixMode) -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(MatrixMode.allCases, id: \.self) { mode in
                Button {
                    withAnimation {
                        onSelect(mode)
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(mode.tint(forSelected: mode == selected))
                            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                        
                        MatrixGridBadge(mode: mode)
                            .frame(width: 28, height: 28)
                    }
                    .frame(width: 60, height: 60)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
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
    @State private var selectedMode: MatrixMode = .all
    @State private var selectedTask: TaskModel? = nil
    
    private var filteredTasks: [TaskModel] {
        let baseTasks = tasks.applying(filter: filterState)
        if let p = selectedMode.priority {
            return baseTasks.filter { $0.priority == p }
        } else {
            return baseTasks
        }
    }
    

    
    var body: some View {
        VStack(spacing: 0) {
            
            // ── Manual large title (inline nav bar = no UIKit scroll hijack) ──
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
                        ModeSelector(selected: selectedMode, onSelect: { selectedMode = $0 })
                        
                        Text("Today")
                            .font(.title2)
                            .bold()
                            .padding(.top, 8)
                        
                        LazyVStack(spacing: 12) {
                            ForEach(filteredTasks) { task in
                                TaskRow(task: task,
                                        iconMode: MatrixMode.mode(from: task.priority),
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
            // Edit existing task — use .sheet(item:) so it re-opens correctly
            // when tapping different tasks back-to-back
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
        fatalError("Gagal membuat preview container: \(error)")
    }
}()

#Preview {
    MatrixListView()
        .modelContainer(previewContainer)
}
