//
//  Matrix.swift
//  kecedo
//
//  Created by Nathan Gitu Loh on 06/04/26.
//

import SwiftUI
import SwiftData

// MARK: - Quadrant Cell

private struct QuadrantCellView: View {
    let priority: Priority
    let tasks: [TaskModel]
    let onToggle: (TaskModel) -> Void

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(tasks) { task in
                    TaskRowView(task: task, priority: priority) {
                        onToggle(task)
                    }
                    if task.id != tasks.last?.id {
                        Divider().opacity(0.4)
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

// MARK: - Task Row

private struct TaskRowView: View {
    let task: TaskModel
    let priority: Priority
    let onToggle: () -> Void

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
                    .foregroundColor(.primary)
                    .lineLimit(2)
                Text(dateText)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
            Spacer()
            // Completion circle — toggle by tapping
            Button(action: onToggle) {
                Circle()
                    .strokeBorder(priority.color.primary, lineWidth: 1.5)
                    .frame(width: 22, height: 22)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Matrix View

struct MatrixView: View {

    // Fetch all tasks from SwiftData; sort by endDate ascending
    @Query(sort: \TaskModel.endDate) private var allTasks: [TaskModel]
    @Environment(\.modelContext) private var context

    @State private var showingAddTask = false

    private let columnLabels = ["Urgent", "Not Urgent"]

    // Helper: filter tasks per priority quadrant
    private func tasks(for priority: Priority) -> [TaskModel] {
        allTasks.filter { $0.priority == priority }
    }

    var body: some View {
        NavigationStack {
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
                                rowLabel("Important",     height: cellH)
                                rowLabel("Not Important", height: cellH)
                            }
                            .frame(width: labelW)

                            // Cells
                            VStack(spacing: gap) {
                                HStack(spacing: gap) {
                                    QuadrantCellView(
                                        priority: .doFirst,
                                        tasks: tasks(for: .doFirst),
                                        onToggle: deleteTask
                                    )
                                    .frame(width: cellW, height: cellH)

                                    QuadrantCellView(
                                        priority: .schedule,
                                        tasks: tasks(for: .schedule),
                                        onToggle: deleteTask
                                    )
                                    .frame(width: cellW, height: cellH)
                                }
                                HStack(spacing: gap) {
                                    QuadrantCellView(
                                        priority: .delegate,
                                        tasks: tasks(for: .delegate),
                                        onToggle: deleteTask
                                    )
                                    .frame(width: cellW, height: cellH)

                                    QuadrantCellView(
                                        priority: .eliminate,
                                        tasks: tasks(for: .eliminate),
                                        onToggle: deleteTask
                                    )
                                    .frame(width: cellW, height: cellH)
                                }
                            }
                        }
                        .padding(.horizontal, hPad)
                    }
                }
            }
            // .inline disables UIKit's large-title scroll observer entirely
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Color.clear // hide the inline centre title
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { } label: {
                        Image(systemName: "gearshape")
                            .foregroundColor(.primary)
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button { } label: {
                        Image(systemName: "list.bullet")
                            .foregroundColor(.primary)
                    }
                    Button { } label: {
                        Image(systemName: "square.on.square")
                            .foregroundColor(.primary)
                    }
                    Button { showingAddTask = true } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.primary)
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskSheet()
            }
        }
    }

    // MARK: - Helpers

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

    private func deleteTask(_ task: TaskModel) {
        context.delete(task)
    }
}

// MARK: - Add Task Sheet

private struct AddTaskSheet: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var desc = ""
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(3600)
    @State private var priority: Priority = .doFirst

    var body: some View {
        NavigationStack {
            Form {
                Section("Task") {
                    TextField("Title", text: $title)
                    TextField("Description", text: $desc)
                }
                Section("Priority") {
                    Picker("Priority", selection: $priority) {
                        ForEach(Priority.allCases) { p in
                            Text(p.name).tag(p)
                        }
                    }
                    .pickerStyle(.menu)
                }
                Section("Dates") {
                    DatePicker("Start", selection: $startDate)
                    DatePicker("Due",   selection: $endDate)
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let task = TaskModel(
                            title: title,
                            desc: desc,
                            startDate: startDate,
                            endDate: endDate,
                            priority: priority
                        )
                        context.insert(task)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    MatrixView()
        .modelContainer(for: TaskModel.self, inMemory: true)
}
