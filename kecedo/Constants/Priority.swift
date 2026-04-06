//
//  Priority.swift
//  kecedo
//
//  Created by Raka Febrian Syahputra on 06/04/26.
//

import Foundation
import SwiftUI

struct MultiColor {
    let primary: Color
    let secondary: Color
}

enum Priority: String, Codable, Identifiable {
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
    
    var color: MultiColor {
        switch self {
        case .doFirst: return MultiColor(primary: Color(hex: "#33C65B"), secondary: Color(hex: "#E2FFEA"))
        case .schedule: return MultiColor(primary: Color(hex: "#FFCC01"), secondary: Color(hex: "#FFF6D2"))
        case .delegate: return MultiColor(primary: Color(hex: "#29B9FF"), secondary: Color(hex: "#CFEFFF"))
        case .eliminate: return MultiColor(primary: Color(hex: "#EF4C14"), secondary: Color(hex: "#FE3054"))
        }
    }
}
