//
//  MatrixGridBadge.swift
//  kecedo
//
//  Created by Raka Febrian Syahputra on 09/04/26.
//

import Foundation
import SwiftUI

struct MatrixGridBadge: View {
    var mode: MatrixMode
    
    var body: some View {
        VStack(spacing: 3) {
            HStack(spacing: 3) {
                quadrantSquare(for: .urgentImportant, color: Priority.doFirst.color.primary)
                quadrantSquare(for: .notUrgentImportant, color: Priority.schedule.color.primary)
            }
            HStack(spacing: 3) {
                quadrantSquare(for: .urgentNotImportant, color: Priority.delegate.color.primary)
                quadrantSquare(for: .notUrgentNotImportant, color: Priority.eliminate.color.primary)
            }
        }
    }
    
    @ViewBuilder
    private func quadrantSquare(for targetMode: MatrixMode, color: Color) -> some View {
        if mode == .all {
            RoundedRectangle(cornerRadius: 3)
                .fill(color)
        } else if mode == targetMode {
            RoundedRectangle(cornerRadius: 3)
                .stroke(color, lineWidth: 2)
                .background(RoundedRectangle(cornerRadius: 3).fill(Color.clear))
        } else {
            RoundedRectangle(cornerRadius: 3)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1.5)
        }
    }
}
