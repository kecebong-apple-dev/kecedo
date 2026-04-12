//
//  Priority.swift
//  kecedo
//
//  Created by Raka Febrian Syahputra on 06/04/26.
//

import Foundation

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
}
