//
//  Matrix.swift
//  kecedo
//
//  Created by Raka Febrian Syahputra on 06/04/26.
//

import SwiftUI

struct Matrix: View {
    var body: some View {
        VStack {
            Text("KeceDo")
            List (TaskModel.dummyTasks.indices, id: \.self) {
                index in
                
                let task = TaskModel.dummyTasks[index]
                
                Text("\(index + 1). \(task.title)")
            }
        }
    }
}

#Preview {
    Matrix()
}
