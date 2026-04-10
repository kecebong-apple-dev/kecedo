//
//  LocalizationManager.swift
//  kecedo
//

import Foundation
import SwiftUI

enum AppLanguage: String, CaseIterable {
    case english = "English"
    case indonesian = "Indonesian"
    case chinese = "Chinese"
    
    var localeIdentifier: String {
        switch self {
        case .english: return "en"
        case .indonesian: return "id"
        case .chinese: return "zh-Hans"
        }
    }
    
    var locale: Locale {
        return Locale(identifier: self.localeIdentifier)
    }
}

extension String {
    func localized(_ language: String) -> String {
        let appLanguage = AppLanguage(rawValue: language) ?? .english
        
        if let path = Bundle.main.path(forResource: appLanguage.localeIdentifier, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return NSLocalizedString(self, bundle: bundle, comment: "")
        }
        
        return NSLocalizedString(self, comment: "")
    }
    
    // Support for strings with arguments
    func localized(_ language: String, _ arguments: CVarArg...) -> String {
        let appLanguage = AppLanguage(rawValue: language) ?? .english
        
        let format: String
        if let path = Bundle.main.path(forResource: appLanguage.localeIdentifier, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            format = NSLocalizedString(self, bundle: bundle, comment: "")
        } else {
            format = NSLocalizedString(self, comment: "")
        }
        
        return String(format: format, locale: appLanguage.locale, arguments: arguments)
    }
}

// Helper for DateFormatter
extension DateFormatter {
    static func localizedFormatter(dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .none, language: String) -> DateFormatter {
        let formatter = DateFormatter()
        let appLanguage = AppLanguage(rawValue: language) ?? .english
        formatter.locale = appLanguage.locale
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter
    }
}
