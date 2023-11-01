//
//  Color+Extensions.swift
//  
//
//  Created by Geovana Contine on 17/08/23.
//

import SwiftUI

extension Color {
    static let missingToken: Color = .yellow
}

public extension Color {
    init(hex: String, opacity: CGFloat = 1) {
        let hexSanitized = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        if Scanner(string: hexSanitized).scanHexInt64(&rgb),
           hexSanitized.count == 6 {
            
            self.init(
                red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgb & 0x0000FF) / 255.0,
                opacity: opacity
            )
        } else {
            self = Color.missingToken
        }
    }
}
