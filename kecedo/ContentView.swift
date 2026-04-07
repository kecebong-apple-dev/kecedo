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
            MatrixView()
            .tabItem {
                Label("Matrix", systemImage: "square.grid.2x2")
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
