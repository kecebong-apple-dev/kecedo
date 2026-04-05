//
//  Screen.swift
//  kecedo
//
//  Created by Raka Febrian Syahputra on 06/04/26.
//

import Foundation
import SwiftUI

var screenHeight: CGFloat {
    if let windowScene = UIApplication.shared.connectedScenes.first as?
    UIWindowScene {
        return windowScene.screen.bounds.height
    }
    
    return 852
}
