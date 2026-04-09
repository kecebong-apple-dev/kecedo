//
//  kecedoApp.swift
//  kecedo
//
//  Created by Raka Febrian Syahputra on 06/04/26.
//

import SwiftUI
import SwiftData

@main
struct kecedoApp: App {
    @AppStorage("appLanguage") private var appLanguage: String = "English"
    @AppStorage("appFontSize") private var appFontSize: Int = 14
    @AppStorage("appIsLightMode") private var appIsLightMode: Bool = true

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TaskModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    private func dynamicTypeSize(for size: Int) -> DynamicTypeSize {
        switch size {
        case ...11: return .xSmall
        case 12...13: return .small
        case 14: return .medium // Default
        case 15...16: return .large
        case 17...18: return .xLarge
        case 19...21: return .xxLarge
        case 22...24: return .xxxLarge
        default: return .medium
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(appIsLightMode ? .light : .dark)
                .environment(\.locale, Locale(identifier: appLanguage == "Indonesian" ? "id" : (appLanguage == "Chinese" ? "zh-Hans" : "en")))
                .dynamicTypeSize(dynamicTypeSize(for: appFontSize))
        }
        .modelContainer(sharedModelContainer)
    }
}
