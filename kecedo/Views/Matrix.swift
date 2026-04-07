//
//  Matrix.swift
//  kecedo
//
//  Created by Raka Febrian Syahputra on 06/04/26.
//

import SwiftUI

struct Matrix: View {
    
    @State var isPresented: Bool = false
    
    var body: some View {
        VStack {
            Text("KeceDo")
            List (TaskModel.dummyTasks.indices, id: \.self) {
                index in
                
                let task = TaskModel.dummyTasks[index]
                
                Text("\(index + 1). \(task.title)")
                    .foregroundStyle(task.priority.color.primary)
                    .background(task.priority.color.secondary)
            }
            Button {
                isPresented.toggle()
            } label: {
                Text("Add")
            }
            .sheet(isPresented: $isPresented) {
                AddTaskView()
            }
        }
    }
}

#Preview {
    Matrix()
}
