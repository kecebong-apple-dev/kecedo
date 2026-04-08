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
        ZStack(alignment: .bottom) {
            currentScreen
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            FloatingGlassTabBar(
                selectedTab: $selectedTab,
                namespace: tabBarNamespace
            )
            .padding(.horizontal, 48)
            .padding(.bottom, 14)
        }
    }

    @ViewBuilder
    private var currentScreen: some View {
        switch selectedTab {
        case .matrix:
            Matrix()
                .transition(.opacity.combined(with: .scale(scale: 0.98)))
        case .calendar:
            CalendarView()
                .transition(.opacity.combined(with: .scale(scale: 0.98)))
        case .statistics:
            StatisticsView()
                .transition(.opacity.combined(with: .scale(scale: 0.98)))
        }
    }
}

enum AppTab: String, CaseIterable, Identifiable {
    case matrix
    case calendar
    case statistics

    var id: String { rawValue }

    var title: String {
        switch self {
        case .matrix:
            "Matrix"
        case .calendar:
            "Calender"
        case .statistics:
            "Statistics"
        }
    }

    var systemImage: String {
        switch self {
        case .matrix:
            "square.grid.2x2"
        case .calendar:
            "calendar"
        case .statistics:
            "chart.bar"
        }
    }
}

private struct FloatingGlassTabBar: View {
    @Binding var selectedTab: AppTab
    let namespace: Namespace.ID

    var body: some View {
        HStack(spacing: 4) {
            ForEach(AppTab.allCases) { tab in
                Button {
                    withAnimation(.spring(response: 0.32, dampingFraction: 0.82)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 5) {
                        Image(systemName: tab.systemImage)
                            .font(.system(size: 21, weight: .semibold, design: .rounded))
                            .symbolVariant(selectedTab == tab ? .fill : .none)

                        Text(tab.title)
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                    }
                    .foregroundStyle(selectedTab == tab ? Color.blue : Color.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background {
                        if selectedTab == tab {
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.62),
                                            Color.blue.opacity(0.18)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .overlay {
                                    Capsule()
                                        .stroke(Color.white.opacity(0.9), lineWidth: 0.8)
                                }
                                .matchedGeometryEffect(id: "activeTabBackground", in: namespace)
                                .padding(.vertical, 4)
                        }
                    }
                    .opacity(selectedTab == tab ? 1 : 0.78)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background {
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay {
                    Capsule()
                        .fill(Color.white.opacity(0.10))
                }
                .overlay {
                    Capsule()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.9),
                                    Color.white.opacity(0.28)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                }
        }
        .shadow(color: Color.black.opacity(0.10), radius: 20, x: 0, y: 10)
        .shadow(color: Color.white.opacity(0.30), radius: 6, x: 0, y: -1)
    }
}

private struct StatisticsView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(hex: "#F7F8FA"),
                    Color(hex: "#EEF1F5")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 12) {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 42, weight: .semibold, design: .rounded))
                    .foregroundStyle(.blue)
                Text("Statistics")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                Text("Add your analytics screen here.")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 80)
        }
    }
}

#Preview {
    ContentView(initialTab: .calendar)
        .modelContainer(for: TaskModel.self, inMemory: true)
}
