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
    @AppStorage("appLanguage") private var appLanguage: String = "English"
    @State private var navigateToSettings = false

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
                return ("Ready to start?".localized(appLanguage), 
                        "Let's get things moving.".localized(appLanguage), 
                        "You have %lld tasks ready to go.".localized(appLanguage, Int64(toComplete)))
            } else {
                return ("All Caught Up".localized(appLanguage), 
                        "No tasks on your plate.".localized(appLanguage), 
                        "Enjoy your day!".localized(appLanguage))
            }
        } else if completed == 1 {
            return ("Great Start!".localized(appLanguage), 
                    "Good job getting started.".localized(appLanguage), 
                    "You completed 1 task today.".localized(appLanguage))
        } else if completed <= 3 {
            return ("Nice Progress".localized(appLanguage), 
                    "Keep up the good work!".localized(appLanguage), 
                    "You completed %lld tasks today.".localized(appLanguage, Int64(completed)))
        } else {
            return ("Excellent Work".localized(appLanguage), 
                    "You're crushing it today.".localized(appLanguage), 
                    "You completed %lld tasks today.".localized(appLanguage, Int64(completed)))
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
                .background(Color(UIColor.systemBackground)) 
            }
            .toolbarMain(
                title: "Statistics".localized(appLanguage),
                items: .statistics,
                onSettings: {
                    navigateToSettings = true
                }
            )
            .navigationTitle("Statistics".localized(appLanguage))
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $navigateToSettings) {
                SettingsView()
            }
        }
    }

    private var overviewCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Completed Task Overview".localized(appLanguage))
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.primary)

            if completedTasks.isEmpty {
                Text("No completed tasks yet.".localized(appLanguage))
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .frame(height: 235)
            } else {
                Chart(Priority.allCases.filter { $0 != .all }) { priority in
                    let count = completedTasks.filter { $0.priority == priority }.count
                    
                    SectorMark(
                        angle: .value("Completed".localized(appLanguage), count),
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
        .background(Color(UIColor.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 10, y: 5) // Bayangan lebih halus
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
                        .foregroundStyle(.primary)
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
                    .background(Color(UIColor.tertiarySystemGroupedBackground), in: Capsule())

                Text(texts.subtitle)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.primary)

                Text(texts.description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .background(Color(UIColor.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 10, y: 5)
    }
}

#Preview {
    StatisticsView()
}
