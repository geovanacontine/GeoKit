import SwiftUI

struct ViewLoggerModifier: ViewModifier {
    
    let viewTitle: String
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                GeoLogger.shared.view.notice("\(viewTitle) appeared")
            }
    }
}

public extension View {
    func addOnAppearLog(_ viewTitle: String = #fileID) -> some View {
        let viewTitleWithoutAppName = viewTitle.replacingOccurrences(of: "Kofi/", with: "")
        let viewTitleWithoutExtension = viewTitleWithoutAppName.replacingOccurrences(of: ".swift", with: "")
        return modifier(ViewLoggerModifier(viewTitle: viewTitleWithoutExtension))
    }
}
