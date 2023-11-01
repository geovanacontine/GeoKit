import SwiftUI

public enum BorderSize: CGFloat {
    case none = 0
    case hairline = 1
    case thick = 2
    case heavy = 4
}

public enum BorderRadius: CGFloat {
    case none = 0
    case sm = 4
    case md = 8
    case lg = 16
    case circle = 9999
}

// MARK: - Modifier

struct BorderModifier: ViewModifier {
    
    let color: Color
    let radius: BorderRadius
    let size: BorderSize
    
    func body(content: Content) -> some View {
        content
            .border(color, width: size.rawValue)
            .cornerRadius(radius.rawValue)
    }
}

public extension View {
    func cornerRadius(size: BorderRadius) -> some View {
        modifier(
            BorderModifier(color: .clear, radius: size, size: .none)
        )
    }
    
    func border(_ color: Color, radius: BorderRadius, size: BorderSize = .none) -> some View {
        modifier(
            BorderModifier(color: color, radius: radius, size: size)
        )
    }
}
