import SwiftUI

public enum PaddingSize: CGFloat {
    case none = 0
    case quarck = 4
    case nano = 8
    case micro = 12
    case xxxs = 16
    case xxs = 24
    case xs = 32
    case sm = 40
    case md = 48
    case lg = 56
    case xl = 72
    case xxl = 96
    case xxxl = 120
}

// MARK: - Modifier

struct PaddingModifier: ViewModifier {
    
    let edges: Edge.Set
    let size: PaddingSize
    
    func body(content: Content) -> some View {
        content
            .padding(edges, size.rawValue)
    }
}

public extension View {
    func padding(_ edges: Edge.Set = .all, size: PaddingSize = .xxxs) -> some View {
        modifier(
            PaddingModifier(edges: edges, size: size)
        )
    }
}
