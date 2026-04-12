import SwiftUI

struct MultiColor {
    let primary: Color
    let secondary: Color
}

extension Priority {
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
