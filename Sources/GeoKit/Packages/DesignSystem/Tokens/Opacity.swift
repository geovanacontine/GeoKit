import SwiftUI

public enum OpacityType: Double {
    case opaque = 1.0
    case semiOpaque = 0.72
    case intense = 0.64
    case medium = 0.32
    case light = 0.16
    case semiTransparent = 0.08
}

// MARK: - Modifier

struct OpacityModifier: ViewModifier {
    
    let type: OpacityType
    
    func body(content: Content) -> some View {
        content.opacity(type.rawValue)
    }
}

public extension View {
    func opacity(type: OpacityType) -> some View {
        modifier(
            OpacityModifier(type: type)
        )
    }
}
