import SwiftUI

public extension ColorScheme {
    var designThemeMode: DesignThemeMode {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        @unknown default:
            fatalError("Scheme not supported!")
        }
    }
}
