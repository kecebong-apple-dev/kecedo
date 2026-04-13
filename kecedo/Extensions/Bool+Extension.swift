//
//  Bool+Extension.swift
//  kecedo
//
//  Created by Raka Febrian Syahputra on 13/04/26.
//

import Foundation

extension Bool: Comparable {
    public static func < (lhs: Bool, rhs: Bool) -> Bool {
        return !lhs && rhs
    }
}
