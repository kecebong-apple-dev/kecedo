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
            MatrixContainerView()
            .tabItem {
                Label("Matrix", systemImage: "square.grid.2x2")
            }
            CalendarView()
                .tabItem {
                Label("Calendar", systemImage: "calendar")
            }
            StatisticsView()
            .tabItem {
                Label("Statistics", systemImage: "chart.bar")
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TaskModel.self, configurations: config)

    for task in TaskModel.dummyTasks {
        container.mainContext.insert(task)
    }
    return ContentView()
        .modelContainer(container)
}
