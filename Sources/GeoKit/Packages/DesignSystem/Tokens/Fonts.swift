import SwiftUI

// MARK: - FontStyle

public struct FontStyle {
    let type: Font.TextStyle
    let weight: Font.Weight
    let color: TextColor
    
    public init(
        type: Font.TextStyle,
        weight: Font.Weight = .regular,
        color: TextColor = .primary
    ) {
        self.type = type
        self.weight = weight
        self.color = color
    }
}

public enum TextColor {
    case primary
    case secondary
    case tertiary
    case highlight(color: ColorType)
}

// MARK: - TextStyleModifier

struct TextStyleModifier: ViewModifier {
    
    @Environment(\.designTokens) var tokens
    
    let style: FontStyle
    
    func body(content: Content) -> some View {
        content
            .font(.system(style.type, weight: style.weight))
            .foregroundStyle(textColor)
    }
    
    private var textColor: Color {
        switch style.color {
        case .primary: tokens.color.textPrimary
        case .secondary: tokens.color.textSecondary
        case .tertiary: tokens.color.textTertiary
        case .highlight(let color): color.color(tokens: tokens)
        }
    }
}

// MARK: - Style

public extension Text {
    func style(
        _ type: Font.TextStyle,
        weight: Font.Weight = .regular,
        color: TextColor = .primary
    ) -> some View {
        modifier(
            TextStyleModifier(style: .init(type: type, weight: weight, color: color))
        )
    }
}
