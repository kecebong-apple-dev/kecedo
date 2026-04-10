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

enum Priority: String, Codable, Identifiable, CaseIterable {
    case all, doFirst, schedule, delegate, eliminate
    
    var id: String {
        self.rawValue
    }
    
    // set label eisenhower
    func localizedName(language: String) -> String {
        switch self {
        case .all:       return "All".localized(language)
        case .doFirst:   return "Do First".localized(language)
        case .schedule:  return "Schedule".localized(language)
        case .delegate:  return "Delegate".localized(language)
        case .eliminate: return "Eliminate".localized(language)
        }
    }
    
    var name: String {
        return localizedName(language: UserDefaults.standard.string(forKey: "appLanguage") ?? "English")
    }
    
    // set color eisenhower
    var color: MultiColor {
        switch self {
        case .all:       return MultiColor(primary: Color(hex: "#181D33"), secondary: Color(hex: "#E3E3E3"))
        case .doFirst:   return MultiColor(primary: Color(hex: "#33C65B"), secondary: Color(hex: "#E2FFEA"))
        case .schedule:  return MultiColor(primary: Color(hex: "#FFCC01"), secondary: Color(hex: "#FFF6D2"))
        case .delegate:  return MultiColor(primary: Color(hex: "#29B9FF"), secondary: Color(hex: "#CFEFFF"))
        case .eliminate: return MultiColor(primary: Color(hex: "#EF4C14"), secondary: Color(hex: "#FFE5DC"))
        }
    }
}
