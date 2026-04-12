//
//  MatrixListView.swift
//  kecedo
//
//  Created by oky faishal on 07/04/26.
//

import SwiftUI

// MARK: - Extensions / Helpers
extension DateFormatter {
    static let matrixTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter
    }()
}

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
        return priority.color.secondary
    }
}

// MARK: - Main View
struct MatrixListView: View {
    @Environment(MatrixViewModel.self) private var matrixViewModel
    @AppStorage("appLanguage") private var appLanguage: String = "English"
    
    var onSettings: () -> Void = {}
    var onFilter: () -> Void = {}
    var onSwap: () -> Void = {}
    
    var body: some View {
        @Bindable var viewModel = matrixViewModel
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        PrioritySelector(selected: viewModel.selectedPriority, onSelect: { viewModel.selectedPriority = $0 })
                            .padding(.top, 18)
                        
                        VStack(){
                            Text(LocalizedStringKey(viewModel.filterState.dateType.rawValue))
                                .font(.title2)
                                .bold()
                                .padding(.top, 8)
                            
                            if(viewModel.filterState.dateType == .period){
                                HStack(spacing: 5){
                                    Text(viewModel.filterState.startDate, format: .dateTime.day().month().year())
                                    Text("-")
                                    Text(viewModel.filterState.endDate, format: .dateTime.day().month().year())
                                }
                            }
                        }
                        
                        
                        LazyVStack(spacing: 12) {
                            if viewModel.listTasks().isEmpty {
                                Text("No tasks on this date.".localized(appLanguage))
                                    .foregroundColor(.gray)
                                    .padding(.top, 40)
                            } else {
                                ForEach(viewModel.listTasks()) { task in
                                    TaskRow(task: task,
                                            iconMode: task.priority,
                                            onToggle: {
                                                withAnimation {
                                                    var updatedTask = task
                                                    updatedTask.toggleDone()
                                                    matrixViewModel.updateTask(updatedTask)
                                                }
                                            },
                                            onTap: {
                                                viewModel.selectedTask = task
                                            })
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarMain(
                title: "Matrix List".localized(appLanguage),
                items: .matrix,
                showingAddTask: $viewModel.showingAddTask,
                onSettings: onSettings,
                onFilter: onFilter,
                onSwap: onSwap
            )
            .sheet(isPresented: $viewModel.showingAddTask) {
                AddTaskView()
            }
            .sheet(item: $viewModel.selectedTask) { task in
                AddTaskView(taskToEdit: task)
            }
    }
}

#Preview {
    MatrixListView()
        .environment(DIContainer().taskViewModel)
        .environment(DIContainer().matrixViewModel)
}
