import SwiftUI

private struct CKContextKey: EnvironmentKey {
    static let defaultValue = CKContext.shared
}

public extension EnvironmentValues {
    var cloudKit: CKContext {
        get { self[CKContextKey.self] }
        set { self[CKContextKey.self] = newValue }
    }
}
