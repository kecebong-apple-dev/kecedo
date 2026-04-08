//
//  Matrix.swift
//  kecedo
//
//  Created by Raka Febrian Syahputra on 06/04/26.
//

import SwiftUI
import SwiftData

struct Matrix: View {
    
    @Query(sort:\TaskModel.startDate, order: .forward) private var tasks: [TaskModel]
    
    @Environment(\.modelContext) var modelContext
    @State private var selectedTask: TaskModel?
    @State var isShowingAdd: Bool = false
    
    var body: some View {
        VStack {
            Text("KeceDo")
            List {
                ForEach(Array(tasks.enumerated()), id: \.element) {
                    index, task in
                    Button {
                        selectedTask = task
                    } label: {
                        Text("\(index + 1). \(task.title)")
                            .foregroundStyle(task.priority.color.primary)
                            .background(task.priority.color.secondary)
                    }
                }
            }
            .sheet(item: $selectedTask) {
                task in
                AddTaskView(taskToEdit: task)
            }
            
            Button {
                isShowingAdd.toggle()
            } label: {
                Text("Add")
            }
            .sheet(isPresented: $isShowingAdd) {
                AddTaskView()
            }
        }
    }
}

#Preview {
    Matrix()
}
