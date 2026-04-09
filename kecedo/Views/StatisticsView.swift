//
//  Statistics.swift
//  kecedo
//
//  Created by sherly dinata oey on 08/04/26.
//

import SwiftUI
import SwiftData
import Charts

struct StatisticsView: View {
    @Query private var tasks: [TaskModel]
    @State private var navigateToSettings = false
    
    // Derived properties
    private var completedTasks: [TaskModel] {
        tasks.filter { $0.isDone }
    }
    
    private var tasksCompletedToday: Int {
        completedTasks.filter { task in
            if let completedAt = task.completedAt {
                return Calendar.current.isDateInToday(completedAt)
            }
            return Calendar.current.isDateInToday(task.endDate)
        }.count
    }
    
    private var progressCardTexts: (title: String, subtitle: String, description: String) {
        let completed = tasksCompletedToday
        let toComplete = tasks.filter { !$0.isDone }.count
        
        if completed == 0 {
            if toComplete > 0 {
                return ("Ready to start?", "Let's get things moving.", "You have \(toComplete) tasks ready to go.")
            } else {
                return ("All Caught Up", "No tasks on your plate.", "Enjoy your day!")
            }
        } else if completed == 1 {
            return ("Great Start!", "Good job getting started.", "You completed 1 task today.")
        } else if completed <= 3 {
            return ("Nice Progress", "Keep up the good work!", "You completed \(completed) tasks today.")
        } else {
            return ("Excellent Work", "You're crushing it today.", "You completed \(completed) tasks today.")
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        overviewCard
                        countCards
                        progressCard
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 18)
                    .padding(.bottom, 32)
                }
            }
            .toolbarMain(
                title: "Statistics",
                items: .statistics,
                onSettings: {
                    navigateToSettings = true
                }
            )
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $navigateToSettings) {
                SettingsView()
            }
        }
    }

    private var overviewCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Completed Task Overview")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(Color(hex: "#222222"))

            if completedTasks.isEmpty {
                Text("No completed tasks yet.")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .frame(height: 235)
            } else {
                Chart(Priority.allCases.filter { $0 != .all }) { priority in
                    let count = completedTasks.filter { $0.priority == priority }.count
                    
                    SectorMark(
                        angle: .value("Completed", count),
                        innerRadius: .ratio(0.55),
                        angularInset: 3.0
                    )
                    .foregroundStyle(priority.color.primary.gradient)
                    .cornerRadius(6)
                }
                .frame(height: 235)
                .padding(.vertical, 10)
            }
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 16)
        .background(.white.opacity(0.97), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 20, y: 10)
    }

    private var countCards: some View {
        HStack(spacing: 10) {
            ForEach(Priority.allCases.filter { $0 != .all }) { priority in
                let count = completedTasks.filter { $0.priority == priority }.count
                
                HStack(spacing: 8) {
                    MatrixGridBadge(priority: priority)
                        .frame(width: 22, height: 22)

                    Text("\(count)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color(hex: "#1F1F1F"))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .padding(.horizontal, 8)
                .background(priority.color.secondary, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
    }

    private var progressCard: some View {
        let texts = progressCardTexts
        
        return HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 10) {
                Text(texts.title)
                    .font(.system(size: 14, weight: .bold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(hex: "#F4F4F4"), in: Capsule())

                Text(texts.subtitle)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color(hex: "#202020"))

                Text(texts.description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color(hex: "#4A4A4A"))
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .background(.white.opacity(0.97), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 18, y: 10)
    }
}

#Preview {
    StatisticsView()
}
