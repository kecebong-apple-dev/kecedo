//
//  MatrixListView.swift
//  kecedo
//
//  Created by oky faishal on 07/04/26.
//

import SwiftUI
import SwiftData

// MARK: - Types

enum MatrixMode: CaseIterable, Equatable {
    case all
    case urgentImportant
    case notUrgentImportant
    case urgentNotImportant
    case notUrgentNotImportant
    
    // Mapping MatrixMode ke Priority
    var priority: Priority? {
        switch self {
        case .all: return nil
        case .urgentImportant: return .doFirst
        case .notUrgentImportant: return .schedule
        case .urgentNotImportant: return .delegate
        case .notUrgentNotImportant: return .eliminate
        }
    }
    
    func tint(forSelected isSelected: Bool) -> Color {
        guard isSelected else { return .white }
        switch self {
        case .all: return .gray.opacity(0.15)
        default:
            if let priority = priority {
                return priority.color.secondary.opacity(0.25)
            }
            return .white
        }
    }
}

// MARK: - Extensions / Helpers

extension DateFormatter {
    static let matrixTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter
    }()
}

// MARK: - Subviews

struct MatrixGridBadge: View {
    var mode: MatrixMode
    
    var body: some View {
        VStack(spacing: 3) {
            HStack(spacing: 3) {
                quadrantSquare(for: .urgentImportant, color: Priority.doFirst.color.primary)
                quadrantSquare(for: .notUrgentImportant, color: Priority.schedule.color.primary)
            }
            HStack(spacing: 3) {
                quadrantSquare(for: .urgentNotImportant, color: Priority.delegate.color.primary)
                quadrantSquare(for: .notUrgentNotImportant, color: Priority.eliminate.color.primary)
            }
        }
    }
    
    @ViewBuilder
    private func quadrantSquare(for targetMode: MatrixMode, color: Color) -> some View {
        if mode == .all {
            RoundedRectangle(cornerRadius: 3)
                .fill(color)
        } else if mode == targetMode {
            RoundedRectangle(cornerRadius: 3)
                .stroke(color, lineWidth: 2)
                .background(RoundedRectangle(cornerRadius: 3).fill(Color.clear))
        } else {
            RoundedRectangle(cornerRadius: 3)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1.5)
        }
    }
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

private struct TaskRow: View {
    let task: TaskModel
    let iconMode: MatrixMode
    let onToggle: () -> Void
    
    // Logika untuk menentukan teks, warna, dan ikon berdasarkan waktu tenggat
    private var statusInfo: (text: String, color: Color, icon: String?) {
        let dateString = DateFormatter.matrixTime.string(from: task.endDate)
        
        // Jika tugas sudah selesai, tampilkan abu-abu netral
        if task.isDone {
            return (dateString, .gray, nil)
        }
        
        let timeInterval = task.endDate.timeIntervalSinceNow
        
        if timeInterval < 0 {
            // Overdue (Lebih dari batas waktu) -> Merah
            return ("Overdue - \(dateString)", .red, "exclamationmark.circle.fill")
        } else if timeInterval < 86400 { // Kurang dari 24 Jam -> Oranye
            let hours = Int(timeInterval / 3600)
            let hourText = hours > 0 ? "Due in \(hours) \(hours == 1 ? "hour" : "hours")" : "Due in less than an hour"
            return ("\(hourText) - \(dateString)", .orange, "alarm.fill")
        } else {
            // Normal -> Abu-abu
            return (dateString, .gray, nil)
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            MatrixGridBadge(mode: iconMode)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(task.isDone ? .gray : .primary)
                    .strikethrough(task.isDone, color: .gray)
                    .lineLimit(1) // Memotong teks panjang menjadi "..."
                
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
            
            Spacer(minLength: 12) // Mendorong teks ke kiri agar tidak menabrak tombol
            
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
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 5, y: 2)
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
    
    private var filteredTasks: [TaskModel] {
        let baseTasks = tasks.applying(filter: filterState)
        if let p = selectedMode.priority {
            return baseTasks.filter { $0.priority == p }
        } else {
            return baseTasks
        }
    }
    
    private func mode(from priority: Priority) -> MatrixMode {
        switch priority {
        case .doFirst: return .urgentImportant
        case .schedule: return .notUrgentImportant
        case .delegate: return .urgentNotImportant
        case .eliminate: return .notUrgentNotImportant
        }
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                Text("Matrix")
                    .font(.system(size: 34, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 16)
                
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
                                        iconMode: mode(from: task.priority),
                                        onToggle: {
                                            withAnimation {
                                                task.isDone.toggle()
                                            }
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
