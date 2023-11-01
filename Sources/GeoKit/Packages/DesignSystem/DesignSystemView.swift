import SwiftUI

public struct DesignSystemView<Content: View>: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State private var currentTheme: DesignTheme = DefaultTheme()
    
    private let supportedThemes: [DesignTheme]
    private let content: () -> Content
    
    public init(
        themes: [DesignTheme],
        content: @escaping () -> Content
    ) {
        self.content = content
        self.supportedThemes = themes
        
        precondition(
            !self.supportedThemes.isEmpty,
            "No supported design themes found!"
        )
    }
    
    public var body: some View {
        content()
            .environment(\.designTokens, currentTheme.tokens)
            .onAppear {
                didChangeThemeMode(to: colorScheme.designThemeMode)
            }
            .onChange(of: colorScheme) { newScheme in
                didChangeThemeMode(to: newScheme.designThemeMode)
            }
            .tint(currentTheme.tokens.color.brandPrimary)
            .accentColor(currentTheme.tokens.color.brandPrimary)
    }
    
    private func didChangeThemeMode(to newThemeMode: DesignThemeMode) {
        if let designTheme = supportedThemes.first(where: { $0.mode == newThemeMode }) {
            currentTheme = designTheme
        }
    }
}
