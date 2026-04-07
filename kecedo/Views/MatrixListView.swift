//
//  MatrixListView.swift
//  kecedo
//
//  Created by oky faishal on 07/04/26.
//

import SwiftUI

struct TaskItem: Identifiable {
    let id: UUID = UUID()
    let title: String
    let due: Date
    let isUrgent: Bool
    let isImportant: Bool
    var isDone: Bool
    
    // Properti bantuan untuk mendapatkan mode matrix secara langsung
    var matrixMode: MatrixMode {
        switch (isUrgent, isImportant) {
        case (true, true): return .urgentImportant
        case (false, true): return .notUrgentImportant
        case (true, false): return .urgentNotImportant
        case (false, false): return .notUrgentNotImportant
        }
    }
}

enum MatrixMode: CaseIterable, Equatable {
    case all
    case urgentImportant
    case notUrgentImportant
    case urgentNotImportant
    case notUrgentNotImportant
    
    // Warna diatur sesuai dengan visual pada gambar
    var color: Color? {
        switch self {
        case .all: return nil
        case .urgentImportant: return .green
        case .notUrgentImportant: return .yellow
        case .urgentNotImportant: return .cyan // Biru muda
        case .notUrgentNotImportant: return .orange
        }
    }
}

// MARK: - Komponen Ikon Grid Matriks (2x2)
struct MatrixGridIcon: View {
    var mode: MatrixMode
    
    var body: some View {
        VStack(spacing: 3) {
            HStack(spacing: 3) {
                quadrantSquare(for: .urgentImportant, color: .green)
                quadrantSquare(for: .notUrgentImportant, color: .yellow)
            }
            HStack(spacing: 3) {
                quadrantSquare(for: .urgentNotImportant, color: .cyan)
                quadrantSquare(for: .notUrgentNotImportant, color: .orange)
            }
        }
    }
    
    @ViewBuilder
    func quadrantSquare(for targetMode: MatrixMode, color: Color) -> some View {
        if mode == .all {
            // Jika mode "All", semua kotak terisi penuh dengan warna
            RoundedRectangle(cornerRadius: 3)
                .fill(color)
        } else if mode == targetMode {
            // Jika mode spesifik (misal hijau), kotak bersangkutan diberi garis warna
            RoundedRectangle(cornerRadius: 3)
                .stroke(color, lineWidth: 2)
                .background(RoundedRectangle(cornerRadius: 3).fill(Color.clear))
        } else {
            // Kotak sisanya diberi garis abu-abu tipis
            RoundedRectangle(cornerRadius: 3)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1.5)
        }
    }
}

// MARK: - Tampilan Utama
struct MatrixListView: View {
    @State private var selectedMode: MatrixMode = .all
    
    // Dummy Data yang disesuaikan dengan isi gambar
    @State private var tasks: [TaskItem] = [
        TaskItem(title: "Finish project report", due: Date().addingTimeInterval(3600), isUrgent: true, isImportant: true, isDone: false),
        TaskItem(title: "Schedule a meeting", due: Date().addingTimeInterval(7200), isUrgent: true, isImportant: true, isDone: false),
        TaskItem(title: "Clean the workspace", due: Date().addingTimeInterval(14400), isUrgent: true, isImportant: false, isDone: false),
        TaskItem(title: "Backup important files", due: Date().addingTimeInterval(18000), isUrgent: false, isImportant: true, isDone: false),
        TaskItem(title: "Plan weekend activities", due: Date().addingTimeInterval(25200), isUrgent: false, isImportant: false, isDone: false),
        TaskItem(title: "Read a book chapter", due: Date().addingTimeInterval(-3600), isUrgent: false, isImportant: false, isDone: true),
        TaskItem(title: "Reply to emails", due: Date().addingTimeInterval(-7200), isUrgent: true, isImportant: true, isDone: true)
    ]
    
    private var filteredTasks: [TaskItem] {
        switch selectedMode {
        case .all:
            return tasks
        default:
            return tasks.filter { $0.matrixMode == selectedMode }
        }
    }
    
    // Format tanggal ("Apr 15, 3:00 AM")
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: date)
    }
    
    var body: some View {
        ZStack {
            // Latar Belakang Abu-abu Terang
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
                    HStack(spacing: 20) {
                        Button(action: {}) {
                            Image(systemName: "line.3.horizontal")
                                .font(.system(size: 18))
                                .foregroundColor(.primary)
                        }
                        Button(action: {}) {
                            Image(systemName: "square.on.square")
                                .font(.system(size: 18))
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.horizontal, 20)
                    .frame(height: 44)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                    Spacer()
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
                .padding(.horizontal)
                .padding(.top, 10)
                
                // 2. Judul "Matrix"
                Text("Matrix")
                    .font(.system(size: 34, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 16)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        
                        // 3. Tombol Filter Horizontal (5 Kotak)
                        HStack(spacing: 12) {
                            ForEach(MatrixMode.allCases, id: \.self) { mode in
                                Button {
                                    withAnimation {
                                        selectedMode = mode
                                    }
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 16)
                                            // Tombol "All" akan berwarna gelap jika dipilih, lainnya putih
                                            .fill(mode == .all && selectedMode == .all ? Color(UIColor.darkGray) : Color.white)
                                            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                                        
                                        MatrixGridIcon(mode: mode)
                                            .frame(width: 28, height: 28)
                                    }
                                    .frame(width: 60, height: 60)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                        
                        // 4. Label "Today" di tengah
                        Text("Today")
                            .font(.title2)
                            .bold()
                            .padding(.top, 8)
                        
                        // 5. Daftar Task Card
                        LazyVStack(spacing: 12) {
                            ForEach(filteredTasks) { task in
                                taskCard(for: task)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 100) // Ruang bernafas ekstra di bawah
                    }
                }
            }
        }
    }
    
    // MARK: - View Komponen Task Card
    @ViewBuilder
    private func taskCard(for task: TaskItem) -> some View {
        HStack(spacing: 16) {
            // Ikon Grid Kiri
            MatrixGridIcon(mode: task.matrixMode)
                .frame(width: 24, height: 24)
            
            // Judul dan Tanggal
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(task.isDone ? .gray : .primary)
                    .strikethrough(task.isDone, color: .gray)
                
                Text(formattedDate(task.due))
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Tombol Checkmark
            Button {
                if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                    withAnimation {
                        tasks[index].isDone.toggle()
                    }
                }
            } label: {
                ZStack {
                    // Lingkaran luar (abu-abu jika belum selesai)
                    Circle()
                        .stroke(task.isDone ? Color.clear : Color.gray.opacity(0.4), lineWidth: 1.5)
                        .frame(width: 28, height: 28)
                    
                    // Lingkaran warna dan tanda centang (jika selesai)
                    if task.isDone {
                        Circle()
                            .fill(task.matrixMode.color ?? .gray)
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
        .shadow(color: .black.opacity(0.04), radius: 5, y: 2) // Efek shadow tipis ala kartu
    }
}

#Preview {
    MatrixListView()
}
