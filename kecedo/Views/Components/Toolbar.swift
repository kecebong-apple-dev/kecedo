//
//  Toolbar.swift
//  kecedo
//
//  Created by Nathan Gitu Loh on 08/04/26.
//

import SwiftUI

struct TaskListToolbar: ViewModifier {
    @Binding var showingAddTask: Bool
    var onFilter: () -> Void
    var onSwap: () -> Void
    var onSettings: () -> Void

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Color.clear
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: onSettings) {
                        Image(systemName: "gearshape")
                            .foregroundColor(.primary)
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: onFilter) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(.primary)
                    }
                    Button(action: onSwap) {
                        Image(systemName: "rectangle.2.swap")
                            .foregroundColor(.primary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showingAddTask = true } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.primary)
                    }
                }
            }
    }
}
