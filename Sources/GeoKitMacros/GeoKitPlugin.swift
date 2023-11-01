import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct GeoKitPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        InitMacro.self,
        CKModelMacro.self,
        CKDerivedPropertyMacro.self,
        ReduxFeatureMacro.self,
        ReduxMacro.self
    ]
}
