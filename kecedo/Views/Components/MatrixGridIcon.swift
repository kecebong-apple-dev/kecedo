//
//  MatrixGridIcon.swift
//  kecedo
//
//  Created by Raka Febrian Syahputra on 07/04/26.
//

import SwiftUI

struct MatrixGridIcon: View {
    var mode: Priority?
    
    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 6) {
                quadrantSquare(for: Priority.doFirst, color: Priority.doFirst.color.primary)
                quadrantSquare(for: Priority.schedule, color: Priority.schedule.color.primary)
            }
            HStack(spacing: 6) {
                quadrantSquare(for: Priority.delegate, color: Priority.delegate.color.primary)
                quadrantSquare(for: Priority.eliminate, color: Priority.eliminate.color.primary)
            }
        }
    }
    
    @ViewBuilder
    func quadrantSquare(for targetMode: Priority, color: Color) -> some View {
        if mode == nil {
            RoundedRectangle(cornerRadius: 3)
                .stroke(color, lineWidth: 3)
        } else if mode == targetMode {
            RoundedRectangle(cornerRadius: 3)
                .stroke(color, lineWidth: 3)
                .background(RoundedRectangle(cornerRadius: 3).fill(Color.clear))
        } else {
            RoundedRectangle(cornerRadius: 3)
                .stroke(Color.gray.opacity(0.3), lineWidth: 3)
        }
    }
}
