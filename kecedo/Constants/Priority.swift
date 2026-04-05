//
//  Priority.swift
//  kecedo
//
//  Created by Raka Febrian Syahputra on 06/04/26.
//

import Foundation
enum Priority: String, CaseIterable, Identifiable {
    case doFirst, schedule, delegate, eliminate
    
    var id: String {
        get {
            self.rawValue
        }
    }
    
    var name: String {
        switch self {
        case .doFirst: return "Do First"
        case .schedule: return "Schedule"
        case .delegate: return "Delegate"
        case .eliminate: return "Eliminate"
        }
    }
}
