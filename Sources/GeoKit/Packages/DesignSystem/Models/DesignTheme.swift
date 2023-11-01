import Foundation

public protocol DesignTheme {
    var id: String { get }
    var mode: DesignThemeMode { get }
    var tokens: DesignTokens { get }
}
