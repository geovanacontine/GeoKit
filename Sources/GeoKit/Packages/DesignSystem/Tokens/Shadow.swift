import SwiftUI

// MARK: - Token

public enum ShadowType {
    case hairline
    case thin
    case thick
    case heavy
}

public extension ShadowType {
    var style: ShadowStyle {
        switch self {
        case .hairline: ShadowStyle(x: 0, y: 4, blur: 8, color: .black.opacity(0.06))
        case .thin: ShadowStyle(x: 0, y: 8, blur: 24, color: .black.opacity(0.12))
        case .thick: ShadowStyle(x: 0, y: 16, blur: 32, color: .black.opacity(0.12))
        case .heavy: ShadowStyle(x: 0, y: 16, blur: 48, color: .black.opacity(0.25))
        }
    }
}

public struct ShadowStyle {
    let x: CGFloat
    let y: CGFloat
    let blur: CGFloat
    let color: Color
}

// MARK: - ViewModifier

struct ShadowStyleModifier: ViewModifier {
    
    let style: ShadowStyle
    
    func body(content: Content) -> some View {
        content
            .shadow(
                color: style.color,
                radius: style.blur,
                x: style.x,
                y: style.y
            )
    }
}

public extension View {
    func shadow(type: ShadowType) -> some View {
        modifier(
            ShadowStyleModifier(style: type.style)
        )
    }
}
