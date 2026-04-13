//
//  Matrix.swift
//  kecedo
//
//  Created by Nathan Gitu Loh on 06/04/26.
//

import SwiftUI
import SwiftData

// MARK: Quadrant Cell

private struct QuadrantCellView: View {
    let priority: Priority
    let tasks: [TaskModel]
    let onToggle: (TaskModel) -> Void
    let onTap: (TaskModel) -> Void

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(tasks) { task in
                    TaskRowView(task: task, priority: priority) {
                        onToggle(task)
                    } onTap: {
                        onTap(task)
                    }
                    if task.id != tasks.last?.id {
                        Divider()
                            .background(Color.primary.opacity(0.15)) // Support lebih halus di dark mode
                    }
                }
                Color.clear.frame(height: 8)
            }
            .padding(.horizontal, 10)
            .padding(.top, 10)
        }
        // Prevents scroll gesture from propagating to the NavigationStack
        .scrollBounceBehavior(.basedOnSize)
        .background(priority.color.secondary)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

// MARK: Task Row

private struct TaskRowView: View {
    let task: TaskModel
    let priority: Priority
    let onToggle: () -> Void
    let onTap: () -> Void

    private var dateText: String {
        let f = DateFormatter()
        f.dateFormat = "MMM d, h:mm a"
        return f.string(from: task.endDate)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text(task.title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(task.isDone ? Color(.systemGray) : .primary)
                    .strikethrough(task.isDone, color: Color(.systemGray    ))
                    .lineLimit(1)
                Text("\(Image(systemName: "alarm.fill")) \(dateText)")
                    .font(.system(size: 11))
                    .foregroundColor(task.isDone ? Color(.systemGray2) : .secondary)
                    .lineLimit(1)
            }
            Spacer()
            // Completion circle — toggle by tapping
            Button(action: onToggle) {
                ZStack {
                    Circle()
                        .fill(task.isDone ? priority.color.primary : Color.clear)
                        .frame(width: 22, height: 22)
                    Circle()
                        .strokeBorder(priority.color.primary, lineWidth: 1.5)
                        .frame(width: 22, height: 22)
                    if task.isDone {
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture { onTap() }
    }
}

// MARK: Matrix View

struct MatrixView: View {
    @AppStorage("appLanguage") private var appLanguage: String = "English"

    // Fetch all tasks from SwiftData; sort by endDate ascending
    @Query(sort: \TaskModel.endDate) private var allTasks: [TaskModel]
    @Environment(\.modelContext) private var context

    @State private var showingAddTask = false
    @State private var selectedTask: TaskModel? = nil
    
    var filterState: MatrixFilterState = MatrixFilterState()
    var onSettings: () -> Void = {}
    var onFilter: () -> Void = {}
    var onSwap: () -> Void = {}

    private var columnLabels: [String] {
        ["Urgent".localized(appLanguage), "Not Urgent".localized(appLanguage)]
    }

    // Helper: filter tasks per priority quadrant
    private func tasks(for priority: Priority) -> [TaskModel] {
        allTasks.applying(filter: filterState).filter { $0.priority == priority }
    }

    var body: some View {
        VStack(spacing: 0) {
                // ── Grid ──────────────────────────────────────────────────────────
                GeometryReader { geo in
                    let hPad:    CGFloat = 12
                    let labelW:  CGFloat = 28
                    let gap:     CGFloat = 8
                    let headerH: CGFloat = 30
                    let cellH = (geo.size.height - headerH - gap) / 2
                    let cellW = (geo.size.width  - hPad * 2 - labelW - gap) / 2

                    VStack(spacing: 0) {

                        // Column headers
                        HStack(spacing: 0) {
                            Color.clear.frame(width: labelW)
                            ForEach(columnLabels, id: \.self) { label in
                                Text(label)
                                    .font(.system(size: 13))
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .frame(height: headerH)
                        .padding(.horizontal, hPad)

                        // 2×2 quadrants
                        HStack(alignment: .top, spacing: 0) {

                            // Row labels
                            VStack(spacing: gap) {
                                rowLabel("Important".localized(appLanguage),     height: cellH)
                                rowLabel("Not Important".localized(appLanguage), height: cellH)
                            }
                            .frame(width: labelW)

                            // Cells
                            VStack(spacing: gap) {
                                HStack(spacing: gap) {
                                    QuadrantCellView(
                                        priority: .doFirst,
                                        tasks: tasks(for: .doFirst),
                                        onToggle: toggleDone,
                                        onTap: { selectedTask = $0 }
                                    )
                                    .frame(width: cellW, height: cellH)

                                    QuadrantCellView(
                                        priority: .schedule,
                                        tasks: tasks(for: .schedule),
                                        onToggle: toggleDone,
                                        onTap: { selectedTask = $0 }
                                    )
                                    .frame(width: cellW, height: cellH)
                                }
                                HStack(spacing: gap) {
                                    QuadrantCellView(
                                        priority: .delegate,
                                        tasks: tasks(for: .delegate),
                                        onToggle: toggleDone,
                                        onTap: { selectedTask = $0 }
                                    )
                                    .frame(width: cellW, height: cellH)

                                    QuadrantCellView(
                                        priority: .eliminate,
                                        tasks: tasks(for: .eliminate),
                                        onToggle: toggleDone,
                                        onTap: { selectedTask = $0 }
                                    )
                                    .frame(width: cellW, height: cellH)
                                }
                            }
                        }
                        .padding(.horizontal, hPad)
                    }
                }
            }
            .padding(.bottom, 10)
            .background(Color(UIColor.systemBackground)) // Pastikan base view aman dari tema gelap
            .navigationBarTitleDisplayMode(.inline)
            .toolbarMain(
                title: "Matrix".localized(appLanguage),
                items: .matrix,
                showingAddTask: $showingAddTask,
                onSettings: onSettings,
                onFilter: onFilter,
                onSwap: onSwap
            )
            // Add new task
            .sheet(isPresented: $showingAddTask) {
                AddTaskView()
            }
            // Edit existing task
            .sheet(item: $selectedTask) { task in
                AddTaskView(taskToEdit: task)
            }
    }

    // MARK: Helpers

    @ViewBuilder
    private func rowLabel(_ text: String, height: CGFloat) -> some View {
        Text(text)
            .font(.system(size: 13))
            .foregroundColor(.secondary)
            .rotationEffect(.degrees(-90))
            .frame(width: height, height: 28)
            .frame(width: 28, height: height)
            .clipped()
    }

    private func toggleDone(_ task: TaskModel) {
        task.toggleDone()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TaskModel.self, configurations: config)

    for task in TaskModel.dummyTasks {
        container.mainContext.insert(task)
    }

    return MatrixView()
        .modelContainer(container)
}
