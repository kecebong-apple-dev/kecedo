//
//  Priority.swift
//  kecedo
//
//  Created by Raka Febrian Syahputra on 06/04/26.
//

import Foundation
import SwiftUI

// Ekstensi untuk mendukung adaptasi warna Light/Dark Mode
extension Color {
    static func dynamic(light: String, dark: String) -> Color {
        return Color(UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor(Color(hex: dark)) : UIColor(Color(hex: light))
        })
    }
}

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
    
    // set color eisenhower dengan adaptasi dark mode
    var color: MultiColor {
        switch self {
        case .all:
            return MultiColor(
                primary: Color.dynamic(light: "#181D33", dark: "#E3E3E3"),
                secondary: Color.dynamic(light: "#E3E3E3", dark: "#2C2C2E")
            )
        case .doFirst:
            return MultiColor(
                primary: Color(hex: "#33C65B"),
                secondary: Color.dynamic(light: "#E2FFEA", dark: "#12381F")
            )
        case .schedule:
            return MultiColor(
                primary: Color(hex: "#FFCC01"),
                secondary: Color.dynamic(light: "#FFF6D2", dark: "#473A00")
            )
        case .delegate:
            return MultiColor(
                primary: Color(hex: "#29B9FF"),
                secondary: Color.dynamic(light: "#CFEFFF", dark: "#0A354C")
            )
        case .eliminate:
            return MultiColor(
                primary: Color(hex: "#EF4C14"),
                secondary: Color.dynamic(light: "#FFE5DC", dark: "#4C1605")
            )
        }
    }
}
