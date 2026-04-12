//
//  ContentView.swift
//  kecedo
//
//  Created by Raka Febrian Syahputra on 06/04/26.
//

import SwiftUI


struct ContentView: View {
    @AppStorage("appLanguage") private var appLanguage: String = "English"
    
    var body: some View {
        TabView {
            MatrixContainerView()
            .tabItem {
                Label("Matrix".localized(appLanguage), systemImage: "square.grid.2x2")
            }
            CalendarView()
                .tabItem {
                Label("Calendar".localized(appLanguage), systemImage: "calendar")
            }
            StatisticsView()
            .tabItem {
                Label("Statistics".localized(appLanguage), systemImage: "chart.pie.fill")
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(DIContainer().taskViewModel)
}
