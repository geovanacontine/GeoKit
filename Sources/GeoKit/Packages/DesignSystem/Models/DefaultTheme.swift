import SwiftUI

public struct DefaultTheme: DesignTheme {
    
    public let id = "defaultTheme"
    public let mode: DesignThemeMode = .light
    
    public let tokens: DesignTokens = .init(
        color: .init(
            brandPrimary: .pink,
            brandSecondary: .pink,
            brandTertiary: .pink,
            feedbackNegative: .red,
            feedbackPositive: .green,
            feedbackWarning: .orange,
            feedbackAlert: .blue,
            backgroundPrimary: .white,
            backgroundSecondary: .white,
            backgroundTertiary: .white,
            textPrimary: .primary,
            textSecondary: .secondary,
            textTertiary: .secondary
        )
    )
    
    public init() {}
}
