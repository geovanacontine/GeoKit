import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct ReducerStoreMacro: MemberMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        
        guard let classDecl = declaration.as(ClassDeclSyntax.self) else { return [] }
        
        let features = classDecl
            .attributes.last?
            .as(AttributeSyntax.self)?.arguments?
            .as(LabeledExprListSyntax.self)?
            .compactMap({ $0.as(LabeledExprSyntax.self)?
                .expression.as(StringLiteralExprSyntax.self)?
                .segments.first?.as(StringSegmentSyntax.self)?
                .content.text
            }) ?? []
        
        let stateSyntax = features.map({ "var \($0.lowercased()) = \($0)Feature.State()" })
        let actionSyntax = features.map({ "case \($0.lowercased())(\($0)Feature.Action)" })
        let runSyntax = features.map({ "case .\($0.lowercased())(let subAction): await \($0)Feature().reduce(state: &state.\($0.lowercased()), action: subAction)" })
        
        return [
            """
            struct State {
                 \(raw: stateSyntax.joined(separator: "\n"))
            }
            
            enum Action {
                 \(raw: actionSyntax.joined(separator: "\n"))
            }
            
            var state = State()
            
            func run(_ action: Action) async {
                switch action {
                 \(raw: runSyntax.joined(separator: "\n"))
                }
            }
            """
        ]
    }
}
