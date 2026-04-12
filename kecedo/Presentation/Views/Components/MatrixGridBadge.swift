//
//  MatrixGridBadge.swift
//  kecedo
//
//  Created by Raka Febrian Syahputra on 09/04/26.
//

import Foundation
import SwiftUI

struct MatrixGridBadge: View {
    var priority: Priority
    
    var body: some View {
        VStack(spacing: 3) {
            HStack(spacing: 3) {
                quadrantSquare(for: Priority.doFirst)
                quadrantSquare(for: Priority.schedule)
            }
            HStack(spacing: 3) {
                quadrantSquare(for: Priority.delegate)
                quadrantSquare(for: Priority.eliminate)
            }
        }
    }
    
    @ViewBuilder
    private func quadrantSquare(for targetMode: Priority) -> some View {
        if priority == .all {
            RoundedRectangle(cornerRadius: 3)
                .fill(targetMode.color.primary)
        } else if priority == targetMode {
            RoundedRectangle(cornerRadius: 3)
                .stroke(targetMode.color.primary, lineWidth: 2)
                .background(RoundedRectangle(cornerRadius: 3).fill(Color.clear))
        } else {
            RoundedRectangle(cornerRadius: 3)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1.5)
        }
    }
}
