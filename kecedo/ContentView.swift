//
//  ContentView.swift
//  kecedo
//
//  Created by Raka Febrian Syahputra on 06/04/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        TabView {
            VStack {
                Text("KeceDo")
                List (TaskModel.dummyTasks.indices, id: \.self) {
                    index in
                    
                    let task = TaskModel.dummyTasks[index]
                    
                    Text("\(index + 1). \(task.title)")
                }
            }
            .tabItem {
                Label("Home", systemImage: "checklist")
            }
            Text("Calendar")
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }
            Text("Statistics")
            .tabItem {
                Label("Statistics", systemImage: "chart.bar")
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: TaskModel.self, inMemory: true)
}
