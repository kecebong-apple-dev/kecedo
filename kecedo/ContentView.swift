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
    @Namespace private var tabBarNamespace
    @State private var selectedTab: AppTab = .matrix

    init(initialTab: AppTab = .matrix) {
        _selectedTab = State(initialValue: initialTab)
    }
    
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
            Text("Statistics")
            .tabItem {
                Label("Statistics", systemImage: "chart.bar")
            }
            .padding(.bottom, 80)
        }
    }
}

#Preview {
    ContentView(initialTab: .calendar)
        .modelContainer(for: TaskModel.self, inMemory: true)
}
