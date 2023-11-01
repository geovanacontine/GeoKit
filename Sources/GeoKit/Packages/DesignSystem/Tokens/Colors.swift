import SwiftUI

// MARK: - Colors Injection

public struct Colors {
    public let brandPrimary: Color
    public let brandSecondary: Color
    public let brandTertiary: Color

    public let feedbackNegative: Color
    public let feedbackPositive: Color
    public let feedbackWarning: Color
    public let feedbackAlert: Color

    public let backgroundPrimary: Color
    public let backgroundSecondary: Color
    public let backgroundTertiary: Color
    
    public let textPrimary: Color
    public let textSecondary: Color
    public let textTertiary: Color
    
    public init(
        brandPrimary: Color,
        brandSecondary: Color,
        brandTertiary: Color,
        feedbackNegative: Color,
        feedbackPositive: Color,
        feedbackWarning: Color,
        feedbackAlert: Color,
        backgroundPrimary: Color,
        backgroundSecondary: Color,
        backgroundTertiary: Color,
        textPrimary: Color,
        textSecondary: Color,
        textTertiary: Color
    ) {
        self.brandPrimary = brandPrimary
        self.brandSecondary = brandSecondary
        self.brandTertiary = brandTertiary
        self.feedbackNegative = feedbackNegative
        self.feedbackPositive = feedbackPositive
        self.feedbackWarning = feedbackWarning
        self.feedbackAlert = feedbackAlert
        self.backgroundPrimary = backgroundPrimary
        self.backgroundSecondary = backgroundSecondary
        self.backgroundTertiary = backgroundTertiary
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
        self.textTertiary = textTertiary
    }
}

// MARK: - ColorType

public enum ColorType {
    case brandPrimary
    case brandSecondary
    case brandTertiary
    
    case feedbackNegative
    case feedbackPositive
    case feedbackWarning
    case feedbackAlert
    
    case backgroundPrimary
    case backgroundSecondary
    case backgroundTertiary
}

public extension ColorType {
    func color(tokens: DesignTokens) -> Color {
        switch self {
        case .brandPrimary: tokens.color.brandPrimary
        case .brandSecondary: tokens.color.brandSecondary
        case .brandTertiary: tokens.color.brandTertiary
        case .feedbackNegative: tokens.color.feedbackNegative
        case .feedbackPositive: tokens.color.feedbackPositive
        case .feedbackWarning: tokens.color.feedbackWarning
        case .feedbackAlert: tokens.color.feedbackAlert
        case .backgroundPrimary: tokens.color.backgroundPrimary
        case .backgroundSecondary: tokens.color.backgroundSecondary
        case .backgroundTertiary: tokens.color.backgroundTertiary
        }
    }
}

// MARK: - Modifier

struct ColorModifier: ViewModifier {
    
    @Environment(\.designTokens) var tokens
    
    let type: ColorType
    let isBackground: Bool
    
    func body(content: Content) -> some View {
        if isBackground {
            content
                .background(type.color(tokens: tokens))
        } else {
            content
                .foregroundStyle(type.color(tokens: tokens))
        }
    }
}

public extension View {
    func background(color: ColorType) -> some View {
        modifier(
            ColorModifier(type: color, isBackground: true)
        )
    }
    
    func foreground(color: ColorType) -> some View {
        modifier(
            ColorModifier(type: color, isBackground: false)
        )
    }
}
