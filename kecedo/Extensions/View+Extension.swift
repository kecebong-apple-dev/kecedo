//
//  View+Extension.swift
//  kecedo
//
//  Created by Raka Febrian Syahputra on 07/04/26.
//

import Foundation
import SwiftUI

extension View {
    func inputFieldStyle() -> some View {
        self
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background()
            .foregroundStyle(.black)
            .cornerRadius(24)
            .shadow(color: .black.opacity(0.12), radius: 18, x: 0, y: 0)
            .padding(.horizontal, 16)
    }
    func gridIconStyle(isActive: Bool) -> some View {
        self
            .padding(10)
            .background(isActive ? Color(hex: "#5D5D5D") : .white)
            .foregroundStyle(.black)
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.12), radius: 18, x: 0, y: 0)
    }
    
    ///    - All 4 (default)
    ///    .toolbarMain(showingAddTask: $showingAddTask)
    ///    - Only settings + add task
    ///    .toolbarMain(
    ///       items: [.settings, .addTask],
    ///       showingAddTask: $showingAddTask,
    ///       onSettings: { navigate() }
    ///    )
    ///    - Using a preset
    ///    .toolbarMain(
    ///        items: .matrix,
    ///        showingAddTask: $showingAddTask
    ///    )
    ///    - Single item
    ///    .toolbarMain(
    ///        items: .addTask,
    ///        showingAddTask: $showingAddTask
    ///    )
    func toolbarMain(
        items: ToolbarMainItems = .matrix,
        showingAddTask: Binding<Bool> = .constant(false),
        onSettings: @escaping () -> Void = {},
        onFilter: @escaping () -> Void = {},
        onSwap: @escaping () -> Void = {}
    ) -> some View {
        modifier(ToolbarMain(
            items: items,
            showingAddTask: showingAddTask,
            onSettings: onSettings,
            onFilter: onFilter,
            onSwap: onSwap
        ))
    }
    
}
