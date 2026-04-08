//
//  MatrixListView.swift
//  kecedo
//
//  Created by oky faishal on 07/04/26.
//

import SwiftUI
import SwiftData

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
}

// MARK: - Komponen Ikon Grid Matriks (2x2)
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
    func quadrantSquare(for targetMode: MatrixMode, color: Color) -> some View {
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

// MARK: - Tampilan Utama
struct MatrixListView: View {
    @Environment(\.modelContext) private var modelContext
    
    // Mengambil data langsung dari SwiftData
    @Query(sort: \TaskModel.endDate) private var tasks: [TaskModel]
    
    @State private var selectedMode: MatrixMode = .all
    
    private var filteredTasks: [TaskModel] {
        switch selectedMode {
        case .all:
            return tasks
        default:
            return tasks.filter { $0.priority == selectedMode.priority }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: date)
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Top Bar
                HStack {
                    Button(action: {}) {
                        Image(systemName: "gearshape")
                            .font(.system(size: 20))
                            .foregroundColor(.primary)
                            .frame(width: 44, height: 44)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        HStack(spacing: 20) {
                            Button(action: {}) {
                                Image(systemName: "line.3.horizontal.circle")
                                    .font(.system(size: 20))
                                    .foregroundColor(.primary)
                            }
                            Button(action: {}) {
                                Image(systemName: "rectangle.2.swap")
                                    .font(.system(size: 18))
                                    .foregroundColor(.primary)
                            }
                        }
                        .padding(.horizontal, 20)
                        .frame(height: 44)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                        
                        Button(action: {}) {
                            Image(systemName: "plus")
                                .font(.system(size: 20))
                                .foregroundColor(.primary)
                                .frame(width: 44, height: 44)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                // 2. Judul
                Text("Matrix")
                    .font(.system(size: 34, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 16)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // 3. Filter
                        HStack(spacing: 12) {
                            ForEach(MatrixMode.allCases, id: \.self) { mode in
                                Button {
                                    withAnimation {
                                        selectedMode = mode
                                    }
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(backgroundColor(for: mode))
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
                        
                        // 4. Label
                        Text("Today")
                            .font(.title2)
                            .bold()
                            .padding(.top, 8)
                        
                        // 5. List Tasks
                        LazyVStack(spacing: 12) {
                            ForEach(filteredTasks) { task in
                                taskCard(for: task)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
    }
    
    private func backgroundColor(for mode: MatrixMode) -> Color {
        if selectedMode == mode {
            if mode == .all {
                return Color.gray.opacity(0.15)
            }
            if let priority = mode.priority {
                return priority.color.secondary.opacity(0.25)
            }
        }
        return Color.white
    }
    
    // Konversi dari Priority ke MatrixMode untuk Icon
    private func getMode(fromPriority priority: Priority) -> MatrixMode {
        switch priority {
        case .doFirst: return .urgentImportant
        case .schedule: return .notUrgentImportant
        case .delegate: return .urgentNotImportant
        case .eliminate: return .notUrgentNotImportant
        }
    }
    
    @ViewBuilder
    private func taskCard(for task: TaskModel) -> some View {
        HStack(spacing: 16) {
            MatrixGridBadge(mode: getMode(fromPriority: task.priority))
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(task.isDone ? .gray : .primary)
                    .strikethrough(task.isDone, color: .gray)
                
                Text(formattedDate(task.endDate))
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button {
                withAnimation {
                    // Karena menggunakan SwiftData, mengubah properti akan otomatis tersimpan
                    task.isDone.toggle()
                }
            } label: {
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

// MARK: - Preview Setup dengan Data Dummy SwiftData
@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: TaskModel.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        
        // Memasukkan data dummy ke dalam container memory untuk preview
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
