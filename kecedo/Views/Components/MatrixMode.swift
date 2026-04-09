//
//  MatrixMode.swift
//  kecedo
//
//  Created by Raka Febrian Syahputra on 09/04/26.
//

import Foundation
import SwiftUI

enum MatrixMode: CaseIterable, Equatable {
    case all
    case urgentImportant
    case notUrgentImportant
    case urgentNotImportant
    case notUrgentNotImportant
    
    // Mapping MatrixMode ke Priority
    var priority: Priority? {
        switch self {
        case .all: return nil
        case .urgentImportant: return .doFirst
        case .notUrgentImportant: return .schedule
        case .urgentNotImportant: return .delegate
        case .notUrgentNotImportant: return .eliminate
        }
    }
    
    func tint(forSelected isSelected: Bool) -> Color {
        guard isSelected else { return .white }
        switch self {
        case .all: return .gray.opacity(0.15)
        default:
            if let priority = priority {
                return priority.color.secondary.opacity(0.25)
            }
            return .white
        }
    }
    
    static func mode(from priority: Priority) -> MatrixMode {
        switch priority {
        case .doFirst: return .urgentImportant
        case .schedule: return .notUrgentImportant
        case .delegate: return .urgentNotImportant
        case .eliminate: return .notUrgentNotImportant
        }
    }
}
