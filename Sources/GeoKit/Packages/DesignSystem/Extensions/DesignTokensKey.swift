import SwiftUI

public struct DesignTokensKey: EnvironmentKey {
    public static let defaultValue: DesignTokens = DefaultTheme().tokens
}

public extension EnvironmentValues {
    var designTokens: DesignTokens {
        get { self[DesignTokensKey.self] }
        set { self[DesignTokensKey.self] = newValue }
    }
}
