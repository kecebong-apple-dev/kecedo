//
//  Toolbar.swift
//  kecedo
//
//  Created by Nathan Gitu Loh on 08/04/26.
//

import SwiftUI

// MARK: Toolbar Config
struct ToolbarMainItems: OptionSet {
    let rawValue: Int

    static let settings  = ToolbarMainItems(rawValue: 1 << 0)
    static let filter    = ToolbarMainItems(rawValue: 1 << 1)
    static let swap      = ToolbarMainItems(rawValue: 1 << 2)
    static let addTask   = ToolbarMainItems(rawValue: 1 << 3)

    // Presets
    static let matrix: ToolbarMainItems = [.settings, .filter, .swap, .addTask]
    static let calendar: ToolbarMainItems = [.settings, .addTask]
    static let statistics: ToolbarMainItems = [.settings]
}

// MARK: Toolbar Main
struct ToolbarMain: ViewModifier {
    @AppStorage("appLanguage") private var appLanguage: String = "English"
    
    var title: String? = nil
    var items: ToolbarMainItems
    @Binding var showingAddTask: Bool
    var onSettings: () -> Void
    var onFilter: () -> Void
    var onSwap: () -> Void

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .principal) {
                    if let title = title {
                        Text(title.localized(appLanguage))
                            .font(.system(size: 18, weight: .bold))
                    } else {
                        Color.clear
                    }
                }

                if items.contains(.settings) {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: onSettings) {
                            Image(systemName: "gearshape")
                                .foregroundColor(.primary)
                        }
                    }
                }

                if items.contains(.filter) || items.contains(.swap) {
                    ToolbarItemGroup() {
                        if items.contains(.filter) {
                            Button(action: onFilter) {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                                    .foregroundColor(.primary)
                            }
                        }
                        if items.contains(.swap) {
                            Button(action: onSwap) {
                                Image(systemName: "rectangle.2.swap")
                                    .foregroundColor(.primary)
                            }
                        }
                        
                    }
                }
                
                if items.contains(.addTask) {
                    ToolbarSpacer(.fixed)
                    ToolbarItem() {
                        Button { showingAddTask = true } label: {
                            Image(systemName: "plus")
                        }
                        .buttonStyle(.glassProminent)
                    }
                }
            }
    }
}
